
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 80 11 40       	mov    $0x40118000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 80 11 00       	mov    %eax,0x118000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	ba 28 af 11 00       	mov    $0x11af28,%edx
  100041:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  10005d:	e8 a2 60 00 00       	call   106104 <memset>

    cons_init();                // init the console
  100062:	e8 86 15 00 00       	call   1015ed <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 a0 62 10 00 	movl   $0x1062a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 bc 62 10 00 	movl   $0x1062bc,(%esp)
  10007c:	e8 c7 02 00 00       	call   100348 <cprintf>

    print_kerninfo();
  100081:	e8 f6 07 00 00       	call   10087c <print_kerninfo>

    grade_backtrace();
  100086:	e8 86 00 00 00       	call   100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 cc 45 00 00       	call   10465c <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 c1 16 00 00       	call   101756 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 39 18 00 00       	call   1018d3 <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 04 0d 00 00       	call   100da3 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 20 16 00 00       	call   1016c4 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	55                   	push   %ebp
  1000a7:	89 e5                	mov    %esp,%ebp
  1000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b3:	00 
  1000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bb:	00 
  1000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c3:	e8 fc 0b 00 00       	call   100cc4 <mon_backtrace>
}
  1000c8:	c9                   	leave  
  1000c9:	c3                   	ret    

001000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000ca:	55                   	push   %ebp
  1000cb:	89 e5                	mov    %esp,%ebp
  1000cd:	53                   	push   %ebx
  1000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000d7:	8d 55 08             	lea    0x8(%ebp),%edx
  1000da:	8b 45 08             	mov    0x8(%ebp),%eax
  1000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000e9:	89 04 24             	mov    %eax,(%esp)
  1000ec:	e8 b5 ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000f1:	83 c4 14             	add    $0x14,%esp
  1000f4:	5b                   	pop    %ebx
  1000f5:	5d                   	pop    %ebp
  1000f6:	c3                   	ret    

001000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f7:	55                   	push   %ebp
  1000f8:	89 e5                	mov    %esp,%ebp
  1000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000fd:	8b 45 10             	mov    0x10(%ebp),%eax
  100100:	89 44 24 04          	mov    %eax,0x4(%esp)
  100104:	8b 45 08             	mov    0x8(%ebp),%eax
  100107:	89 04 24             	mov    %eax,(%esp)
  10010a:	e8 bb ff ff ff       	call   1000ca <grade_backtrace1>
}
  10010f:	c9                   	leave  
  100110:	c3                   	ret    

00100111 <grade_backtrace>:

void
grade_backtrace(void) {
  100111:	55                   	push   %ebp
  100112:	89 e5                	mov    %esp,%ebp
  100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100117:	b8 36 00 10 00       	mov    $0x100036,%eax
  10011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100123:	ff 
  100124:	89 44 24 04          	mov    %eax,0x4(%esp)
  100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10012f:	e8 c3 ff ff ff       	call   1000f7 <grade_backtrace0>
}
  100134:	c9                   	leave  
  100135:	c3                   	ret    

00100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100136:	55                   	push   %ebp
  100137:	89 e5                	mov    %esp,%ebp
  100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014c:	0f b7 c0             	movzwl %ax,%eax
  10014f:	83 e0 03             	and    $0x3,%eax
  100152:	89 c2                	mov    %eax,%edx
  100154:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100159:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100161:	c7 04 24 c1 62 10 00 	movl   $0x1062c1,(%esp)
  100168:	e8 db 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100171:	0f b7 d0             	movzwl %ax,%edx
  100174:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100179:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100181:	c7 04 24 cf 62 10 00 	movl   $0x1062cf,(%esp)
  100188:	e8 bb 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100191:	0f b7 d0             	movzwl %ax,%edx
  100194:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100199:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a1:	c7 04 24 dd 62 10 00 	movl   $0x1062dd,(%esp)
  1001a8:	e8 9b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b1:	0f b7 d0             	movzwl %ax,%edx
  1001b4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 eb 62 10 00 	movl   $0x1062eb,(%esp)
  1001c8:	e8 7b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d1:	0f b7 d0             	movzwl %ax,%edx
  1001d4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e1:	c7 04 24 f9 62 10 00 	movl   $0x1062f9,(%esp)
  1001e8:	e8 5b 01 00 00       	call   100348 <cprintf>
    round ++;
  1001ed:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001f2:	83 c0 01             	add    $0x1,%eax
  1001f5:	a3 00 a0 11 00       	mov    %eax,0x11a000
}
  1001fa:	c9                   	leave  
  1001fb:	c3                   	ret    

001001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001ff:	5d                   	pop    %ebp
  100200:	c3                   	ret    

00100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100201:	55                   	push   %ebp
  100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  100204:	5d                   	pop    %ebp
  100205:	c3                   	ret    

00100206 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100206:	55                   	push   %ebp
  100207:	89 e5                	mov    %esp,%ebp
  100209:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020c:	e8 25 ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100211:	c7 04 24 08 63 10 00 	movl   $0x106308,(%esp)
  100218:	e8 2b 01 00 00       	call   100348 <cprintf>
    lab1_switch_to_user();
  10021d:	e8 da ff ff ff       	call   1001fc <lab1_switch_to_user>
    lab1_print_cur_status();
  100222:	e8 0f ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100227:	c7 04 24 28 63 10 00 	movl   $0x106328,(%esp)
  10022e:	e8 15 01 00 00       	call   100348 <cprintf>
    lab1_switch_to_kernel();
  100233:	e8 c9 ff ff ff       	call   100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100238:	e8 f9 fe ff ff       	call   100136 <lab1_print_cur_status>
}
  10023d:	c9                   	leave  
  10023e:	c3                   	ret    

0010023f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10023f:	55                   	push   %ebp
  100240:	89 e5                	mov    %esp,%ebp
  100242:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100249:	74 13                	je     10025e <readline+0x1f>
        cprintf("%s", prompt);
  10024b:	8b 45 08             	mov    0x8(%ebp),%eax
  10024e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100252:	c7 04 24 47 63 10 00 	movl   $0x106347,(%esp)
  100259:	e8 ea 00 00 00       	call   100348 <cprintf>
    }
    int i = 0, c;
  10025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100265:	e8 66 01 00 00       	call   1003d0 <getchar>
  10026a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10026d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100271:	79 07                	jns    10027a <readline+0x3b>
            return NULL;
  100273:	b8 00 00 00 00       	mov    $0x0,%eax
  100278:	eb 79                	jmp    1002f3 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10027a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10027e:	7e 28                	jle    1002a8 <readline+0x69>
  100280:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100287:	7f 1f                	jg     1002a8 <readline+0x69>
            cputchar(c);
  100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10028c:	89 04 24             	mov    %eax,(%esp)
  10028f:	e8 da 00 00 00       	call   10036e <cputchar>
            buf[i ++] = c;
  100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100297:	8d 50 01             	lea    0x1(%eax),%edx
  10029a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10029d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002a0:	88 90 20 a0 11 00    	mov    %dl,0x11a020(%eax)
  1002a6:	eb 46                	jmp    1002ee <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  1002a8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002ac:	75 17                	jne    1002c5 <readline+0x86>
  1002ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002b2:	7e 11                	jle    1002c5 <readline+0x86>
            cputchar(c);
  1002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b7:	89 04 24             	mov    %eax,(%esp)
  1002ba:	e8 af 00 00 00       	call   10036e <cputchar>
            i --;
  1002bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002c3:	eb 29                	jmp    1002ee <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c9:	74 06                	je     1002d1 <readline+0x92>
  1002cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002cf:	75 1d                	jne    1002ee <readline+0xaf>
            cputchar(c);
  1002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d4:	89 04 24             	mov    %eax,(%esp)
  1002d7:	e8 92 00 00 00       	call   10036e <cputchar>
            buf[i] = '\0';
  1002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002df:	05 20 a0 11 00       	add    $0x11a020,%eax
  1002e4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e7:	b8 20 a0 11 00       	mov    $0x11a020,%eax
  1002ec:	eb 05                	jmp    1002f3 <readline+0xb4>
        }
    }
  1002ee:	e9 72 ff ff ff       	jmp    100265 <readline+0x26>
}
  1002f3:	c9                   	leave  
  1002f4:	c3                   	ret    

001002f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f5:	55                   	push   %ebp
  1002f6:	89 e5                	mov    %esp,%ebp
  1002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fe:	89 04 24             	mov    %eax,(%esp)
  100301:	e8 13 13 00 00       	call   101619 <cons_putc>
    (*cnt) ++;
  100306:	8b 45 0c             	mov    0xc(%ebp),%eax
  100309:	8b 00                	mov    (%eax),%eax
  10030b:	8d 50 01             	lea    0x1(%eax),%edx
  10030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100311:	89 10                	mov    %edx,(%eax)
}
  100313:	c9                   	leave  
  100314:	c3                   	ret    

00100315 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100315:	55                   	push   %ebp
  100316:	89 e5                	mov    %esp,%ebp
  100318:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100322:	8b 45 0c             	mov    0xc(%ebp),%eax
  100325:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100329:	8b 45 08             	mov    0x8(%ebp),%eax
  10032c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100330:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100333:	89 44 24 04          	mov    %eax,0x4(%esp)
  100337:	c7 04 24 f5 02 10 00 	movl   $0x1002f5,(%esp)
  10033e:	e8 da 55 00 00       	call   10591d <vprintfmt>
    return cnt;
  100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100346:	c9                   	leave  
  100347:	c3                   	ret    

00100348 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10034e:	8d 45 0c             	lea    0xc(%ebp),%eax
  100351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100357:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035b:	8b 45 08             	mov    0x8(%ebp),%eax
  10035e:	89 04 24             	mov    %eax,(%esp)
  100361:	e8 af ff ff ff       	call   100315 <vcprintf>
  100366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036c:	c9                   	leave  
  10036d:	c3                   	ret    

0010036e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10036e:	55                   	push   %ebp
  10036f:	89 e5                	mov    %esp,%ebp
  100371:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100374:	8b 45 08             	mov    0x8(%ebp),%eax
  100377:	89 04 24             	mov    %eax,(%esp)
  10037a:	e8 9a 12 00 00       	call   101619 <cons_putc>
}
  10037f:	c9                   	leave  
  100380:	c3                   	ret    

00100381 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100381:	55                   	push   %ebp
  100382:	89 e5                	mov    %esp,%ebp
  100384:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038e:	eb 13                	jmp    1003a3 <cputs+0x22>
        cputch(c, &cnt);
  100390:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100397:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039b:	89 04 24             	mov    %eax,(%esp)
  10039e:	e8 52 ff ff ff       	call   1002f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a6:	8d 50 01             	lea    0x1(%eax),%edx
  1003a9:	89 55 08             	mov    %edx,0x8(%ebp)
  1003ac:	0f b6 00             	movzbl (%eax),%eax
  1003af:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b6:	75 d8                	jne    100390 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003c6:	e8 2a ff ff ff       	call   1002f5 <cputch>
    return cnt;
  1003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ce:	c9                   	leave  
  1003cf:	c3                   	ret    

001003d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003d0:	55                   	push   %ebp
  1003d1:	89 e5                	mov    %esp,%ebp
  1003d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003d6:	e8 7a 12 00 00       	call   101655 <cons_getc>
  1003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e2:	74 f2                	je     1003d6 <getchar+0x6>
        /* do nothing */;
    return c;
  1003e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003e7:	c9                   	leave  
  1003e8:	c3                   	ret    

001003e9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003e9:	55                   	push   %ebp
  1003ea:	89 e5                	mov    %esp,%ebp
  1003ec:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f2:	8b 00                	mov    (%eax),%eax
  1003f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1003fa:	8b 00                	mov    (%eax),%eax
  1003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100406:	e9 d2 00 00 00       	jmp    1004dd <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10040b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10040e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100411:	01 d0                	add    %edx,%eax
  100413:	89 c2                	mov    %eax,%edx
  100415:	c1 ea 1f             	shr    $0x1f,%edx
  100418:	01 d0                	add    %edx,%eax
  10041a:	d1 f8                	sar    %eax
  10041c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100422:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100425:	eb 04                	jmp    10042b <stab_binsearch+0x42>
            m --;
  100427:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100431:	7c 1f                	jl     100452 <stab_binsearch+0x69>
  100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100436:	89 d0                	mov    %edx,%eax
  100438:	01 c0                	add    %eax,%eax
  10043a:	01 d0                	add    %edx,%eax
  10043c:	c1 e0 02             	shl    $0x2,%eax
  10043f:	89 c2                	mov    %eax,%edx
  100441:	8b 45 08             	mov    0x8(%ebp),%eax
  100444:	01 d0                	add    %edx,%eax
  100446:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10044a:	0f b6 c0             	movzbl %al,%eax
  10044d:	3b 45 14             	cmp    0x14(%ebp),%eax
  100450:	75 d5                	jne    100427 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100455:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100458:	7d 0b                	jge    100465 <stab_binsearch+0x7c>
            l = true_m + 1;
  10045a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045d:	83 c0 01             	add    $0x1,%eax
  100460:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100463:	eb 78                	jmp    1004dd <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100465:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10046c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046f:	89 d0                	mov    %edx,%eax
  100471:	01 c0                	add    %eax,%eax
  100473:	01 d0                	add    %edx,%eax
  100475:	c1 e0 02             	shl    $0x2,%eax
  100478:	89 c2                	mov    %eax,%edx
  10047a:	8b 45 08             	mov    0x8(%ebp),%eax
  10047d:	01 d0                	add    %edx,%eax
  10047f:	8b 40 08             	mov    0x8(%eax),%eax
  100482:	3b 45 18             	cmp    0x18(%ebp),%eax
  100485:	73 13                	jae    10049a <stab_binsearch+0xb1>
            *region_left = m;
  100487:	8b 45 0c             	mov    0xc(%ebp),%eax
  10048a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10048f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100492:	83 c0 01             	add    $0x1,%eax
  100495:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100498:	eb 43                	jmp    1004dd <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049d:	89 d0                	mov    %edx,%eax
  10049f:	01 c0                	add    %eax,%eax
  1004a1:	01 d0                	add    %edx,%eax
  1004a3:	c1 e0 02             	shl    $0x2,%eax
  1004a6:	89 c2                	mov    %eax,%edx
  1004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ab:	01 d0                	add    %edx,%eax
  1004ad:	8b 40 08             	mov    0x8(%eax),%eax
  1004b0:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004b3:	76 16                	jbe    1004cb <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c3:	83 e8 01             	sub    $0x1,%eax
  1004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c9:	eb 12                	jmp    1004dd <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d1:	89 10                	mov    %edx,(%eax)
            l = m;
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004d9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004e3:	0f 8e 22 ff ff ff    	jle    10040b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004ed:	75 0f                	jne    1004fe <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f2:	8b 00                	mov    (%eax),%eax
  1004f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1004fa:	89 10                	mov    %edx,(%eax)
  1004fc:	eb 3f                	jmp    10053d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  100501:	8b 00                	mov    (%eax),%eax
  100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100506:	eb 04                	jmp    10050c <stab_binsearch+0x123>
  100508:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050f:	8b 00                	mov    (%eax),%eax
  100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100514:	7d 1f                	jge    100535 <stab_binsearch+0x14c>
  100516:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100519:	89 d0                	mov    %edx,%eax
  10051b:	01 c0                	add    %eax,%eax
  10051d:	01 d0                	add    %edx,%eax
  10051f:	c1 e0 02             	shl    $0x2,%eax
  100522:	89 c2                	mov    %eax,%edx
  100524:	8b 45 08             	mov    0x8(%ebp),%eax
  100527:	01 d0                	add    %edx,%eax
  100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10052d:	0f b6 c0             	movzbl %al,%eax
  100530:	3b 45 14             	cmp    0x14(%ebp),%eax
  100533:	75 d3                	jne    100508 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100535:	8b 45 0c             	mov    0xc(%ebp),%eax
  100538:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10053b:	89 10                	mov    %edx,(%eax)
    }
}
  10053d:	c9                   	leave  
  10053e:	c3                   	ret    

0010053f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10053f:	55                   	push   %ebp
  100540:	89 e5                	mov    %esp,%ebp
  100542:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100545:	8b 45 0c             	mov    0xc(%ebp),%eax
  100548:	c7 00 4c 63 10 00    	movl   $0x10634c,(%eax)
    info->eip_line = 0;
  10054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100558:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055b:	c7 40 08 4c 63 10 00 	movl   $0x10634c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100562:	8b 45 0c             	mov    0xc(%ebp),%eax
  100565:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056f:	8b 55 08             	mov    0x8(%ebp),%edx
  100572:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100575:	8b 45 0c             	mov    0xc(%ebp),%eax
  100578:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10057f:	c7 45 f4 c8 75 10 00 	movl   $0x1075c8,-0xc(%ebp)
    stab_end = __STAB_END__;
  100586:	c7 45 f0 04 24 11 00 	movl   $0x112404,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10058d:	c7 45 ec 05 24 11 00 	movl   $0x112405,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100594:	c7 45 e8 b5 4e 11 00 	movl   $0x114eb5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005a1:	76 0d                	jbe    1005b0 <debuginfo_eip+0x71>
  1005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005a6:	83 e8 01             	sub    $0x1,%eax
  1005a9:	0f b6 00             	movzbl (%eax),%eax
  1005ac:	84 c0                	test   %al,%al
  1005ae:	74 0a                	je     1005ba <debuginfo_eip+0x7b>
        return -1;
  1005b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005b5:	e9 c0 02 00 00       	jmp    10087a <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c7:	29 c2                	sub    %eax,%edx
  1005c9:	89 d0                	mov    %edx,%eax
  1005cb:	c1 f8 02             	sar    $0x2,%eax
  1005ce:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005d4:	83 e8 01             	sub    $0x1,%eax
  1005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005da:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005e1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005e8:	00 
  1005e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005fa:	89 04 24             	mov    %eax,(%esp)
  1005fd:	e8 e7 fd ff ff       	call   1003e9 <stab_binsearch>
    if (lfile == 0)
  100602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100605:	85 c0                	test   %eax,%eax
  100607:	75 0a                	jne    100613 <debuginfo_eip+0xd4>
        return -1;
  100609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10060e:	e9 67 02 00 00       	jmp    10087a <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100616:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10061f:	8b 45 08             	mov    0x8(%ebp),%eax
  100622:	89 44 24 10          	mov    %eax,0x10(%esp)
  100626:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10062d:	00 
  10062e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100631:	89 44 24 08          	mov    %eax,0x8(%esp)
  100635:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100638:	89 44 24 04          	mov    %eax,0x4(%esp)
  10063c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063f:	89 04 24             	mov    %eax,(%esp)
  100642:	e8 a2 fd ff ff       	call   1003e9 <stab_binsearch>

    if (lfun <= rfun) {
  100647:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10064d:	39 c2                	cmp    %eax,%edx
  10064f:	7f 7c                	jg     1006cd <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100654:	89 c2                	mov    %eax,%edx
  100656:	89 d0                	mov    %edx,%eax
  100658:	01 c0                	add    %eax,%eax
  10065a:	01 d0                	add    %edx,%eax
  10065c:	c1 e0 02             	shl    $0x2,%eax
  10065f:	89 c2                	mov    %eax,%edx
  100661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100664:	01 d0                	add    %edx,%eax
  100666:	8b 10                	mov    (%eax),%edx
  100668:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066e:	29 c1                	sub    %eax,%ecx
  100670:	89 c8                	mov    %ecx,%eax
  100672:	39 c2                	cmp    %eax,%edx
  100674:	73 22                	jae    100698 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100676:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100679:	89 c2                	mov    %eax,%edx
  10067b:	89 d0                	mov    %edx,%eax
  10067d:	01 c0                	add    %eax,%eax
  10067f:	01 d0                	add    %edx,%eax
  100681:	c1 e0 02             	shl    $0x2,%eax
  100684:	89 c2                	mov    %eax,%edx
  100686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100689:	01 d0                	add    %edx,%eax
  10068b:	8b 10                	mov    (%eax),%edx
  10068d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100690:	01 c2                	add    %eax,%edx
  100692:	8b 45 0c             	mov    0xc(%ebp),%eax
  100695:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100698:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069b:	89 c2                	mov    %eax,%edx
  10069d:	89 d0                	mov    %edx,%eax
  10069f:	01 c0                	add    %eax,%eax
  1006a1:	01 d0                	add    %edx,%eax
  1006a3:	c1 e0 02             	shl    $0x2,%eax
  1006a6:	89 c2                	mov    %eax,%edx
  1006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ab:	01 d0                	add    %edx,%eax
  1006ad:	8b 50 08             	mov    0x8(%eax),%edx
  1006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b9:	8b 40 10             	mov    0x10(%eax),%eax
  1006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006cb:	eb 15                	jmp    1006e2 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e5:	8b 40 08             	mov    0x8(%eax),%eax
  1006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006ef:	00 
  1006f0:	89 04 24             	mov    %eax,(%esp)
  1006f3:	e8 80 58 00 00       	call   105f78 <strfind>
  1006f8:	89 c2                	mov    %eax,%edx
  1006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006fd:	8b 40 08             	mov    0x8(%eax),%eax
  100700:	29 c2                	sub    %eax,%edx
  100702:	8b 45 0c             	mov    0xc(%ebp),%eax
  100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100708:	8b 45 08             	mov    0x8(%ebp),%eax
  10070b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100716:	00 
  100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10071a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100721:	89 44 24 04          	mov    %eax,0x4(%esp)
  100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100728:	89 04 24             	mov    %eax,(%esp)
  10072b:	e8 b9 fc ff ff       	call   1003e9 <stab_binsearch>
    if (lline <= rline) {
  100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100736:	39 c2                	cmp    %eax,%edx
  100738:	7f 24                	jg     10075e <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073d:	89 c2                	mov    %eax,%edx
  10073f:	89 d0                	mov    %edx,%eax
  100741:	01 c0                	add    %eax,%eax
  100743:	01 d0                	add    %edx,%eax
  100745:	c1 e0 02             	shl    $0x2,%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074d:	01 d0                	add    %edx,%eax
  10074f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100753:	0f b7 d0             	movzwl %ax,%edx
  100756:	8b 45 0c             	mov    0xc(%ebp),%eax
  100759:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10075c:	eb 13                	jmp    100771 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100763:	e9 12 01 00 00       	jmp    10087a <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076b:	83 e8 01             	sub    $0x1,%eax
  10076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100777:	39 c2                	cmp    %eax,%edx
  100779:	7c 56                	jl     1007d1 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077e:	89 c2                	mov    %eax,%edx
  100780:	89 d0                	mov    %edx,%eax
  100782:	01 c0                	add    %eax,%eax
  100784:	01 d0                	add    %edx,%eax
  100786:	c1 e0 02             	shl    $0x2,%eax
  100789:	89 c2                	mov    %eax,%edx
  10078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10078e:	01 d0                	add    %edx,%eax
  100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100794:	3c 84                	cmp    $0x84,%al
  100796:	74 39                	je     1007d1 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	89 d0                	mov    %edx,%eax
  10079f:	01 c0                	add    %eax,%eax
  1007a1:	01 d0                	add    %edx,%eax
  1007a3:	c1 e0 02             	shl    $0x2,%eax
  1007a6:	89 c2                	mov    %eax,%edx
  1007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ab:	01 d0                	add    %edx,%eax
  1007ad:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b1:	3c 64                	cmp    $0x64,%al
  1007b3:	75 b3                	jne    100768 <debuginfo_eip+0x229>
  1007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	89 d0                	mov    %edx,%eax
  1007bc:	01 c0                	add    %eax,%eax
  1007be:	01 d0                	add    %edx,%eax
  1007c0:	c1 e0 02             	shl    $0x2,%eax
  1007c3:	89 c2                	mov    %eax,%edx
  1007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c8:	01 d0                	add    %edx,%eax
  1007ca:	8b 40 08             	mov    0x8(%eax),%eax
  1007cd:	85 c0                	test   %eax,%eax
  1007cf:	74 97                	je     100768 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d7:	39 c2                	cmp    %eax,%edx
  1007d9:	7c 46                	jl     100821 <debuginfo_eip+0x2e2>
  1007db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007de:	89 c2                	mov    %eax,%edx
  1007e0:	89 d0                	mov    %edx,%eax
  1007e2:	01 c0                	add    %eax,%eax
  1007e4:	01 d0                	add    %edx,%eax
  1007e6:	c1 e0 02             	shl    $0x2,%eax
  1007e9:	89 c2                	mov    %eax,%edx
  1007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ee:	01 d0                	add    %edx,%eax
  1007f0:	8b 10                	mov    (%eax),%edx
  1007f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f8:	29 c1                	sub    %eax,%ecx
  1007fa:	89 c8                	mov    %ecx,%eax
  1007fc:	39 c2                	cmp    %eax,%edx
  1007fe:	73 21                	jae    100821 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	89 d0                	mov    %edx,%eax
  100807:	01 c0                	add    %eax,%eax
  100809:	01 d0                	add    %edx,%eax
  10080b:	c1 e0 02             	shl    $0x2,%eax
  10080e:	89 c2                	mov    %eax,%edx
  100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	8b 10                	mov    (%eax),%edx
  100817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10081a:	01 c2                	add    %eax,%edx
  10081c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100821:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100824:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100827:	39 c2                	cmp    %eax,%edx
  100829:	7d 4a                	jge    100875 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10082b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082e:	83 c0 01             	add    $0x1,%eax
  100831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100834:	eb 18                	jmp    10084e <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100836:	8b 45 0c             	mov    0xc(%ebp),%eax
  100839:	8b 40 14             	mov    0x14(%eax),%eax
  10083c:	8d 50 01             	lea    0x1(%eax),%edx
  10083f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100842:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100848:	83 c0 01             	add    $0x1,%eax
  10084b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100851:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100854:	39 c2                	cmp    %eax,%edx
  100856:	7d 1d                	jge    100875 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	89 d0                	mov    %edx,%eax
  10085f:	01 c0                	add    %eax,%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	c1 e0 02             	shl    $0x2,%eax
  100866:	89 c2                	mov    %eax,%edx
  100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086b:	01 d0                	add    %edx,%eax
  10086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100871:	3c a0                	cmp    $0xa0,%al
  100873:	74 c1                	je     100836 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10087a:	c9                   	leave  
  10087b:	c3                   	ret    

0010087c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10087c:	55                   	push   %ebp
  10087d:	89 e5                	mov    %esp,%ebp
  10087f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100882:	c7 04 24 56 63 10 00 	movl   $0x106356,(%esp)
  100889:	e8 ba fa ff ff       	call   100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088e:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100895:	00 
  100896:	c7 04 24 6f 63 10 00 	movl   $0x10636f,(%esp)
  10089d:	e8 a6 fa ff ff       	call   100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008a2:	c7 44 24 04 8d 62 10 	movl   $0x10628d,0x4(%esp)
  1008a9:	00 
  1008aa:	c7 04 24 87 63 10 00 	movl   $0x106387,(%esp)
  1008b1:	e8 92 fa ff ff       	call   100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b6:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008bd:	00 
  1008be:	c7 04 24 9f 63 10 00 	movl   $0x10639f,(%esp)
  1008c5:	e8 7e fa ff ff       	call   100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008ca:	c7 44 24 04 28 af 11 	movl   $0x11af28,0x4(%esp)
  1008d1:	00 
  1008d2:	c7 04 24 b7 63 10 00 	movl   $0x1063b7,(%esp)
  1008d9:	e8 6a fa ff ff       	call   100348 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008de:	b8 28 af 11 00       	mov    $0x11af28,%eax
  1008e3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008e9:	b8 36 00 10 00       	mov    $0x100036,%eax
  1008ee:	29 c2                	sub    %eax,%edx
  1008f0:	89 d0                	mov    %edx,%eax
  1008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f8:	85 c0                	test   %eax,%eax
  1008fa:	0f 48 c2             	cmovs  %edx,%eax
  1008fd:	c1 f8 0a             	sar    $0xa,%eax
  100900:	89 44 24 04          	mov    %eax,0x4(%esp)
  100904:	c7 04 24 d0 63 10 00 	movl   $0x1063d0,(%esp)
  10090b:	e8 38 fa ff ff       	call   100348 <cprintf>
}
  100910:	c9                   	leave  
  100911:	c3                   	ret    

00100912 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100912:	55                   	push   %ebp
  100913:	89 e5                	mov    %esp,%ebp
  100915:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10091b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10091e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100922:	8b 45 08             	mov    0x8(%ebp),%eax
  100925:	89 04 24             	mov    %eax,(%esp)
  100928:	e8 12 fc ff ff       	call   10053f <debuginfo_eip>
  10092d:	85 c0                	test   %eax,%eax
  10092f:	74 15                	je     100946 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100931:	8b 45 08             	mov    0x8(%ebp),%eax
  100934:	89 44 24 04          	mov    %eax,0x4(%esp)
  100938:	c7 04 24 fa 63 10 00 	movl   $0x1063fa,(%esp)
  10093f:	e8 04 fa ff ff       	call   100348 <cprintf>
  100944:	eb 6d                	jmp    1009b3 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10094d:	eb 1c                	jmp    10096b <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  10094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100955:	01 d0                	add    %edx,%eax
  100957:	0f b6 00             	movzbl (%eax),%eax
  10095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100963:	01 ca                	add    %ecx,%edx
  100965:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100971:	7f dc                	jg     10094f <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097c:	01 d0                	add    %edx,%eax
  10097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100984:	8b 55 08             	mov    0x8(%ebp),%edx
  100987:	89 d1                	mov    %edx,%ecx
  100989:	29 c1                	sub    %eax,%ecx
  10098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10099f:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a7:	c7 04 24 16 64 10 00 	movl   $0x106416,(%esp)
  1009ae:	e8 95 f9 ff ff       	call   100348 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009b3:	c9                   	leave  
  1009b4:	c3                   	ret    

001009b5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b5:	55                   	push   %ebp
  1009b6:	89 e5                	mov    %esp,%ebp
  1009b8:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009bb:	8b 45 04             	mov    0x4(%ebp),%eax
  1009be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c4:	c9                   	leave  
  1009c5:	c3                   	ret    

001009c6 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c6:	55                   	push   %ebp
  1009c7:	89 e5                	mov    %esp,%ebp
  1009c9:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cc:	89 e8                	mov    %ebp,%eax
  1009ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t valueEbp = read_ebp();
  1009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t valueEip = read_eip();
  1009d7:	e8 d9 ff ff ff       	call   1009b5 <read_eip>
  1009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i = 0 ;
  1009df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(i ; i < STACKFRAME_DEPTH; i++) {
  1009e6:	e9 92 00 00 00       	jmp    100a7d <print_stackframe+0xb7>
	    if(valueEbp != 0) {
  1009eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1009ef:	0f 84 84 00 00 00    	je     100a79 <print_stackframe+0xb3>
		cprintf("ebp:0x%08x eip:0x%08x args:", valueEbp, valueEip);
  1009f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a03:	c7 04 24 28 64 10 00 	movl   $0x106428,(%esp)
  100a0a:	e8 39 f9 ff ff       	call   100348 <cprintf>
		int j = 0;
  100a0f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for(j ; j < 4; j++) {
  100a16:	eb 2e                	jmp    100a46 <print_stackframe+0x80>
		    uint32_t args =  *((uint32_t*)valueEbp + 2 + j);
  100a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a25:	01 d0                	add    %edx,%eax
  100a27:	83 c0 08             	add    $0x8,%eax
  100a2a:	8b 00                	mov    (%eax),%eax
  100a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		    cprintf("0x%08x ", args);
  100a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a32:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a36:	c7 04 24 44 64 10 00 	movl   $0x106444,(%esp)
  100a3d:	e8 06 f9 ff ff       	call   100348 <cprintf>
	int i = 0 ;
	for(i ; i < STACKFRAME_DEPTH; i++) {
	    if(valueEbp != 0) {
		cprintf("ebp:0x%08x eip:0x%08x args:", valueEbp, valueEip);
		int j = 0;
		for(j ; j < 4; j++) {
  100a42:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a46:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a4a:	7e cc                	jle    100a18 <print_stackframe+0x52>
		    uint32_t args =  *((uint32_t*)valueEbp + 2 + j);
		    cprintf("0x%08x ", args);
		}
		cprintf("\n");
  100a4c:	c7 04 24 4c 64 10 00 	movl   $0x10644c,(%esp)
  100a53:	e8 f0 f8 ff ff       	call   100348 <cprintf>
		print_debuginfo(valueEip - 1);
  100a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a5b:	83 e8 01             	sub    $0x1,%eax
  100a5e:	89 04 24             	mov    %eax,(%esp)
  100a61:	e8 ac fe ff ff       	call   100912 <print_debuginfo>
		valueEip = *((uint32_t*)valueEbp + 1);
  100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a69:	83 c0 04             	add    $0x4,%eax
  100a6c:	8b 00                	mov    (%eax),%eax
  100a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		valueEbp = *((uint32_t*)valueEbp);
  100a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a74:	8b 00                	mov    (%eax),%eax
  100a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t valueEbp = read_ebp();
	uint32_t valueEip = read_eip();
	int i = 0 ;
	for(i ; i < STACKFRAME_DEPTH; i++) {
  100a79:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a7d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a81:	0f 8e 64 ff ff ff    	jle    1009eb <print_stackframe+0x25>
		print_debuginfo(valueEip - 1);
		valueEip = *((uint32_t*)valueEbp + 1);
		valueEbp = *((uint32_t*)valueEbp);
	    }
	}
}
  100a87:	c9                   	leave  
  100a88:	c3                   	ret    

00100a89 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a89:	55                   	push   %ebp
  100a8a:	89 e5                	mov    %esp,%ebp
  100a8c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a96:	eb 0c                	jmp    100aa4 <parse+0x1b>
            *buf ++ = '\0';
  100a98:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9b:	8d 50 01             	lea    0x1(%eax),%edx
  100a9e:	89 55 08             	mov    %edx,0x8(%ebp)
  100aa1:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa7:	0f b6 00             	movzbl (%eax),%eax
  100aaa:	84 c0                	test   %al,%al
  100aac:	74 1d                	je     100acb <parse+0x42>
  100aae:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab1:	0f b6 00             	movzbl (%eax),%eax
  100ab4:	0f be c0             	movsbl %al,%eax
  100ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100abb:	c7 04 24 d0 64 10 00 	movl   $0x1064d0,(%esp)
  100ac2:	e8 7e 54 00 00       	call   105f45 <strchr>
  100ac7:	85 c0                	test   %eax,%eax
  100ac9:	75 cd                	jne    100a98 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100acb:	8b 45 08             	mov    0x8(%ebp),%eax
  100ace:	0f b6 00             	movzbl (%eax),%eax
  100ad1:	84 c0                	test   %al,%al
  100ad3:	75 02                	jne    100ad7 <parse+0x4e>
            break;
  100ad5:	eb 67                	jmp    100b3e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ad7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100adb:	75 14                	jne    100af1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100add:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ae4:	00 
  100ae5:	c7 04 24 d5 64 10 00 	movl   $0x1064d5,(%esp)
  100aec:	e8 57 f8 ff ff       	call   100348 <cprintf>
        }
        argv[argc ++] = buf;
  100af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af4:	8d 50 01             	lea    0x1(%eax),%edx
  100af7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100afa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b04:	01 c2                	add    %eax,%edx
  100b06:	8b 45 08             	mov    0x8(%ebp),%eax
  100b09:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b0b:	eb 04                	jmp    100b11 <parse+0x88>
            buf ++;
  100b0d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b11:	8b 45 08             	mov    0x8(%ebp),%eax
  100b14:	0f b6 00             	movzbl (%eax),%eax
  100b17:	84 c0                	test   %al,%al
  100b19:	74 1d                	je     100b38 <parse+0xaf>
  100b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1e:	0f b6 00             	movzbl (%eax),%eax
  100b21:	0f be c0             	movsbl %al,%eax
  100b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b28:	c7 04 24 d0 64 10 00 	movl   $0x1064d0,(%esp)
  100b2f:	e8 11 54 00 00       	call   105f45 <strchr>
  100b34:	85 c0                	test   %eax,%eax
  100b36:	74 d5                	je     100b0d <parse+0x84>
            buf ++;
        }
    }
  100b38:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b39:	e9 66 ff ff ff       	jmp    100aa4 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b41:	c9                   	leave  
  100b42:	c3                   	ret    

00100b43 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b43:	55                   	push   %ebp
  100b44:	89 e5                	mov    %esp,%ebp
  100b46:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b49:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b50:	8b 45 08             	mov    0x8(%ebp),%eax
  100b53:	89 04 24             	mov    %eax,(%esp)
  100b56:	e8 2e ff ff ff       	call   100a89 <parse>
  100b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b62:	75 0a                	jne    100b6e <runcmd+0x2b>
        return 0;
  100b64:	b8 00 00 00 00       	mov    $0x0,%eax
  100b69:	e9 85 00 00 00       	jmp    100bf3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b75:	eb 5c                	jmp    100bd3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b77:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b7d:	89 d0                	mov    %edx,%eax
  100b7f:	01 c0                	add    %eax,%eax
  100b81:	01 d0                	add    %edx,%eax
  100b83:	c1 e0 02             	shl    $0x2,%eax
  100b86:	05 00 70 11 00       	add    $0x117000,%eax
  100b8b:	8b 00                	mov    (%eax),%eax
  100b8d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b91:	89 04 24             	mov    %eax,(%esp)
  100b94:	e8 0d 53 00 00       	call   105ea6 <strcmp>
  100b99:	85 c0                	test   %eax,%eax
  100b9b:	75 32                	jne    100bcf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ba0:	89 d0                	mov    %edx,%eax
  100ba2:	01 c0                	add    %eax,%eax
  100ba4:	01 d0                	add    %edx,%eax
  100ba6:	c1 e0 02             	shl    $0x2,%eax
  100ba9:	05 00 70 11 00       	add    $0x117000,%eax
  100bae:	8b 40 08             	mov    0x8(%eax),%eax
  100bb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bb4:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bba:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bbe:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bc1:	83 c2 04             	add    $0x4,%edx
  100bc4:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bc8:	89 0c 24             	mov    %ecx,(%esp)
  100bcb:	ff d0                	call   *%eax
  100bcd:	eb 24                	jmp    100bf3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bcf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd6:	83 f8 02             	cmp    $0x2,%eax
  100bd9:	76 9c                	jbe    100b77 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bdb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bde:	89 44 24 04          	mov    %eax,0x4(%esp)
  100be2:	c7 04 24 f3 64 10 00 	movl   $0x1064f3,(%esp)
  100be9:	e8 5a f7 ff ff       	call   100348 <cprintf>
    return 0;
  100bee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bf3:	c9                   	leave  
  100bf4:	c3                   	ret    

00100bf5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bf5:	55                   	push   %ebp
  100bf6:	89 e5                	mov    %esp,%ebp
  100bf8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bfb:	c7 04 24 0c 65 10 00 	movl   $0x10650c,(%esp)
  100c02:	e8 41 f7 ff ff       	call   100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c07:	c7 04 24 34 65 10 00 	movl   $0x106534,(%esp)
  100c0e:	e8 35 f7 ff ff       	call   100348 <cprintf>

    if (tf != NULL) {
  100c13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c17:	74 0b                	je     100c24 <kmonitor+0x2f>
        print_trapframe(tf);
  100c19:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1c:	89 04 24             	mov    %eax,(%esp)
  100c1f:	e8 a7 0f 00 00       	call   101bcb <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c24:	c7 04 24 59 65 10 00 	movl   $0x106559,(%esp)
  100c2b:	e8 0f f6 ff ff       	call   10023f <readline>
  100c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c37:	74 18                	je     100c51 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c39:	8b 45 08             	mov    0x8(%ebp),%eax
  100c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c43:	89 04 24             	mov    %eax,(%esp)
  100c46:	e8 f8 fe ff ff       	call   100b43 <runcmd>
  100c4b:	85 c0                	test   %eax,%eax
  100c4d:	79 02                	jns    100c51 <kmonitor+0x5c>
                break;
  100c4f:	eb 02                	jmp    100c53 <kmonitor+0x5e>
            }
        }
    }
  100c51:	eb d1                	jmp    100c24 <kmonitor+0x2f>
}
  100c53:	c9                   	leave  
  100c54:	c3                   	ret    

00100c55 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c55:	55                   	push   %ebp
  100c56:	89 e5                	mov    %esp,%ebp
  100c58:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c62:	eb 3f                	jmp    100ca3 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c67:	89 d0                	mov    %edx,%eax
  100c69:	01 c0                	add    %eax,%eax
  100c6b:	01 d0                	add    %edx,%eax
  100c6d:	c1 e0 02             	shl    $0x2,%eax
  100c70:	05 00 70 11 00       	add    $0x117000,%eax
  100c75:	8b 48 04             	mov    0x4(%eax),%ecx
  100c78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c7b:	89 d0                	mov    %edx,%eax
  100c7d:	01 c0                	add    %eax,%eax
  100c7f:	01 d0                	add    %edx,%eax
  100c81:	c1 e0 02             	shl    $0x2,%eax
  100c84:	05 00 70 11 00       	add    $0x117000,%eax
  100c89:	8b 00                	mov    (%eax),%eax
  100c8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c93:	c7 04 24 5d 65 10 00 	movl   $0x10655d,(%esp)
  100c9a:	e8 a9 f6 ff ff       	call   100348 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c9f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca6:	83 f8 02             	cmp    $0x2,%eax
  100ca9:	76 b9                	jbe    100c64 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb0:	c9                   	leave  
  100cb1:	c3                   	ret    

00100cb2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cb2:	55                   	push   %ebp
  100cb3:	89 e5                	mov    %esp,%ebp
  100cb5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cb8:	e8 bf fb ff ff       	call   10087c <print_kerninfo>
    return 0;
  100cbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc2:	c9                   	leave  
  100cc3:	c3                   	ret    

00100cc4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cc4:	55                   	push   %ebp
  100cc5:	89 e5                	mov    %esp,%ebp
  100cc7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cca:	e8 f7 fc ff ff       	call   1009c6 <print_stackframe>
    return 0;
  100ccf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd4:	c9                   	leave  
  100cd5:	c3                   	ret    

00100cd6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cd6:	55                   	push   %ebp
  100cd7:	89 e5                	mov    %esp,%ebp
  100cd9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cdc:	a1 20 a4 11 00       	mov    0x11a420,%eax
  100ce1:	85 c0                	test   %eax,%eax
  100ce3:	74 02                	je     100ce7 <__panic+0x11>
        goto panic_dead;
  100ce5:	eb 59                	jmp    100d40 <__panic+0x6a>
    }
    is_panic = 1;
  100ce7:	c7 05 20 a4 11 00 01 	movl   $0x1,0x11a420
  100cee:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cf1:	8d 45 14             	lea    0x14(%ebp),%eax
  100cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  100d01:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d05:	c7 04 24 66 65 10 00 	movl   $0x106566,(%esp)
  100d0c:	e8 37 f6 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d18:	8b 45 10             	mov    0x10(%ebp),%eax
  100d1b:	89 04 24             	mov    %eax,(%esp)
  100d1e:	e8 f2 f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100d23:	c7 04 24 82 65 10 00 	movl   $0x106582,(%esp)
  100d2a:	e8 19 f6 ff ff       	call   100348 <cprintf>
    
    cprintf("stack trackback:\n");
  100d2f:	c7 04 24 84 65 10 00 	movl   $0x106584,(%esp)
  100d36:	e8 0d f6 ff ff       	call   100348 <cprintf>
    print_stackframe();
  100d3b:	e8 86 fc ff ff       	call   1009c6 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d40:	e8 85 09 00 00       	call   1016ca <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d4c:	e8 a4 fe ff ff       	call   100bf5 <kmonitor>
    }
  100d51:	eb f2                	jmp    100d45 <__panic+0x6f>

00100d53 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d53:	55                   	push   %ebp
  100d54:	89 e5                	mov    %esp,%ebp
  100d56:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d59:	8d 45 14             	lea    0x14(%ebp),%eax
  100d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d62:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d66:	8b 45 08             	mov    0x8(%ebp),%eax
  100d69:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d6d:	c7 04 24 96 65 10 00 	movl   $0x106596,(%esp)
  100d74:	e8 cf f5 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d80:	8b 45 10             	mov    0x10(%ebp),%eax
  100d83:	89 04 24             	mov    %eax,(%esp)
  100d86:	e8 8a f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100d8b:	c7 04 24 82 65 10 00 	movl   $0x106582,(%esp)
  100d92:	e8 b1 f5 ff ff       	call   100348 <cprintf>
    va_end(ap);
}
  100d97:	c9                   	leave  
  100d98:	c3                   	ret    

00100d99 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d99:	55                   	push   %ebp
  100d9a:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d9c:	a1 20 a4 11 00       	mov    0x11a420,%eax
}
  100da1:	5d                   	pop    %ebp
  100da2:	c3                   	ret    

00100da3 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100da3:	55                   	push   %ebp
  100da4:	89 e5                	mov    %esp,%ebp
  100da6:	83 ec 28             	sub    $0x28,%esp
  100da9:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100daf:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100db3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100db7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dbb:	ee                   	out    %al,(%dx)
  100dbc:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dc2:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dc6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dca:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dce:	ee                   	out    %al,(%dx)
  100dcf:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dd5:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dd9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ddd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100de1:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100de2:	c7 05 0c af 11 00 00 	movl   $0x0,0x11af0c
  100de9:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dec:	c7 04 24 b4 65 10 00 	movl   $0x1065b4,(%esp)
  100df3:	e8 50 f5 ff ff       	call   100348 <cprintf>
    pic_enable(IRQ_TIMER);
  100df8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dff:	e8 24 09 00 00       	call   101728 <pic_enable>
}
  100e04:	c9                   	leave  
  100e05:	c3                   	ret    

00100e06 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e06:	55                   	push   %ebp
  100e07:	89 e5                	mov    %esp,%ebp
  100e09:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e0c:	9c                   	pushf  
  100e0d:	58                   	pop    %eax
  100e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e14:	25 00 02 00 00       	and    $0x200,%eax
  100e19:	85 c0                	test   %eax,%eax
  100e1b:	74 0c                	je     100e29 <__intr_save+0x23>
        intr_disable();
  100e1d:	e8 a8 08 00 00       	call   1016ca <intr_disable>
        return 1;
  100e22:	b8 01 00 00 00       	mov    $0x1,%eax
  100e27:	eb 05                	jmp    100e2e <__intr_save+0x28>
    }
    return 0;
  100e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e2e:	c9                   	leave  
  100e2f:	c3                   	ret    

00100e30 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e30:	55                   	push   %ebp
  100e31:	89 e5                	mov    %esp,%ebp
  100e33:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e3a:	74 05                	je     100e41 <__intr_restore+0x11>
        intr_enable();
  100e3c:	e8 83 08 00 00       	call   1016c4 <intr_enable>
    }
}
  100e41:	c9                   	leave  
  100e42:	c3                   	ret    

00100e43 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e43:	55                   	push   %ebp
  100e44:	89 e5                	mov    %esp,%ebp
  100e46:	83 ec 10             	sub    $0x10,%esp
  100e49:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e4f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e53:	89 c2                	mov    %eax,%edx
  100e55:	ec                   	in     (%dx),%al
  100e56:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e59:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e5f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e63:	89 c2                	mov    %eax,%edx
  100e65:	ec                   	in     (%dx),%al
  100e66:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e69:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e6f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e73:	89 c2                	mov    %eax,%edx
  100e75:	ec                   	in     (%dx),%al
  100e76:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e79:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e7f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e83:	89 c2                	mov    %eax,%edx
  100e85:	ec                   	in     (%dx),%al
  100e86:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e89:	c9                   	leave  
  100e8a:	c3                   	ret    

00100e8b <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e8b:	55                   	push   %ebp
  100e8c:	89 e5                	mov    %esp,%ebp
  100e8e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e91:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9b:	0f b7 00             	movzwl (%eax),%eax
  100e9e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea5:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100eaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ead:	0f b7 00             	movzwl (%eax),%eax
  100eb0:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100eb4:	74 12                	je     100ec8 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100eb6:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ebd:	66 c7 05 46 a4 11 00 	movw   $0x3b4,0x11a446
  100ec4:	b4 03 
  100ec6:	eb 13                	jmp    100edb <cga_init+0x50>
    } else {
        *cp = was;
  100ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ecf:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ed2:	66 c7 05 46 a4 11 00 	movw   $0x3d4,0x11a446
  100ed9:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100edb:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ee2:	0f b7 c0             	movzwl %ax,%eax
  100ee5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ee9:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eed:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ef1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ef5:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ef6:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100efd:	83 c0 01             	add    $0x1,%eax
  100f00:	0f b7 c0             	movzwl %ax,%eax
  100f03:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f07:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f0b:	89 c2                	mov    %eax,%edx
  100f0d:	ec                   	in     (%dx),%al
  100f0e:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f11:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f15:	0f b6 c0             	movzbl %al,%eax
  100f18:	c1 e0 08             	shl    $0x8,%eax
  100f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f1e:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f25:	0f b7 c0             	movzwl %ax,%eax
  100f28:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f2c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f30:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f34:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f38:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f39:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f40:	83 c0 01             	add    $0x1,%eax
  100f43:	0f b7 c0             	movzwl %ax,%eax
  100f46:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f4a:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f4e:	89 c2                	mov    %eax,%edx
  100f50:	ec                   	in     (%dx),%al
  100f51:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f54:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f58:	0f b6 c0             	movzbl %al,%eax
  100f5b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f61:	a3 40 a4 11 00       	mov    %eax,0x11a440
    crt_pos = pos;
  100f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f69:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
}
  100f6f:	c9                   	leave  
  100f70:	c3                   	ret    

00100f71 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f71:	55                   	push   %ebp
  100f72:	89 e5                	mov    %esp,%ebp
  100f74:	83 ec 48             	sub    $0x48,%esp
  100f77:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f7d:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f81:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f85:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f89:	ee                   	out    %al,(%dx)
  100f8a:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f90:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f94:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f98:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f9c:	ee                   	out    %al,(%dx)
  100f9d:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100fa3:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100fa7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fab:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100faf:	ee                   	out    %al,(%dx)
  100fb0:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fb6:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fba:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fbe:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fc2:	ee                   	out    %al,(%dx)
  100fc3:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fc9:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fcd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fd1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fd5:	ee                   	out    %al,(%dx)
  100fd6:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fdc:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fe0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fe4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fe8:	ee                   	out    %al,(%dx)
  100fe9:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fef:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100ff3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100ff7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100ffb:	ee                   	out    %al,(%dx)
  100ffc:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101002:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  101006:	89 c2                	mov    %eax,%edx
  101008:	ec                   	in     (%dx),%al
  101009:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  10100c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101010:	3c ff                	cmp    $0xff,%al
  101012:	0f 95 c0             	setne  %al
  101015:	0f b6 c0             	movzbl %al,%eax
  101018:	a3 48 a4 11 00       	mov    %eax,0x11a448
  10101d:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101023:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101027:	89 c2                	mov    %eax,%edx
  101029:	ec                   	in     (%dx),%al
  10102a:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10102d:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101033:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101037:	89 c2                	mov    %eax,%edx
  101039:	ec                   	in     (%dx),%al
  10103a:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10103d:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101042:	85 c0                	test   %eax,%eax
  101044:	74 0c                	je     101052 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101046:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10104d:	e8 d6 06 00 00       	call   101728 <pic_enable>
    }
}
  101052:	c9                   	leave  
  101053:	c3                   	ret    

00101054 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101054:	55                   	push   %ebp
  101055:	89 e5                	mov    %esp,%ebp
  101057:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10105a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101061:	eb 09                	jmp    10106c <lpt_putc_sub+0x18>
        delay();
  101063:	e8 db fd ff ff       	call   100e43 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101068:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10106c:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101072:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101076:	89 c2                	mov    %eax,%edx
  101078:	ec                   	in     (%dx),%al
  101079:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10107c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101080:	84 c0                	test   %al,%al
  101082:	78 09                	js     10108d <lpt_putc_sub+0x39>
  101084:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10108b:	7e d6                	jle    101063 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10108d:	8b 45 08             	mov    0x8(%ebp),%eax
  101090:	0f b6 c0             	movzbl %al,%eax
  101093:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101099:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10109c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010a0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010a4:	ee                   	out    %al,(%dx)
  1010a5:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010ab:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010af:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010b3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010b7:	ee                   	out    %al,(%dx)
  1010b8:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010be:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010c2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010c6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010ca:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010cb:	c9                   	leave  
  1010cc:	c3                   	ret    

001010cd <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010cd:	55                   	push   %ebp
  1010ce:	89 e5                	mov    %esp,%ebp
  1010d0:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010d3:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010d7:	74 0d                	je     1010e6 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010dc:	89 04 24             	mov    %eax,(%esp)
  1010df:	e8 70 ff ff ff       	call   101054 <lpt_putc_sub>
  1010e4:	eb 24                	jmp    10110a <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010e6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ed:	e8 62 ff ff ff       	call   101054 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010f2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010f9:	e8 56 ff ff ff       	call   101054 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010fe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101105:	e8 4a ff ff ff       	call   101054 <lpt_putc_sub>
    }
}
  10110a:	c9                   	leave  
  10110b:	c3                   	ret    

0010110c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10110c:	55                   	push   %ebp
  10110d:	89 e5                	mov    %esp,%ebp
  10110f:	53                   	push   %ebx
  101110:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101113:	8b 45 08             	mov    0x8(%ebp),%eax
  101116:	b0 00                	mov    $0x0,%al
  101118:	85 c0                	test   %eax,%eax
  10111a:	75 07                	jne    101123 <cga_putc+0x17>
        c |= 0x0700;
  10111c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101123:	8b 45 08             	mov    0x8(%ebp),%eax
  101126:	0f b6 c0             	movzbl %al,%eax
  101129:	83 f8 0a             	cmp    $0xa,%eax
  10112c:	74 4c                	je     10117a <cga_putc+0x6e>
  10112e:	83 f8 0d             	cmp    $0xd,%eax
  101131:	74 57                	je     10118a <cga_putc+0x7e>
  101133:	83 f8 08             	cmp    $0x8,%eax
  101136:	0f 85 88 00 00 00    	jne    1011c4 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10113c:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101143:	66 85 c0             	test   %ax,%ax
  101146:	74 30                	je     101178 <cga_putc+0x6c>
            crt_pos --;
  101148:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10114f:	83 e8 01             	sub    $0x1,%eax
  101152:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101158:	a1 40 a4 11 00       	mov    0x11a440,%eax
  10115d:	0f b7 15 44 a4 11 00 	movzwl 0x11a444,%edx
  101164:	0f b7 d2             	movzwl %dx,%edx
  101167:	01 d2                	add    %edx,%edx
  101169:	01 c2                	add    %eax,%edx
  10116b:	8b 45 08             	mov    0x8(%ebp),%eax
  10116e:	b0 00                	mov    $0x0,%al
  101170:	83 c8 20             	or     $0x20,%eax
  101173:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101176:	eb 72                	jmp    1011ea <cga_putc+0xde>
  101178:	eb 70                	jmp    1011ea <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10117a:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101181:	83 c0 50             	add    $0x50,%eax
  101184:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10118a:	0f b7 1d 44 a4 11 00 	movzwl 0x11a444,%ebx
  101191:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  101198:	0f b7 c1             	movzwl %cx,%eax
  10119b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1011a1:	c1 e8 10             	shr    $0x10,%eax
  1011a4:	89 c2                	mov    %eax,%edx
  1011a6:	66 c1 ea 06          	shr    $0x6,%dx
  1011aa:	89 d0                	mov    %edx,%eax
  1011ac:	c1 e0 02             	shl    $0x2,%eax
  1011af:	01 d0                	add    %edx,%eax
  1011b1:	c1 e0 04             	shl    $0x4,%eax
  1011b4:	29 c1                	sub    %eax,%ecx
  1011b6:	89 ca                	mov    %ecx,%edx
  1011b8:	89 d8                	mov    %ebx,%eax
  1011ba:	29 d0                	sub    %edx,%eax
  1011bc:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
        break;
  1011c2:	eb 26                	jmp    1011ea <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011c4:	8b 0d 40 a4 11 00    	mov    0x11a440,%ecx
  1011ca:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011d1:	8d 50 01             	lea    0x1(%eax),%edx
  1011d4:	66 89 15 44 a4 11 00 	mov    %dx,0x11a444
  1011db:	0f b7 c0             	movzwl %ax,%eax
  1011de:	01 c0                	add    %eax,%eax
  1011e0:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1011e6:	66 89 02             	mov    %ax,(%edx)
        break;
  1011e9:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011ea:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011f1:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011f5:	76 5b                	jbe    101252 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011f7:	a1 40 a4 11 00       	mov    0x11a440,%eax
  1011fc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101202:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101207:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10120e:	00 
  10120f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101213:	89 04 24             	mov    %eax,(%esp)
  101216:	e8 28 4f 00 00       	call   106143 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121b:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101222:	eb 15                	jmp    101239 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101224:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101229:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10122c:	01 d2                	add    %edx,%edx
  10122e:	01 d0                	add    %edx,%eax
  101230:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101235:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101239:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101240:	7e e2                	jle    101224 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101242:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101249:	83 e8 50             	sub    $0x50,%eax
  10124c:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101252:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  101259:	0f b7 c0             	movzwl %ax,%eax
  10125c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101260:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101264:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101268:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10126c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10126d:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101274:	66 c1 e8 08          	shr    $0x8,%ax
  101278:	0f b6 c0             	movzbl %al,%eax
  10127b:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  101282:	83 c2 01             	add    $0x1,%edx
  101285:	0f b7 d2             	movzwl %dx,%edx
  101288:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10128c:	88 45 ed             	mov    %al,-0x13(%ebp)
  10128f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101293:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101297:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101298:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  10129f:	0f b7 c0             	movzwl %ax,%eax
  1012a2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1012a6:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1012aa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012ae:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012b2:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012b3:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1012ba:	0f b6 c0             	movzbl %al,%eax
  1012bd:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  1012c4:	83 c2 01             	add    $0x1,%edx
  1012c7:	0f b7 d2             	movzwl %dx,%edx
  1012ca:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012ce:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012d1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012d5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012d9:	ee                   	out    %al,(%dx)
}
  1012da:	83 c4 34             	add    $0x34,%esp
  1012dd:	5b                   	pop    %ebx
  1012de:	5d                   	pop    %ebp
  1012df:	c3                   	ret    

001012e0 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012e0:	55                   	push   %ebp
  1012e1:	89 e5                	mov    %esp,%ebp
  1012e3:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012ed:	eb 09                	jmp    1012f8 <serial_putc_sub+0x18>
        delay();
  1012ef:	e8 4f fb ff ff       	call   100e43 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012f8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012fe:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101302:	89 c2                	mov    %eax,%edx
  101304:	ec                   	in     (%dx),%al
  101305:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101308:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10130c:	0f b6 c0             	movzbl %al,%eax
  10130f:	83 e0 20             	and    $0x20,%eax
  101312:	85 c0                	test   %eax,%eax
  101314:	75 09                	jne    10131f <serial_putc_sub+0x3f>
  101316:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10131d:	7e d0                	jle    1012ef <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10131f:	8b 45 08             	mov    0x8(%ebp),%eax
  101322:	0f b6 c0             	movzbl %al,%eax
  101325:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10132b:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10132e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101332:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101336:	ee                   	out    %al,(%dx)
}
  101337:	c9                   	leave  
  101338:	c3                   	ret    

00101339 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101339:	55                   	push   %ebp
  10133a:	89 e5                	mov    %esp,%ebp
  10133c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10133f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101343:	74 0d                	je     101352 <serial_putc+0x19>
        serial_putc_sub(c);
  101345:	8b 45 08             	mov    0x8(%ebp),%eax
  101348:	89 04 24             	mov    %eax,(%esp)
  10134b:	e8 90 ff ff ff       	call   1012e0 <serial_putc_sub>
  101350:	eb 24                	jmp    101376 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101352:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101359:	e8 82 ff ff ff       	call   1012e0 <serial_putc_sub>
        serial_putc_sub(' ');
  10135e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101365:	e8 76 ff ff ff       	call   1012e0 <serial_putc_sub>
        serial_putc_sub('\b');
  10136a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101371:	e8 6a ff ff ff       	call   1012e0 <serial_putc_sub>
    }
}
  101376:	c9                   	leave  
  101377:	c3                   	ret    

00101378 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101378:	55                   	push   %ebp
  101379:	89 e5                	mov    %esp,%ebp
  10137b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10137e:	eb 33                	jmp    1013b3 <cons_intr+0x3b>
        if (c != 0) {
  101380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101384:	74 2d                	je     1013b3 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101386:	a1 64 a6 11 00       	mov    0x11a664,%eax
  10138b:	8d 50 01             	lea    0x1(%eax),%edx
  10138e:	89 15 64 a6 11 00    	mov    %edx,0x11a664
  101394:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101397:	88 90 60 a4 11 00    	mov    %dl,0x11a460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10139d:	a1 64 a6 11 00       	mov    0x11a664,%eax
  1013a2:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013a7:	75 0a                	jne    1013b3 <cons_intr+0x3b>
                cons.wpos = 0;
  1013a9:	c7 05 64 a6 11 00 00 	movl   $0x0,0x11a664
  1013b0:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1013b6:	ff d0                	call   *%eax
  1013b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013bb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013bf:	75 bf                	jne    101380 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013c1:	c9                   	leave  
  1013c2:	c3                   	ret    

001013c3 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013c3:	55                   	push   %ebp
  1013c4:	89 e5                	mov    %esp,%ebp
  1013c6:	83 ec 10             	sub    $0x10,%esp
  1013c9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013cf:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013d3:	89 c2                	mov    %eax,%edx
  1013d5:	ec                   	in     (%dx),%al
  1013d6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013d9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013dd:	0f b6 c0             	movzbl %al,%eax
  1013e0:	83 e0 01             	and    $0x1,%eax
  1013e3:	85 c0                	test   %eax,%eax
  1013e5:	75 07                	jne    1013ee <serial_proc_data+0x2b>
        return -1;
  1013e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013ec:	eb 2a                	jmp    101418 <serial_proc_data+0x55>
  1013ee:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013f4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013f8:	89 c2                	mov    %eax,%edx
  1013fa:	ec                   	in     (%dx),%al
  1013fb:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013fe:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101402:	0f b6 c0             	movzbl %al,%eax
  101405:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101408:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10140c:	75 07                	jne    101415 <serial_proc_data+0x52>
        c = '\b';
  10140e:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101415:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101418:	c9                   	leave  
  101419:	c3                   	ret    

0010141a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10141a:	55                   	push   %ebp
  10141b:	89 e5                	mov    %esp,%ebp
  10141d:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101420:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101425:	85 c0                	test   %eax,%eax
  101427:	74 0c                	je     101435 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101429:	c7 04 24 c3 13 10 00 	movl   $0x1013c3,(%esp)
  101430:	e8 43 ff ff ff       	call   101378 <cons_intr>
    }
}
  101435:	c9                   	leave  
  101436:	c3                   	ret    

00101437 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101437:	55                   	push   %ebp
  101438:	89 e5                	mov    %esp,%ebp
  10143a:	83 ec 38             	sub    $0x38,%esp
  10143d:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101443:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101447:	89 c2                	mov    %eax,%edx
  101449:	ec                   	in     (%dx),%al
  10144a:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10144d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101451:	0f b6 c0             	movzbl %al,%eax
  101454:	83 e0 01             	and    $0x1,%eax
  101457:	85 c0                	test   %eax,%eax
  101459:	75 0a                	jne    101465 <kbd_proc_data+0x2e>
        return -1;
  10145b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101460:	e9 59 01 00 00       	jmp    1015be <kbd_proc_data+0x187>
  101465:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10146b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10146f:	89 c2                	mov    %eax,%edx
  101471:	ec                   	in     (%dx),%al
  101472:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101475:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101479:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10147c:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101480:	75 17                	jne    101499 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101482:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101487:	83 c8 40             	or     $0x40,%eax
  10148a:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  10148f:	b8 00 00 00 00       	mov    $0x0,%eax
  101494:	e9 25 01 00 00       	jmp    1015be <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101499:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149d:	84 c0                	test   %al,%al
  10149f:	79 47                	jns    1014e8 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014a1:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014a6:	83 e0 40             	and    $0x40,%eax
  1014a9:	85 c0                	test   %eax,%eax
  1014ab:	75 09                	jne    1014b6 <kbd_proc_data+0x7f>
  1014ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b1:	83 e0 7f             	and    $0x7f,%eax
  1014b4:	eb 04                	jmp    1014ba <kbd_proc_data+0x83>
  1014b6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ba:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014bd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c1:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1014c8:	83 c8 40             	or     $0x40,%eax
  1014cb:	0f b6 c0             	movzbl %al,%eax
  1014ce:	f7 d0                	not    %eax
  1014d0:	89 c2                	mov    %eax,%edx
  1014d2:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014d7:	21 d0                	and    %edx,%eax
  1014d9:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014de:	b8 00 00 00 00       	mov    $0x0,%eax
  1014e3:	e9 d6 00 00 00       	jmp    1015be <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014e8:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014ed:	83 e0 40             	and    $0x40,%eax
  1014f0:	85 c0                	test   %eax,%eax
  1014f2:	74 11                	je     101505 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014f4:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014f8:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014fd:	83 e0 bf             	and    $0xffffffbf,%eax
  101500:	a3 68 a6 11 00       	mov    %eax,0x11a668
    }

    shift |= shiftcode[data];
  101505:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101509:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  101510:	0f b6 d0             	movzbl %al,%edx
  101513:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101518:	09 d0                	or     %edx,%eax
  10151a:	a3 68 a6 11 00       	mov    %eax,0x11a668
    shift ^= togglecode[data];
  10151f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101523:	0f b6 80 40 71 11 00 	movzbl 0x117140(%eax),%eax
  10152a:	0f b6 d0             	movzbl %al,%edx
  10152d:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101532:	31 d0                	xor    %edx,%eax
  101534:	a3 68 a6 11 00       	mov    %eax,0x11a668

    c = charcode[shift & (CTL | SHIFT)][data];
  101539:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10153e:	83 e0 03             	and    $0x3,%eax
  101541:	8b 14 85 40 75 11 00 	mov    0x117540(,%eax,4),%edx
  101548:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10154c:	01 d0                	add    %edx,%eax
  10154e:	0f b6 00             	movzbl (%eax),%eax
  101551:	0f b6 c0             	movzbl %al,%eax
  101554:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101557:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10155c:	83 e0 08             	and    $0x8,%eax
  10155f:	85 c0                	test   %eax,%eax
  101561:	74 22                	je     101585 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101563:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101567:	7e 0c                	jle    101575 <kbd_proc_data+0x13e>
  101569:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10156d:	7f 06                	jg     101575 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10156f:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101573:	eb 10                	jmp    101585 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101575:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101579:	7e 0a                	jle    101585 <kbd_proc_data+0x14e>
  10157b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10157f:	7f 04                	jg     101585 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101581:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101585:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10158a:	f7 d0                	not    %eax
  10158c:	83 e0 06             	and    $0x6,%eax
  10158f:	85 c0                	test   %eax,%eax
  101591:	75 28                	jne    1015bb <kbd_proc_data+0x184>
  101593:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10159a:	75 1f                	jne    1015bb <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10159c:	c7 04 24 cf 65 10 00 	movl   $0x1065cf,(%esp)
  1015a3:	e8 a0 ed ff ff       	call   100348 <cprintf>
  1015a8:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015ae:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015b2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015b6:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015ba:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015be:	c9                   	leave  
  1015bf:	c3                   	ret    

001015c0 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015c0:	55                   	push   %ebp
  1015c1:	89 e5                	mov    %esp,%ebp
  1015c3:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015c6:	c7 04 24 37 14 10 00 	movl   $0x101437,(%esp)
  1015cd:	e8 a6 fd ff ff       	call   101378 <cons_intr>
}
  1015d2:	c9                   	leave  
  1015d3:	c3                   	ret    

001015d4 <kbd_init>:

static void
kbd_init(void) {
  1015d4:	55                   	push   %ebp
  1015d5:	89 e5                	mov    %esp,%ebp
  1015d7:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015da:	e8 e1 ff ff ff       	call   1015c0 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015e6:	e8 3d 01 00 00       	call   101728 <pic_enable>
}
  1015eb:	c9                   	leave  
  1015ec:	c3                   	ret    

001015ed <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015ed:	55                   	push   %ebp
  1015ee:	89 e5                	mov    %esp,%ebp
  1015f0:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015f3:	e8 93 f8 ff ff       	call   100e8b <cga_init>
    serial_init();
  1015f8:	e8 74 f9 ff ff       	call   100f71 <serial_init>
    kbd_init();
  1015fd:	e8 d2 ff ff ff       	call   1015d4 <kbd_init>
    if (!serial_exists) {
  101602:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101607:	85 c0                	test   %eax,%eax
  101609:	75 0c                	jne    101617 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10160b:	c7 04 24 db 65 10 00 	movl   $0x1065db,(%esp)
  101612:	e8 31 ed ff ff       	call   100348 <cprintf>
    }
}
  101617:	c9                   	leave  
  101618:	c3                   	ret    

00101619 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101619:	55                   	push   %ebp
  10161a:	89 e5                	mov    %esp,%ebp
  10161c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  10161f:	e8 e2 f7 ff ff       	call   100e06 <__intr_save>
  101624:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101627:	8b 45 08             	mov    0x8(%ebp),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 9b fa ff ff       	call   1010cd <lpt_putc>
        cga_putc(c);
  101632:	8b 45 08             	mov    0x8(%ebp),%eax
  101635:	89 04 24             	mov    %eax,(%esp)
  101638:	e8 cf fa ff ff       	call   10110c <cga_putc>
        serial_putc(c);
  10163d:	8b 45 08             	mov    0x8(%ebp),%eax
  101640:	89 04 24             	mov    %eax,(%esp)
  101643:	e8 f1 fc ff ff       	call   101339 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10164b:	89 04 24             	mov    %eax,(%esp)
  10164e:	e8 dd f7 ff ff       	call   100e30 <__intr_restore>
}
  101653:	c9                   	leave  
  101654:	c3                   	ret    

00101655 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101655:	55                   	push   %ebp
  101656:	89 e5                	mov    %esp,%ebp
  101658:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10165b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101662:	e8 9f f7 ff ff       	call   100e06 <__intr_save>
  101667:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10166a:	e8 ab fd ff ff       	call   10141a <serial_intr>
        kbd_intr();
  10166f:	e8 4c ff ff ff       	call   1015c0 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101674:	8b 15 60 a6 11 00    	mov    0x11a660,%edx
  10167a:	a1 64 a6 11 00       	mov    0x11a664,%eax
  10167f:	39 c2                	cmp    %eax,%edx
  101681:	74 31                	je     1016b4 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101683:	a1 60 a6 11 00       	mov    0x11a660,%eax
  101688:	8d 50 01             	lea    0x1(%eax),%edx
  10168b:	89 15 60 a6 11 00    	mov    %edx,0x11a660
  101691:	0f b6 80 60 a4 11 00 	movzbl 0x11a460(%eax),%eax
  101698:	0f b6 c0             	movzbl %al,%eax
  10169b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10169e:	a1 60 a6 11 00       	mov    0x11a660,%eax
  1016a3:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016a8:	75 0a                	jne    1016b4 <cons_getc+0x5f>
                cons.rpos = 0;
  1016aa:	c7 05 60 a6 11 00 00 	movl   $0x0,0x11a660
  1016b1:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016b7:	89 04 24             	mov    %eax,(%esp)
  1016ba:	e8 71 f7 ff ff       	call   100e30 <__intr_restore>
    return c;
  1016bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016c2:	c9                   	leave  
  1016c3:	c3                   	ret    

001016c4 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016c4:	55                   	push   %ebp
  1016c5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016c7:	fb                   	sti    
    sti();
}
  1016c8:	5d                   	pop    %ebp
  1016c9:	c3                   	ret    

001016ca <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016ca:	55                   	push   %ebp
  1016cb:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016cd:	fa                   	cli    
    cli();
}
  1016ce:	5d                   	pop    %ebp
  1016cf:	c3                   	ret    

001016d0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016d0:	55                   	push   %ebp
  1016d1:	89 e5                	mov    %esp,%ebp
  1016d3:	83 ec 14             	sub    $0x14,%esp
  1016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1016d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016e1:	66 a3 50 75 11 00    	mov    %ax,0x117550
    if (did_init) {
  1016e7:	a1 6c a6 11 00       	mov    0x11a66c,%eax
  1016ec:	85 c0                	test   %eax,%eax
  1016ee:	74 36                	je     101726 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016f0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f4:	0f b6 c0             	movzbl %al,%eax
  1016f7:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016fd:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101700:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101704:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101708:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101709:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10170d:	66 c1 e8 08          	shr    $0x8,%ax
  101711:	0f b6 c0             	movzbl %al,%eax
  101714:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10171a:	88 45 f9             	mov    %al,-0x7(%ebp)
  10171d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101721:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101725:	ee                   	out    %al,(%dx)
    }
}
  101726:	c9                   	leave  
  101727:	c3                   	ret    

00101728 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101728:	55                   	push   %ebp
  101729:	89 e5                	mov    %esp,%ebp
  10172b:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10172e:	8b 45 08             	mov    0x8(%ebp),%eax
  101731:	ba 01 00 00 00       	mov    $0x1,%edx
  101736:	89 c1                	mov    %eax,%ecx
  101738:	d3 e2                	shl    %cl,%edx
  10173a:	89 d0                	mov    %edx,%eax
  10173c:	f7 d0                	not    %eax
  10173e:	89 c2                	mov    %eax,%edx
  101740:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101747:	21 d0                	and    %edx,%eax
  101749:	0f b7 c0             	movzwl %ax,%eax
  10174c:	89 04 24             	mov    %eax,(%esp)
  10174f:	e8 7c ff ff ff       	call   1016d0 <pic_setmask>
}
  101754:	c9                   	leave  
  101755:	c3                   	ret    

00101756 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101756:	55                   	push   %ebp
  101757:	89 e5                	mov    %esp,%ebp
  101759:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10175c:	c7 05 6c a6 11 00 01 	movl   $0x1,0x11a66c
  101763:	00 00 00 
  101766:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10176c:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101770:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101774:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101778:	ee                   	out    %al,(%dx)
  101779:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10177f:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101783:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101787:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10178b:	ee                   	out    %al,(%dx)
  10178c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101792:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101796:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10179a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10179e:	ee                   	out    %al,(%dx)
  10179f:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1017a5:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1017a9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017ad:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017b1:	ee                   	out    %al,(%dx)
  1017b2:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017b8:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017bc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017c0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017c4:	ee                   	out    %al,(%dx)
  1017c5:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017cb:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017cf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017d3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017d7:	ee                   	out    %al,(%dx)
  1017d8:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017de:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017e2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017e6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
  1017eb:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017f1:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017f5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017f9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017fd:	ee                   	out    %al,(%dx)
  1017fe:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101804:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101808:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10180c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101810:	ee                   	out    %al,(%dx)
  101811:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101817:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10181b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10181f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101823:	ee                   	out    %al,(%dx)
  101824:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10182a:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10182e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101832:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101836:	ee                   	out    %al,(%dx)
  101837:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10183d:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101841:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101845:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101849:	ee                   	out    %al,(%dx)
  10184a:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101850:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101854:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101858:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10185c:	ee                   	out    %al,(%dx)
  10185d:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101863:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101867:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10186b:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10186f:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101870:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101877:	66 83 f8 ff          	cmp    $0xffff,%ax
  10187b:	74 12                	je     10188f <pic_init+0x139>
        pic_setmask(irq_mask);
  10187d:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101884:	0f b7 c0             	movzwl %ax,%eax
  101887:	89 04 24             	mov    %eax,(%esp)
  10188a:	e8 41 fe ff ff       	call   1016d0 <pic_setmask>
    }
}
  10188f:	c9                   	leave  
  101890:	c3                   	ret    

00101891 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101891:	55                   	push   %ebp
  101892:	89 e5                	mov    %esp,%ebp
  101894:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101897:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10189e:	00 
  10189f:	c7 04 24 00 66 10 00 	movl   $0x106600,(%esp)
  1018a6:	e8 9d ea ff ff       	call   100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018ab:	c7 04 24 0a 66 10 00 	movl   $0x10660a,(%esp)
  1018b2:	e8 91 ea ff ff       	call   100348 <cprintf>
    panic("EOT: kernel seems ok.");
  1018b7:	c7 44 24 08 18 66 10 	movl   $0x106618,0x8(%esp)
  1018be:	00 
  1018bf:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018c6:	00 
  1018c7:	c7 04 24 2e 66 10 00 	movl   $0x10662e,(%esp)
  1018ce:	e8 03 f4 ff ff       	call   100cd6 <__panic>

001018d3 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018d3:	55                   	push   %ebp
  1018d4:	89 e5                	mov    %esp,%ebp
  1018d6:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
  1018d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i; i < 256 ; i++) {
  1018e0:	e9 83 02 00 00       	jmp    101b68 <idt_init+0x295>
	    if(i != T_SYSCALL && i != T_SWITCH_TOK && i >= IRQ_OFFSET) {
  1018e5:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  1018ec:	0f 84 d8 00 00 00    	je     1019ca <idt_init+0xf7>
  1018f2:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
  1018f6:	0f 84 ce 00 00 00    	je     1019ca <idt_init+0xf7>
  1018fc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  101900:	0f 8e c4 00 00 00    	jle    1019ca <idt_init+0xf7>
	       SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101906:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101909:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  101910:	89 c2                	mov    %eax,%edx
  101912:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101915:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  10191c:	00 
  10191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101920:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  101927:	00 08 00 
  10192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192d:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101934:	00 
  101935:	83 e2 e0             	and    $0xffffffe0,%edx
  101938:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  10193f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101942:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101949:	00 
  10194a:	83 e2 1f             	and    $0x1f,%edx
  10194d:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101954:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101957:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10195e:	00 
  10195f:	83 e2 f0             	and    $0xfffffff0,%edx
  101962:	83 ca 0e             	or     $0xe,%edx
  101965:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196f:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101976:	00 
  101977:	83 e2 ef             	and    $0xffffffef,%edx
  10197a:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101981:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101984:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10198b:	00 
  10198c:	83 e2 9f             	and    $0xffffff9f,%edx
  10198f:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101999:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  1019a0:	00 
  1019a1:	83 ca 80             	or     $0xffffff80,%edx
  1019a4:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  1019ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ae:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1019b5:	c1 e8 10             	shr    $0x10,%eax
  1019b8:	89 c2                	mov    %eax,%edx
  1019ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019bd:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  1019c4:	00 
  1019c5:	e9 9a 01 00 00       	jmp    101b64 <idt_init+0x291>
	    } else {
	    	if(i == T_SYSCALL || i == T_SWITCH_TOK) {
  1019ca:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  1019d1:	74 0a                	je     1019dd <idt_init+0x10a>
  1019d3:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
  1019d7:	0f 85 c1 00 00 00    	jne    101a9e <idt_init+0x1cb>
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);		
  1019dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e0:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1019e7:	89 c2                	mov    %eax,%edx
  1019e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ec:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  1019f3:	00 
  1019f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f7:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  1019fe:	00 08 00 
  101a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a04:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101a0b:	00 
  101a0c:	83 e2 e0             	and    $0xffffffe0,%edx
  101a0f:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a19:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101a20:	00 
  101a21:	83 e2 1f             	and    $0x1f,%edx
  101a24:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a2e:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101a35:	00 
  101a36:	83 ca 0f             	or     $0xf,%edx
  101a39:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a43:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101a4a:	00 
  101a4b:	83 e2 ef             	and    $0xffffffef,%edx
  101a4e:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101a55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a58:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101a5f:	00 
  101a60:	83 ca 60             	or     $0x60,%edx
  101a63:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101a6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a6d:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101a74:	00 
  101a75:	83 ca 80             	or     $0xffffff80,%edx
  101a78:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101a7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a82:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  101a89:	c1 e8 10             	shr    $0x10,%eax
  101a8c:	89 c2                	mov    %eax,%edx
  101a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a91:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  101a98:	00 
  101a99:	e9 c6 00 00 00       	jmp    101b64 <idt_init+0x291>
		} else if(i < IRQ_OFFSET) {
  101a9e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  101aa2:	0f 8f bc 00 00 00    	jg     101b64 <idt_init+0x291>
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);		
  101aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101aab:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  101ab2:	89 c2                	mov    %eax,%edx
  101ab4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ab7:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  101abe:	00 
  101abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ac2:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  101ac9:	00 08 00 
  101acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101acf:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101ad6:	00 
  101ad7:	83 e2 e0             	and    $0xffffffe0,%edx
  101ada:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ae4:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101aeb:	00 
  101aec:	83 e2 1f             	and    $0x1f,%edx
  101aef:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101af6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101af9:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101b00:	00 
  101b01:	83 ca 0f             	or     $0xf,%edx
  101b04:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101b0e:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101b15:	00 
  101b16:	83 e2 ef             	and    $0xffffffef,%edx
  101b19:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101b20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101b23:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101b2a:	00 
  101b2b:	83 e2 9f             	and    $0xffffff9f,%edx
  101b2e:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101b35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101b38:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101b3f:	00 
  101b40:	83 ca 80             	or     $0xffffff80,%edx
  101b43:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101b4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101b4d:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  101b54:	c1 e8 10             	shr    $0x10,%eax
  101b57:	89 c2                	mov    %eax,%edx
  101b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101b5c:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  101b63:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
	for(i; i < 256 ; i++) {
  101b64:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101b68:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101b6f:	0f 8e 70 fd ff ff    	jle    1018e5 <idt_init+0x12>
  101b75:	c7 45 f8 60 75 11 00 	movl   $0x117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101b7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b7f:	0f 01 18             	lidtl  (%eax)
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);		
		}
	    }
	}
	lidt(&idt_pd);
}
  101b82:	c9                   	leave  
  101b83:	c3                   	ret    

00101b84 <trapname>:

static const char *
trapname(int trapno) {
  101b84:	55                   	push   %ebp
  101b85:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b87:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8a:	83 f8 13             	cmp    $0x13,%eax
  101b8d:	77 0c                	ja     101b9b <trapname+0x17>
        return excnames[trapno];
  101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b92:	8b 04 85 80 69 10 00 	mov    0x106980(,%eax,4),%eax
  101b99:	eb 18                	jmp    101bb3 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b9b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b9f:	7e 0d                	jle    101bae <trapname+0x2a>
  101ba1:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ba5:	7f 07                	jg     101bae <trapname+0x2a>
        return "Hardware Interrupt";
  101ba7:	b8 3f 66 10 00       	mov    $0x10663f,%eax
  101bac:	eb 05                	jmp    101bb3 <trapname+0x2f>
    }
    return "(unknown trap)";
  101bae:	b8 52 66 10 00       	mov    $0x106652,%eax
}
  101bb3:	5d                   	pop    %ebp
  101bb4:	c3                   	ret    

00101bb5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101bb5:	55                   	push   %ebp
  101bb6:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bbf:	66 83 f8 08          	cmp    $0x8,%ax
  101bc3:	0f 94 c0             	sete   %al
  101bc6:	0f b6 c0             	movzbl %al,%eax
}
  101bc9:	5d                   	pop    %ebp
  101bca:	c3                   	ret    

00101bcb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101bcb:	55                   	push   %ebp
  101bcc:	89 e5                	mov    %esp,%ebp
  101bce:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd8:	c7 04 24 93 66 10 00 	movl   $0x106693,(%esp)
  101bdf:	e8 64 e7 ff ff       	call   100348 <cprintf>
    print_regs(&tf->tf_regs);
  101be4:	8b 45 08             	mov    0x8(%ebp),%eax
  101be7:	89 04 24             	mov    %eax,(%esp)
  101bea:	e8 a1 01 00 00       	call   101d90 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101bef:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf2:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101bf6:	0f b7 c0             	movzwl %ax,%eax
  101bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfd:	c7 04 24 a4 66 10 00 	movl   $0x1066a4,(%esp)
  101c04:	e8 3f e7 ff ff       	call   100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101c09:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101c10:	0f b7 c0             	movzwl %ax,%eax
  101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c17:	c7 04 24 b7 66 10 00 	movl   $0x1066b7,(%esp)
  101c1e:	e8 25 e7 ff ff       	call   100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101c23:	8b 45 08             	mov    0x8(%ebp),%eax
  101c26:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101c2a:	0f b7 c0             	movzwl %ax,%eax
  101c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c31:	c7 04 24 ca 66 10 00 	movl   $0x1066ca,(%esp)
  101c38:	e8 0b e7 ff ff       	call   100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c40:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c44:	0f b7 c0             	movzwl %ax,%eax
  101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4b:	c7 04 24 dd 66 10 00 	movl   $0x1066dd,(%esp)
  101c52:	e8 f1 e6 ff ff       	call   100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c57:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5a:	8b 40 30             	mov    0x30(%eax),%eax
  101c5d:	89 04 24             	mov    %eax,(%esp)
  101c60:	e8 1f ff ff ff       	call   101b84 <trapname>
  101c65:	8b 55 08             	mov    0x8(%ebp),%edx
  101c68:	8b 52 30             	mov    0x30(%edx),%edx
  101c6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c6f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c73:	c7 04 24 f0 66 10 00 	movl   $0x1066f0,(%esp)
  101c7a:	e8 c9 e6 ff ff       	call   100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c82:	8b 40 34             	mov    0x34(%eax),%eax
  101c85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c89:	c7 04 24 02 67 10 00 	movl   $0x106702,(%esp)
  101c90:	e8 b3 e6 ff ff       	call   100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c95:	8b 45 08             	mov    0x8(%ebp),%eax
  101c98:	8b 40 38             	mov    0x38(%eax),%eax
  101c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9f:	c7 04 24 11 67 10 00 	movl   $0x106711,(%esp)
  101ca6:	e8 9d e6 ff ff       	call   100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101cab:	8b 45 08             	mov    0x8(%ebp),%eax
  101cae:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101cb2:	0f b7 c0             	movzwl %ax,%eax
  101cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb9:	c7 04 24 20 67 10 00 	movl   $0x106720,(%esp)
  101cc0:	e8 83 e6 ff ff       	call   100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc8:	8b 40 40             	mov    0x40(%eax),%eax
  101ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ccf:	c7 04 24 33 67 10 00 	movl   $0x106733,(%esp)
  101cd6:	e8 6d e6 ff ff       	call   100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ce2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ce9:	eb 3e                	jmp    101d29 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cee:	8b 50 40             	mov    0x40(%eax),%edx
  101cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101cf4:	21 d0                	and    %edx,%eax
  101cf6:	85 c0                	test   %eax,%eax
  101cf8:	74 28                	je     101d22 <print_trapframe+0x157>
  101cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cfd:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101d04:	85 c0                	test   %eax,%eax
  101d06:	74 1a                	je     101d22 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d0b:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101d12:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d16:	c7 04 24 42 67 10 00 	movl   $0x106742,(%esp)
  101d1d:	e8 26 e6 ff ff       	call   100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101d26:	d1 65 f0             	shll   -0x10(%ebp)
  101d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d2c:	83 f8 17             	cmp    $0x17,%eax
  101d2f:	76 ba                	jbe    101ceb <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101d31:	8b 45 08             	mov    0x8(%ebp),%eax
  101d34:	8b 40 40             	mov    0x40(%eax),%eax
  101d37:	25 00 30 00 00       	and    $0x3000,%eax
  101d3c:	c1 e8 0c             	shr    $0xc,%eax
  101d3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d43:	c7 04 24 46 67 10 00 	movl   $0x106746,(%esp)
  101d4a:	e8 f9 e5 ff ff       	call   100348 <cprintf>

    if (!trap_in_kernel(tf)) {
  101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d52:	89 04 24             	mov    %eax,(%esp)
  101d55:	e8 5b fe ff ff       	call   101bb5 <trap_in_kernel>
  101d5a:	85 c0                	test   %eax,%eax
  101d5c:	75 30                	jne    101d8e <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d61:	8b 40 44             	mov    0x44(%eax),%eax
  101d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d68:	c7 04 24 4f 67 10 00 	movl   $0x10674f,(%esp)
  101d6f:	e8 d4 e5 ff ff       	call   100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d74:	8b 45 08             	mov    0x8(%ebp),%eax
  101d77:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d7b:	0f b7 c0             	movzwl %ax,%eax
  101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d82:	c7 04 24 5e 67 10 00 	movl   $0x10675e,(%esp)
  101d89:	e8 ba e5 ff ff       	call   100348 <cprintf>
    }
}
  101d8e:	c9                   	leave  
  101d8f:	c3                   	ret    

00101d90 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d90:	55                   	push   %ebp
  101d91:	89 e5                	mov    %esp,%ebp
  101d93:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d96:	8b 45 08             	mov    0x8(%ebp),%eax
  101d99:	8b 00                	mov    (%eax),%eax
  101d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d9f:	c7 04 24 71 67 10 00 	movl   $0x106771,(%esp)
  101da6:	e8 9d e5 ff ff       	call   100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101dab:	8b 45 08             	mov    0x8(%ebp),%eax
  101dae:	8b 40 04             	mov    0x4(%eax),%eax
  101db1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db5:	c7 04 24 80 67 10 00 	movl   $0x106780,(%esp)
  101dbc:	e8 87 e5 ff ff       	call   100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc4:	8b 40 08             	mov    0x8(%eax),%eax
  101dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dcb:	c7 04 24 8f 67 10 00 	movl   $0x10678f,(%esp)
  101dd2:	e8 71 e5 ff ff       	call   100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dda:	8b 40 0c             	mov    0xc(%eax),%eax
  101ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101de1:	c7 04 24 9e 67 10 00 	movl   $0x10679e,(%esp)
  101de8:	e8 5b e5 ff ff       	call   100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101ded:	8b 45 08             	mov    0x8(%ebp),%eax
  101df0:	8b 40 10             	mov    0x10(%eax),%eax
  101df3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df7:	c7 04 24 ad 67 10 00 	movl   $0x1067ad,(%esp)
  101dfe:	e8 45 e5 ff ff       	call   100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101e03:	8b 45 08             	mov    0x8(%ebp),%eax
  101e06:	8b 40 14             	mov    0x14(%eax),%eax
  101e09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e0d:	c7 04 24 bc 67 10 00 	movl   $0x1067bc,(%esp)
  101e14:	e8 2f e5 ff ff       	call   100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101e19:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1c:	8b 40 18             	mov    0x18(%eax),%eax
  101e1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e23:	c7 04 24 cb 67 10 00 	movl   $0x1067cb,(%esp)
  101e2a:	e8 19 e5 ff ff       	call   100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e32:	8b 40 1c             	mov    0x1c(%eax),%eax
  101e35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e39:	c7 04 24 da 67 10 00 	movl   $0x1067da,(%esp)
  101e40:	e8 03 e5 ff ff       	call   100348 <cprintf>
}
  101e45:	c9                   	leave  
  101e46:	c3                   	ret    

00101e47 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e47:	55                   	push   %ebp
  101e48:	89 e5                	mov    %esp,%ebp
  101e4a:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e50:	8b 40 30             	mov    0x30(%eax),%eax
  101e53:	83 f8 2f             	cmp    $0x2f,%eax
  101e56:	77 21                	ja     101e79 <trap_dispatch+0x32>
  101e58:	83 f8 2e             	cmp    $0x2e,%eax
  101e5b:	0f 83 04 01 00 00    	jae    101f65 <trap_dispatch+0x11e>
  101e61:	83 f8 21             	cmp    $0x21,%eax
  101e64:	0f 84 81 00 00 00    	je     101eeb <trap_dispatch+0xa4>
  101e6a:	83 f8 24             	cmp    $0x24,%eax
  101e6d:	74 56                	je     101ec5 <trap_dispatch+0x7e>
  101e6f:	83 f8 20             	cmp    $0x20,%eax
  101e72:	74 16                	je     101e8a <trap_dispatch+0x43>
  101e74:	e9 b4 00 00 00       	jmp    101f2d <trap_dispatch+0xe6>
  101e79:	83 e8 78             	sub    $0x78,%eax
  101e7c:	83 f8 01             	cmp    $0x1,%eax
  101e7f:	0f 87 a8 00 00 00    	ja     101f2d <trap_dispatch+0xe6>
  101e85:	e9 87 00 00 00       	jmp    101f11 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks = ticks + 1;
  101e8a:	a1 0c af 11 00       	mov    0x11af0c,%eax
  101e8f:	83 c0 01             	add    $0x1,%eax
  101e92:	a3 0c af 11 00       	mov    %eax,0x11af0c
	if(ticks % 100 == 0) {
  101e97:	8b 0d 0c af 11 00    	mov    0x11af0c,%ecx
  101e9d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101ea2:	89 c8                	mov    %ecx,%eax
  101ea4:	f7 e2                	mul    %edx
  101ea6:	89 d0                	mov    %edx,%eax
  101ea8:	c1 e8 05             	shr    $0x5,%eax
  101eab:	6b c0 64             	imul   $0x64,%eax,%eax
  101eae:	29 c1                	sub    %eax,%ecx
  101eb0:	89 c8                	mov    %ecx,%eax
  101eb2:	85 c0                	test   %eax,%eax
  101eb4:	75 0a                	jne    101ec0 <trap_dispatch+0x79>
	   print_ticks();	
  101eb6:	e8 d6 f9 ff ff       	call   101891 <print_ticks>
	}
        break;
  101ebb:	e9 a6 00 00 00       	jmp    101f66 <trap_dispatch+0x11f>
  101ec0:	e9 a1 00 00 00       	jmp    101f66 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ec5:	e8 8b f7 ff ff       	call   101655 <cons_getc>
  101eca:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ecd:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ed1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ed5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101edd:	c7 04 24 e9 67 10 00 	movl   $0x1067e9,(%esp)
  101ee4:	e8 5f e4 ff ff       	call   100348 <cprintf>
        break;
  101ee9:	eb 7b                	jmp    101f66 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101eeb:	e8 65 f7 ff ff       	call   101655 <cons_getc>
  101ef0:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ef3:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ef7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101efb:	89 54 24 08          	mov    %edx,0x8(%esp)
  101eff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f03:	c7 04 24 fb 67 10 00 	movl   $0x1067fb,(%esp)
  101f0a:	e8 39 e4 ff ff       	call   100348 <cprintf>
        break;
  101f0f:	eb 55                	jmp    101f66 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101f11:	c7 44 24 08 0a 68 10 	movl   $0x10680a,0x8(%esp)
  101f18:	00 
  101f19:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  101f20:	00 
  101f21:	c7 04 24 2e 66 10 00 	movl   $0x10662e,(%esp)
  101f28:	e8 a9 ed ff ff       	call   100cd6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f30:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f34:	0f b7 c0             	movzwl %ax,%eax
  101f37:	83 e0 03             	and    $0x3,%eax
  101f3a:	85 c0                	test   %eax,%eax
  101f3c:	75 28                	jne    101f66 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f41:	89 04 24             	mov    %eax,(%esp)
  101f44:	e8 82 fc ff ff       	call   101bcb <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f49:	c7 44 24 08 1a 68 10 	movl   $0x10681a,0x8(%esp)
  101f50:	00 
  101f51:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  101f58:	00 
  101f59:	c7 04 24 2e 66 10 00 	movl   $0x10662e,(%esp)
  101f60:	e8 71 ed ff ff       	call   100cd6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101f65:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101f66:	c9                   	leave  
  101f67:	c3                   	ret    

00101f68 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f68:	55                   	push   %ebp
  101f69:	89 e5                	mov    %esp,%ebp
  101f6b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f71:	89 04 24             	mov    %eax,(%esp)
  101f74:	e8 ce fe ff ff       	call   101e47 <trap_dispatch>
}
  101f79:	c9                   	leave  
  101f7a:	c3                   	ret    

00101f7b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f7b:	1e                   	push   %ds
    pushl %es
  101f7c:	06                   	push   %es
    pushl %fs
  101f7d:	0f a0                	push   %fs
    pushl %gs
  101f7f:	0f a8                	push   %gs
    pushal
  101f81:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f82:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f87:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f89:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f8b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f8c:	e8 d7 ff ff ff       	call   101f68 <trap>

    # pop the pushed stack pointer
    popl %esp
  101f91:	5c                   	pop    %esp

00101f92 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f92:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f93:	0f a9                	pop    %gs
    popl %fs
  101f95:	0f a1                	pop    %fs
    popl %es
  101f97:	07                   	pop    %es
    popl %ds
  101f98:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f99:	83 c4 08             	add    $0x8,%esp
    iret
  101f9c:	cf                   	iret   

00101f9d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $0
  101f9f:	6a 00                	push   $0x0
  jmp __alltraps
  101fa1:	e9 d5 ff ff ff       	jmp    101f7b <__alltraps>

00101fa6 <vector1>:
.globl vector1
vector1:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $1
  101fa8:	6a 01                	push   $0x1
  jmp __alltraps
  101faa:	e9 cc ff ff ff       	jmp    101f7b <__alltraps>

00101faf <vector2>:
.globl vector2
vector2:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $2
  101fb1:	6a 02                	push   $0x2
  jmp __alltraps
  101fb3:	e9 c3 ff ff ff       	jmp    101f7b <__alltraps>

00101fb8 <vector3>:
.globl vector3
vector3:
  pushl $0
  101fb8:	6a 00                	push   $0x0
  pushl $3
  101fba:	6a 03                	push   $0x3
  jmp __alltraps
  101fbc:	e9 ba ff ff ff       	jmp    101f7b <__alltraps>

00101fc1 <vector4>:
.globl vector4
vector4:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $4
  101fc3:	6a 04                	push   $0x4
  jmp __alltraps
  101fc5:	e9 b1 ff ff ff       	jmp    101f7b <__alltraps>

00101fca <vector5>:
.globl vector5
vector5:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $5
  101fcc:	6a 05                	push   $0x5
  jmp __alltraps
  101fce:	e9 a8 ff ff ff       	jmp    101f7b <__alltraps>

00101fd3 <vector6>:
.globl vector6
vector6:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $6
  101fd5:	6a 06                	push   $0x6
  jmp __alltraps
  101fd7:	e9 9f ff ff ff       	jmp    101f7b <__alltraps>

00101fdc <vector7>:
.globl vector7
vector7:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $7
  101fde:	6a 07                	push   $0x7
  jmp __alltraps
  101fe0:	e9 96 ff ff ff       	jmp    101f7b <__alltraps>

00101fe5 <vector8>:
.globl vector8
vector8:
  pushl $8
  101fe5:	6a 08                	push   $0x8
  jmp __alltraps
  101fe7:	e9 8f ff ff ff       	jmp    101f7b <__alltraps>

00101fec <vector9>:
.globl vector9
vector9:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $9
  101fee:	6a 09                	push   $0x9
  jmp __alltraps
  101ff0:	e9 86 ff ff ff       	jmp    101f7b <__alltraps>

00101ff5 <vector10>:
.globl vector10
vector10:
  pushl $10
  101ff5:	6a 0a                	push   $0xa
  jmp __alltraps
  101ff7:	e9 7f ff ff ff       	jmp    101f7b <__alltraps>

00101ffc <vector11>:
.globl vector11
vector11:
  pushl $11
  101ffc:	6a 0b                	push   $0xb
  jmp __alltraps
  101ffe:	e9 78 ff ff ff       	jmp    101f7b <__alltraps>

00102003 <vector12>:
.globl vector12
vector12:
  pushl $12
  102003:	6a 0c                	push   $0xc
  jmp __alltraps
  102005:	e9 71 ff ff ff       	jmp    101f7b <__alltraps>

0010200a <vector13>:
.globl vector13
vector13:
  pushl $13
  10200a:	6a 0d                	push   $0xd
  jmp __alltraps
  10200c:	e9 6a ff ff ff       	jmp    101f7b <__alltraps>

00102011 <vector14>:
.globl vector14
vector14:
  pushl $14
  102011:	6a 0e                	push   $0xe
  jmp __alltraps
  102013:	e9 63 ff ff ff       	jmp    101f7b <__alltraps>

00102018 <vector15>:
.globl vector15
vector15:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $15
  10201a:	6a 0f                	push   $0xf
  jmp __alltraps
  10201c:	e9 5a ff ff ff       	jmp    101f7b <__alltraps>

00102021 <vector16>:
.globl vector16
vector16:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $16
  102023:	6a 10                	push   $0x10
  jmp __alltraps
  102025:	e9 51 ff ff ff       	jmp    101f7b <__alltraps>

0010202a <vector17>:
.globl vector17
vector17:
  pushl $17
  10202a:	6a 11                	push   $0x11
  jmp __alltraps
  10202c:	e9 4a ff ff ff       	jmp    101f7b <__alltraps>

00102031 <vector18>:
.globl vector18
vector18:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $18
  102033:	6a 12                	push   $0x12
  jmp __alltraps
  102035:	e9 41 ff ff ff       	jmp    101f7b <__alltraps>

0010203a <vector19>:
.globl vector19
vector19:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $19
  10203c:	6a 13                	push   $0x13
  jmp __alltraps
  10203e:	e9 38 ff ff ff       	jmp    101f7b <__alltraps>

00102043 <vector20>:
.globl vector20
vector20:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $20
  102045:	6a 14                	push   $0x14
  jmp __alltraps
  102047:	e9 2f ff ff ff       	jmp    101f7b <__alltraps>

0010204c <vector21>:
.globl vector21
vector21:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $21
  10204e:	6a 15                	push   $0x15
  jmp __alltraps
  102050:	e9 26 ff ff ff       	jmp    101f7b <__alltraps>

00102055 <vector22>:
.globl vector22
vector22:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $22
  102057:	6a 16                	push   $0x16
  jmp __alltraps
  102059:	e9 1d ff ff ff       	jmp    101f7b <__alltraps>

0010205e <vector23>:
.globl vector23
vector23:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $23
  102060:	6a 17                	push   $0x17
  jmp __alltraps
  102062:	e9 14 ff ff ff       	jmp    101f7b <__alltraps>

00102067 <vector24>:
.globl vector24
vector24:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $24
  102069:	6a 18                	push   $0x18
  jmp __alltraps
  10206b:	e9 0b ff ff ff       	jmp    101f7b <__alltraps>

00102070 <vector25>:
.globl vector25
vector25:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $25
  102072:	6a 19                	push   $0x19
  jmp __alltraps
  102074:	e9 02 ff ff ff       	jmp    101f7b <__alltraps>

00102079 <vector26>:
.globl vector26
vector26:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $26
  10207b:	6a 1a                	push   $0x1a
  jmp __alltraps
  10207d:	e9 f9 fe ff ff       	jmp    101f7b <__alltraps>

00102082 <vector27>:
.globl vector27
vector27:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $27
  102084:	6a 1b                	push   $0x1b
  jmp __alltraps
  102086:	e9 f0 fe ff ff       	jmp    101f7b <__alltraps>

0010208b <vector28>:
.globl vector28
vector28:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $28
  10208d:	6a 1c                	push   $0x1c
  jmp __alltraps
  10208f:	e9 e7 fe ff ff       	jmp    101f7b <__alltraps>

00102094 <vector29>:
.globl vector29
vector29:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $29
  102096:	6a 1d                	push   $0x1d
  jmp __alltraps
  102098:	e9 de fe ff ff       	jmp    101f7b <__alltraps>

0010209d <vector30>:
.globl vector30
vector30:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $30
  10209f:	6a 1e                	push   $0x1e
  jmp __alltraps
  1020a1:	e9 d5 fe ff ff       	jmp    101f7b <__alltraps>

001020a6 <vector31>:
.globl vector31
vector31:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $31
  1020a8:	6a 1f                	push   $0x1f
  jmp __alltraps
  1020aa:	e9 cc fe ff ff       	jmp    101f7b <__alltraps>

001020af <vector32>:
.globl vector32
vector32:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $32
  1020b1:	6a 20                	push   $0x20
  jmp __alltraps
  1020b3:	e9 c3 fe ff ff       	jmp    101f7b <__alltraps>

001020b8 <vector33>:
.globl vector33
vector33:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $33
  1020ba:	6a 21                	push   $0x21
  jmp __alltraps
  1020bc:	e9 ba fe ff ff       	jmp    101f7b <__alltraps>

001020c1 <vector34>:
.globl vector34
vector34:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $34
  1020c3:	6a 22                	push   $0x22
  jmp __alltraps
  1020c5:	e9 b1 fe ff ff       	jmp    101f7b <__alltraps>

001020ca <vector35>:
.globl vector35
vector35:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $35
  1020cc:	6a 23                	push   $0x23
  jmp __alltraps
  1020ce:	e9 a8 fe ff ff       	jmp    101f7b <__alltraps>

001020d3 <vector36>:
.globl vector36
vector36:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $36
  1020d5:	6a 24                	push   $0x24
  jmp __alltraps
  1020d7:	e9 9f fe ff ff       	jmp    101f7b <__alltraps>

001020dc <vector37>:
.globl vector37
vector37:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $37
  1020de:	6a 25                	push   $0x25
  jmp __alltraps
  1020e0:	e9 96 fe ff ff       	jmp    101f7b <__alltraps>

001020e5 <vector38>:
.globl vector38
vector38:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $38
  1020e7:	6a 26                	push   $0x26
  jmp __alltraps
  1020e9:	e9 8d fe ff ff       	jmp    101f7b <__alltraps>

001020ee <vector39>:
.globl vector39
vector39:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $39
  1020f0:	6a 27                	push   $0x27
  jmp __alltraps
  1020f2:	e9 84 fe ff ff       	jmp    101f7b <__alltraps>

001020f7 <vector40>:
.globl vector40
vector40:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $40
  1020f9:	6a 28                	push   $0x28
  jmp __alltraps
  1020fb:	e9 7b fe ff ff       	jmp    101f7b <__alltraps>

00102100 <vector41>:
.globl vector41
vector41:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $41
  102102:	6a 29                	push   $0x29
  jmp __alltraps
  102104:	e9 72 fe ff ff       	jmp    101f7b <__alltraps>

00102109 <vector42>:
.globl vector42
vector42:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $42
  10210b:	6a 2a                	push   $0x2a
  jmp __alltraps
  10210d:	e9 69 fe ff ff       	jmp    101f7b <__alltraps>

00102112 <vector43>:
.globl vector43
vector43:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $43
  102114:	6a 2b                	push   $0x2b
  jmp __alltraps
  102116:	e9 60 fe ff ff       	jmp    101f7b <__alltraps>

0010211b <vector44>:
.globl vector44
vector44:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $44
  10211d:	6a 2c                	push   $0x2c
  jmp __alltraps
  10211f:	e9 57 fe ff ff       	jmp    101f7b <__alltraps>

00102124 <vector45>:
.globl vector45
vector45:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $45
  102126:	6a 2d                	push   $0x2d
  jmp __alltraps
  102128:	e9 4e fe ff ff       	jmp    101f7b <__alltraps>

0010212d <vector46>:
.globl vector46
vector46:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $46
  10212f:	6a 2e                	push   $0x2e
  jmp __alltraps
  102131:	e9 45 fe ff ff       	jmp    101f7b <__alltraps>

00102136 <vector47>:
.globl vector47
vector47:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $47
  102138:	6a 2f                	push   $0x2f
  jmp __alltraps
  10213a:	e9 3c fe ff ff       	jmp    101f7b <__alltraps>

0010213f <vector48>:
.globl vector48
vector48:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $48
  102141:	6a 30                	push   $0x30
  jmp __alltraps
  102143:	e9 33 fe ff ff       	jmp    101f7b <__alltraps>

00102148 <vector49>:
.globl vector49
vector49:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $49
  10214a:	6a 31                	push   $0x31
  jmp __alltraps
  10214c:	e9 2a fe ff ff       	jmp    101f7b <__alltraps>

00102151 <vector50>:
.globl vector50
vector50:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $50
  102153:	6a 32                	push   $0x32
  jmp __alltraps
  102155:	e9 21 fe ff ff       	jmp    101f7b <__alltraps>

0010215a <vector51>:
.globl vector51
vector51:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $51
  10215c:	6a 33                	push   $0x33
  jmp __alltraps
  10215e:	e9 18 fe ff ff       	jmp    101f7b <__alltraps>

00102163 <vector52>:
.globl vector52
vector52:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $52
  102165:	6a 34                	push   $0x34
  jmp __alltraps
  102167:	e9 0f fe ff ff       	jmp    101f7b <__alltraps>

0010216c <vector53>:
.globl vector53
vector53:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $53
  10216e:	6a 35                	push   $0x35
  jmp __alltraps
  102170:	e9 06 fe ff ff       	jmp    101f7b <__alltraps>

00102175 <vector54>:
.globl vector54
vector54:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $54
  102177:	6a 36                	push   $0x36
  jmp __alltraps
  102179:	e9 fd fd ff ff       	jmp    101f7b <__alltraps>

0010217e <vector55>:
.globl vector55
vector55:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $55
  102180:	6a 37                	push   $0x37
  jmp __alltraps
  102182:	e9 f4 fd ff ff       	jmp    101f7b <__alltraps>

00102187 <vector56>:
.globl vector56
vector56:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $56
  102189:	6a 38                	push   $0x38
  jmp __alltraps
  10218b:	e9 eb fd ff ff       	jmp    101f7b <__alltraps>

00102190 <vector57>:
.globl vector57
vector57:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $57
  102192:	6a 39                	push   $0x39
  jmp __alltraps
  102194:	e9 e2 fd ff ff       	jmp    101f7b <__alltraps>

00102199 <vector58>:
.globl vector58
vector58:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $58
  10219b:	6a 3a                	push   $0x3a
  jmp __alltraps
  10219d:	e9 d9 fd ff ff       	jmp    101f7b <__alltraps>

001021a2 <vector59>:
.globl vector59
vector59:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $59
  1021a4:	6a 3b                	push   $0x3b
  jmp __alltraps
  1021a6:	e9 d0 fd ff ff       	jmp    101f7b <__alltraps>

001021ab <vector60>:
.globl vector60
vector60:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $60
  1021ad:	6a 3c                	push   $0x3c
  jmp __alltraps
  1021af:	e9 c7 fd ff ff       	jmp    101f7b <__alltraps>

001021b4 <vector61>:
.globl vector61
vector61:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $61
  1021b6:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021b8:	e9 be fd ff ff       	jmp    101f7b <__alltraps>

001021bd <vector62>:
.globl vector62
vector62:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $62
  1021bf:	6a 3e                	push   $0x3e
  jmp __alltraps
  1021c1:	e9 b5 fd ff ff       	jmp    101f7b <__alltraps>

001021c6 <vector63>:
.globl vector63
vector63:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $63
  1021c8:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021ca:	e9 ac fd ff ff       	jmp    101f7b <__alltraps>

001021cf <vector64>:
.globl vector64
vector64:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $64
  1021d1:	6a 40                	push   $0x40
  jmp __alltraps
  1021d3:	e9 a3 fd ff ff       	jmp    101f7b <__alltraps>

001021d8 <vector65>:
.globl vector65
vector65:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $65
  1021da:	6a 41                	push   $0x41
  jmp __alltraps
  1021dc:	e9 9a fd ff ff       	jmp    101f7b <__alltraps>

001021e1 <vector66>:
.globl vector66
vector66:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $66
  1021e3:	6a 42                	push   $0x42
  jmp __alltraps
  1021e5:	e9 91 fd ff ff       	jmp    101f7b <__alltraps>

001021ea <vector67>:
.globl vector67
vector67:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $67
  1021ec:	6a 43                	push   $0x43
  jmp __alltraps
  1021ee:	e9 88 fd ff ff       	jmp    101f7b <__alltraps>

001021f3 <vector68>:
.globl vector68
vector68:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $68
  1021f5:	6a 44                	push   $0x44
  jmp __alltraps
  1021f7:	e9 7f fd ff ff       	jmp    101f7b <__alltraps>

001021fc <vector69>:
.globl vector69
vector69:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $69
  1021fe:	6a 45                	push   $0x45
  jmp __alltraps
  102200:	e9 76 fd ff ff       	jmp    101f7b <__alltraps>

00102205 <vector70>:
.globl vector70
vector70:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $70
  102207:	6a 46                	push   $0x46
  jmp __alltraps
  102209:	e9 6d fd ff ff       	jmp    101f7b <__alltraps>

0010220e <vector71>:
.globl vector71
vector71:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $71
  102210:	6a 47                	push   $0x47
  jmp __alltraps
  102212:	e9 64 fd ff ff       	jmp    101f7b <__alltraps>

00102217 <vector72>:
.globl vector72
vector72:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $72
  102219:	6a 48                	push   $0x48
  jmp __alltraps
  10221b:	e9 5b fd ff ff       	jmp    101f7b <__alltraps>

00102220 <vector73>:
.globl vector73
vector73:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $73
  102222:	6a 49                	push   $0x49
  jmp __alltraps
  102224:	e9 52 fd ff ff       	jmp    101f7b <__alltraps>

00102229 <vector74>:
.globl vector74
vector74:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $74
  10222b:	6a 4a                	push   $0x4a
  jmp __alltraps
  10222d:	e9 49 fd ff ff       	jmp    101f7b <__alltraps>

00102232 <vector75>:
.globl vector75
vector75:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $75
  102234:	6a 4b                	push   $0x4b
  jmp __alltraps
  102236:	e9 40 fd ff ff       	jmp    101f7b <__alltraps>

0010223b <vector76>:
.globl vector76
vector76:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $76
  10223d:	6a 4c                	push   $0x4c
  jmp __alltraps
  10223f:	e9 37 fd ff ff       	jmp    101f7b <__alltraps>

00102244 <vector77>:
.globl vector77
vector77:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $77
  102246:	6a 4d                	push   $0x4d
  jmp __alltraps
  102248:	e9 2e fd ff ff       	jmp    101f7b <__alltraps>

0010224d <vector78>:
.globl vector78
vector78:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $78
  10224f:	6a 4e                	push   $0x4e
  jmp __alltraps
  102251:	e9 25 fd ff ff       	jmp    101f7b <__alltraps>

00102256 <vector79>:
.globl vector79
vector79:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $79
  102258:	6a 4f                	push   $0x4f
  jmp __alltraps
  10225a:	e9 1c fd ff ff       	jmp    101f7b <__alltraps>

0010225f <vector80>:
.globl vector80
vector80:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $80
  102261:	6a 50                	push   $0x50
  jmp __alltraps
  102263:	e9 13 fd ff ff       	jmp    101f7b <__alltraps>

00102268 <vector81>:
.globl vector81
vector81:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $81
  10226a:	6a 51                	push   $0x51
  jmp __alltraps
  10226c:	e9 0a fd ff ff       	jmp    101f7b <__alltraps>

00102271 <vector82>:
.globl vector82
vector82:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $82
  102273:	6a 52                	push   $0x52
  jmp __alltraps
  102275:	e9 01 fd ff ff       	jmp    101f7b <__alltraps>

0010227a <vector83>:
.globl vector83
vector83:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $83
  10227c:	6a 53                	push   $0x53
  jmp __alltraps
  10227e:	e9 f8 fc ff ff       	jmp    101f7b <__alltraps>

00102283 <vector84>:
.globl vector84
vector84:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $84
  102285:	6a 54                	push   $0x54
  jmp __alltraps
  102287:	e9 ef fc ff ff       	jmp    101f7b <__alltraps>

0010228c <vector85>:
.globl vector85
vector85:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $85
  10228e:	6a 55                	push   $0x55
  jmp __alltraps
  102290:	e9 e6 fc ff ff       	jmp    101f7b <__alltraps>

00102295 <vector86>:
.globl vector86
vector86:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $86
  102297:	6a 56                	push   $0x56
  jmp __alltraps
  102299:	e9 dd fc ff ff       	jmp    101f7b <__alltraps>

0010229e <vector87>:
.globl vector87
vector87:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $87
  1022a0:	6a 57                	push   $0x57
  jmp __alltraps
  1022a2:	e9 d4 fc ff ff       	jmp    101f7b <__alltraps>

001022a7 <vector88>:
.globl vector88
vector88:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $88
  1022a9:	6a 58                	push   $0x58
  jmp __alltraps
  1022ab:	e9 cb fc ff ff       	jmp    101f7b <__alltraps>

001022b0 <vector89>:
.globl vector89
vector89:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $89
  1022b2:	6a 59                	push   $0x59
  jmp __alltraps
  1022b4:	e9 c2 fc ff ff       	jmp    101f7b <__alltraps>

001022b9 <vector90>:
.globl vector90
vector90:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $90
  1022bb:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022bd:	e9 b9 fc ff ff       	jmp    101f7b <__alltraps>

001022c2 <vector91>:
.globl vector91
vector91:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $91
  1022c4:	6a 5b                	push   $0x5b
  jmp __alltraps
  1022c6:	e9 b0 fc ff ff       	jmp    101f7b <__alltraps>

001022cb <vector92>:
.globl vector92
vector92:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $92
  1022cd:	6a 5c                	push   $0x5c
  jmp __alltraps
  1022cf:	e9 a7 fc ff ff       	jmp    101f7b <__alltraps>

001022d4 <vector93>:
.globl vector93
vector93:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $93
  1022d6:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022d8:	e9 9e fc ff ff       	jmp    101f7b <__alltraps>

001022dd <vector94>:
.globl vector94
vector94:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $94
  1022df:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022e1:	e9 95 fc ff ff       	jmp    101f7b <__alltraps>

001022e6 <vector95>:
.globl vector95
vector95:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $95
  1022e8:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022ea:	e9 8c fc ff ff       	jmp    101f7b <__alltraps>

001022ef <vector96>:
.globl vector96
vector96:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $96
  1022f1:	6a 60                	push   $0x60
  jmp __alltraps
  1022f3:	e9 83 fc ff ff       	jmp    101f7b <__alltraps>

001022f8 <vector97>:
.globl vector97
vector97:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $97
  1022fa:	6a 61                	push   $0x61
  jmp __alltraps
  1022fc:	e9 7a fc ff ff       	jmp    101f7b <__alltraps>

00102301 <vector98>:
.globl vector98
vector98:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $98
  102303:	6a 62                	push   $0x62
  jmp __alltraps
  102305:	e9 71 fc ff ff       	jmp    101f7b <__alltraps>

0010230a <vector99>:
.globl vector99
vector99:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $99
  10230c:	6a 63                	push   $0x63
  jmp __alltraps
  10230e:	e9 68 fc ff ff       	jmp    101f7b <__alltraps>

00102313 <vector100>:
.globl vector100
vector100:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $100
  102315:	6a 64                	push   $0x64
  jmp __alltraps
  102317:	e9 5f fc ff ff       	jmp    101f7b <__alltraps>

0010231c <vector101>:
.globl vector101
vector101:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $101
  10231e:	6a 65                	push   $0x65
  jmp __alltraps
  102320:	e9 56 fc ff ff       	jmp    101f7b <__alltraps>

00102325 <vector102>:
.globl vector102
vector102:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $102
  102327:	6a 66                	push   $0x66
  jmp __alltraps
  102329:	e9 4d fc ff ff       	jmp    101f7b <__alltraps>

0010232e <vector103>:
.globl vector103
vector103:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $103
  102330:	6a 67                	push   $0x67
  jmp __alltraps
  102332:	e9 44 fc ff ff       	jmp    101f7b <__alltraps>

00102337 <vector104>:
.globl vector104
vector104:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $104
  102339:	6a 68                	push   $0x68
  jmp __alltraps
  10233b:	e9 3b fc ff ff       	jmp    101f7b <__alltraps>

00102340 <vector105>:
.globl vector105
vector105:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $105
  102342:	6a 69                	push   $0x69
  jmp __alltraps
  102344:	e9 32 fc ff ff       	jmp    101f7b <__alltraps>

00102349 <vector106>:
.globl vector106
vector106:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $106
  10234b:	6a 6a                	push   $0x6a
  jmp __alltraps
  10234d:	e9 29 fc ff ff       	jmp    101f7b <__alltraps>

00102352 <vector107>:
.globl vector107
vector107:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $107
  102354:	6a 6b                	push   $0x6b
  jmp __alltraps
  102356:	e9 20 fc ff ff       	jmp    101f7b <__alltraps>

0010235b <vector108>:
.globl vector108
vector108:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $108
  10235d:	6a 6c                	push   $0x6c
  jmp __alltraps
  10235f:	e9 17 fc ff ff       	jmp    101f7b <__alltraps>

00102364 <vector109>:
.globl vector109
vector109:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $109
  102366:	6a 6d                	push   $0x6d
  jmp __alltraps
  102368:	e9 0e fc ff ff       	jmp    101f7b <__alltraps>

0010236d <vector110>:
.globl vector110
vector110:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $110
  10236f:	6a 6e                	push   $0x6e
  jmp __alltraps
  102371:	e9 05 fc ff ff       	jmp    101f7b <__alltraps>

00102376 <vector111>:
.globl vector111
vector111:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $111
  102378:	6a 6f                	push   $0x6f
  jmp __alltraps
  10237a:	e9 fc fb ff ff       	jmp    101f7b <__alltraps>

0010237f <vector112>:
.globl vector112
vector112:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $112
  102381:	6a 70                	push   $0x70
  jmp __alltraps
  102383:	e9 f3 fb ff ff       	jmp    101f7b <__alltraps>

00102388 <vector113>:
.globl vector113
vector113:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $113
  10238a:	6a 71                	push   $0x71
  jmp __alltraps
  10238c:	e9 ea fb ff ff       	jmp    101f7b <__alltraps>

00102391 <vector114>:
.globl vector114
vector114:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $114
  102393:	6a 72                	push   $0x72
  jmp __alltraps
  102395:	e9 e1 fb ff ff       	jmp    101f7b <__alltraps>

0010239a <vector115>:
.globl vector115
vector115:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $115
  10239c:	6a 73                	push   $0x73
  jmp __alltraps
  10239e:	e9 d8 fb ff ff       	jmp    101f7b <__alltraps>

001023a3 <vector116>:
.globl vector116
vector116:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $116
  1023a5:	6a 74                	push   $0x74
  jmp __alltraps
  1023a7:	e9 cf fb ff ff       	jmp    101f7b <__alltraps>

001023ac <vector117>:
.globl vector117
vector117:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $117
  1023ae:	6a 75                	push   $0x75
  jmp __alltraps
  1023b0:	e9 c6 fb ff ff       	jmp    101f7b <__alltraps>

001023b5 <vector118>:
.globl vector118
vector118:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $118
  1023b7:	6a 76                	push   $0x76
  jmp __alltraps
  1023b9:	e9 bd fb ff ff       	jmp    101f7b <__alltraps>

001023be <vector119>:
.globl vector119
vector119:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $119
  1023c0:	6a 77                	push   $0x77
  jmp __alltraps
  1023c2:	e9 b4 fb ff ff       	jmp    101f7b <__alltraps>

001023c7 <vector120>:
.globl vector120
vector120:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $120
  1023c9:	6a 78                	push   $0x78
  jmp __alltraps
  1023cb:	e9 ab fb ff ff       	jmp    101f7b <__alltraps>

001023d0 <vector121>:
.globl vector121
vector121:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $121
  1023d2:	6a 79                	push   $0x79
  jmp __alltraps
  1023d4:	e9 a2 fb ff ff       	jmp    101f7b <__alltraps>

001023d9 <vector122>:
.globl vector122
vector122:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $122
  1023db:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023dd:	e9 99 fb ff ff       	jmp    101f7b <__alltraps>

001023e2 <vector123>:
.globl vector123
vector123:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $123
  1023e4:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023e6:	e9 90 fb ff ff       	jmp    101f7b <__alltraps>

001023eb <vector124>:
.globl vector124
vector124:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $124
  1023ed:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023ef:	e9 87 fb ff ff       	jmp    101f7b <__alltraps>

001023f4 <vector125>:
.globl vector125
vector125:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $125
  1023f6:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023f8:	e9 7e fb ff ff       	jmp    101f7b <__alltraps>

001023fd <vector126>:
.globl vector126
vector126:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $126
  1023ff:	6a 7e                	push   $0x7e
  jmp __alltraps
  102401:	e9 75 fb ff ff       	jmp    101f7b <__alltraps>

00102406 <vector127>:
.globl vector127
vector127:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $127
  102408:	6a 7f                	push   $0x7f
  jmp __alltraps
  10240a:	e9 6c fb ff ff       	jmp    101f7b <__alltraps>

0010240f <vector128>:
.globl vector128
vector128:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $128
  102411:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102416:	e9 60 fb ff ff       	jmp    101f7b <__alltraps>

0010241b <vector129>:
.globl vector129
vector129:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $129
  10241d:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102422:	e9 54 fb ff ff       	jmp    101f7b <__alltraps>

00102427 <vector130>:
.globl vector130
vector130:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $130
  102429:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10242e:	e9 48 fb ff ff       	jmp    101f7b <__alltraps>

00102433 <vector131>:
.globl vector131
vector131:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $131
  102435:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10243a:	e9 3c fb ff ff       	jmp    101f7b <__alltraps>

0010243f <vector132>:
.globl vector132
vector132:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $132
  102441:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102446:	e9 30 fb ff ff       	jmp    101f7b <__alltraps>

0010244b <vector133>:
.globl vector133
vector133:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $133
  10244d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102452:	e9 24 fb ff ff       	jmp    101f7b <__alltraps>

00102457 <vector134>:
.globl vector134
vector134:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $134
  102459:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10245e:	e9 18 fb ff ff       	jmp    101f7b <__alltraps>

00102463 <vector135>:
.globl vector135
vector135:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $135
  102465:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10246a:	e9 0c fb ff ff       	jmp    101f7b <__alltraps>

0010246f <vector136>:
.globl vector136
vector136:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $136
  102471:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102476:	e9 00 fb ff ff       	jmp    101f7b <__alltraps>

0010247b <vector137>:
.globl vector137
vector137:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $137
  10247d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102482:	e9 f4 fa ff ff       	jmp    101f7b <__alltraps>

00102487 <vector138>:
.globl vector138
vector138:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $138
  102489:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10248e:	e9 e8 fa ff ff       	jmp    101f7b <__alltraps>

00102493 <vector139>:
.globl vector139
vector139:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $139
  102495:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10249a:	e9 dc fa ff ff       	jmp    101f7b <__alltraps>

0010249f <vector140>:
.globl vector140
vector140:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $140
  1024a1:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1024a6:	e9 d0 fa ff ff       	jmp    101f7b <__alltraps>

001024ab <vector141>:
.globl vector141
vector141:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $141
  1024ad:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1024b2:	e9 c4 fa ff ff       	jmp    101f7b <__alltraps>

001024b7 <vector142>:
.globl vector142
vector142:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $142
  1024b9:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024be:	e9 b8 fa ff ff       	jmp    101f7b <__alltraps>

001024c3 <vector143>:
.globl vector143
vector143:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $143
  1024c5:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024ca:	e9 ac fa ff ff       	jmp    101f7b <__alltraps>

001024cf <vector144>:
.globl vector144
vector144:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $144
  1024d1:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024d6:	e9 a0 fa ff ff       	jmp    101f7b <__alltraps>

001024db <vector145>:
.globl vector145
vector145:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $145
  1024dd:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024e2:	e9 94 fa ff ff       	jmp    101f7b <__alltraps>

001024e7 <vector146>:
.globl vector146
vector146:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $146
  1024e9:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024ee:	e9 88 fa ff ff       	jmp    101f7b <__alltraps>

001024f3 <vector147>:
.globl vector147
vector147:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $147
  1024f5:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024fa:	e9 7c fa ff ff       	jmp    101f7b <__alltraps>

001024ff <vector148>:
.globl vector148
vector148:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $148
  102501:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102506:	e9 70 fa ff ff       	jmp    101f7b <__alltraps>

0010250b <vector149>:
.globl vector149
vector149:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $149
  10250d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102512:	e9 64 fa ff ff       	jmp    101f7b <__alltraps>

00102517 <vector150>:
.globl vector150
vector150:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $150
  102519:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10251e:	e9 58 fa ff ff       	jmp    101f7b <__alltraps>

00102523 <vector151>:
.globl vector151
vector151:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $151
  102525:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10252a:	e9 4c fa ff ff       	jmp    101f7b <__alltraps>

0010252f <vector152>:
.globl vector152
vector152:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $152
  102531:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102536:	e9 40 fa ff ff       	jmp    101f7b <__alltraps>

0010253b <vector153>:
.globl vector153
vector153:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $153
  10253d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102542:	e9 34 fa ff ff       	jmp    101f7b <__alltraps>

00102547 <vector154>:
.globl vector154
vector154:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $154
  102549:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10254e:	e9 28 fa ff ff       	jmp    101f7b <__alltraps>

00102553 <vector155>:
.globl vector155
vector155:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $155
  102555:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10255a:	e9 1c fa ff ff       	jmp    101f7b <__alltraps>

0010255f <vector156>:
.globl vector156
vector156:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $156
  102561:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102566:	e9 10 fa ff ff       	jmp    101f7b <__alltraps>

0010256b <vector157>:
.globl vector157
vector157:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $157
  10256d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102572:	e9 04 fa ff ff       	jmp    101f7b <__alltraps>

00102577 <vector158>:
.globl vector158
vector158:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $158
  102579:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10257e:	e9 f8 f9 ff ff       	jmp    101f7b <__alltraps>

00102583 <vector159>:
.globl vector159
vector159:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $159
  102585:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10258a:	e9 ec f9 ff ff       	jmp    101f7b <__alltraps>

0010258f <vector160>:
.globl vector160
vector160:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $160
  102591:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102596:	e9 e0 f9 ff ff       	jmp    101f7b <__alltraps>

0010259b <vector161>:
.globl vector161
vector161:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $161
  10259d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1025a2:	e9 d4 f9 ff ff       	jmp    101f7b <__alltraps>

001025a7 <vector162>:
.globl vector162
vector162:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $162
  1025a9:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1025ae:	e9 c8 f9 ff ff       	jmp    101f7b <__alltraps>

001025b3 <vector163>:
.globl vector163
vector163:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $163
  1025b5:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025ba:	e9 bc f9 ff ff       	jmp    101f7b <__alltraps>

001025bf <vector164>:
.globl vector164
vector164:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $164
  1025c1:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1025c6:	e9 b0 f9 ff ff       	jmp    101f7b <__alltraps>

001025cb <vector165>:
.globl vector165
vector165:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $165
  1025cd:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1025d2:	e9 a4 f9 ff ff       	jmp    101f7b <__alltraps>

001025d7 <vector166>:
.globl vector166
vector166:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $166
  1025d9:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025de:	e9 98 f9 ff ff       	jmp    101f7b <__alltraps>

001025e3 <vector167>:
.globl vector167
vector167:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $167
  1025e5:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025ea:	e9 8c f9 ff ff       	jmp    101f7b <__alltraps>

001025ef <vector168>:
.globl vector168
vector168:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $168
  1025f1:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025f6:	e9 80 f9 ff ff       	jmp    101f7b <__alltraps>

001025fb <vector169>:
.globl vector169
vector169:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $169
  1025fd:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102602:	e9 74 f9 ff ff       	jmp    101f7b <__alltraps>

00102607 <vector170>:
.globl vector170
vector170:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $170
  102609:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10260e:	e9 68 f9 ff ff       	jmp    101f7b <__alltraps>

00102613 <vector171>:
.globl vector171
vector171:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $171
  102615:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10261a:	e9 5c f9 ff ff       	jmp    101f7b <__alltraps>

0010261f <vector172>:
.globl vector172
vector172:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $172
  102621:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102626:	e9 50 f9 ff ff       	jmp    101f7b <__alltraps>

0010262b <vector173>:
.globl vector173
vector173:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $173
  10262d:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102632:	e9 44 f9 ff ff       	jmp    101f7b <__alltraps>

00102637 <vector174>:
.globl vector174
vector174:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $174
  102639:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10263e:	e9 38 f9 ff ff       	jmp    101f7b <__alltraps>

00102643 <vector175>:
.globl vector175
vector175:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $175
  102645:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10264a:	e9 2c f9 ff ff       	jmp    101f7b <__alltraps>

0010264f <vector176>:
.globl vector176
vector176:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $176
  102651:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102656:	e9 20 f9 ff ff       	jmp    101f7b <__alltraps>

0010265b <vector177>:
.globl vector177
vector177:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $177
  10265d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102662:	e9 14 f9 ff ff       	jmp    101f7b <__alltraps>

00102667 <vector178>:
.globl vector178
vector178:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $178
  102669:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10266e:	e9 08 f9 ff ff       	jmp    101f7b <__alltraps>

00102673 <vector179>:
.globl vector179
vector179:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $179
  102675:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10267a:	e9 fc f8 ff ff       	jmp    101f7b <__alltraps>

0010267f <vector180>:
.globl vector180
vector180:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $180
  102681:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102686:	e9 f0 f8 ff ff       	jmp    101f7b <__alltraps>

0010268b <vector181>:
.globl vector181
vector181:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $181
  10268d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102692:	e9 e4 f8 ff ff       	jmp    101f7b <__alltraps>

00102697 <vector182>:
.globl vector182
vector182:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $182
  102699:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10269e:	e9 d8 f8 ff ff       	jmp    101f7b <__alltraps>

001026a3 <vector183>:
.globl vector183
vector183:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $183
  1026a5:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1026aa:	e9 cc f8 ff ff       	jmp    101f7b <__alltraps>

001026af <vector184>:
.globl vector184
vector184:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $184
  1026b1:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1026b6:	e9 c0 f8 ff ff       	jmp    101f7b <__alltraps>

001026bb <vector185>:
.globl vector185
vector185:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $185
  1026bd:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1026c2:	e9 b4 f8 ff ff       	jmp    101f7b <__alltraps>

001026c7 <vector186>:
.globl vector186
vector186:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $186
  1026c9:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1026ce:	e9 a8 f8 ff ff       	jmp    101f7b <__alltraps>

001026d3 <vector187>:
.globl vector187
vector187:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $187
  1026d5:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026da:	e9 9c f8 ff ff       	jmp    101f7b <__alltraps>

001026df <vector188>:
.globl vector188
vector188:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $188
  1026e1:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026e6:	e9 90 f8 ff ff       	jmp    101f7b <__alltraps>

001026eb <vector189>:
.globl vector189
vector189:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $189
  1026ed:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026f2:	e9 84 f8 ff ff       	jmp    101f7b <__alltraps>

001026f7 <vector190>:
.globl vector190
vector190:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $190
  1026f9:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026fe:	e9 78 f8 ff ff       	jmp    101f7b <__alltraps>

00102703 <vector191>:
.globl vector191
vector191:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $191
  102705:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10270a:	e9 6c f8 ff ff       	jmp    101f7b <__alltraps>

0010270f <vector192>:
.globl vector192
vector192:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $192
  102711:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102716:	e9 60 f8 ff ff       	jmp    101f7b <__alltraps>

0010271b <vector193>:
.globl vector193
vector193:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $193
  10271d:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102722:	e9 54 f8 ff ff       	jmp    101f7b <__alltraps>

00102727 <vector194>:
.globl vector194
vector194:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $194
  102729:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10272e:	e9 48 f8 ff ff       	jmp    101f7b <__alltraps>

00102733 <vector195>:
.globl vector195
vector195:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $195
  102735:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10273a:	e9 3c f8 ff ff       	jmp    101f7b <__alltraps>

0010273f <vector196>:
.globl vector196
vector196:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $196
  102741:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102746:	e9 30 f8 ff ff       	jmp    101f7b <__alltraps>

0010274b <vector197>:
.globl vector197
vector197:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $197
  10274d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102752:	e9 24 f8 ff ff       	jmp    101f7b <__alltraps>

00102757 <vector198>:
.globl vector198
vector198:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $198
  102759:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10275e:	e9 18 f8 ff ff       	jmp    101f7b <__alltraps>

00102763 <vector199>:
.globl vector199
vector199:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $199
  102765:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10276a:	e9 0c f8 ff ff       	jmp    101f7b <__alltraps>

0010276f <vector200>:
.globl vector200
vector200:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $200
  102771:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102776:	e9 00 f8 ff ff       	jmp    101f7b <__alltraps>

0010277b <vector201>:
.globl vector201
vector201:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $201
  10277d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102782:	e9 f4 f7 ff ff       	jmp    101f7b <__alltraps>

00102787 <vector202>:
.globl vector202
vector202:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $202
  102789:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10278e:	e9 e8 f7 ff ff       	jmp    101f7b <__alltraps>

00102793 <vector203>:
.globl vector203
vector203:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $203
  102795:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10279a:	e9 dc f7 ff ff       	jmp    101f7b <__alltraps>

0010279f <vector204>:
.globl vector204
vector204:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $204
  1027a1:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1027a6:	e9 d0 f7 ff ff       	jmp    101f7b <__alltraps>

001027ab <vector205>:
.globl vector205
vector205:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $205
  1027ad:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1027b2:	e9 c4 f7 ff ff       	jmp    101f7b <__alltraps>

001027b7 <vector206>:
.globl vector206
vector206:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $206
  1027b9:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027be:	e9 b8 f7 ff ff       	jmp    101f7b <__alltraps>

001027c3 <vector207>:
.globl vector207
vector207:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $207
  1027c5:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027ca:	e9 ac f7 ff ff       	jmp    101f7b <__alltraps>

001027cf <vector208>:
.globl vector208
vector208:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $208
  1027d1:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027d6:	e9 a0 f7 ff ff       	jmp    101f7b <__alltraps>

001027db <vector209>:
.globl vector209
vector209:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $209
  1027dd:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027e2:	e9 94 f7 ff ff       	jmp    101f7b <__alltraps>

001027e7 <vector210>:
.globl vector210
vector210:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $210
  1027e9:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027ee:	e9 88 f7 ff ff       	jmp    101f7b <__alltraps>

001027f3 <vector211>:
.globl vector211
vector211:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $211
  1027f5:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027fa:	e9 7c f7 ff ff       	jmp    101f7b <__alltraps>

001027ff <vector212>:
.globl vector212
vector212:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $212
  102801:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102806:	e9 70 f7 ff ff       	jmp    101f7b <__alltraps>

0010280b <vector213>:
.globl vector213
vector213:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $213
  10280d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102812:	e9 64 f7 ff ff       	jmp    101f7b <__alltraps>

00102817 <vector214>:
.globl vector214
vector214:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $214
  102819:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10281e:	e9 58 f7 ff ff       	jmp    101f7b <__alltraps>

00102823 <vector215>:
.globl vector215
vector215:
  pushl $0
  102823:	6a 00                	push   $0x0
  pushl $215
  102825:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10282a:	e9 4c f7 ff ff       	jmp    101f7b <__alltraps>

0010282f <vector216>:
.globl vector216
vector216:
  pushl $0
  10282f:	6a 00                	push   $0x0
  pushl $216
  102831:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102836:	e9 40 f7 ff ff       	jmp    101f7b <__alltraps>

0010283b <vector217>:
.globl vector217
vector217:
  pushl $0
  10283b:	6a 00                	push   $0x0
  pushl $217
  10283d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102842:	e9 34 f7 ff ff       	jmp    101f7b <__alltraps>

00102847 <vector218>:
.globl vector218
vector218:
  pushl $0
  102847:	6a 00                	push   $0x0
  pushl $218
  102849:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10284e:	e9 28 f7 ff ff       	jmp    101f7b <__alltraps>

00102853 <vector219>:
.globl vector219
vector219:
  pushl $0
  102853:	6a 00                	push   $0x0
  pushl $219
  102855:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10285a:	e9 1c f7 ff ff       	jmp    101f7b <__alltraps>

0010285f <vector220>:
.globl vector220
vector220:
  pushl $0
  10285f:	6a 00                	push   $0x0
  pushl $220
  102861:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102866:	e9 10 f7 ff ff       	jmp    101f7b <__alltraps>

0010286b <vector221>:
.globl vector221
vector221:
  pushl $0
  10286b:	6a 00                	push   $0x0
  pushl $221
  10286d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102872:	e9 04 f7 ff ff       	jmp    101f7b <__alltraps>

00102877 <vector222>:
.globl vector222
vector222:
  pushl $0
  102877:	6a 00                	push   $0x0
  pushl $222
  102879:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10287e:	e9 f8 f6 ff ff       	jmp    101f7b <__alltraps>

00102883 <vector223>:
.globl vector223
vector223:
  pushl $0
  102883:	6a 00                	push   $0x0
  pushl $223
  102885:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10288a:	e9 ec f6 ff ff       	jmp    101f7b <__alltraps>

0010288f <vector224>:
.globl vector224
vector224:
  pushl $0
  10288f:	6a 00                	push   $0x0
  pushl $224
  102891:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102896:	e9 e0 f6 ff ff       	jmp    101f7b <__alltraps>

0010289b <vector225>:
.globl vector225
vector225:
  pushl $0
  10289b:	6a 00                	push   $0x0
  pushl $225
  10289d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1028a2:	e9 d4 f6 ff ff       	jmp    101f7b <__alltraps>

001028a7 <vector226>:
.globl vector226
vector226:
  pushl $0
  1028a7:	6a 00                	push   $0x0
  pushl $226
  1028a9:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1028ae:	e9 c8 f6 ff ff       	jmp    101f7b <__alltraps>

001028b3 <vector227>:
.globl vector227
vector227:
  pushl $0
  1028b3:	6a 00                	push   $0x0
  pushl $227
  1028b5:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028ba:	e9 bc f6 ff ff       	jmp    101f7b <__alltraps>

001028bf <vector228>:
.globl vector228
vector228:
  pushl $0
  1028bf:	6a 00                	push   $0x0
  pushl $228
  1028c1:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1028c6:	e9 b0 f6 ff ff       	jmp    101f7b <__alltraps>

001028cb <vector229>:
.globl vector229
vector229:
  pushl $0
  1028cb:	6a 00                	push   $0x0
  pushl $229
  1028cd:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1028d2:	e9 a4 f6 ff ff       	jmp    101f7b <__alltraps>

001028d7 <vector230>:
.globl vector230
vector230:
  pushl $0
  1028d7:	6a 00                	push   $0x0
  pushl $230
  1028d9:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028de:	e9 98 f6 ff ff       	jmp    101f7b <__alltraps>

001028e3 <vector231>:
.globl vector231
vector231:
  pushl $0
  1028e3:	6a 00                	push   $0x0
  pushl $231
  1028e5:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028ea:	e9 8c f6 ff ff       	jmp    101f7b <__alltraps>

001028ef <vector232>:
.globl vector232
vector232:
  pushl $0
  1028ef:	6a 00                	push   $0x0
  pushl $232
  1028f1:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028f6:	e9 80 f6 ff ff       	jmp    101f7b <__alltraps>

001028fb <vector233>:
.globl vector233
vector233:
  pushl $0
  1028fb:	6a 00                	push   $0x0
  pushl $233
  1028fd:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102902:	e9 74 f6 ff ff       	jmp    101f7b <__alltraps>

00102907 <vector234>:
.globl vector234
vector234:
  pushl $0
  102907:	6a 00                	push   $0x0
  pushl $234
  102909:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10290e:	e9 68 f6 ff ff       	jmp    101f7b <__alltraps>

00102913 <vector235>:
.globl vector235
vector235:
  pushl $0
  102913:	6a 00                	push   $0x0
  pushl $235
  102915:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10291a:	e9 5c f6 ff ff       	jmp    101f7b <__alltraps>

0010291f <vector236>:
.globl vector236
vector236:
  pushl $0
  10291f:	6a 00                	push   $0x0
  pushl $236
  102921:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102926:	e9 50 f6 ff ff       	jmp    101f7b <__alltraps>

0010292b <vector237>:
.globl vector237
vector237:
  pushl $0
  10292b:	6a 00                	push   $0x0
  pushl $237
  10292d:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102932:	e9 44 f6 ff ff       	jmp    101f7b <__alltraps>

00102937 <vector238>:
.globl vector238
vector238:
  pushl $0
  102937:	6a 00                	push   $0x0
  pushl $238
  102939:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10293e:	e9 38 f6 ff ff       	jmp    101f7b <__alltraps>

00102943 <vector239>:
.globl vector239
vector239:
  pushl $0
  102943:	6a 00                	push   $0x0
  pushl $239
  102945:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10294a:	e9 2c f6 ff ff       	jmp    101f7b <__alltraps>

0010294f <vector240>:
.globl vector240
vector240:
  pushl $0
  10294f:	6a 00                	push   $0x0
  pushl $240
  102951:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102956:	e9 20 f6 ff ff       	jmp    101f7b <__alltraps>

0010295b <vector241>:
.globl vector241
vector241:
  pushl $0
  10295b:	6a 00                	push   $0x0
  pushl $241
  10295d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102962:	e9 14 f6 ff ff       	jmp    101f7b <__alltraps>

00102967 <vector242>:
.globl vector242
vector242:
  pushl $0
  102967:	6a 00                	push   $0x0
  pushl $242
  102969:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10296e:	e9 08 f6 ff ff       	jmp    101f7b <__alltraps>

00102973 <vector243>:
.globl vector243
vector243:
  pushl $0
  102973:	6a 00                	push   $0x0
  pushl $243
  102975:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10297a:	e9 fc f5 ff ff       	jmp    101f7b <__alltraps>

0010297f <vector244>:
.globl vector244
vector244:
  pushl $0
  10297f:	6a 00                	push   $0x0
  pushl $244
  102981:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102986:	e9 f0 f5 ff ff       	jmp    101f7b <__alltraps>

0010298b <vector245>:
.globl vector245
vector245:
  pushl $0
  10298b:	6a 00                	push   $0x0
  pushl $245
  10298d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102992:	e9 e4 f5 ff ff       	jmp    101f7b <__alltraps>

00102997 <vector246>:
.globl vector246
vector246:
  pushl $0
  102997:	6a 00                	push   $0x0
  pushl $246
  102999:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10299e:	e9 d8 f5 ff ff       	jmp    101f7b <__alltraps>

001029a3 <vector247>:
.globl vector247
vector247:
  pushl $0
  1029a3:	6a 00                	push   $0x0
  pushl $247
  1029a5:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1029aa:	e9 cc f5 ff ff       	jmp    101f7b <__alltraps>

001029af <vector248>:
.globl vector248
vector248:
  pushl $0
  1029af:	6a 00                	push   $0x0
  pushl $248
  1029b1:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1029b6:	e9 c0 f5 ff ff       	jmp    101f7b <__alltraps>

001029bb <vector249>:
.globl vector249
vector249:
  pushl $0
  1029bb:	6a 00                	push   $0x0
  pushl $249
  1029bd:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1029c2:	e9 b4 f5 ff ff       	jmp    101f7b <__alltraps>

001029c7 <vector250>:
.globl vector250
vector250:
  pushl $0
  1029c7:	6a 00                	push   $0x0
  pushl $250
  1029c9:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1029ce:	e9 a8 f5 ff ff       	jmp    101f7b <__alltraps>

001029d3 <vector251>:
.globl vector251
vector251:
  pushl $0
  1029d3:	6a 00                	push   $0x0
  pushl $251
  1029d5:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029da:	e9 9c f5 ff ff       	jmp    101f7b <__alltraps>

001029df <vector252>:
.globl vector252
vector252:
  pushl $0
  1029df:	6a 00                	push   $0x0
  pushl $252
  1029e1:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029e6:	e9 90 f5 ff ff       	jmp    101f7b <__alltraps>

001029eb <vector253>:
.globl vector253
vector253:
  pushl $0
  1029eb:	6a 00                	push   $0x0
  pushl $253
  1029ed:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029f2:	e9 84 f5 ff ff       	jmp    101f7b <__alltraps>

001029f7 <vector254>:
.globl vector254
vector254:
  pushl $0
  1029f7:	6a 00                	push   $0x0
  pushl $254
  1029f9:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029fe:	e9 78 f5 ff ff       	jmp    101f7b <__alltraps>

00102a03 <vector255>:
.globl vector255
vector255:
  pushl $0
  102a03:	6a 00                	push   $0x0
  pushl $255
  102a05:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a0a:	e9 6c f5 ff ff       	jmp    101f7b <__alltraps>

00102a0f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102a0f:	55                   	push   %ebp
  102a10:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102a12:	8b 55 08             	mov    0x8(%ebp),%edx
  102a15:	a1 24 af 11 00       	mov    0x11af24,%eax
  102a1a:	29 c2                	sub    %eax,%edx
  102a1c:	89 d0                	mov    %edx,%eax
  102a1e:	c1 f8 02             	sar    $0x2,%eax
  102a21:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102a27:	5d                   	pop    %ebp
  102a28:	c3                   	ret    

00102a29 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102a29:	55                   	push   %ebp
  102a2a:	89 e5                	mov    %esp,%ebp
  102a2c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a32:	89 04 24             	mov    %eax,(%esp)
  102a35:	e8 d5 ff ff ff       	call   102a0f <page2ppn>
  102a3a:	c1 e0 0c             	shl    $0xc,%eax
}
  102a3d:	c9                   	leave  
  102a3e:	c3                   	ret    

00102a3f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102a3f:	55                   	push   %ebp
  102a40:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102a42:	8b 45 08             	mov    0x8(%ebp),%eax
  102a45:	8b 00                	mov    (%eax),%eax
}
  102a47:	5d                   	pop    %ebp
  102a48:	c3                   	ret    

00102a49 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102a49:	55                   	push   %ebp
  102a4a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a52:	89 10                	mov    %edx,(%eax)
}
  102a54:	5d                   	pop    %ebp
  102a55:	c3                   	ret    

00102a56 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102a56:	55                   	push   %ebp
  102a57:	89 e5                	mov    %esp,%ebp
  102a59:	83 ec 10             	sub    $0x10,%esp
  102a5c:	c7 45 fc 10 af 11 00 	movl   $0x11af10,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102a63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a66:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102a69:	89 50 04             	mov    %edx,0x4(%eax)
  102a6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a6f:	8b 50 04             	mov    0x4(%eax),%edx
  102a72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a75:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102a77:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  102a7e:	00 00 00 
}
  102a81:	c9                   	leave  
  102a82:	c3                   	ret    

00102a83 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102a83:	55                   	push   %ebp
  102a84:	89 e5                	mov    %esp,%ebp
  102a86:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102a89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a8d:	75 24                	jne    102ab3 <default_init_memmap+0x30>
  102a8f:	c7 44 24 0c d0 69 10 	movl   $0x1069d0,0xc(%esp)
  102a96:	00 
  102a97:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  102a9e:	00 
  102a9f:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  102aa6:	00 
  102aa7:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  102aae:	e8 23 e2 ff ff       	call   100cd6 <__panic>
    struct Page *p = base;
  102ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102ab9:	eb 7d                	jmp    102b38 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  102abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102abe:	83 c0 04             	add    $0x4,%eax
  102ac1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102ac8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ace:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ad1:	0f a3 10             	bt     %edx,(%eax)
  102ad4:	19 c0                	sbb    %eax,%eax
  102ad6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102ad9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102add:	0f 95 c0             	setne  %al
  102ae0:	0f b6 c0             	movzbl %al,%eax
  102ae3:	85 c0                	test   %eax,%eax
  102ae5:	75 24                	jne    102b0b <default_init_memmap+0x88>
  102ae7:	c7 44 24 0c 01 6a 10 	movl   $0x106a01,0xc(%esp)
  102aee:	00 
  102aef:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  102af6:	00 
  102af7:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  102afe:	00 
  102aff:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  102b06:	e8 cb e1 ff ff       	call   100cd6 <__panic>
	//初始化flags，property
        p->flags = p->property = 0;
  102b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b18:	8b 50 08             	mov    0x8(%eax),%edx
  102b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b1e:	89 50 04             	mov    %edx,0x4(%eax)
	//初始化ref
        set_page_ref(p, 0);
  102b21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102b28:	00 
  102b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b2c:	89 04 24             	mov    %eax,(%esp)
  102b2f:	e8 15 ff ff ff       	call   102a49 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102b34:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b3b:	89 d0                	mov    %edx,%eax
  102b3d:	c1 e0 02             	shl    $0x2,%eax
  102b40:	01 d0                	add    %edx,%eax
  102b42:	c1 e0 02             	shl    $0x2,%eax
  102b45:	89 c2                	mov    %eax,%edx
  102b47:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4a:	01 d0                	add    %edx,%eax
  102b4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102b4f:	0f 85 66 ff ff ff    	jne    102abb <default_init_memmap+0x38>
        p->flags = p->property = 0;
	//初始化ref
        set_page_ref(p, 0);
    }
    //第一页并且空闲的页面property置为块的总数
    base->property = n;
  102b55:	8b 45 08             	mov    0x8(%ebp),%eax
  102b58:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b5b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b61:	83 c0 04             	add    $0x4,%eax
  102b64:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102b6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b74:	0f ab 10             	bts    %edx,(%eax)
    //we should update the sum of the free memory blocks
    nr_free += n;
  102b77:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  102b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b80:	01 d0                	add    %edx,%eax
  102b82:	a3 18 af 11 00       	mov    %eax,0x11af18
    list_add(&free_list, &(base->page_link));
  102b87:	8b 45 08             	mov    0x8(%ebp),%eax
  102b8a:	83 c0 0c             	add    $0xc,%eax
  102b8d:	c7 45 dc 10 af 11 00 	movl   $0x11af10,-0x24(%ebp)
  102b94:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102b97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b9a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102b9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102ba0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102ba3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102ba6:	8b 40 04             	mov    0x4(%eax),%eax
  102ba9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102bac:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102baf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102bb2:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102bb5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102bb8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102bbb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102bbe:	89 10                	mov    %edx,(%eax)
  102bc0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102bc3:	8b 10                	mov    (%eax),%edx
  102bc5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102bc8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102bcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102bce:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102bd1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102bd4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102bd7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102bda:	89 10                	mov    %edx,(%eax)
}
  102bdc:	c9                   	leave  
  102bdd:	c3                   	ret    

00102bde <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102bde:	55                   	push   %ebp
  102bdf:	89 e5                	mov    %esp,%ebp
  102be1:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102be4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102be8:	75 24                	jne    102c0e <default_alloc_pages+0x30>
  102bea:	c7 44 24 0c d0 69 10 	movl   $0x1069d0,0xc(%esp)
  102bf1:	00 
  102bf2:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  102bf9:	00 
  102bfa:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  102c01:	00 
  102c02:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  102c09:	e8 c8 e0 ff ff       	call   100cd6 <__panic>
    //如果当前要分配的块数大于总共的空闲块总数
    if (n > nr_free) {
  102c0e:	a1 18 af 11 00       	mov    0x11af18,%eax
  102c13:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c16:	73 0a                	jae    102c22 <default_alloc_pages+0x44>
        return NULL;
  102c18:	b8 00 00 00 00       	mov    $0x0,%eax
  102c1d:	e9 95 01 00 00       	jmp    102db7 <default_alloc_pages+0x1d9>
    }
    struct Page *page = NULL;
  102c22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    //search the free list
    list_entry_t *le = &free_list;
  102c29:	c7 45 f0 10 af 11 00 	movl   $0x11af10,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102c30:	eb 1c                	jmp    102c4e <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c35:	83 e8 0c             	sub    $0xc,%eax
  102c38:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//the num of free pages in this block >= n
        if (p->property >= n) {
  102c3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c3e:	8b 40 08             	mov    0x8(%eax),%eax
  102c41:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c44:	72 08                	jb     102c4e <default_alloc_pages+0x70>
            page = p;
  102c46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102c4c:	eb 18                	jmp    102c66 <default_alloc_pages+0x88>
  102c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c51:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102c54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c57:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    //search the free list
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c5d:	81 7d f0 10 af 11 00 	cmpl   $0x11af10,-0x10(%ebp)
  102c64:	75 cc                	jne    102c32 <default_alloc_pages+0x54>
            break;
        }
    }
    
    //Some flag bits of this page should be set
    if (page != NULL) {
  102c66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102c6a:	0f 84 42 01 00 00    	je     102db2 <default_alloc_pages+0x1d4>
	//first `n` pages can be malloced
	struct Page *pi = page + 1;
  102c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c73:	83 c0 14             	add    $0x14,%eax
  102c76:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for(pi; pi != page + n; pi++) {
  102c79:	eb 21                	jmp    102c9c <default_alloc_pages+0xbe>
	    pi->property = 0;
  102c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    set_page_ref(pi, 0);
  102c85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c8c:	00 
  102c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c90:	89 04 24             	mov    %eax,(%esp)
  102c93:	e8 b1 fd ff ff       	call   102a49 <set_page_ref>
    
    //Some flag bits of this page should be set
    if (page != NULL) {
	//first `n` pages can be malloced
	struct Page *pi = page + 1;
	for(pi; pi != page + n; pi++) {
  102c98:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  102c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  102c9f:	89 d0                	mov    %edx,%eax
  102ca1:	c1 e0 02             	shl    $0x2,%eax
  102ca4:	01 d0                	add    %edx,%eax
  102ca6:	c1 e0 02             	shl    $0x2,%eax
  102ca9:	89 c2                	mov    %eax,%edx
  102cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cae:	01 d0                	add    %edx,%eax
  102cb0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102cb3:	75 c6                	jne    102c7b <default_alloc_pages+0x9d>
	    pi->property = 0;
	    set_page_ref(pi, 0);
	}
        //list_del(&(page->page_link));
        if (page->property > n) {
  102cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cb8:	8b 40 08             	mov    0x8(%eax),%eax
  102cbb:	3b 45 08             	cmp    0x8(%ebp),%eax
  102cbe:	0f 86 98 00 00 00    	jbe    102d5c <default_alloc_pages+0x17e>
            struct Page *p = page + n;
  102cc4:	8b 55 08             	mov    0x8(%ebp),%edx
  102cc7:	89 d0                	mov    %edx,%eax
  102cc9:	c1 e0 02             	shl    $0x2,%eax
  102ccc:	01 d0                	add    %edx,%eax
  102cce:	c1 e0 02             	shl    $0x2,%eax
  102cd1:	89 c2                	mov    %eax,%edx
  102cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cd6:	01 d0                	add    %edx,%eax
  102cd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    //re-caculate number of the rest of this free block
            p->property = page->property - n;
  102cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cde:	8b 40 08             	mov    0x8(%eax),%eax
  102ce1:	2b 45 08             	sub    0x8(%ebp),%eax
  102ce4:	89 c2                	mov    %eax,%edx
  102ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ce9:	89 50 08             	mov    %edx,0x8(%eax)
	    SetPageProperty(p);
  102cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cef:	83 c0 04             	add    $0x4,%eax
  102cf2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102cf9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102cfc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102cff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d02:	0f ab 10             	bts    %edx,(%eax)
	    //分裂后的块插入当前块后面，以保证列表的顺序性
            list_add(&(page->page_link), &(p->page_link));
  102d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d08:	83 c0 0c             	add    $0xc,%eax
  102d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d0e:	83 c2 0c             	add    $0xc,%edx
  102d11:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102d14:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102d17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102d1a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102d1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d20:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102d23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d26:	8b 40 04             	mov    0x4(%eax),%eax
  102d29:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102d2c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102d2f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102d32:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102d35:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102d38:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d3b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d3e:	89 10                	mov    %edx,(%eax)
  102d40:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d43:	8b 10                	mov    (%eax),%edx
  102d45:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d48:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102d4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d4e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102d51:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102d54:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d57:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102d5a:	89 10                	mov    %edx,(%eax)
    }
	//re-caculate nr-free
        nr_free = nr_free - n;
  102d5c:	a1 18 af 11 00       	mov    0x11af18,%eax
  102d61:	2b 45 08             	sub    0x8(%ebp),%eax
  102d64:	a3 18 af 11 00       	mov    %eax,0x11af18
	//unlink the pages from 'free_list'
	list_del(&(page->page_link));
  102d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d6c:	83 c0 0c             	add    $0xc,%eax
  102d6f:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102d72:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d75:	8b 40 04             	mov    0x4(%eax),%eax
  102d78:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102d7b:	8b 12                	mov    (%edx),%edx
  102d7d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  102d80:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102d83:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d86:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102d89:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102d8c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102d8f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d92:	89 10                	mov    %edx,(%eax)
        ClearPageProperty(page);
  102d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d97:	83 c0 04             	add    $0x4,%eax
  102d9a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  102da1:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102da4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102da7:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102daa:	0f b3 10             	btr    %edx,(%eax)
    } else {
	return NULL;
    }
    return page;
  102dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db0:	eb 05                	jmp    102db7 <default_alloc_pages+0x1d9>
        nr_free = nr_free - n;
	//unlink the pages from 'free_list'
	list_del(&(page->page_link));
        ClearPageProperty(page);
    } else {
	return NULL;
  102db2:	b8 00 00 00 00       	mov    $0x0,%eax
    }
    return page;
}
  102db7:	c9                   	leave  
  102db8:	c3                   	ret    

00102db9 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102db9:	55                   	push   %ebp
  102dba:	89 e5                	mov    %esp,%ebp
  102dbc:	81 ec b8 00 00 00    	sub    $0xb8,%esp
    assert(n > 0);
  102dc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102dc6:	75 24                	jne    102dec <default_free_pages+0x33>
  102dc8:	c7 44 24 0c d0 69 10 	movl   $0x1069d0,0xc(%esp)
  102dcf:	00 
  102dd0:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  102dd7:	00 
  102dd8:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  102ddf:	00 
  102de0:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  102de7:	e8 ea de ff ff       	call   100cd6 <__panic>
    struct Page *p = base;
  102dec:	8b 45 08             	mov    0x8(%ebp),%eax
  102def:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102df2:	e9 9d 00 00 00       	jmp    102e94 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dfa:	83 c0 04             	add    $0x4,%eax
  102dfd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  102e04:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102e07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102e0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102e0d:	0f a3 10             	bt     %edx,(%eax)
  102e10:	19 c0                	sbb    %eax,%eax
  102e12:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
  102e15:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  102e19:	0f 95 c0             	setne  %al
  102e1c:	0f b6 c0             	movzbl %al,%eax
  102e1f:	85 c0                	test   %eax,%eax
  102e21:	75 2c                	jne    102e4f <default_free_pages+0x96>
  102e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e26:	83 c0 04             	add    $0x4,%eax
  102e29:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  102e30:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102e33:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102e36:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102e39:	0f a3 10             	bt     %edx,(%eax)
  102e3c:	19 c0                	sbb    %eax,%eax
  102e3e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return oldbit != 0;
  102e41:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  102e45:	0f 95 c0             	setne  %al
  102e48:	0f b6 c0             	movzbl %al,%eax
  102e4b:	85 c0                	test   %eax,%eax
  102e4d:	74 24                	je     102e73 <default_free_pages+0xba>
  102e4f:	c7 44 24 0c 14 6a 10 	movl   $0x106a14,0xc(%esp)
  102e56:	00 
  102e57:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  102e5e:	00 
  102e5f:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  102e66:	00 
  102e67:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  102e6e:	e8 63 de ff ff       	call   100cd6 <__panic>
        p->flags = 0;
  102e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102e7d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102e84:	00 
  102e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e88:	89 04 24             	mov    %eax,(%esp)
  102e8b:	e8 b9 fb ff ff       	call   102a49 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102e90:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e97:	89 d0                	mov    %edx,%eax
  102e99:	c1 e0 02             	shl    $0x2,%eax
  102e9c:	01 d0                	add    %edx,%eax
  102e9e:	c1 e0 02             	shl    $0x2,%eax
  102ea1:	89 c2                	mov    %eax,%edx
  102ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea6:	01 d0                	add    %edx,%eax
  102ea8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102eab:	0f 85 46 ff ff ff    	jne    102df7 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  102eb7:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102eba:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebd:	83 c0 04             	add    $0x4,%eax
  102ec0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102ec7:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102eca:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ecd:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102ed0:	0f ab 10             	bts    %edx,(%eax)
    struct Page *behind = NULL;//记录后面可以合并的
  102ed3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    struct Page *before = NULL;//记录前面可以合并的
  102eda:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    bool hasBehind = 0;//是否有后面可以合并的
  102ee1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    bool hasBefore = 0;//是否有前面可以合并的
  102ee8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bool bigSmall = 0;//base地址附近没有可以合并的块，记录base块应该插入p的前还是后？
  102eef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102ef6:	c7 45 b8 10 af 11 00 	movl   $0x11af10,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102efd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102f00:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102f03:	89 45 dc             	mov    %eax,-0x24(%ebp)
    while (le != &free_list) {
  102f06:	e9 9b 00 00 00       	jmp    102fa6 <default_free_pages+0x1ed>
        p = le2page(le, page_link);
  102f0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f0e:	83 e8 0c             	sub    $0xc,%eax
  102f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f17:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102f1a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102f1d:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);	
  102f20:	89 45 dc             	mov    %eax,-0x24(%ebp)
	//找到base前面可以合并的块
        if (p + p->property == base) {
  102f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f26:	8b 50 08             	mov    0x8(%eax),%edx
  102f29:	89 d0                	mov    %edx,%eax
  102f2b:	c1 e0 02             	shl    $0x2,%eax
  102f2e:	01 d0                	add    %edx,%eax
  102f30:	c1 e0 02             	shl    $0x2,%eax
  102f33:	89 c2                	mov    %eax,%edx
  102f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f38:	01 d0                	add    %edx,%eax
  102f3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  102f3d:	75 0f                	jne    102f4e <default_free_pages+0x195>
            before = p;
  102f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f42:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    hasBefore = 1;
  102f45:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102f4c:	eb 2b                	jmp    102f79 <default_free_pages+0x1c0>
        }
	//找到base后面可以合并的块
        else if (base + base->property == p) {
  102f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f51:	8b 50 08             	mov    0x8(%eax),%edx
  102f54:	89 d0                	mov    %edx,%eax
  102f56:	c1 e0 02             	shl    $0x2,%eax
  102f59:	01 d0                	add    %edx,%eax
  102f5b:	c1 e0 02             	shl    $0x2,%eax
  102f5e:	89 c2                	mov    %eax,%edx
  102f60:	8b 45 08             	mov    0x8(%ebp),%eax
  102f63:	01 d0                	add    %edx,%eax
  102f65:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f68:	75 0f                	jne    102f79 <default_free_pages+0x1c0>
            behind = p;
  102f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    hasBehind = 1;
  102f70:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	    break;//后面的找到就没比较继续遍历了
  102f77:	eb 3a                	jmp    102fb3 <default_free_pages+0x1fa>
        }
	//超过了base及其块的范围仍未找到可以合并的
	if(p > base && p != base + base->property) {
  102f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  102f7f:	76 25                	jbe    102fa6 <default_free_pages+0x1ed>
  102f81:	8b 45 08             	mov    0x8(%ebp),%eax
  102f84:	8b 50 08             	mov    0x8(%eax),%edx
  102f87:	89 d0                	mov    %edx,%eax
  102f89:	c1 e0 02             	shl    $0x2,%eax
  102f8c:	01 d0                	add    %edx,%eax
  102f8e:	c1 e0 02             	shl    $0x2,%eax
  102f91:	89 c2                	mov    %eax,%edx
  102f93:	8b 45 08             	mov    0x8(%ebp),%eax
  102f96:	01 d0                	add    %edx,%eax
  102f98:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f9b:	74 09                	je     102fa6 <default_free_pages+0x1ed>
	    bigSmall = 1; //p在base的后面
  102f9d:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	    break;//此时没有必要继续遍历了
  102fa4:	eb 0d                	jmp    102fb3 <default_free_pages+0x1fa>
    struct Page *before = NULL;//记录前面可以合并的
    bool hasBehind = 0;//是否有后面可以合并的
    bool hasBefore = 0;//是否有前面可以合并的
    bool bigSmall = 0;//base地址附近没有可以合并的块，记录base块应该插入p的前还是后？
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  102fa6:	81 7d dc 10 af 11 00 	cmpl   $0x11af10,-0x24(%ebp)
  102fad:	0f 85 58 ff ff ff    	jne    102f0b <default_free_pages+0x152>
	    bigSmall = 1; //p在base的后面
	    break;//此时没有必要继续遍历了
        }
    }
    
    nr_free = nr_free + n;
  102fb3:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  102fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fbc:	01 d0                	add    %edx,%eax
  102fbe:	a3 18 af 11 00       	mov    %eax,0x11af18
    
    //没有可以合并的，直接将base加入链表即可
    if(!hasBefore && !hasBehind && bigSmall) {
  102fc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102fc7:	75 58                	jne    103021 <default_free_pages+0x268>
  102fc9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102fcd:	75 52                	jne    103021 <default_free_pages+0x268>
  102fcf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  102fd3:	74 4c                	je     103021 <default_free_pages+0x268>
	list_add_before(&(p->page_link), &(base->page_link));//base在p前的情况
  102fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd8:	83 c0 0c             	add    $0xc,%eax
  102fdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fde:	83 c2 0c             	add    $0xc,%edx
  102fe1:	89 55 b0             	mov    %edx,-0x50(%ebp)
  102fe4:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102fe7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102fea:	8b 00                	mov    (%eax),%eax
  102fec:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102fef:	89 55 a8             	mov    %edx,-0x58(%ebp)
  102ff2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102ff5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102ff8:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ffb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102ffe:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103001:	89 10                	mov    %edx,(%eax)
  103003:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103006:	8b 10                	mov    (%eax),%edx
  103008:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10300b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10300e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103011:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103014:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103017:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10301a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10301d:	89 10                	mov    %edx,(%eax)
  10301f:	eb 5a                	jmp    10307b <default_free_pages+0x2c2>
    } else if(!hasBefore && !hasBehind && !bigSmall) {
  103021:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103025:	75 54                	jne    10307b <default_free_pages+0x2c2>
  103027:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10302b:	75 4e                	jne    10307b <default_free_pages+0x2c2>
  10302d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103031:	75 48                	jne    10307b <default_free_pages+0x2c2>
	list_add_before(&free_list, &(base->page_link));
  103033:	8b 45 08             	mov    0x8(%ebp),%eax
  103036:	83 c0 0c             	add    $0xc,%eax
  103039:	c7 45 9c 10 af 11 00 	movl   $0x11af10,-0x64(%ebp)
  103040:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  103043:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103046:	8b 00                	mov    (%eax),%eax
  103048:	8b 55 98             	mov    -0x68(%ebp),%edx
  10304b:	89 55 94             	mov    %edx,-0x6c(%ebp)
  10304e:	89 45 90             	mov    %eax,-0x70(%ebp)
  103051:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103054:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  103057:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10305a:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10305d:	89 10                	mov    %edx,(%eax)
  10305f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103062:	8b 10                	mov    (%eax),%edx
  103064:	8b 45 90             	mov    -0x70(%ebp),%eax
  103067:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10306a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10306d:	8b 55 8c             	mov    -0x74(%ebp),%edx
  103070:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103073:	8b 45 94             	mov    -0x6c(%ebp),%eax
  103076:	8b 55 90             	mov    -0x70(%ebp),%edx
  103079:	89 10                	mov    %edx,(%eax)
    }
    
    //合并操作
    //先合并前面的块
    if(hasBefore) {
  10307b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10307f:	74 33                	je     1030b4 <default_free_pages+0x2fb>
    	before->property = before->property + base->property;
  103081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103084:	8b 50 08             	mov    0x8(%eax),%edx
  103087:	8b 45 08             	mov    0x8(%ebp),%eax
  10308a:	8b 40 08             	mov    0x8(%eax),%eax
  10308d:	01 c2                	add    %eax,%edx
  10308f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103092:	89 50 08             	mov    %edx,0x8(%eax)
	ClearPageProperty(base);
  103095:	8b 45 08             	mov    0x8(%ebp),%eax
  103098:	83 c0 04             	add    $0x4,%eax
  10309b:	c7 45 88 01 00 00 00 	movl   $0x1,-0x78(%ebp)
  1030a2:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1030a5:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1030a8:	8b 55 88             	mov    -0x78(%ebp),%edx
  1030ab:	0f b3 10             	btr    %edx,(%eax)
	base = before; //此时base是合并后的块
  1030ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030b1:	89 45 08             	mov    %eax,0x8(%ebp)
    }
    //继续合并后面的块
    if(hasBehind) {
  1030b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1030b8:	0f 84 f9 00 00 00    	je     1031b7 <default_free_pages+0x3fe>
    	base->property = base->property + behind->property;
  1030be:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c1:	8b 50 08             	mov    0x8(%eax),%edx
  1030c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030c7:	8b 40 08             	mov    0x8(%eax),%eax
  1030ca:	01 c2                	add    %eax,%edx
  1030cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1030cf:	89 50 08             	mov    %edx,0x8(%eax)
	ClearPageProperty(behind);
  1030d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030d5:	83 c0 04             	add    $0x4,%eax
  1030d8:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%ebp)
  1030df:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  1030e5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  1030eb:	8b 55 80             	mov    -0x80(%ebp),%edx
  1030ee:	0f b3 10             	btr    %edx,(%eax)
	if(!hasBefore) {
  1030f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1030f5:	75 7a                	jne    103171 <default_free_pages+0x3b8>
	   list_add_before(&(behind->page_link), &(base->page_link));
  1030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1030fa:	83 c0 0c             	add    $0xc,%eax
  1030fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103100:	83 c2 0c             	add    $0xc,%edx
  103103:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
  103109:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  10310f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  103115:	8b 00                	mov    (%eax),%eax
  103117:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  10311d:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
  103123:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  103129:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  10312f:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  103135:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  10313b:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  103141:	89 10                	mov    %edx,(%eax)
  103143:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  103149:	8b 10                	mov    (%eax),%edx
  10314b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  103151:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103154:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  10315a:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
  103160:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103163:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  103169:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  10316f:	89 10                	mov    %edx,(%eax)
	}
	list_del(&(behind->page_link));
  103171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103174:	83 c0 0c             	add    $0xc,%eax
  103177:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  10317d:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  103183:	8b 40 04             	mov    0x4(%eax),%eax
  103186:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  10318c:	8b 12                	mov    (%edx),%edx
  10318e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  103194:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  10319a:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  1031a0:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  1031a6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1031a9:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  1031af:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  1031b5:	89 10                	mov    %edx,(%eax)
    }
    
    //list_add(&free_list, &(base->page_link));
}
  1031b7:	c9                   	leave  
  1031b8:	c3                   	ret    

001031b9 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  1031b9:	55                   	push   %ebp
  1031ba:	89 e5                	mov    %esp,%ebp
    return nr_free;
  1031bc:	a1 18 af 11 00       	mov    0x11af18,%eax
}
  1031c1:	5d                   	pop    %ebp
  1031c2:	c3                   	ret    

001031c3 <basic_check>:

static void
basic_check(void) {
  1031c3:	55                   	push   %ebp
  1031c4:	89 e5                	mov    %esp,%ebp
  1031c6:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  1031c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1031d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1031dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031e3:	e8 9d 0e 00 00       	call   104085 <alloc_pages>
  1031e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1031ef:	75 24                	jne    103215 <basic_check+0x52>
  1031f1:	c7 44 24 0c 39 6a 10 	movl   $0x106a39,0xc(%esp)
  1031f8:	00 
  1031f9:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103200:	00 
  103201:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  103208:	00 
  103209:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103210:	e8 c1 da ff ff       	call   100cd6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103215:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10321c:	e8 64 0e 00 00       	call   104085 <alloc_pages>
  103221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103224:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103228:	75 24                	jne    10324e <basic_check+0x8b>
  10322a:	c7 44 24 0c 55 6a 10 	movl   $0x106a55,0xc(%esp)
  103231:	00 
  103232:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103239:	00 
  10323a:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  103241:	00 
  103242:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103249:	e8 88 da ff ff       	call   100cd6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  10324e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103255:	e8 2b 0e 00 00       	call   104085 <alloc_pages>
  10325a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10325d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103261:	75 24                	jne    103287 <basic_check+0xc4>
  103263:	c7 44 24 0c 71 6a 10 	movl   $0x106a71,0xc(%esp)
  10326a:	00 
  10326b:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103272:	00 
  103273:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  10327a:	00 
  10327b:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103282:	e8 4f da ff ff       	call   100cd6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  103287:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10328a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10328d:	74 10                	je     10329f <basic_check+0xdc>
  10328f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103292:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103295:	74 08                	je     10329f <basic_check+0xdc>
  103297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10329a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10329d:	75 24                	jne    1032c3 <basic_check+0x100>
  10329f:	c7 44 24 0c 90 6a 10 	movl   $0x106a90,0xc(%esp)
  1032a6:	00 
  1032a7:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  1032ae:	00 
  1032af:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1032b6:	00 
  1032b7:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  1032be:	e8 13 da ff ff       	call   100cd6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  1032c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032c6:	89 04 24             	mov    %eax,(%esp)
  1032c9:	e8 71 f7 ff ff       	call   102a3f <page_ref>
  1032ce:	85 c0                	test   %eax,%eax
  1032d0:	75 1e                	jne    1032f0 <basic_check+0x12d>
  1032d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032d5:	89 04 24             	mov    %eax,(%esp)
  1032d8:	e8 62 f7 ff ff       	call   102a3f <page_ref>
  1032dd:	85 c0                	test   %eax,%eax
  1032df:	75 0f                	jne    1032f0 <basic_check+0x12d>
  1032e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032e4:	89 04 24             	mov    %eax,(%esp)
  1032e7:	e8 53 f7 ff ff       	call   102a3f <page_ref>
  1032ec:	85 c0                	test   %eax,%eax
  1032ee:	74 24                	je     103314 <basic_check+0x151>
  1032f0:	c7 44 24 0c b4 6a 10 	movl   $0x106ab4,0xc(%esp)
  1032f7:	00 
  1032f8:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  1032ff:	00 
  103300:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103307:	00 
  103308:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  10330f:	e8 c2 d9 ff ff       	call   100cd6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  103314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103317:	89 04 24             	mov    %eax,(%esp)
  10331a:	e8 0a f7 ff ff       	call   102a29 <page2pa>
  10331f:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  103325:	c1 e2 0c             	shl    $0xc,%edx
  103328:	39 d0                	cmp    %edx,%eax
  10332a:	72 24                	jb     103350 <basic_check+0x18d>
  10332c:	c7 44 24 0c f0 6a 10 	movl   $0x106af0,0xc(%esp)
  103333:	00 
  103334:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  10333b:	00 
  10333c:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  103343:	00 
  103344:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  10334b:	e8 86 d9 ff ff       	call   100cd6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  103350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103353:	89 04 24             	mov    %eax,(%esp)
  103356:	e8 ce f6 ff ff       	call   102a29 <page2pa>
  10335b:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  103361:	c1 e2 0c             	shl    $0xc,%edx
  103364:	39 d0                	cmp    %edx,%eax
  103366:	72 24                	jb     10338c <basic_check+0x1c9>
  103368:	c7 44 24 0c 0d 6b 10 	movl   $0x106b0d,0xc(%esp)
  10336f:	00 
  103370:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103377:	00 
  103378:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  10337f:	00 
  103380:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103387:	e8 4a d9 ff ff       	call   100cd6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10338f:	89 04 24             	mov    %eax,(%esp)
  103392:	e8 92 f6 ff ff       	call   102a29 <page2pa>
  103397:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  10339d:	c1 e2 0c             	shl    $0xc,%edx
  1033a0:	39 d0                	cmp    %edx,%eax
  1033a2:	72 24                	jb     1033c8 <basic_check+0x205>
  1033a4:	c7 44 24 0c 2a 6b 10 	movl   $0x106b2a,0xc(%esp)
  1033ab:	00 
  1033ac:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  1033b3:	00 
  1033b4:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  1033bb:	00 
  1033bc:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  1033c3:	e8 0e d9 ff ff       	call   100cd6 <__panic>

    list_entry_t free_list_store = free_list;
  1033c8:	a1 10 af 11 00       	mov    0x11af10,%eax
  1033cd:	8b 15 14 af 11 00    	mov    0x11af14,%edx
  1033d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1033d6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1033d9:	c7 45 e0 10 af 11 00 	movl   $0x11af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1033e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1033e6:	89 50 04             	mov    %edx,0x4(%eax)
  1033e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033ec:	8b 50 04             	mov    0x4(%eax),%edx
  1033ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033f2:	89 10                	mov    %edx,(%eax)
  1033f4:	c7 45 dc 10 af 11 00 	movl   $0x11af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1033fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1033fe:	8b 40 04             	mov    0x4(%eax),%eax
  103401:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103404:	0f 94 c0             	sete   %al
  103407:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10340a:	85 c0                	test   %eax,%eax
  10340c:	75 24                	jne    103432 <basic_check+0x26f>
  10340e:	c7 44 24 0c 47 6b 10 	movl   $0x106b47,0xc(%esp)
  103415:	00 
  103416:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  10341d:	00 
  10341e:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  103425:	00 
  103426:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  10342d:	e8 a4 d8 ff ff       	call   100cd6 <__panic>

    unsigned int nr_free_store = nr_free;
  103432:	a1 18 af 11 00       	mov    0x11af18,%eax
  103437:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10343a:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  103441:	00 00 00 

    assert(alloc_page() == NULL);
  103444:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10344b:	e8 35 0c 00 00       	call   104085 <alloc_pages>
  103450:	85 c0                	test   %eax,%eax
  103452:	74 24                	je     103478 <basic_check+0x2b5>
  103454:	c7 44 24 0c 5e 6b 10 	movl   $0x106b5e,0xc(%esp)
  10345b:	00 
  10345c:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103463:	00 
  103464:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  10346b:	00 
  10346c:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103473:	e8 5e d8 ff ff       	call   100cd6 <__panic>

    free_page(p0);
  103478:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10347f:	00 
  103480:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103483:	89 04 24             	mov    %eax,(%esp)
  103486:	e8 32 0c 00 00       	call   1040bd <free_pages>
    free_page(p1);
  10348b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103492:	00 
  103493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103496:	89 04 24             	mov    %eax,(%esp)
  103499:	e8 1f 0c 00 00       	call   1040bd <free_pages>
    free_page(p2);
  10349e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1034a5:	00 
  1034a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034a9:	89 04 24             	mov    %eax,(%esp)
  1034ac:	e8 0c 0c 00 00       	call   1040bd <free_pages>
    assert(nr_free == 3);
  1034b1:	a1 18 af 11 00       	mov    0x11af18,%eax
  1034b6:	83 f8 03             	cmp    $0x3,%eax
  1034b9:	74 24                	je     1034df <basic_check+0x31c>
  1034bb:	c7 44 24 0c 73 6b 10 	movl   $0x106b73,0xc(%esp)
  1034c2:	00 
  1034c3:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  1034ca:	00 
  1034cb:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  1034d2:	00 
  1034d3:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  1034da:	e8 f7 d7 ff ff       	call   100cd6 <__panic>

    assert((p0 = alloc_page()) != NULL);
  1034df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034e6:	e8 9a 0b 00 00       	call   104085 <alloc_pages>
  1034eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1034f2:	75 24                	jne    103518 <basic_check+0x355>
  1034f4:	c7 44 24 0c 39 6a 10 	movl   $0x106a39,0xc(%esp)
  1034fb:	00 
  1034fc:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103503:	00 
  103504:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  10350b:	00 
  10350c:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103513:	e8 be d7 ff ff       	call   100cd6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103518:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10351f:	e8 61 0b 00 00       	call   104085 <alloc_pages>
  103524:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103527:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10352b:	75 24                	jne    103551 <basic_check+0x38e>
  10352d:	c7 44 24 0c 55 6a 10 	movl   $0x106a55,0xc(%esp)
  103534:	00 
  103535:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  10353c:	00 
  10353d:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  103544:	00 
  103545:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  10354c:	e8 85 d7 ff ff       	call   100cd6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103551:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103558:	e8 28 0b 00 00       	call   104085 <alloc_pages>
  10355d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103564:	75 24                	jne    10358a <basic_check+0x3c7>
  103566:	c7 44 24 0c 71 6a 10 	movl   $0x106a71,0xc(%esp)
  10356d:	00 
  10356e:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103575:	00 
  103576:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  10357d:	00 
  10357e:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103585:	e8 4c d7 ff ff       	call   100cd6 <__panic>

    assert(alloc_page() == NULL);
  10358a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103591:	e8 ef 0a 00 00       	call   104085 <alloc_pages>
  103596:	85 c0                	test   %eax,%eax
  103598:	74 24                	je     1035be <basic_check+0x3fb>
  10359a:	c7 44 24 0c 5e 6b 10 	movl   $0x106b5e,0xc(%esp)
  1035a1:	00 
  1035a2:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  1035a9:	00 
  1035aa:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1035b1:	00 
  1035b2:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  1035b9:	e8 18 d7 ff ff       	call   100cd6 <__panic>

    free_page(p0);
  1035be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035c5:	00 
  1035c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035c9:	89 04 24             	mov    %eax,(%esp)
  1035cc:	e8 ec 0a 00 00       	call   1040bd <free_pages>
  1035d1:	c7 45 d8 10 af 11 00 	movl   $0x11af10,-0x28(%ebp)
  1035d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1035db:	8b 40 04             	mov    0x4(%eax),%eax
  1035de:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1035e1:	0f 94 c0             	sete   %al
  1035e4:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1035e7:	85 c0                	test   %eax,%eax
  1035e9:	74 24                	je     10360f <basic_check+0x44c>
  1035eb:	c7 44 24 0c 80 6b 10 	movl   $0x106b80,0xc(%esp)
  1035f2:	00 
  1035f3:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  1035fa:	00 
  1035fb:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  103602:	00 
  103603:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  10360a:	e8 c7 d6 ff ff       	call   100cd6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10360f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103616:	e8 6a 0a 00 00       	call   104085 <alloc_pages>
  10361b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10361e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103621:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103624:	74 24                	je     10364a <basic_check+0x487>
  103626:	c7 44 24 0c 98 6b 10 	movl   $0x106b98,0xc(%esp)
  10362d:	00 
  10362e:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103635:	00 
  103636:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  10363d:	00 
  10363e:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103645:	e8 8c d6 ff ff       	call   100cd6 <__panic>
    assert(alloc_page() == NULL);
  10364a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103651:	e8 2f 0a 00 00       	call   104085 <alloc_pages>
  103656:	85 c0                	test   %eax,%eax
  103658:	74 24                	je     10367e <basic_check+0x4bb>
  10365a:	c7 44 24 0c 5e 6b 10 	movl   $0x106b5e,0xc(%esp)
  103661:	00 
  103662:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103669:	00 
  10366a:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  103671:	00 
  103672:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103679:	e8 58 d6 ff ff       	call   100cd6 <__panic>

    assert(nr_free == 0);
  10367e:	a1 18 af 11 00       	mov    0x11af18,%eax
  103683:	85 c0                	test   %eax,%eax
  103685:	74 24                	je     1036ab <basic_check+0x4e8>
  103687:	c7 44 24 0c b1 6b 10 	movl   $0x106bb1,0xc(%esp)
  10368e:	00 
  10368f:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103696:	00 
  103697:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  10369e:	00 
  10369f:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  1036a6:	e8 2b d6 ff ff       	call   100cd6 <__panic>
    free_list = free_list_store;
  1036ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1036ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1036b1:	a3 10 af 11 00       	mov    %eax,0x11af10
  1036b6:	89 15 14 af 11 00    	mov    %edx,0x11af14
    nr_free = nr_free_store;
  1036bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036bf:	a3 18 af 11 00       	mov    %eax,0x11af18

    free_page(p);
  1036c4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036cb:	00 
  1036cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036cf:	89 04 24             	mov    %eax,(%esp)
  1036d2:	e8 e6 09 00 00       	call   1040bd <free_pages>
    free_page(p1);
  1036d7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036de:	00 
  1036df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036e2:	89 04 24             	mov    %eax,(%esp)
  1036e5:	e8 d3 09 00 00       	call   1040bd <free_pages>
    free_page(p2);
  1036ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036f1:	00 
  1036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036f5:	89 04 24             	mov    %eax,(%esp)
  1036f8:	e8 c0 09 00 00       	call   1040bd <free_pages>
}
  1036fd:	c9                   	leave  
  1036fe:	c3                   	ret    

001036ff <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1036ff:	55                   	push   %ebp
  103700:	89 e5                	mov    %esp,%ebp
  103702:	53                   	push   %ebx
  103703:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103709:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103710:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103717:	c7 45 ec 10 af 11 00 	movl   $0x11af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10371e:	eb 6b                	jmp    10378b <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103720:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103723:	83 e8 0c             	sub    $0xc,%eax
  103726:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103729:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10372c:	83 c0 04             	add    $0x4,%eax
  10372f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103736:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103739:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10373c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10373f:	0f a3 10             	bt     %edx,(%eax)
  103742:	19 c0                	sbb    %eax,%eax
  103744:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103747:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10374b:	0f 95 c0             	setne  %al
  10374e:	0f b6 c0             	movzbl %al,%eax
  103751:	85 c0                	test   %eax,%eax
  103753:	75 24                	jne    103779 <default_check+0x7a>
  103755:	c7 44 24 0c be 6b 10 	movl   $0x106bbe,0xc(%esp)
  10375c:	00 
  10375d:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103764:	00 
  103765:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  10376c:	00 
  10376d:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103774:	e8 5d d5 ff ff       	call   100cd6 <__panic>
        count ++, total += p->property;
  103779:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10377d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103780:	8b 50 08             	mov    0x8(%eax),%edx
  103783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103786:	01 d0                	add    %edx,%eax
  103788:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10378b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10378e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103791:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103794:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103797:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10379a:	81 7d ec 10 af 11 00 	cmpl   $0x11af10,-0x14(%ebp)
  1037a1:	0f 85 79 ff ff ff    	jne    103720 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1037a7:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1037aa:	e8 40 09 00 00       	call   1040ef <nr_free_pages>
  1037af:	39 c3                	cmp    %eax,%ebx
  1037b1:	74 24                	je     1037d7 <default_check+0xd8>
  1037b3:	c7 44 24 0c ce 6b 10 	movl   $0x106bce,0xc(%esp)
  1037ba:	00 
  1037bb:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  1037c2:	00 
  1037c3:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  1037ca:	00 
  1037cb:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  1037d2:	e8 ff d4 ff ff       	call   100cd6 <__panic>

    basic_check();
  1037d7:	e8 e7 f9 ff ff       	call   1031c3 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1037dc:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1037e3:	e8 9d 08 00 00       	call   104085 <alloc_pages>
  1037e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1037eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1037ef:	75 24                	jne    103815 <default_check+0x116>
  1037f1:	c7 44 24 0c e7 6b 10 	movl   $0x106be7,0xc(%esp)
  1037f8:	00 
  1037f9:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103800:	00 
  103801:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  103808:	00 
  103809:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103810:	e8 c1 d4 ff ff       	call   100cd6 <__panic>
    assert(!PageProperty(p0));
  103815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103818:	83 c0 04             	add    $0x4,%eax
  10381b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103822:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103825:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103828:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10382b:	0f a3 10             	bt     %edx,(%eax)
  10382e:	19 c0                	sbb    %eax,%eax
  103830:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103833:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103837:	0f 95 c0             	setne  %al
  10383a:	0f b6 c0             	movzbl %al,%eax
  10383d:	85 c0                	test   %eax,%eax
  10383f:	74 24                	je     103865 <default_check+0x166>
  103841:	c7 44 24 0c f2 6b 10 	movl   $0x106bf2,0xc(%esp)
  103848:	00 
  103849:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103850:	00 
  103851:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  103858:	00 
  103859:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103860:	e8 71 d4 ff ff       	call   100cd6 <__panic>

    list_entry_t free_list_store = free_list;
  103865:	a1 10 af 11 00       	mov    0x11af10,%eax
  10386a:	8b 15 14 af 11 00    	mov    0x11af14,%edx
  103870:	89 45 80             	mov    %eax,-0x80(%ebp)
  103873:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103876:	c7 45 b4 10 af 11 00 	movl   $0x11af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10387d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103880:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103883:	89 50 04             	mov    %edx,0x4(%eax)
  103886:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103889:	8b 50 04             	mov    0x4(%eax),%edx
  10388c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10388f:	89 10                	mov    %edx,(%eax)
  103891:	c7 45 b0 10 af 11 00 	movl   $0x11af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103898:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10389b:	8b 40 04             	mov    0x4(%eax),%eax
  10389e:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1038a1:	0f 94 c0             	sete   %al
  1038a4:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1038a7:	85 c0                	test   %eax,%eax
  1038a9:	75 24                	jne    1038cf <default_check+0x1d0>
  1038ab:	c7 44 24 0c 47 6b 10 	movl   $0x106b47,0xc(%esp)
  1038b2:	00 
  1038b3:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  1038ba:	00 
  1038bb:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  1038c2:	00 
  1038c3:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  1038ca:	e8 07 d4 ff ff       	call   100cd6 <__panic>
    assert(alloc_page() == NULL);
  1038cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038d6:	e8 aa 07 00 00       	call   104085 <alloc_pages>
  1038db:	85 c0                	test   %eax,%eax
  1038dd:	74 24                	je     103903 <default_check+0x204>
  1038df:	c7 44 24 0c 5e 6b 10 	movl   $0x106b5e,0xc(%esp)
  1038e6:	00 
  1038e7:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  1038ee:	00 
  1038ef:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
  1038f6:	00 
  1038f7:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  1038fe:	e8 d3 d3 ff ff       	call   100cd6 <__panic>

    unsigned int nr_free_store = nr_free;
  103903:	a1 18 af 11 00       	mov    0x11af18,%eax
  103908:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10390b:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  103912:	00 00 00 

    free_pages(p0 + 2, 3);
  103915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103918:	83 c0 28             	add    $0x28,%eax
  10391b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103922:	00 
  103923:	89 04 24             	mov    %eax,(%esp)
  103926:	e8 92 07 00 00       	call   1040bd <free_pages>
    assert(alloc_pages(4) == NULL);
  10392b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103932:	e8 4e 07 00 00       	call   104085 <alloc_pages>
  103937:	85 c0                	test   %eax,%eax
  103939:	74 24                	je     10395f <default_check+0x260>
  10393b:	c7 44 24 0c 04 6c 10 	movl   $0x106c04,0xc(%esp)
  103942:	00 
  103943:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  10394a:	00 
  10394b:	c7 44 24 04 44 01 00 	movl   $0x144,0x4(%esp)
  103952:	00 
  103953:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  10395a:	e8 77 d3 ff ff       	call   100cd6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10395f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103962:	83 c0 28             	add    $0x28,%eax
  103965:	83 c0 04             	add    $0x4,%eax
  103968:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  10396f:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103972:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103975:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103978:	0f a3 10             	bt     %edx,(%eax)
  10397b:	19 c0                	sbb    %eax,%eax
  10397d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103980:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103984:	0f 95 c0             	setne  %al
  103987:	0f b6 c0             	movzbl %al,%eax
  10398a:	85 c0                	test   %eax,%eax
  10398c:	74 0e                	je     10399c <default_check+0x29d>
  10398e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103991:	83 c0 28             	add    $0x28,%eax
  103994:	8b 40 08             	mov    0x8(%eax),%eax
  103997:	83 f8 03             	cmp    $0x3,%eax
  10399a:	74 24                	je     1039c0 <default_check+0x2c1>
  10399c:	c7 44 24 0c 1c 6c 10 	movl   $0x106c1c,0xc(%esp)
  1039a3:	00 
  1039a4:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  1039ab:	00 
  1039ac:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  1039b3:	00 
  1039b4:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  1039bb:	e8 16 d3 ff ff       	call   100cd6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1039c0:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1039c7:	e8 b9 06 00 00       	call   104085 <alloc_pages>
  1039cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1039cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1039d3:	75 24                	jne    1039f9 <default_check+0x2fa>
  1039d5:	c7 44 24 0c 48 6c 10 	movl   $0x106c48,0xc(%esp)
  1039dc:	00 
  1039dd:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  1039e4:	00 
  1039e5:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
  1039ec:	00 
  1039ed:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  1039f4:	e8 dd d2 ff ff       	call   100cd6 <__panic>
    assert(alloc_page() == NULL);
  1039f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103a00:	e8 80 06 00 00       	call   104085 <alloc_pages>
  103a05:	85 c0                	test   %eax,%eax
  103a07:	74 24                	je     103a2d <default_check+0x32e>
  103a09:	c7 44 24 0c 5e 6b 10 	movl   $0x106b5e,0xc(%esp)
  103a10:	00 
  103a11:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103a18:	00 
  103a19:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  103a20:	00 
  103a21:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103a28:	e8 a9 d2 ff ff       	call   100cd6 <__panic>
    assert(p0 + 2 == p1);
  103a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a30:	83 c0 28             	add    $0x28,%eax
  103a33:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103a36:	74 24                	je     103a5c <default_check+0x35d>
  103a38:	c7 44 24 0c 66 6c 10 	movl   $0x106c66,0xc(%esp)
  103a3f:	00 
  103a40:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103a47:	00 
  103a48:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
  103a4f:	00 
  103a50:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103a57:	e8 7a d2 ff ff       	call   100cd6 <__panic>

    p2 = p0 + 1;
  103a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a5f:	83 c0 14             	add    $0x14,%eax
  103a62:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103a65:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a6c:	00 
  103a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a70:	89 04 24             	mov    %eax,(%esp)
  103a73:	e8 45 06 00 00       	call   1040bd <free_pages>
    free_pages(p1, 3);
  103a78:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103a7f:	00 
  103a80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a83:	89 04 24             	mov    %eax,(%esp)
  103a86:	e8 32 06 00 00       	call   1040bd <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103a8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a8e:	83 c0 04             	add    $0x4,%eax
  103a91:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103a98:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103a9b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103a9e:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103aa1:	0f a3 10             	bt     %edx,(%eax)
  103aa4:	19 c0                	sbb    %eax,%eax
  103aa6:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103aa9:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103aad:	0f 95 c0             	setne  %al
  103ab0:	0f b6 c0             	movzbl %al,%eax
  103ab3:	85 c0                	test   %eax,%eax
  103ab5:	74 0b                	je     103ac2 <default_check+0x3c3>
  103ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103aba:	8b 40 08             	mov    0x8(%eax),%eax
  103abd:	83 f8 01             	cmp    $0x1,%eax
  103ac0:	74 24                	je     103ae6 <default_check+0x3e7>
  103ac2:	c7 44 24 0c 74 6c 10 	movl   $0x106c74,0xc(%esp)
  103ac9:	00 
  103aca:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103ad1:	00 
  103ad2:	c7 44 24 04 4d 01 00 	movl   $0x14d,0x4(%esp)
  103ad9:	00 
  103ada:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103ae1:	e8 f0 d1 ff ff       	call   100cd6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103ae6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ae9:	83 c0 04             	add    $0x4,%eax
  103aec:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103af3:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103af6:	8b 45 90             	mov    -0x70(%ebp),%eax
  103af9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103afc:	0f a3 10             	bt     %edx,(%eax)
  103aff:	19 c0                	sbb    %eax,%eax
  103b01:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103b04:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103b08:	0f 95 c0             	setne  %al
  103b0b:	0f b6 c0             	movzbl %al,%eax
  103b0e:	85 c0                	test   %eax,%eax
  103b10:	74 0b                	je     103b1d <default_check+0x41e>
  103b12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103b15:	8b 40 08             	mov    0x8(%eax),%eax
  103b18:	83 f8 03             	cmp    $0x3,%eax
  103b1b:	74 24                	je     103b41 <default_check+0x442>
  103b1d:	c7 44 24 0c 9c 6c 10 	movl   $0x106c9c,0xc(%esp)
  103b24:	00 
  103b25:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103b2c:	00 
  103b2d:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
  103b34:	00 
  103b35:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103b3c:	e8 95 d1 ff ff       	call   100cd6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103b41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103b48:	e8 38 05 00 00       	call   104085 <alloc_pages>
  103b4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103b50:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103b53:	83 e8 14             	sub    $0x14,%eax
  103b56:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103b59:	74 24                	je     103b7f <default_check+0x480>
  103b5b:	c7 44 24 0c c2 6c 10 	movl   $0x106cc2,0xc(%esp)
  103b62:	00 
  103b63:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103b6a:	00 
  103b6b:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
  103b72:	00 
  103b73:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103b7a:	e8 57 d1 ff ff       	call   100cd6 <__panic>
    free_page(p0);
  103b7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103b86:	00 
  103b87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b8a:	89 04 24             	mov    %eax,(%esp)
  103b8d:	e8 2b 05 00 00       	call   1040bd <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103b92:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103b99:	e8 e7 04 00 00       	call   104085 <alloc_pages>
  103b9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ba1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103ba4:	83 c0 14             	add    $0x14,%eax
  103ba7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103baa:	74 24                	je     103bd0 <default_check+0x4d1>
  103bac:	c7 44 24 0c e0 6c 10 	movl   $0x106ce0,0xc(%esp)
  103bb3:	00 
  103bb4:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103bbb:	00 
  103bbc:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  103bc3:	00 
  103bc4:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103bcb:	e8 06 d1 ff ff       	call   100cd6 <__panic>

    free_pages(p0, 2);
  103bd0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103bd7:	00 
  103bd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103bdb:	89 04 24             	mov    %eax,(%esp)
  103bde:	e8 da 04 00 00       	call   1040bd <free_pages>
    free_page(p2);
  103be3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103bea:	00 
  103beb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103bee:	89 04 24             	mov    %eax,(%esp)
  103bf1:	e8 c7 04 00 00       	call   1040bd <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103bf6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103bfd:	e8 83 04 00 00       	call   104085 <alloc_pages>
  103c02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103c05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103c09:	75 24                	jne    103c2f <default_check+0x530>
  103c0b:	c7 44 24 0c 00 6d 10 	movl   $0x106d00,0xc(%esp)
  103c12:	00 
  103c13:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103c1a:	00 
  103c1b:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
  103c22:	00 
  103c23:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103c2a:	e8 a7 d0 ff ff       	call   100cd6 <__panic>
    assert(alloc_page() == NULL);
  103c2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103c36:	e8 4a 04 00 00       	call   104085 <alloc_pages>
  103c3b:	85 c0                	test   %eax,%eax
  103c3d:	74 24                	je     103c63 <default_check+0x564>
  103c3f:	c7 44 24 0c 5e 6b 10 	movl   $0x106b5e,0xc(%esp)
  103c46:	00 
  103c47:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103c4e:	00 
  103c4f:	c7 44 24 04 58 01 00 	movl   $0x158,0x4(%esp)
  103c56:	00 
  103c57:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103c5e:	e8 73 d0 ff ff       	call   100cd6 <__panic>

    assert(nr_free == 0);
  103c63:	a1 18 af 11 00       	mov    0x11af18,%eax
  103c68:	85 c0                	test   %eax,%eax
  103c6a:	74 24                	je     103c90 <default_check+0x591>
  103c6c:	c7 44 24 0c b1 6b 10 	movl   $0x106bb1,0xc(%esp)
  103c73:	00 
  103c74:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103c7b:	00 
  103c7c:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
  103c83:	00 
  103c84:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103c8b:	e8 46 d0 ff ff       	call   100cd6 <__panic>
    nr_free = nr_free_store;
  103c90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103c93:	a3 18 af 11 00       	mov    %eax,0x11af18

    free_list = free_list_store;
  103c98:	8b 45 80             	mov    -0x80(%ebp),%eax
  103c9b:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103c9e:	a3 10 af 11 00       	mov    %eax,0x11af10
  103ca3:	89 15 14 af 11 00    	mov    %edx,0x11af14
    free_pages(p0, 5);
  103ca9:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103cb0:	00 
  103cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103cb4:	89 04 24             	mov    %eax,(%esp)
  103cb7:	e8 01 04 00 00       	call   1040bd <free_pages>

    le = &free_list;
  103cbc:	c7 45 ec 10 af 11 00 	movl   $0x11af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103cc3:	eb 1d                	jmp    103ce2 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103cc8:	83 e8 0c             	sub    $0xc,%eax
  103ccb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103cce:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103cd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103cd5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103cd8:	8b 40 08             	mov    0x8(%eax),%eax
  103cdb:	29 c2                	sub    %eax,%edx
  103cdd:	89 d0                	mov    %edx,%eax
  103cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ce5:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103ce8:	8b 45 88             	mov    -0x78(%ebp),%eax
  103ceb:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103cee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103cf1:	81 7d ec 10 af 11 00 	cmpl   $0x11af10,-0x14(%ebp)
  103cf8:	75 cb                	jne    103cc5 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103cfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103cfe:	74 24                	je     103d24 <default_check+0x625>
  103d00:	c7 44 24 0c 1e 6d 10 	movl   $0x106d1e,0xc(%esp)
  103d07:	00 
  103d08:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103d0f:	00 
  103d10:	c7 44 24 04 65 01 00 	movl   $0x165,0x4(%esp)
  103d17:	00 
  103d18:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103d1f:	e8 b2 cf ff ff       	call   100cd6 <__panic>
    assert(total == 0);
  103d24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103d28:	74 24                	je     103d4e <default_check+0x64f>
  103d2a:	c7 44 24 0c 29 6d 10 	movl   $0x106d29,0xc(%esp)
  103d31:	00 
  103d32:	c7 44 24 08 d6 69 10 	movl   $0x1069d6,0x8(%esp)
  103d39:	00 
  103d3a:	c7 44 24 04 66 01 00 	movl   $0x166,0x4(%esp)
  103d41:	00 
  103d42:	c7 04 24 eb 69 10 00 	movl   $0x1069eb,(%esp)
  103d49:	e8 88 cf ff ff       	call   100cd6 <__panic>
}
  103d4e:	81 c4 94 00 00 00    	add    $0x94,%esp
  103d54:	5b                   	pop    %ebx
  103d55:	5d                   	pop    %ebp
  103d56:	c3                   	ret    

00103d57 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103d57:	55                   	push   %ebp
  103d58:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  103d5d:	a1 24 af 11 00       	mov    0x11af24,%eax
  103d62:	29 c2                	sub    %eax,%edx
  103d64:	89 d0                	mov    %edx,%eax
  103d66:	c1 f8 02             	sar    $0x2,%eax
  103d69:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103d6f:	5d                   	pop    %ebp
  103d70:	c3                   	ret    

00103d71 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103d71:	55                   	push   %ebp
  103d72:	89 e5                	mov    %esp,%ebp
  103d74:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103d77:	8b 45 08             	mov    0x8(%ebp),%eax
  103d7a:	89 04 24             	mov    %eax,(%esp)
  103d7d:	e8 d5 ff ff ff       	call   103d57 <page2ppn>
  103d82:	c1 e0 0c             	shl    $0xc,%eax
}
  103d85:	c9                   	leave  
  103d86:	c3                   	ret    

00103d87 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103d87:	55                   	push   %ebp
  103d88:	89 e5                	mov    %esp,%ebp
  103d8a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  103d90:	c1 e8 0c             	shr    $0xc,%eax
  103d93:	89 c2                	mov    %eax,%edx
  103d95:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103d9a:	39 c2                	cmp    %eax,%edx
  103d9c:	72 1c                	jb     103dba <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103d9e:	c7 44 24 08 64 6d 10 	movl   $0x106d64,0x8(%esp)
  103da5:	00 
  103da6:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103dad:	00 
  103dae:	c7 04 24 83 6d 10 00 	movl   $0x106d83,(%esp)
  103db5:	e8 1c cf ff ff       	call   100cd6 <__panic>
    }
    return &pages[PPN(pa)];
  103dba:	8b 0d 24 af 11 00    	mov    0x11af24,%ecx
  103dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  103dc3:	c1 e8 0c             	shr    $0xc,%eax
  103dc6:	89 c2                	mov    %eax,%edx
  103dc8:	89 d0                	mov    %edx,%eax
  103dca:	c1 e0 02             	shl    $0x2,%eax
  103dcd:	01 d0                	add    %edx,%eax
  103dcf:	c1 e0 02             	shl    $0x2,%eax
  103dd2:	01 c8                	add    %ecx,%eax
}
  103dd4:	c9                   	leave  
  103dd5:	c3                   	ret    

00103dd6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103dd6:	55                   	push   %ebp
  103dd7:	89 e5                	mov    %esp,%ebp
  103dd9:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  103ddf:	89 04 24             	mov    %eax,(%esp)
  103de2:	e8 8a ff ff ff       	call   103d71 <page2pa>
  103de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ded:	c1 e8 0c             	shr    $0xc,%eax
  103df0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103df3:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103df8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103dfb:	72 23                	jb     103e20 <page2kva+0x4a>
  103dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e00:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e04:	c7 44 24 08 94 6d 10 	movl   $0x106d94,0x8(%esp)
  103e0b:	00 
  103e0c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103e13:	00 
  103e14:	c7 04 24 83 6d 10 00 	movl   $0x106d83,(%esp)
  103e1b:	e8 b6 ce ff ff       	call   100cd6 <__panic>
  103e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e23:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103e28:	c9                   	leave  
  103e29:	c3                   	ret    

00103e2a <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103e2a:	55                   	push   %ebp
  103e2b:	89 e5                	mov    %esp,%ebp
  103e2d:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103e30:	8b 45 08             	mov    0x8(%ebp),%eax
  103e33:	83 e0 01             	and    $0x1,%eax
  103e36:	85 c0                	test   %eax,%eax
  103e38:	75 1c                	jne    103e56 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103e3a:	c7 44 24 08 b8 6d 10 	movl   $0x106db8,0x8(%esp)
  103e41:	00 
  103e42:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103e49:	00 
  103e4a:	c7 04 24 83 6d 10 00 	movl   $0x106d83,(%esp)
  103e51:	e8 80 ce ff ff       	call   100cd6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103e56:	8b 45 08             	mov    0x8(%ebp),%eax
  103e59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e5e:	89 04 24             	mov    %eax,(%esp)
  103e61:	e8 21 ff ff ff       	call   103d87 <pa2page>
}
  103e66:	c9                   	leave  
  103e67:	c3                   	ret    

00103e68 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103e68:	55                   	push   %ebp
  103e69:	89 e5                	mov    %esp,%ebp
  103e6b:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  103e71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e76:	89 04 24             	mov    %eax,(%esp)
  103e79:	e8 09 ff ff ff       	call   103d87 <pa2page>
}
  103e7e:	c9                   	leave  
  103e7f:	c3                   	ret    

00103e80 <page_ref>:

static inline int
page_ref(struct Page *page) {
  103e80:	55                   	push   %ebp
  103e81:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103e83:	8b 45 08             	mov    0x8(%ebp),%eax
  103e86:	8b 00                	mov    (%eax),%eax
}
  103e88:	5d                   	pop    %ebp
  103e89:	c3                   	ret    

00103e8a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103e8a:	55                   	push   %ebp
  103e8b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  103e90:	8b 55 0c             	mov    0xc(%ebp),%edx
  103e93:	89 10                	mov    %edx,(%eax)
}
  103e95:	5d                   	pop    %ebp
  103e96:	c3                   	ret    

00103e97 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103e97:	55                   	push   %ebp
  103e98:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  103e9d:	8b 00                	mov    (%eax),%eax
  103e9f:	8d 50 01             	lea    0x1(%eax),%edx
  103ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  103ea5:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  103eaa:	8b 00                	mov    (%eax),%eax
}
  103eac:	5d                   	pop    %ebp
  103ead:	c3                   	ret    

00103eae <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103eae:	55                   	push   %ebp
  103eaf:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  103eb4:	8b 00                	mov    (%eax),%eax
  103eb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  103eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  103ebc:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  103ec1:	8b 00                	mov    (%eax),%eax
}
  103ec3:	5d                   	pop    %ebp
  103ec4:	c3                   	ret    

00103ec5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103ec5:	55                   	push   %ebp
  103ec6:	89 e5                	mov    %esp,%ebp
  103ec8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103ecb:	9c                   	pushf  
  103ecc:	58                   	pop    %eax
  103ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103ed3:	25 00 02 00 00       	and    $0x200,%eax
  103ed8:	85 c0                	test   %eax,%eax
  103eda:	74 0c                	je     103ee8 <__intr_save+0x23>
        intr_disable();
  103edc:	e8 e9 d7 ff ff       	call   1016ca <intr_disable>
        return 1;
  103ee1:	b8 01 00 00 00       	mov    $0x1,%eax
  103ee6:	eb 05                	jmp    103eed <__intr_save+0x28>
    }
    return 0;
  103ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103eed:	c9                   	leave  
  103eee:	c3                   	ret    

00103eef <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103eef:	55                   	push   %ebp
  103ef0:	89 e5                	mov    %esp,%ebp
  103ef2:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103ef5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103ef9:	74 05                	je     103f00 <__intr_restore+0x11>
        intr_enable();
  103efb:	e8 c4 d7 ff ff       	call   1016c4 <intr_enable>
    }
}
  103f00:	c9                   	leave  
  103f01:	c3                   	ret    

00103f02 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103f02:	55                   	push   %ebp
  103f03:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103f05:	8b 45 08             	mov    0x8(%ebp),%eax
  103f08:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103f0b:	b8 23 00 00 00       	mov    $0x23,%eax
  103f10:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103f12:	b8 23 00 00 00       	mov    $0x23,%eax
  103f17:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103f19:	b8 10 00 00 00       	mov    $0x10,%eax
  103f1e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103f20:	b8 10 00 00 00       	mov    $0x10,%eax
  103f25:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103f27:	b8 10 00 00 00       	mov    $0x10,%eax
  103f2c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103f2e:	ea 35 3f 10 00 08 00 	ljmp   $0x8,$0x103f35
}
  103f35:	5d                   	pop    %ebp
  103f36:	c3                   	ret    

00103f37 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103f37:	55                   	push   %ebp
  103f38:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  103f3d:	a3 a4 ae 11 00       	mov    %eax,0x11aea4
}
  103f42:	5d                   	pop    %ebp
  103f43:	c3                   	ret    

00103f44 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103f44:	55                   	push   %ebp
  103f45:	89 e5                	mov    %esp,%ebp
  103f47:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103f4a:	b8 00 70 11 00       	mov    $0x117000,%eax
  103f4f:	89 04 24             	mov    %eax,(%esp)
  103f52:	e8 e0 ff ff ff       	call   103f37 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103f57:	66 c7 05 a8 ae 11 00 	movw   $0x10,0x11aea8
  103f5e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103f60:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103f67:	68 00 
  103f69:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103f6e:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103f74:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103f79:	c1 e8 10             	shr    $0x10,%eax
  103f7c:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103f81:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103f88:	83 e0 f0             	and    $0xfffffff0,%eax
  103f8b:	83 c8 09             	or     $0x9,%eax
  103f8e:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103f93:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103f9a:	83 e0 ef             	and    $0xffffffef,%eax
  103f9d:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103fa2:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103fa9:	83 e0 9f             	and    $0xffffff9f,%eax
  103fac:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103fb1:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103fb8:	83 c8 80             	or     $0xffffff80,%eax
  103fbb:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103fc0:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103fc7:	83 e0 f0             	and    $0xfffffff0,%eax
  103fca:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103fcf:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103fd6:	83 e0 ef             	and    $0xffffffef,%eax
  103fd9:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103fde:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103fe5:	83 e0 df             	and    $0xffffffdf,%eax
  103fe8:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103fed:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103ff4:	83 c8 40             	or     $0x40,%eax
  103ff7:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103ffc:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  104003:	83 e0 7f             	and    $0x7f,%eax
  104006:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  10400b:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  104010:	c1 e8 18             	shr    $0x18,%eax
  104013:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  104018:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  10401f:	e8 de fe ff ff       	call   103f02 <lgdt>
  104024:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  10402a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10402e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  104031:	c9                   	leave  
  104032:	c3                   	ret    

00104033 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  104033:	55                   	push   %ebp
  104034:	89 e5                	mov    %esp,%ebp
  104036:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  104039:	c7 05 1c af 11 00 48 	movl   $0x106d48,0x11af1c
  104040:	6d 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  104043:	a1 1c af 11 00       	mov    0x11af1c,%eax
  104048:	8b 00                	mov    (%eax),%eax
  10404a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10404e:	c7 04 24 e4 6d 10 00 	movl   $0x106de4,(%esp)
  104055:	e8 ee c2 ff ff       	call   100348 <cprintf>
    pmm_manager->init();
  10405a:	a1 1c af 11 00       	mov    0x11af1c,%eax
  10405f:	8b 40 04             	mov    0x4(%eax),%eax
  104062:	ff d0                	call   *%eax
}
  104064:	c9                   	leave  
  104065:	c3                   	ret    

00104066 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  104066:	55                   	push   %ebp
  104067:	89 e5                	mov    %esp,%ebp
  104069:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  10406c:	a1 1c af 11 00       	mov    0x11af1c,%eax
  104071:	8b 40 08             	mov    0x8(%eax),%eax
  104074:	8b 55 0c             	mov    0xc(%ebp),%edx
  104077:	89 54 24 04          	mov    %edx,0x4(%esp)
  10407b:	8b 55 08             	mov    0x8(%ebp),%edx
  10407e:	89 14 24             	mov    %edx,(%esp)
  104081:	ff d0                	call   *%eax
}
  104083:	c9                   	leave  
  104084:	c3                   	ret    

00104085 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  104085:	55                   	push   %ebp
  104086:	89 e5                	mov    %esp,%ebp
  104088:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  10408b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  104092:	e8 2e fe ff ff       	call   103ec5 <__intr_save>
  104097:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  10409a:	a1 1c af 11 00       	mov    0x11af1c,%eax
  10409f:	8b 40 0c             	mov    0xc(%eax),%eax
  1040a2:	8b 55 08             	mov    0x8(%ebp),%edx
  1040a5:	89 14 24             	mov    %edx,(%esp)
  1040a8:	ff d0                	call   *%eax
  1040aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  1040ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040b0:	89 04 24             	mov    %eax,(%esp)
  1040b3:	e8 37 fe ff ff       	call   103eef <__intr_restore>
    return page;
  1040b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1040bb:	c9                   	leave  
  1040bc:	c3                   	ret    

001040bd <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  1040bd:	55                   	push   %ebp
  1040be:	89 e5                	mov    %esp,%ebp
  1040c0:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1040c3:	e8 fd fd ff ff       	call   103ec5 <__intr_save>
  1040c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  1040cb:	a1 1c af 11 00       	mov    0x11af1c,%eax
  1040d0:	8b 40 10             	mov    0x10(%eax),%eax
  1040d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1040d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1040da:	8b 55 08             	mov    0x8(%ebp),%edx
  1040dd:	89 14 24             	mov    %edx,(%esp)
  1040e0:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  1040e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1040e5:	89 04 24             	mov    %eax,(%esp)
  1040e8:	e8 02 fe ff ff       	call   103eef <__intr_restore>
}
  1040ed:	c9                   	leave  
  1040ee:	c3                   	ret    

001040ef <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  1040ef:	55                   	push   %ebp
  1040f0:	89 e5                	mov    %esp,%ebp
  1040f2:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  1040f5:	e8 cb fd ff ff       	call   103ec5 <__intr_save>
  1040fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  1040fd:	a1 1c af 11 00       	mov    0x11af1c,%eax
  104102:	8b 40 14             	mov    0x14(%eax),%eax
  104105:	ff d0                	call   *%eax
  104107:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  10410a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10410d:	89 04 24             	mov    %eax,(%esp)
  104110:	e8 da fd ff ff       	call   103eef <__intr_restore>
    return ret;
  104115:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  104118:	c9                   	leave  
  104119:	c3                   	ret    

0010411a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  10411a:	55                   	push   %ebp
  10411b:	89 e5                	mov    %esp,%ebp
  10411d:	57                   	push   %edi
  10411e:	56                   	push   %esi
  10411f:	53                   	push   %ebx
  104120:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  104126:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  10412d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  104134:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  10413b:	c7 04 24 fb 6d 10 00 	movl   $0x106dfb,(%esp)
  104142:	e8 01 c2 ff ff       	call   100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104147:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10414e:	e9 15 01 00 00       	jmp    104268 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104153:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104156:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104159:	89 d0                	mov    %edx,%eax
  10415b:	c1 e0 02             	shl    $0x2,%eax
  10415e:	01 d0                	add    %edx,%eax
  104160:	c1 e0 02             	shl    $0x2,%eax
  104163:	01 c8                	add    %ecx,%eax
  104165:	8b 50 08             	mov    0x8(%eax),%edx
  104168:	8b 40 04             	mov    0x4(%eax),%eax
  10416b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  10416e:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104171:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104174:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104177:	89 d0                	mov    %edx,%eax
  104179:	c1 e0 02             	shl    $0x2,%eax
  10417c:	01 d0                	add    %edx,%eax
  10417e:	c1 e0 02             	shl    $0x2,%eax
  104181:	01 c8                	add    %ecx,%eax
  104183:	8b 48 0c             	mov    0xc(%eax),%ecx
  104186:	8b 58 10             	mov    0x10(%eax),%ebx
  104189:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10418c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10418f:	01 c8                	add    %ecx,%eax
  104191:	11 da                	adc    %ebx,%edx
  104193:	89 45 b0             	mov    %eax,-0x50(%ebp)
  104196:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104199:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10419c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10419f:	89 d0                	mov    %edx,%eax
  1041a1:	c1 e0 02             	shl    $0x2,%eax
  1041a4:	01 d0                	add    %edx,%eax
  1041a6:	c1 e0 02             	shl    $0x2,%eax
  1041a9:	01 c8                	add    %ecx,%eax
  1041ab:	83 c0 14             	add    $0x14,%eax
  1041ae:	8b 00                	mov    (%eax),%eax
  1041b0:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  1041b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1041b9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1041bc:	83 c0 ff             	add    $0xffffffff,%eax
  1041bf:	83 d2 ff             	adc    $0xffffffff,%edx
  1041c2:	89 c6                	mov    %eax,%esi
  1041c4:	89 d7                	mov    %edx,%edi
  1041c6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1041c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041cc:	89 d0                	mov    %edx,%eax
  1041ce:	c1 e0 02             	shl    $0x2,%eax
  1041d1:	01 d0                	add    %edx,%eax
  1041d3:	c1 e0 02             	shl    $0x2,%eax
  1041d6:	01 c8                	add    %ecx,%eax
  1041d8:	8b 48 0c             	mov    0xc(%eax),%ecx
  1041db:	8b 58 10             	mov    0x10(%eax),%ebx
  1041de:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  1041e4:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  1041e8:	89 74 24 14          	mov    %esi,0x14(%esp)
  1041ec:	89 7c 24 18          	mov    %edi,0x18(%esp)
  1041f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1041f3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1041f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1041fa:	89 54 24 10          	mov    %edx,0x10(%esp)
  1041fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104202:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104206:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  10420d:	e8 36 c1 ff ff       	call   100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  104212:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104215:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104218:	89 d0                	mov    %edx,%eax
  10421a:	c1 e0 02             	shl    $0x2,%eax
  10421d:	01 d0                	add    %edx,%eax
  10421f:	c1 e0 02             	shl    $0x2,%eax
  104222:	01 c8                	add    %ecx,%eax
  104224:	83 c0 14             	add    $0x14,%eax
  104227:	8b 00                	mov    (%eax),%eax
  104229:	83 f8 01             	cmp    $0x1,%eax
  10422c:	75 36                	jne    104264 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  10422e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104231:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104234:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  104237:	77 2b                	ja     104264 <page_init+0x14a>
  104239:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  10423c:	72 05                	jb     104243 <page_init+0x129>
  10423e:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  104241:	73 21                	jae    104264 <page_init+0x14a>
  104243:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  104247:	77 1b                	ja     104264 <page_init+0x14a>
  104249:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  10424d:	72 09                	jb     104258 <page_init+0x13e>
  10424f:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  104256:	77 0c                	ja     104264 <page_init+0x14a>
                maxpa = end;
  104258:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10425b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10425e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104261:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104264:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104268:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10426b:	8b 00                	mov    (%eax),%eax
  10426d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104270:	0f 8f dd fe ff ff    	jg     104153 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104276:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10427a:	72 1d                	jb     104299 <page_init+0x17f>
  10427c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104280:	77 09                	ja     10428b <page_init+0x171>
  104282:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  104289:	76 0e                	jbe    104299 <page_init+0x17f>
        maxpa = KMEMSIZE;
  10428b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104292:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  104299:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10429c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10429f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1042a3:	c1 ea 0c             	shr    $0xc,%edx
  1042a6:	a3 80 ae 11 00       	mov    %eax,0x11ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  1042ab:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  1042b2:	b8 28 af 11 00       	mov    $0x11af28,%eax
  1042b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1042ba:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1042bd:	01 d0                	add    %edx,%eax
  1042bf:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1042c2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1042c5:	ba 00 00 00 00       	mov    $0x0,%edx
  1042ca:	f7 75 ac             	divl   -0x54(%ebp)
  1042cd:	89 d0                	mov    %edx,%eax
  1042cf:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1042d2:	29 c2                	sub    %eax,%edx
  1042d4:	89 d0                	mov    %edx,%eax
  1042d6:	a3 24 af 11 00       	mov    %eax,0x11af24

    for (i = 0; i < npage; i ++) {
  1042db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1042e2:	eb 2f                	jmp    104313 <page_init+0x1f9>
        SetPageReserved(pages + i);
  1042e4:	8b 0d 24 af 11 00    	mov    0x11af24,%ecx
  1042ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1042ed:	89 d0                	mov    %edx,%eax
  1042ef:	c1 e0 02             	shl    $0x2,%eax
  1042f2:	01 d0                	add    %edx,%eax
  1042f4:	c1 e0 02             	shl    $0x2,%eax
  1042f7:	01 c8                	add    %ecx,%eax
  1042f9:	83 c0 04             	add    $0x4,%eax
  1042fc:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  104303:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104306:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104309:	8b 55 90             	mov    -0x70(%ebp),%edx
  10430c:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  10430f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104313:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104316:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  10431b:	39 c2                	cmp    %eax,%edx
  10431d:	72 c5                	jb     1042e4 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  10431f:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  104325:	89 d0                	mov    %edx,%eax
  104327:	c1 e0 02             	shl    $0x2,%eax
  10432a:	01 d0                	add    %edx,%eax
  10432c:	c1 e0 02             	shl    $0x2,%eax
  10432f:	89 c2                	mov    %eax,%edx
  104331:	a1 24 af 11 00       	mov    0x11af24,%eax
  104336:	01 d0                	add    %edx,%eax
  104338:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  10433b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  104342:	77 23                	ja     104367 <page_init+0x24d>
  104344:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104347:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10434b:	c7 44 24 08 38 6e 10 	movl   $0x106e38,0x8(%esp)
  104352:	00 
  104353:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  10435a:	00 
  10435b:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104362:	e8 6f c9 ff ff       	call   100cd6 <__panic>
  104367:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10436a:	05 00 00 00 40       	add    $0x40000000,%eax
  10436f:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  104372:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104379:	e9 74 01 00 00       	jmp    1044f2 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10437e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104381:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104384:	89 d0                	mov    %edx,%eax
  104386:	c1 e0 02             	shl    $0x2,%eax
  104389:	01 d0                	add    %edx,%eax
  10438b:	c1 e0 02             	shl    $0x2,%eax
  10438e:	01 c8                	add    %ecx,%eax
  104390:	8b 50 08             	mov    0x8(%eax),%edx
  104393:	8b 40 04             	mov    0x4(%eax),%eax
  104396:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104399:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10439c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10439f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1043a2:	89 d0                	mov    %edx,%eax
  1043a4:	c1 e0 02             	shl    $0x2,%eax
  1043a7:	01 d0                	add    %edx,%eax
  1043a9:	c1 e0 02             	shl    $0x2,%eax
  1043ac:	01 c8                	add    %ecx,%eax
  1043ae:	8b 48 0c             	mov    0xc(%eax),%ecx
  1043b1:	8b 58 10             	mov    0x10(%eax),%ebx
  1043b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1043b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1043ba:	01 c8                	add    %ecx,%eax
  1043bc:	11 da                	adc    %ebx,%edx
  1043be:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1043c1:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1043c4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1043c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1043ca:	89 d0                	mov    %edx,%eax
  1043cc:	c1 e0 02             	shl    $0x2,%eax
  1043cf:	01 d0                	add    %edx,%eax
  1043d1:	c1 e0 02             	shl    $0x2,%eax
  1043d4:	01 c8                	add    %ecx,%eax
  1043d6:	83 c0 14             	add    $0x14,%eax
  1043d9:	8b 00                	mov    (%eax),%eax
  1043db:	83 f8 01             	cmp    $0x1,%eax
  1043de:	0f 85 0a 01 00 00    	jne    1044ee <page_init+0x3d4>
            if (begin < freemem) {
  1043e4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1043e7:	ba 00 00 00 00       	mov    $0x0,%edx
  1043ec:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1043ef:	72 17                	jb     104408 <page_init+0x2ee>
  1043f1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1043f4:	77 05                	ja     1043fb <page_init+0x2e1>
  1043f6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1043f9:	76 0d                	jbe    104408 <page_init+0x2ee>
                begin = freemem;
  1043fb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1043fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104401:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104408:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10440c:	72 1d                	jb     10442b <page_init+0x311>
  10440e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104412:	77 09                	ja     10441d <page_init+0x303>
  104414:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10441b:	76 0e                	jbe    10442b <page_init+0x311>
                end = KMEMSIZE;
  10441d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104424:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10442b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10442e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104431:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104434:	0f 87 b4 00 00 00    	ja     1044ee <page_init+0x3d4>
  10443a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10443d:	72 09                	jb     104448 <page_init+0x32e>
  10443f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104442:	0f 83 a6 00 00 00    	jae    1044ee <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104448:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  10444f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104452:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104455:	01 d0                	add    %edx,%eax
  104457:	83 e8 01             	sub    $0x1,%eax
  10445a:	89 45 98             	mov    %eax,-0x68(%ebp)
  10445d:	8b 45 98             	mov    -0x68(%ebp),%eax
  104460:	ba 00 00 00 00       	mov    $0x0,%edx
  104465:	f7 75 9c             	divl   -0x64(%ebp)
  104468:	89 d0                	mov    %edx,%eax
  10446a:	8b 55 98             	mov    -0x68(%ebp),%edx
  10446d:	29 c2                	sub    %eax,%edx
  10446f:	89 d0                	mov    %edx,%eax
  104471:	ba 00 00 00 00       	mov    $0x0,%edx
  104476:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104479:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10447c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10447f:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104482:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104485:	ba 00 00 00 00       	mov    $0x0,%edx
  10448a:	89 c7                	mov    %eax,%edi
  10448c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104492:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104495:	89 d0                	mov    %edx,%eax
  104497:	83 e0 00             	and    $0x0,%eax
  10449a:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10449d:	8b 45 80             	mov    -0x80(%ebp),%eax
  1044a0:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1044a3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1044a6:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1044a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1044ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1044af:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1044b2:	77 3a                	ja     1044ee <page_init+0x3d4>
  1044b4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1044b7:	72 05                	jb     1044be <page_init+0x3a4>
  1044b9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1044bc:	73 30                	jae    1044ee <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1044be:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1044c1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1044c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1044c7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1044ca:	29 c8                	sub    %ecx,%eax
  1044cc:	19 da                	sbb    %ebx,%edx
  1044ce:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1044d2:	c1 ea 0c             	shr    $0xc,%edx
  1044d5:	89 c3                	mov    %eax,%ebx
  1044d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1044da:	89 04 24             	mov    %eax,(%esp)
  1044dd:	e8 a5 f8 ff ff       	call   103d87 <pa2page>
  1044e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1044e6:	89 04 24             	mov    %eax,(%esp)
  1044e9:	e8 78 fb ff ff       	call   104066 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  1044ee:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1044f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1044f5:	8b 00                	mov    (%eax),%eax
  1044f7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1044fa:	0f 8f 7e fe ff ff    	jg     10437e <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104500:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104506:	5b                   	pop    %ebx
  104507:	5e                   	pop    %esi
  104508:	5f                   	pop    %edi
  104509:	5d                   	pop    %ebp
  10450a:	c3                   	ret    

0010450b <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10450b:	55                   	push   %ebp
  10450c:	89 e5                	mov    %esp,%ebp
  10450e:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104511:	8b 45 14             	mov    0x14(%ebp),%eax
  104514:	8b 55 0c             	mov    0xc(%ebp),%edx
  104517:	31 d0                	xor    %edx,%eax
  104519:	25 ff 0f 00 00       	and    $0xfff,%eax
  10451e:	85 c0                	test   %eax,%eax
  104520:	74 24                	je     104546 <boot_map_segment+0x3b>
  104522:	c7 44 24 0c 6a 6e 10 	movl   $0x106e6a,0xc(%esp)
  104529:	00 
  10452a:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104531:	00 
  104532:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  104539:	00 
  10453a:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104541:	e8 90 c7 ff ff       	call   100cd6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104546:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10454d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104550:	25 ff 0f 00 00       	and    $0xfff,%eax
  104555:	89 c2                	mov    %eax,%edx
  104557:	8b 45 10             	mov    0x10(%ebp),%eax
  10455a:	01 c2                	add    %eax,%edx
  10455c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10455f:	01 d0                	add    %edx,%eax
  104561:	83 e8 01             	sub    $0x1,%eax
  104564:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104567:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10456a:	ba 00 00 00 00       	mov    $0x0,%edx
  10456f:	f7 75 f0             	divl   -0x10(%ebp)
  104572:	89 d0                	mov    %edx,%eax
  104574:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104577:	29 c2                	sub    %eax,%edx
  104579:	89 d0                	mov    %edx,%eax
  10457b:	c1 e8 0c             	shr    $0xc,%eax
  10457e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104581:	8b 45 0c             	mov    0xc(%ebp),%eax
  104584:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104587:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10458a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10458f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104592:	8b 45 14             	mov    0x14(%ebp),%eax
  104595:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10459b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1045a0:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1045a3:	eb 6b                	jmp    104610 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1045a5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1045ac:	00 
  1045ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1045b7:	89 04 24             	mov    %eax,(%esp)
  1045ba:	e8 82 01 00 00       	call   104741 <get_pte>
  1045bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1045c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1045c6:	75 24                	jne    1045ec <boot_map_segment+0xe1>
  1045c8:	c7 44 24 0c 96 6e 10 	movl   $0x106e96,0xc(%esp)
  1045cf:	00 
  1045d0:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  1045d7:	00 
  1045d8:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1045df:	00 
  1045e0:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  1045e7:	e8 ea c6 ff ff       	call   100cd6 <__panic>
        *ptep = pa | PTE_P | perm;
  1045ec:	8b 45 18             	mov    0x18(%ebp),%eax
  1045ef:	8b 55 14             	mov    0x14(%ebp),%edx
  1045f2:	09 d0                	or     %edx,%eax
  1045f4:	83 c8 01             	or     $0x1,%eax
  1045f7:	89 c2                	mov    %eax,%edx
  1045f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045fc:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1045fe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104602:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104609:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104614:	75 8f                	jne    1045a5 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104616:	c9                   	leave  
  104617:	c3                   	ret    

00104618 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104618:	55                   	push   %ebp
  104619:	89 e5                	mov    %esp,%ebp
  10461b:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10461e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104625:	e8 5b fa ff ff       	call   104085 <alloc_pages>
  10462a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10462d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104631:	75 1c                	jne    10464f <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104633:	c7 44 24 08 a3 6e 10 	movl   $0x106ea3,0x8(%esp)
  10463a:	00 
  10463b:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  104642:	00 
  104643:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  10464a:	e8 87 c6 ff ff       	call   100cd6 <__panic>
    }
    return page2kva(p);
  10464f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104652:	89 04 24             	mov    %eax,(%esp)
  104655:	e8 7c f7 ff ff       	call   103dd6 <page2kva>
}
  10465a:	c9                   	leave  
  10465b:	c3                   	ret    

0010465c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10465c:	55                   	push   %ebp
  10465d:	89 e5                	mov    %esp,%ebp
  10465f:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  104662:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104667:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10466a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104671:	77 23                	ja     104696 <pmm_init+0x3a>
  104673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104676:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10467a:	c7 44 24 08 38 6e 10 	movl   $0x106e38,0x8(%esp)
  104681:	00 
  104682:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104689:	00 
  10468a:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104691:	e8 40 c6 ff ff       	call   100cd6 <__panic>
  104696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104699:	05 00 00 00 40       	add    $0x40000000,%eax
  10469e:	a3 20 af 11 00       	mov    %eax,0x11af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1046a3:	e8 8b f9 ff ff       	call   104033 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1046a8:	e8 6d fa ff ff       	call   10411a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1046ad:	e8 ee 03 00 00       	call   104aa0 <check_alloc_page>

    check_pgdir();
  1046b2:	e8 07 04 00 00       	call   104abe <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1046b7:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1046bc:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1046c2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1046c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1046ca:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1046d1:	77 23                	ja     1046f6 <pmm_init+0x9a>
  1046d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1046da:	c7 44 24 08 38 6e 10 	movl   $0x106e38,0x8(%esp)
  1046e1:	00 
  1046e2:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1046e9:	00 
  1046ea:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  1046f1:	e8 e0 c5 ff ff       	call   100cd6 <__panic>
  1046f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046f9:	05 00 00 00 40       	add    $0x40000000,%eax
  1046fe:	83 c8 03             	or     $0x3,%eax
  104701:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  104703:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104708:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10470f:	00 
  104710:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104717:	00 
  104718:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10471f:	38 
  104720:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104727:	c0 
  104728:	89 04 24             	mov    %eax,(%esp)
  10472b:	e8 db fd ff ff       	call   10450b <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104730:	e8 0f f8 ff ff       	call   103f44 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104735:	e8 1f 0a 00 00       	call   105159 <check_boot_pgdir>

    print_pgdir();
  10473a:	e8 a7 0e 00 00       	call   1055e6 <print_pgdir>

}
  10473f:	c9                   	leave  
  104740:	c3                   	ret    

00104741 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104741:	55                   	push   %ebp
  104742:	89 e5                	mov    %esp,%ebp
  104744:	83 ec 48             	sub    $0x48,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
	// (1) find page directory entry
	pde_t *pdep = pgdir + PDX(la);
  104747:	8b 45 0c             	mov    0xc(%ebp),%eax
  10474a:	c1 e8 16             	shr    $0x16,%eax
  10474d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104754:	8b 45 08             	mov    0x8(%ebp),%eax
  104757:	01 d0                	add    %edx,%eax
  104759:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//（2）check if entry is not present
	if(!(PTE_P & *pdep)) {   //不存在
  10475c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10475f:	8b 00                	mov    (%eax),%eax
  104761:	83 e0 01             	and    $0x1,%eax
  104764:	85 c0                	test   %eax,%eax
  104766:	0f 85 b7 00 00 00    	jne    104823 <get_pte+0xe2>
	//(3) check if creating is needed
	    if(create) {	//需要创建二级页表
  10476c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104770:	0f 84 a6 00 00 00    	je     10481c <get_pte+0xdb>
	       struct Page* newPage = alloc_page();//创建一个新的页面
  104776:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10477d:	e8 03 f9 ff ff       	call   104085 <alloc_pages>
  104782:	89 45 f0             	mov    %eax,-0x10(%ebp)
	// (4) set page reference
	       set_page_ref(newPage, 1);
  104785:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10478c:	00 
  10478d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104790:	89 04 24             	mov    %eax,(%esp)
  104793:	e8 f2 f6 ff ff       	call   103e8a <set_page_ref>
	//(5) get linear address of page
	       uintptr_t paPage = page2pa(newPage);
  104798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10479b:	89 04 24             	mov    %eax,(%esp)
  10479e:	e8 ce f5 ff ff       	call   103d71 <page2pa>
  1047a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	       pte_t laPage = KADDR(paPage);
  1047a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1047ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1047af:	c1 e8 0c             	shr    $0xc,%eax
  1047b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1047b5:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1047ba:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1047bd:	72 23                	jb     1047e2 <get_pte+0xa1>
  1047bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1047c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047c6:	c7 44 24 08 94 6d 10 	movl   $0x106d94,0x8(%esp)
  1047cd:	00 
  1047ce:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  1047d5:	00 
  1047d6:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  1047dd:	e8 f4 c4 ff ff       	call   100cd6 <__panic>
  1047e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1047e5:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1047ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
	//(6) clear page content using memset
	       memset(laPage, 0, PGSIZE);
  1047ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1047f0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1047f7:	00 
  1047f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1047ff:	00 
  104800:	89 04 24             	mov    %eax,(%esp)
  104803:	e8 fc 18 00 00       	call   106104 <memset>
	//(7) set page directory entry's permission
	       *pdep = ((paPage & ~0x0FFF) | PTE_U | PTE_W | PTE_P);
  104808:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10480b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104810:	83 c8 07             	or     $0x7,%eax
  104813:	89 c2                	mov    %eax,%edx
  104815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104818:	89 10                	mov    %edx,(%eax)
  10481a:	eb 07                	jmp    104823 <get_pte+0xe2>
	    } else {
	        return NULL;
  10481c:	b8 00 00 00 00       	mov    $0x0,%eax
  104821:	eb 62                	jmp    104885 <get_pte+0x144>
	    }
	}
	// (8) return page table entry
	pte_t *pte = (pte_t *)(KADDR((*pdep & ~0xFFF))) + PTX(la);
  104823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104826:	8b 00                	mov    (%eax),%eax
  104828:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10482d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104830:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104833:	c1 e8 0c             	shr    $0xc,%eax
  104836:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104839:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  10483e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104841:	72 23                	jb     104866 <get_pte+0x125>
  104843:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104846:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10484a:	c7 44 24 08 94 6d 10 	movl   $0x106d94,0x8(%esp)
  104851:	00 
  104852:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
  104859:	00 
  10485a:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104861:	e8 70 c4 ff ff       	call   100cd6 <__panic>
  104866:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104869:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10486e:	8b 55 0c             	mov    0xc(%ebp),%edx
  104871:	c1 ea 0c             	shr    $0xc,%edx
  104874:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  10487a:	c1 e2 02             	shl    $0x2,%edx
  10487d:	01 d0                	add    %edx,%eax
  10487f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	return pte; 
  104882:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  104885:	c9                   	leave  
  104886:	c3                   	ret    

00104887 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104887:	55                   	push   %ebp
  104888:	89 e5                	mov    %esp,%ebp
  10488a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10488d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104894:	00 
  104895:	8b 45 0c             	mov    0xc(%ebp),%eax
  104898:	89 44 24 04          	mov    %eax,0x4(%esp)
  10489c:	8b 45 08             	mov    0x8(%ebp),%eax
  10489f:	89 04 24             	mov    %eax,(%esp)
  1048a2:	e8 9a fe ff ff       	call   104741 <get_pte>
  1048a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1048aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1048ae:	74 08                	je     1048b8 <get_page+0x31>
        *ptep_store = ptep;
  1048b0:	8b 45 10             	mov    0x10(%ebp),%eax
  1048b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1048b6:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1048b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1048bc:	74 1b                	je     1048d9 <get_page+0x52>
  1048be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048c1:	8b 00                	mov    (%eax),%eax
  1048c3:	83 e0 01             	and    $0x1,%eax
  1048c6:	85 c0                	test   %eax,%eax
  1048c8:	74 0f                	je     1048d9 <get_page+0x52>
        return pte2page(*ptep);
  1048ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048cd:	8b 00                	mov    (%eax),%eax
  1048cf:	89 04 24             	mov    %eax,(%esp)
  1048d2:	e8 53 f5 ff ff       	call   103e2a <pte2page>
  1048d7:	eb 05                	jmp    1048de <get_page+0x57>
    }
    return NULL;
  1048d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1048de:	c9                   	leave  
  1048df:	c3                   	ret    

001048e0 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1048e0:	55                   	push   %ebp
  1048e1:	89 e5                	mov    %esp,%ebp
  1048e3:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
	//(1)check if this page table entry is present
	if((*ptep & PTE_P) == 1) {
  1048e6:	8b 45 10             	mov    0x10(%ebp),%eax
  1048e9:	8b 00                	mov    (%eax),%eax
  1048eb:	83 e0 01             	and    $0x1,%eax
  1048ee:	85 c0                	test   %eax,%eax
  1048f0:	74 52                	je     104944 <page_remove_pte+0x64>
	//(2)find correspending page to pte
	    struct Page* page = pte2page(*ptep);
  1048f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1048f5:	8b 00                	mov    (%eax),%eax
  1048f7:	89 04 24             	mov    %eax,(%esp)
  1048fa:	e8 2b f5 ff ff       	call   103e2a <pte2page>
  1048ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//(3)decrease page reference
	    page_ref_dec(page);
  104902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104905:	89 04 24             	mov    %eax,(%esp)
  104908:	e8 a1 f5 ff ff       	call   103eae <page_ref_dec>
	//(4)and free this page when page reference reachs 0
	    if(page->ref == 0) {
  10490d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104910:	8b 00                	mov    (%eax),%eax
  104912:	85 c0                	test   %eax,%eax
  104914:	75 13                	jne    104929 <page_remove_pte+0x49>
	    	free_page(page);
  104916:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10491d:	00 
  10491e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104921:	89 04 24             	mov    %eax,(%esp)
  104924:	e8 94 f7 ff ff       	call   1040bd <free_pages>
	    }
	//(5)clear second page table entry
	    *ptep = 0;
  104929:	8b 45 10             	mov    0x10(%ebp),%eax
  10492c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//(6)flush tlb
	    tlb_invalidate(pgdir, la);
  104932:	8b 45 0c             	mov    0xc(%ebp),%eax
  104935:	89 44 24 04          	mov    %eax,0x4(%esp)
  104939:	8b 45 08             	mov    0x8(%ebp),%eax
  10493c:	89 04 24             	mov    %eax,(%esp)
  10493f:	e8 ff 00 00 00       	call   104a43 <tlb_invalidate>
	}
}
  104944:	c9                   	leave  
  104945:	c3                   	ret    

00104946 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104946:	55                   	push   %ebp
  104947:	89 e5                	mov    %esp,%ebp
  104949:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10494c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104953:	00 
  104954:	8b 45 0c             	mov    0xc(%ebp),%eax
  104957:	89 44 24 04          	mov    %eax,0x4(%esp)
  10495b:	8b 45 08             	mov    0x8(%ebp),%eax
  10495e:	89 04 24             	mov    %eax,(%esp)
  104961:	e8 db fd ff ff       	call   104741 <get_pte>
  104966:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104969:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10496d:	74 19                	je     104988 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10496f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104972:	89 44 24 08          	mov    %eax,0x8(%esp)
  104976:	8b 45 0c             	mov    0xc(%ebp),%eax
  104979:	89 44 24 04          	mov    %eax,0x4(%esp)
  10497d:	8b 45 08             	mov    0x8(%ebp),%eax
  104980:	89 04 24             	mov    %eax,(%esp)
  104983:	e8 58 ff ff ff       	call   1048e0 <page_remove_pte>
    }
}
  104988:	c9                   	leave  
  104989:	c3                   	ret    

0010498a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10498a:	55                   	push   %ebp
  10498b:	89 e5                	mov    %esp,%ebp
  10498d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104990:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104997:	00 
  104998:	8b 45 10             	mov    0x10(%ebp),%eax
  10499b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10499f:	8b 45 08             	mov    0x8(%ebp),%eax
  1049a2:	89 04 24             	mov    %eax,(%esp)
  1049a5:	e8 97 fd ff ff       	call   104741 <get_pte>
  1049aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1049ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1049b1:	75 0a                	jne    1049bd <page_insert+0x33>
        return -E_NO_MEM;
  1049b3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1049b8:	e9 84 00 00 00       	jmp    104a41 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1049bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1049c0:	89 04 24             	mov    %eax,(%esp)
  1049c3:	e8 cf f4 ff ff       	call   103e97 <page_ref_inc>
    if (*ptep & PTE_P) {
  1049c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049cb:	8b 00                	mov    (%eax),%eax
  1049cd:	83 e0 01             	and    $0x1,%eax
  1049d0:	85 c0                	test   %eax,%eax
  1049d2:	74 3e                	je     104a12 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1049d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d7:	8b 00                	mov    (%eax),%eax
  1049d9:	89 04 24             	mov    %eax,(%esp)
  1049dc:	e8 49 f4 ff ff       	call   103e2a <pte2page>
  1049e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1049e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1049ea:	75 0d                	jne    1049f9 <page_insert+0x6f>
            page_ref_dec(page);
  1049ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1049ef:	89 04 24             	mov    %eax,(%esp)
  1049f2:	e8 b7 f4 ff ff       	call   103eae <page_ref_dec>
  1049f7:	eb 19                	jmp    104a12 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1049f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  104a00:	8b 45 10             	mov    0x10(%ebp),%eax
  104a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a07:	8b 45 08             	mov    0x8(%ebp),%eax
  104a0a:	89 04 24             	mov    %eax,(%esp)
  104a0d:	e8 ce fe ff ff       	call   1048e0 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  104a15:	89 04 24             	mov    %eax,(%esp)
  104a18:	e8 54 f3 ff ff       	call   103d71 <page2pa>
  104a1d:	0b 45 14             	or     0x14(%ebp),%eax
  104a20:	83 c8 01             	or     $0x1,%eax
  104a23:	89 c2                	mov    %eax,%edx
  104a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a28:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104a2a:	8b 45 10             	mov    0x10(%ebp),%eax
  104a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a31:	8b 45 08             	mov    0x8(%ebp),%eax
  104a34:	89 04 24             	mov    %eax,(%esp)
  104a37:	e8 07 00 00 00       	call   104a43 <tlb_invalidate>
    return 0;
  104a3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104a41:	c9                   	leave  
  104a42:	c3                   	ret    

00104a43 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104a43:	55                   	push   %ebp
  104a44:	89 e5                	mov    %esp,%ebp
  104a46:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104a49:	0f 20 d8             	mov    %cr3,%eax
  104a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104a52:	89 c2                	mov    %eax,%edx
  104a54:	8b 45 08             	mov    0x8(%ebp),%eax
  104a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104a5a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104a61:	77 23                	ja     104a86 <tlb_invalidate+0x43>
  104a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a66:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104a6a:	c7 44 24 08 38 6e 10 	movl   $0x106e38,0x8(%esp)
  104a71:	00 
  104a72:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  104a79:	00 
  104a7a:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104a81:	e8 50 c2 ff ff       	call   100cd6 <__panic>
  104a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a89:	05 00 00 00 40       	add    $0x40000000,%eax
  104a8e:	39 c2                	cmp    %eax,%edx
  104a90:	75 0c                	jne    104a9e <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  104a95:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a9b:	0f 01 38             	invlpg (%eax)
    }
}
  104a9e:	c9                   	leave  
  104a9f:	c3                   	ret    

00104aa0 <check_alloc_page>:

static void
check_alloc_page(void) {
  104aa0:	55                   	push   %ebp
  104aa1:	89 e5                	mov    %esp,%ebp
  104aa3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104aa6:	a1 1c af 11 00       	mov    0x11af1c,%eax
  104aab:	8b 40 18             	mov    0x18(%eax),%eax
  104aae:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104ab0:	c7 04 24 bc 6e 10 00 	movl   $0x106ebc,(%esp)
  104ab7:	e8 8c b8 ff ff       	call   100348 <cprintf>
}
  104abc:	c9                   	leave  
  104abd:	c3                   	ret    

00104abe <check_pgdir>:

static void
check_pgdir(void) {
  104abe:	55                   	push   %ebp
  104abf:	89 e5                	mov    %esp,%ebp
  104ac1:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104ac4:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104ac9:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104ace:	76 24                	jbe    104af4 <check_pgdir+0x36>
  104ad0:	c7 44 24 0c db 6e 10 	movl   $0x106edb,0xc(%esp)
  104ad7:	00 
  104ad8:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104adf:	00 
  104ae0:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104ae7:	00 
  104ae8:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104aef:	e8 e2 c1 ff ff       	call   100cd6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104af4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104af9:	85 c0                	test   %eax,%eax
  104afb:	74 0e                	je     104b0b <check_pgdir+0x4d>
  104afd:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104b02:	25 ff 0f 00 00       	and    $0xfff,%eax
  104b07:	85 c0                	test   %eax,%eax
  104b09:	74 24                	je     104b2f <check_pgdir+0x71>
  104b0b:	c7 44 24 0c f8 6e 10 	movl   $0x106ef8,0xc(%esp)
  104b12:	00 
  104b13:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104b1a:	00 
  104b1b:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104b22:	00 
  104b23:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104b2a:	e8 a7 c1 ff ff       	call   100cd6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104b2f:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104b34:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b3b:	00 
  104b3c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b43:	00 
  104b44:	89 04 24             	mov    %eax,(%esp)
  104b47:	e8 3b fd ff ff       	call   104887 <get_page>
  104b4c:	85 c0                	test   %eax,%eax
  104b4e:	74 24                	je     104b74 <check_pgdir+0xb6>
  104b50:	c7 44 24 0c 30 6f 10 	movl   $0x106f30,0xc(%esp)
  104b57:	00 
  104b58:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104b5f:	00 
  104b60:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  104b67:	00 
  104b68:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104b6f:	e8 62 c1 ff ff       	call   100cd6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104b74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b7b:	e8 05 f5 ff ff       	call   104085 <alloc_pages>
  104b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104b83:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104b88:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104b8f:	00 
  104b90:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b97:	00 
  104b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b9b:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b9f:	89 04 24             	mov    %eax,(%esp)
  104ba2:	e8 e3 fd ff ff       	call   10498a <page_insert>
  104ba7:	85 c0                	test   %eax,%eax
  104ba9:	74 24                	je     104bcf <check_pgdir+0x111>
  104bab:	c7 44 24 0c 58 6f 10 	movl   $0x106f58,0xc(%esp)
  104bb2:	00 
  104bb3:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104bba:	00 
  104bbb:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  104bc2:	00 
  104bc3:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104bca:	e8 07 c1 ff ff       	call   100cd6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104bcf:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104bd4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104bdb:	00 
  104bdc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104be3:	00 
  104be4:	89 04 24             	mov    %eax,(%esp)
  104be7:	e8 55 fb ff ff       	call   104741 <get_pte>
  104bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104bef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104bf3:	75 24                	jne    104c19 <check_pgdir+0x15b>
  104bf5:	c7 44 24 0c 84 6f 10 	movl   $0x106f84,0xc(%esp)
  104bfc:	00 
  104bfd:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104c04:	00 
  104c05:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104c0c:	00 
  104c0d:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104c14:	e8 bd c0 ff ff       	call   100cd6 <__panic>
    assert(pte2page(*ptep) == p1);
  104c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c1c:	8b 00                	mov    (%eax),%eax
  104c1e:	89 04 24             	mov    %eax,(%esp)
  104c21:	e8 04 f2 ff ff       	call   103e2a <pte2page>
  104c26:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104c29:	74 24                	je     104c4f <check_pgdir+0x191>
  104c2b:	c7 44 24 0c b1 6f 10 	movl   $0x106fb1,0xc(%esp)
  104c32:	00 
  104c33:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104c3a:	00 
  104c3b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104c42:	00 
  104c43:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104c4a:	e8 87 c0 ff ff       	call   100cd6 <__panic>
    assert(page_ref(p1) == 1);
  104c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c52:	89 04 24             	mov    %eax,(%esp)
  104c55:	e8 26 f2 ff ff       	call   103e80 <page_ref>
  104c5a:	83 f8 01             	cmp    $0x1,%eax
  104c5d:	74 24                	je     104c83 <check_pgdir+0x1c5>
  104c5f:	c7 44 24 0c c7 6f 10 	movl   $0x106fc7,0xc(%esp)
  104c66:	00 
  104c67:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104c6e:	00 
  104c6f:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104c76:	00 
  104c77:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104c7e:	e8 53 c0 ff ff       	call   100cd6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104c83:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104c88:	8b 00                	mov    (%eax),%eax
  104c8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104c8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c95:	c1 e8 0c             	shr    $0xc,%eax
  104c98:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104c9b:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104ca0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104ca3:	72 23                	jb     104cc8 <check_pgdir+0x20a>
  104ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ca8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104cac:	c7 44 24 08 94 6d 10 	movl   $0x106d94,0x8(%esp)
  104cb3:	00 
  104cb4:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104cbb:	00 
  104cbc:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104cc3:	e8 0e c0 ff ff       	call   100cd6 <__panic>
  104cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ccb:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104cd0:	83 c0 04             	add    $0x4,%eax
  104cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104cd6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104cdb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ce2:	00 
  104ce3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104cea:	00 
  104ceb:	89 04 24             	mov    %eax,(%esp)
  104cee:	e8 4e fa ff ff       	call   104741 <get_pte>
  104cf3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104cf6:	74 24                	je     104d1c <check_pgdir+0x25e>
  104cf8:	c7 44 24 0c dc 6f 10 	movl   $0x106fdc,0xc(%esp)
  104cff:	00 
  104d00:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104d07:	00 
  104d08:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104d0f:	00 
  104d10:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104d17:	e8 ba bf ff ff       	call   100cd6 <__panic>

    p2 = alloc_page();
  104d1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d23:	e8 5d f3 ff ff       	call   104085 <alloc_pages>
  104d28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104d2b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104d30:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104d37:	00 
  104d38:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104d3f:	00 
  104d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104d43:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d47:	89 04 24             	mov    %eax,(%esp)
  104d4a:	e8 3b fc ff ff       	call   10498a <page_insert>
  104d4f:	85 c0                	test   %eax,%eax
  104d51:	74 24                	je     104d77 <check_pgdir+0x2b9>
  104d53:	c7 44 24 0c 04 70 10 	movl   $0x107004,0xc(%esp)
  104d5a:	00 
  104d5b:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104d62:	00 
  104d63:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104d6a:	00 
  104d6b:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104d72:	e8 5f bf ff ff       	call   100cd6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104d77:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104d7c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104d83:	00 
  104d84:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d8b:	00 
  104d8c:	89 04 24             	mov    %eax,(%esp)
  104d8f:	e8 ad f9 ff ff       	call   104741 <get_pte>
  104d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104d9b:	75 24                	jne    104dc1 <check_pgdir+0x303>
  104d9d:	c7 44 24 0c 3c 70 10 	movl   $0x10703c,0xc(%esp)
  104da4:	00 
  104da5:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104dac:	00 
  104dad:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104db4:	00 
  104db5:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104dbc:	e8 15 bf ff ff       	call   100cd6 <__panic>
    assert(*ptep & PTE_U);
  104dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dc4:	8b 00                	mov    (%eax),%eax
  104dc6:	83 e0 04             	and    $0x4,%eax
  104dc9:	85 c0                	test   %eax,%eax
  104dcb:	75 24                	jne    104df1 <check_pgdir+0x333>
  104dcd:	c7 44 24 0c 6c 70 10 	movl   $0x10706c,0xc(%esp)
  104dd4:	00 
  104dd5:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104ddc:	00 
  104ddd:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104de4:	00 
  104de5:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104dec:	e8 e5 be ff ff       	call   100cd6 <__panic>
    assert(*ptep & PTE_W);
  104df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104df4:	8b 00                	mov    (%eax),%eax
  104df6:	83 e0 02             	and    $0x2,%eax
  104df9:	85 c0                	test   %eax,%eax
  104dfb:	75 24                	jne    104e21 <check_pgdir+0x363>
  104dfd:	c7 44 24 0c 7a 70 10 	movl   $0x10707a,0xc(%esp)
  104e04:	00 
  104e05:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104e0c:	00 
  104e0d:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104e14:	00 
  104e15:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104e1c:	e8 b5 be ff ff       	call   100cd6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104e21:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104e26:	8b 00                	mov    (%eax),%eax
  104e28:	83 e0 04             	and    $0x4,%eax
  104e2b:	85 c0                	test   %eax,%eax
  104e2d:	75 24                	jne    104e53 <check_pgdir+0x395>
  104e2f:	c7 44 24 0c 88 70 10 	movl   $0x107088,0xc(%esp)
  104e36:	00 
  104e37:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104e3e:	00 
  104e3f:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104e46:	00 
  104e47:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104e4e:	e8 83 be ff ff       	call   100cd6 <__panic>
    assert(page_ref(p2) == 1);
  104e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e56:	89 04 24             	mov    %eax,(%esp)
  104e59:	e8 22 f0 ff ff       	call   103e80 <page_ref>
  104e5e:	83 f8 01             	cmp    $0x1,%eax
  104e61:	74 24                	je     104e87 <check_pgdir+0x3c9>
  104e63:	c7 44 24 0c 9e 70 10 	movl   $0x10709e,0xc(%esp)
  104e6a:	00 
  104e6b:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104e72:	00 
  104e73:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104e7a:	00 
  104e7b:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104e82:	e8 4f be ff ff       	call   100cd6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104e87:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104e8c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104e93:	00 
  104e94:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104e9b:	00 
  104e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104e9f:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ea3:	89 04 24             	mov    %eax,(%esp)
  104ea6:	e8 df fa ff ff       	call   10498a <page_insert>
  104eab:	85 c0                	test   %eax,%eax
  104ead:	74 24                	je     104ed3 <check_pgdir+0x415>
  104eaf:	c7 44 24 0c b0 70 10 	movl   $0x1070b0,0xc(%esp)
  104eb6:	00 
  104eb7:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104ebe:	00 
  104ebf:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104ec6:	00 
  104ec7:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104ece:	e8 03 be ff ff       	call   100cd6 <__panic>
    assert(page_ref(p1) == 2);
  104ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ed6:	89 04 24             	mov    %eax,(%esp)
  104ed9:	e8 a2 ef ff ff       	call   103e80 <page_ref>
  104ede:	83 f8 02             	cmp    $0x2,%eax
  104ee1:	74 24                	je     104f07 <check_pgdir+0x449>
  104ee3:	c7 44 24 0c dc 70 10 	movl   $0x1070dc,0xc(%esp)
  104eea:	00 
  104eeb:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104ef2:	00 
  104ef3:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104efa:	00 
  104efb:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104f02:	e8 cf bd ff ff       	call   100cd6 <__panic>
    assert(page_ref(p2) == 0);
  104f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f0a:	89 04 24             	mov    %eax,(%esp)
  104f0d:	e8 6e ef ff ff       	call   103e80 <page_ref>
  104f12:	85 c0                	test   %eax,%eax
  104f14:	74 24                	je     104f3a <check_pgdir+0x47c>
  104f16:	c7 44 24 0c ee 70 10 	movl   $0x1070ee,0xc(%esp)
  104f1d:	00 
  104f1e:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104f25:	00 
  104f26:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104f2d:	00 
  104f2e:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104f35:	e8 9c bd ff ff       	call   100cd6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104f3a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104f3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104f46:	00 
  104f47:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104f4e:	00 
  104f4f:	89 04 24             	mov    %eax,(%esp)
  104f52:	e8 ea f7 ff ff       	call   104741 <get_pte>
  104f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104f5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104f5e:	75 24                	jne    104f84 <check_pgdir+0x4c6>
  104f60:	c7 44 24 0c 3c 70 10 	movl   $0x10703c,0xc(%esp)
  104f67:	00 
  104f68:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104f6f:	00 
  104f70:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104f77:	00 
  104f78:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104f7f:	e8 52 bd ff ff       	call   100cd6 <__panic>
    assert(pte2page(*ptep) == p1);
  104f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f87:	8b 00                	mov    (%eax),%eax
  104f89:	89 04 24             	mov    %eax,(%esp)
  104f8c:	e8 99 ee ff ff       	call   103e2a <pte2page>
  104f91:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104f94:	74 24                	je     104fba <check_pgdir+0x4fc>
  104f96:	c7 44 24 0c b1 6f 10 	movl   $0x106fb1,0xc(%esp)
  104f9d:	00 
  104f9e:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104fa5:	00 
  104fa6:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104fad:	00 
  104fae:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104fb5:	e8 1c bd ff ff       	call   100cd6 <__panic>
    assert((*ptep & PTE_U) == 0);
  104fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fbd:	8b 00                	mov    (%eax),%eax
  104fbf:	83 e0 04             	and    $0x4,%eax
  104fc2:	85 c0                	test   %eax,%eax
  104fc4:	74 24                	je     104fea <check_pgdir+0x52c>
  104fc6:	c7 44 24 0c 00 71 10 	movl   $0x107100,0xc(%esp)
  104fcd:	00 
  104fce:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  104fd5:	00 
  104fd6:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104fdd:	00 
  104fde:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  104fe5:	e8 ec bc ff ff       	call   100cd6 <__panic>

    page_remove(boot_pgdir, 0x0);
  104fea:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104fef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ff6:	00 
  104ff7:	89 04 24             	mov    %eax,(%esp)
  104ffa:	e8 47 f9 ff ff       	call   104946 <page_remove>
    assert(page_ref(p1) == 1);
  104fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105002:	89 04 24             	mov    %eax,(%esp)
  105005:	e8 76 ee ff ff       	call   103e80 <page_ref>
  10500a:	83 f8 01             	cmp    $0x1,%eax
  10500d:	74 24                	je     105033 <check_pgdir+0x575>
  10500f:	c7 44 24 0c c7 6f 10 	movl   $0x106fc7,0xc(%esp)
  105016:	00 
  105017:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  10501e:	00 
  10501f:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  105026:	00 
  105027:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  10502e:	e8 a3 bc ff ff       	call   100cd6 <__panic>
    assert(page_ref(p2) == 0);
  105033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105036:	89 04 24             	mov    %eax,(%esp)
  105039:	e8 42 ee ff ff       	call   103e80 <page_ref>
  10503e:	85 c0                	test   %eax,%eax
  105040:	74 24                	je     105066 <check_pgdir+0x5a8>
  105042:	c7 44 24 0c ee 70 10 	movl   $0x1070ee,0xc(%esp)
  105049:	00 
  10504a:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  105051:	00 
  105052:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  105059:	00 
  10505a:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  105061:	e8 70 bc ff ff       	call   100cd6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  105066:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10506b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105072:	00 
  105073:	89 04 24             	mov    %eax,(%esp)
  105076:	e8 cb f8 ff ff       	call   104946 <page_remove>
    assert(page_ref(p1) == 0);
  10507b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10507e:	89 04 24             	mov    %eax,(%esp)
  105081:	e8 fa ed ff ff       	call   103e80 <page_ref>
  105086:	85 c0                	test   %eax,%eax
  105088:	74 24                	je     1050ae <check_pgdir+0x5f0>
  10508a:	c7 44 24 0c 15 71 10 	movl   $0x107115,0xc(%esp)
  105091:	00 
  105092:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  105099:	00 
  10509a:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  1050a1:	00 
  1050a2:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  1050a9:	e8 28 bc ff ff       	call   100cd6 <__panic>
    assert(page_ref(p2) == 0);
  1050ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050b1:	89 04 24             	mov    %eax,(%esp)
  1050b4:	e8 c7 ed ff ff       	call   103e80 <page_ref>
  1050b9:	85 c0                	test   %eax,%eax
  1050bb:	74 24                	je     1050e1 <check_pgdir+0x623>
  1050bd:	c7 44 24 0c ee 70 10 	movl   $0x1070ee,0xc(%esp)
  1050c4:	00 
  1050c5:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  1050cc:	00 
  1050cd:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  1050d4:	00 
  1050d5:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  1050dc:	e8 f5 bb ff ff       	call   100cd6 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  1050e1:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1050e6:	8b 00                	mov    (%eax),%eax
  1050e8:	89 04 24             	mov    %eax,(%esp)
  1050eb:	e8 78 ed ff ff       	call   103e68 <pde2page>
  1050f0:	89 04 24             	mov    %eax,(%esp)
  1050f3:	e8 88 ed ff ff       	call   103e80 <page_ref>
  1050f8:	83 f8 01             	cmp    $0x1,%eax
  1050fb:	74 24                	je     105121 <check_pgdir+0x663>
  1050fd:	c7 44 24 0c 28 71 10 	movl   $0x107128,0xc(%esp)
  105104:	00 
  105105:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  10510c:	00 
  10510d:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  105114:	00 
  105115:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  10511c:	e8 b5 bb ff ff       	call   100cd6 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  105121:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  105126:	8b 00                	mov    (%eax),%eax
  105128:	89 04 24             	mov    %eax,(%esp)
  10512b:	e8 38 ed ff ff       	call   103e68 <pde2page>
  105130:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105137:	00 
  105138:	89 04 24             	mov    %eax,(%esp)
  10513b:	e8 7d ef ff ff       	call   1040bd <free_pages>
    boot_pgdir[0] = 0;
  105140:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  105145:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  10514b:	c7 04 24 4f 71 10 00 	movl   $0x10714f,(%esp)
  105152:	e8 f1 b1 ff ff       	call   100348 <cprintf>
}
  105157:	c9                   	leave  
  105158:	c3                   	ret    

00105159 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  105159:	55                   	push   %ebp
  10515a:	89 e5                	mov    %esp,%ebp
  10515c:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  10515f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105166:	e9 ca 00 00 00       	jmp    105235 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  10516b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10516e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105174:	c1 e8 0c             	shr    $0xc,%eax
  105177:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10517a:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  10517f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105182:	72 23                	jb     1051a7 <check_boot_pgdir+0x4e>
  105184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105187:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10518b:	c7 44 24 08 94 6d 10 	movl   $0x106d94,0x8(%esp)
  105192:	00 
  105193:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  10519a:	00 
  10519b:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  1051a2:	e8 2f bb ff ff       	call   100cd6 <__panic>
  1051a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051aa:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1051af:	89 c2                	mov    %eax,%edx
  1051b1:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1051b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1051bd:	00 
  1051be:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051c2:	89 04 24             	mov    %eax,(%esp)
  1051c5:	e8 77 f5 ff ff       	call   104741 <get_pte>
  1051ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1051cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1051d1:	75 24                	jne    1051f7 <check_boot_pgdir+0x9e>
  1051d3:	c7 44 24 0c 6c 71 10 	movl   $0x10716c,0xc(%esp)
  1051da:	00 
  1051db:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  1051e2:	00 
  1051e3:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  1051ea:	00 
  1051eb:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  1051f2:	e8 df ba ff ff       	call   100cd6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  1051f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051fa:	8b 00                	mov    (%eax),%eax
  1051fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105201:	89 c2                	mov    %eax,%edx
  105203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105206:	39 c2                	cmp    %eax,%edx
  105208:	74 24                	je     10522e <check_boot_pgdir+0xd5>
  10520a:	c7 44 24 0c a9 71 10 	movl   $0x1071a9,0xc(%esp)
  105211:	00 
  105212:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  105219:	00 
  10521a:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  105221:	00 
  105222:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  105229:	e8 a8 ba ff ff       	call   100cd6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  10522e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  105235:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105238:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  10523d:	39 c2                	cmp    %eax,%edx
  10523f:	0f 82 26 ff ff ff    	jb     10516b <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  105245:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10524a:	05 ac 0f 00 00       	add    $0xfac,%eax
  10524f:	8b 00                	mov    (%eax),%eax
  105251:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105256:	89 c2                	mov    %eax,%edx
  105258:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10525d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105260:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  105267:	77 23                	ja     10528c <check_boot_pgdir+0x133>
  105269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10526c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105270:	c7 44 24 08 38 6e 10 	movl   $0x106e38,0x8(%esp)
  105277:	00 
  105278:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  10527f:	00 
  105280:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  105287:	e8 4a ba ff ff       	call   100cd6 <__panic>
  10528c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10528f:	05 00 00 00 40       	add    $0x40000000,%eax
  105294:	39 c2                	cmp    %eax,%edx
  105296:	74 24                	je     1052bc <check_boot_pgdir+0x163>
  105298:	c7 44 24 0c c0 71 10 	movl   $0x1071c0,0xc(%esp)
  10529f:	00 
  1052a0:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  1052a7:	00 
  1052a8:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  1052af:	00 
  1052b0:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  1052b7:	e8 1a ba ff ff       	call   100cd6 <__panic>

    assert(boot_pgdir[0] == 0);
  1052bc:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1052c1:	8b 00                	mov    (%eax),%eax
  1052c3:	85 c0                	test   %eax,%eax
  1052c5:	74 24                	je     1052eb <check_boot_pgdir+0x192>
  1052c7:	c7 44 24 0c f4 71 10 	movl   $0x1071f4,0xc(%esp)
  1052ce:	00 
  1052cf:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  1052d6:	00 
  1052d7:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  1052de:	00 
  1052df:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  1052e6:	e8 eb b9 ff ff       	call   100cd6 <__panic>

    struct Page *p;
    p = alloc_page();
  1052eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052f2:	e8 8e ed ff ff       	call   104085 <alloc_pages>
  1052f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  1052fa:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1052ff:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105306:	00 
  105307:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  10530e:	00 
  10530f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105312:	89 54 24 04          	mov    %edx,0x4(%esp)
  105316:	89 04 24             	mov    %eax,(%esp)
  105319:	e8 6c f6 ff ff       	call   10498a <page_insert>
  10531e:	85 c0                	test   %eax,%eax
  105320:	74 24                	je     105346 <check_boot_pgdir+0x1ed>
  105322:	c7 44 24 0c 08 72 10 	movl   $0x107208,0xc(%esp)
  105329:	00 
  10532a:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  105331:	00 
  105332:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  105339:	00 
  10533a:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  105341:	e8 90 b9 ff ff       	call   100cd6 <__panic>
    assert(page_ref(p) == 1);
  105346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105349:	89 04 24             	mov    %eax,(%esp)
  10534c:	e8 2f eb ff ff       	call   103e80 <page_ref>
  105351:	83 f8 01             	cmp    $0x1,%eax
  105354:	74 24                	je     10537a <check_boot_pgdir+0x221>
  105356:	c7 44 24 0c 36 72 10 	movl   $0x107236,0xc(%esp)
  10535d:	00 
  10535e:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  105365:	00 
  105366:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  10536d:	00 
  10536e:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  105375:	e8 5c b9 ff ff       	call   100cd6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10537a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10537f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105386:	00 
  105387:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10538e:	00 
  10538f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105392:	89 54 24 04          	mov    %edx,0x4(%esp)
  105396:	89 04 24             	mov    %eax,(%esp)
  105399:	e8 ec f5 ff ff       	call   10498a <page_insert>
  10539e:	85 c0                	test   %eax,%eax
  1053a0:	74 24                	je     1053c6 <check_boot_pgdir+0x26d>
  1053a2:	c7 44 24 0c 48 72 10 	movl   $0x107248,0xc(%esp)
  1053a9:	00 
  1053aa:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  1053b1:	00 
  1053b2:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  1053b9:	00 
  1053ba:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  1053c1:	e8 10 b9 ff ff       	call   100cd6 <__panic>
    assert(page_ref(p) == 2);
  1053c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053c9:	89 04 24             	mov    %eax,(%esp)
  1053cc:	e8 af ea ff ff       	call   103e80 <page_ref>
  1053d1:	83 f8 02             	cmp    $0x2,%eax
  1053d4:	74 24                	je     1053fa <check_boot_pgdir+0x2a1>
  1053d6:	c7 44 24 0c 7f 72 10 	movl   $0x10727f,0xc(%esp)
  1053dd:	00 
  1053de:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  1053e5:	00 
  1053e6:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  1053ed:	00 
  1053ee:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  1053f5:	e8 dc b8 ff ff       	call   100cd6 <__panic>

    const char *str = "ucore: Hello world!!";
  1053fa:	c7 45 dc 90 72 10 00 	movl   $0x107290,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105401:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105404:	89 44 24 04          	mov    %eax,0x4(%esp)
  105408:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10540f:	e8 19 0a 00 00       	call   105e2d <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105414:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10541b:	00 
  10541c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105423:	e8 7e 0a 00 00       	call   105ea6 <strcmp>
  105428:	85 c0                	test   %eax,%eax
  10542a:	74 24                	je     105450 <check_boot_pgdir+0x2f7>
  10542c:	c7 44 24 0c a8 72 10 	movl   $0x1072a8,0xc(%esp)
  105433:	00 
  105434:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  10543b:	00 
  10543c:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  105443:	00 
  105444:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  10544b:	e8 86 b8 ff ff       	call   100cd6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105450:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105453:	89 04 24             	mov    %eax,(%esp)
  105456:	e8 7b e9 ff ff       	call   103dd6 <page2kva>
  10545b:	05 00 01 00 00       	add    $0x100,%eax
  105460:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105463:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10546a:	e8 66 09 00 00       	call   105dd5 <strlen>
  10546f:	85 c0                	test   %eax,%eax
  105471:	74 24                	je     105497 <check_boot_pgdir+0x33e>
  105473:	c7 44 24 0c e0 72 10 	movl   $0x1072e0,0xc(%esp)
  10547a:	00 
  10547b:	c7 44 24 08 81 6e 10 	movl   $0x106e81,0x8(%esp)
  105482:	00 
  105483:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  10548a:	00 
  10548b:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  105492:	e8 3f b8 ff ff       	call   100cd6 <__panic>

    free_page(p);
  105497:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10549e:	00 
  10549f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054a2:	89 04 24             	mov    %eax,(%esp)
  1054a5:	e8 13 ec ff ff       	call   1040bd <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  1054aa:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1054af:	8b 00                	mov    (%eax),%eax
  1054b1:	89 04 24             	mov    %eax,(%esp)
  1054b4:	e8 af e9 ff ff       	call   103e68 <pde2page>
  1054b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1054c0:	00 
  1054c1:	89 04 24             	mov    %eax,(%esp)
  1054c4:	e8 f4 eb ff ff       	call   1040bd <free_pages>
    boot_pgdir[0] = 0;
  1054c9:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1054ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1054d4:	c7 04 24 04 73 10 00 	movl   $0x107304,(%esp)
  1054db:	e8 68 ae ff ff       	call   100348 <cprintf>
}
  1054e0:	c9                   	leave  
  1054e1:	c3                   	ret    

001054e2 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1054e2:	55                   	push   %ebp
  1054e3:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1054e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1054e8:	83 e0 04             	and    $0x4,%eax
  1054eb:	85 c0                	test   %eax,%eax
  1054ed:	74 07                	je     1054f6 <perm2str+0x14>
  1054ef:	b8 75 00 00 00       	mov    $0x75,%eax
  1054f4:	eb 05                	jmp    1054fb <perm2str+0x19>
  1054f6:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1054fb:	a2 08 af 11 00       	mov    %al,0x11af08
    str[1] = 'r';
  105500:	c6 05 09 af 11 00 72 	movb   $0x72,0x11af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105507:	8b 45 08             	mov    0x8(%ebp),%eax
  10550a:	83 e0 02             	and    $0x2,%eax
  10550d:	85 c0                	test   %eax,%eax
  10550f:	74 07                	je     105518 <perm2str+0x36>
  105511:	b8 77 00 00 00       	mov    $0x77,%eax
  105516:	eb 05                	jmp    10551d <perm2str+0x3b>
  105518:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10551d:	a2 0a af 11 00       	mov    %al,0x11af0a
    str[3] = '\0';
  105522:	c6 05 0b af 11 00 00 	movb   $0x0,0x11af0b
    return str;
  105529:	b8 08 af 11 00       	mov    $0x11af08,%eax
}
  10552e:	5d                   	pop    %ebp
  10552f:	c3                   	ret    

00105530 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105530:	55                   	push   %ebp
  105531:	89 e5                	mov    %esp,%ebp
  105533:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105536:	8b 45 10             	mov    0x10(%ebp),%eax
  105539:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10553c:	72 0a                	jb     105548 <get_pgtable_items+0x18>
        return 0;
  10553e:	b8 00 00 00 00       	mov    $0x0,%eax
  105543:	e9 9c 00 00 00       	jmp    1055e4 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105548:	eb 04                	jmp    10554e <get_pgtable_items+0x1e>
        start ++;
  10554a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  10554e:	8b 45 10             	mov    0x10(%ebp),%eax
  105551:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105554:	73 18                	jae    10556e <get_pgtable_items+0x3e>
  105556:	8b 45 10             	mov    0x10(%ebp),%eax
  105559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105560:	8b 45 14             	mov    0x14(%ebp),%eax
  105563:	01 d0                	add    %edx,%eax
  105565:	8b 00                	mov    (%eax),%eax
  105567:	83 e0 01             	and    $0x1,%eax
  10556a:	85 c0                	test   %eax,%eax
  10556c:	74 dc                	je     10554a <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  10556e:	8b 45 10             	mov    0x10(%ebp),%eax
  105571:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105574:	73 69                	jae    1055df <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105576:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10557a:	74 08                	je     105584 <get_pgtable_items+0x54>
            *left_store = start;
  10557c:	8b 45 18             	mov    0x18(%ebp),%eax
  10557f:	8b 55 10             	mov    0x10(%ebp),%edx
  105582:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105584:	8b 45 10             	mov    0x10(%ebp),%eax
  105587:	8d 50 01             	lea    0x1(%eax),%edx
  10558a:	89 55 10             	mov    %edx,0x10(%ebp)
  10558d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105594:	8b 45 14             	mov    0x14(%ebp),%eax
  105597:	01 d0                	add    %edx,%eax
  105599:	8b 00                	mov    (%eax),%eax
  10559b:	83 e0 07             	and    $0x7,%eax
  10559e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1055a1:	eb 04                	jmp    1055a7 <get_pgtable_items+0x77>
            start ++;
  1055a3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1055a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1055aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1055ad:	73 1d                	jae    1055cc <get_pgtable_items+0x9c>
  1055af:	8b 45 10             	mov    0x10(%ebp),%eax
  1055b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1055b9:	8b 45 14             	mov    0x14(%ebp),%eax
  1055bc:	01 d0                	add    %edx,%eax
  1055be:	8b 00                	mov    (%eax),%eax
  1055c0:	83 e0 07             	and    $0x7,%eax
  1055c3:	89 c2                	mov    %eax,%edx
  1055c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055c8:	39 c2                	cmp    %eax,%edx
  1055ca:	74 d7                	je     1055a3 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1055cc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1055d0:	74 08                	je     1055da <get_pgtable_items+0xaa>
            *right_store = start;
  1055d2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1055d5:	8b 55 10             	mov    0x10(%ebp),%edx
  1055d8:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1055da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055dd:	eb 05                	jmp    1055e4 <get_pgtable_items+0xb4>
    }
    return 0;
  1055df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1055e4:	c9                   	leave  
  1055e5:	c3                   	ret    

001055e6 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1055e6:	55                   	push   %ebp
  1055e7:	89 e5                	mov    %esp,%ebp
  1055e9:	57                   	push   %edi
  1055ea:	56                   	push   %esi
  1055eb:	53                   	push   %ebx
  1055ec:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1055ef:	c7 04 24 24 73 10 00 	movl   $0x107324,(%esp)
  1055f6:	e8 4d ad ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
  1055fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105602:	e9 fa 00 00 00       	jmp    105701 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10560a:	89 04 24             	mov    %eax,(%esp)
  10560d:	e8 d0 fe ff ff       	call   1054e2 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105612:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105615:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105618:	29 d1                	sub    %edx,%ecx
  10561a:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10561c:	89 d6                	mov    %edx,%esi
  10561e:	c1 e6 16             	shl    $0x16,%esi
  105621:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105624:	89 d3                	mov    %edx,%ebx
  105626:	c1 e3 16             	shl    $0x16,%ebx
  105629:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10562c:	89 d1                	mov    %edx,%ecx
  10562e:	c1 e1 16             	shl    $0x16,%ecx
  105631:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105634:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105637:	29 d7                	sub    %edx,%edi
  105639:	89 fa                	mov    %edi,%edx
  10563b:	89 44 24 14          	mov    %eax,0x14(%esp)
  10563f:	89 74 24 10          	mov    %esi,0x10(%esp)
  105643:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105647:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10564b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10564f:	c7 04 24 55 73 10 00 	movl   $0x107355,(%esp)
  105656:	e8 ed ac ff ff       	call   100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  10565b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10565e:	c1 e0 0a             	shl    $0xa,%eax
  105661:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105664:	eb 54                	jmp    1056ba <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105669:	89 04 24             	mov    %eax,(%esp)
  10566c:	e8 71 fe ff ff       	call   1054e2 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105671:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105674:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105677:	29 d1                	sub    %edx,%ecx
  105679:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10567b:	89 d6                	mov    %edx,%esi
  10567d:	c1 e6 0c             	shl    $0xc,%esi
  105680:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105683:	89 d3                	mov    %edx,%ebx
  105685:	c1 e3 0c             	shl    $0xc,%ebx
  105688:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10568b:	c1 e2 0c             	shl    $0xc,%edx
  10568e:	89 d1                	mov    %edx,%ecx
  105690:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105693:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105696:	29 d7                	sub    %edx,%edi
  105698:	89 fa                	mov    %edi,%edx
  10569a:	89 44 24 14          	mov    %eax,0x14(%esp)
  10569e:	89 74 24 10          	mov    %esi,0x10(%esp)
  1056a2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1056a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1056aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056ae:	c7 04 24 74 73 10 00 	movl   $0x107374,(%esp)
  1056b5:	e8 8e ac ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1056ba:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1056bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1056c2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1056c5:	89 ce                	mov    %ecx,%esi
  1056c7:	c1 e6 0a             	shl    $0xa,%esi
  1056ca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1056cd:	89 cb                	mov    %ecx,%ebx
  1056cf:	c1 e3 0a             	shl    $0xa,%ebx
  1056d2:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1056d5:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1056d9:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1056dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1056e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1056e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1056e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  1056ec:	89 1c 24             	mov    %ebx,(%esp)
  1056ef:	e8 3c fe ff ff       	call   105530 <get_pgtable_items>
  1056f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1056f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1056fb:	0f 85 65 ff ff ff    	jne    105666 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105701:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  105706:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105709:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10570c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105710:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105713:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105717:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10571b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10571f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105726:	00 
  105727:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10572e:	e8 fd fd ff ff       	call   105530 <get_pgtable_items>
  105733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105736:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10573a:	0f 85 c7 fe ff ff    	jne    105607 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105740:	c7 04 24 98 73 10 00 	movl   $0x107398,(%esp)
  105747:	e8 fc ab ff ff       	call   100348 <cprintf>
}
  10574c:	83 c4 4c             	add    $0x4c,%esp
  10574f:	5b                   	pop    %ebx
  105750:	5e                   	pop    %esi
  105751:	5f                   	pop    %edi
  105752:	5d                   	pop    %ebp
  105753:	c3                   	ret    

00105754 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105754:	55                   	push   %ebp
  105755:	89 e5                	mov    %esp,%ebp
  105757:	83 ec 58             	sub    $0x58,%esp
  10575a:	8b 45 10             	mov    0x10(%ebp),%eax
  10575d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105760:	8b 45 14             	mov    0x14(%ebp),%eax
  105763:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105766:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105769:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10576c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10576f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105772:	8b 45 18             	mov    0x18(%ebp),%eax
  105775:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10577b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10577e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105781:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105787:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10578a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10578e:	74 1c                	je     1057ac <printnum+0x58>
  105790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105793:	ba 00 00 00 00       	mov    $0x0,%edx
  105798:	f7 75 e4             	divl   -0x1c(%ebp)
  10579b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10579e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057a1:	ba 00 00 00 00       	mov    $0x0,%edx
  1057a6:	f7 75 e4             	divl   -0x1c(%ebp)
  1057a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057b2:	f7 75 e4             	divl   -0x1c(%ebp)
  1057b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1057b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1057bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1057c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057c4:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1057c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1057ca:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1057cd:	8b 45 18             	mov    0x18(%ebp),%eax
  1057d0:	ba 00 00 00 00       	mov    $0x0,%edx
  1057d5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1057d8:	77 56                	ja     105830 <printnum+0xdc>
  1057da:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1057dd:	72 05                	jb     1057e4 <printnum+0x90>
  1057df:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1057e2:	77 4c                	ja     105830 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1057e4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1057e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1057ea:	8b 45 20             	mov    0x20(%ebp),%eax
  1057ed:	89 44 24 18          	mov    %eax,0x18(%esp)
  1057f1:	89 54 24 14          	mov    %edx,0x14(%esp)
  1057f5:	8b 45 18             	mov    0x18(%ebp),%eax
  1057f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1057fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105802:	89 44 24 08          	mov    %eax,0x8(%esp)
  105806:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10580a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10580d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105811:	8b 45 08             	mov    0x8(%ebp),%eax
  105814:	89 04 24             	mov    %eax,(%esp)
  105817:	e8 38 ff ff ff       	call   105754 <printnum>
  10581c:	eb 1c                	jmp    10583a <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10581e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105821:	89 44 24 04          	mov    %eax,0x4(%esp)
  105825:	8b 45 20             	mov    0x20(%ebp),%eax
  105828:	89 04 24             	mov    %eax,(%esp)
  10582b:	8b 45 08             	mov    0x8(%ebp),%eax
  10582e:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105830:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105834:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105838:	7f e4                	jg     10581e <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10583a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10583d:	05 4c 74 10 00       	add    $0x10744c,%eax
  105842:	0f b6 00             	movzbl (%eax),%eax
  105845:	0f be c0             	movsbl %al,%eax
  105848:	8b 55 0c             	mov    0xc(%ebp),%edx
  10584b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10584f:	89 04 24             	mov    %eax,(%esp)
  105852:	8b 45 08             	mov    0x8(%ebp),%eax
  105855:	ff d0                	call   *%eax
}
  105857:	c9                   	leave  
  105858:	c3                   	ret    

00105859 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105859:	55                   	push   %ebp
  10585a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10585c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105860:	7e 14                	jle    105876 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105862:	8b 45 08             	mov    0x8(%ebp),%eax
  105865:	8b 00                	mov    (%eax),%eax
  105867:	8d 48 08             	lea    0x8(%eax),%ecx
  10586a:	8b 55 08             	mov    0x8(%ebp),%edx
  10586d:	89 0a                	mov    %ecx,(%edx)
  10586f:	8b 50 04             	mov    0x4(%eax),%edx
  105872:	8b 00                	mov    (%eax),%eax
  105874:	eb 30                	jmp    1058a6 <getuint+0x4d>
    }
    else if (lflag) {
  105876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10587a:	74 16                	je     105892 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10587c:	8b 45 08             	mov    0x8(%ebp),%eax
  10587f:	8b 00                	mov    (%eax),%eax
  105881:	8d 48 04             	lea    0x4(%eax),%ecx
  105884:	8b 55 08             	mov    0x8(%ebp),%edx
  105887:	89 0a                	mov    %ecx,(%edx)
  105889:	8b 00                	mov    (%eax),%eax
  10588b:	ba 00 00 00 00       	mov    $0x0,%edx
  105890:	eb 14                	jmp    1058a6 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105892:	8b 45 08             	mov    0x8(%ebp),%eax
  105895:	8b 00                	mov    (%eax),%eax
  105897:	8d 48 04             	lea    0x4(%eax),%ecx
  10589a:	8b 55 08             	mov    0x8(%ebp),%edx
  10589d:	89 0a                	mov    %ecx,(%edx)
  10589f:	8b 00                	mov    (%eax),%eax
  1058a1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1058a6:	5d                   	pop    %ebp
  1058a7:	c3                   	ret    

001058a8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1058a8:	55                   	push   %ebp
  1058a9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1058ab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1058af:	7e 14                	jle    1058c5 <getint+0x1d>
        return va_arg(*ap, long long);
  1058b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1058b4:	8b 00                	mov    (%eax),%eax
  1058b6:	8d 48 08             	lea    0x8(%eax),%ecx
  1058b9:	8b 55 08             	mov    0x8(%ebp),%edx
  1058bc:	89 0a                	mov    %ecx,(%edx)
  1058be:	8b 50 04             	mov    0x4(%eax),%edx
  1058c1:	8b 00                	mov    (%eax),%eax
  1058c3:	eb 28                	jmp    1058ed <getint+0x45>
    }
    else if (lflag) {
  1058c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1058c9:	74 12                	je     1058dd <getint+0x35>
        return va_arg(*ap, long);
  1058cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ce:	8b 00                	mov    (%eax),%eax
  1058d0:	8d 48 04             	lea    0x4(%eax),%ecx
  1058d3:	8b 55 08             	mov    0x8(%ebp),%edx
  1058d6:	89 0a                	mov    %ecx,(%edx)
  1058d8:	8b 00                	mov    (%eax),%eax
  1058da:	99                   	cltd   
  1058db:	eb 10                	jmp    1058ed <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1058dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e0:	8b 00                	mov    (%eax),%eax
  1058e2:	8d 48 04             	lea    0x4(%eax),%ecx
  1058e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1058e8:	89 0a                	mov    %ecx,(%edx)
  1058ea:	8b 00                	mov    (%eax),%eax
  1058ec:	99                   	cltd   
    }
}
  1058ed:	5d                   	pop    %ebp
  1058ee:	c3                   	ret    

001058ef <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1058ef:	55                   	push   %ebp
  1058f0:	89 e5                	mov    %esp,%ebp
  1058f2:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1058f5:	8d 45 14             	lea    0x14(%ebp),%eax
  1058f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1058fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105902:	8b 45 10             	mov    0x10(%ebp),%eax
  105905:	89 44 24 08          	mov    %eax,0x8(%esp)
  105909:	8b 45 0c             	mov    0xc(%ebp),%eax
  10590c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105910:	8b 45 08             	mov    0x8(%ebp),%eax
  105913:	89 04 24             	mov    %eax,(%esp)
  105916:	e8 02 00 00 00       	call   10591d <vprintfmt>
    va_end(ap);
}
  10591b:	c9                   	leave  
  10591c:	c3                   	ret    

0010591d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10591d:	55                   	push   %ebp
  10591e:	89 e5                	mov    %esp,%ebp
  105920:	56                   	push   %esi
  105921:	53                   	push   %ebx
  105922:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105925:	eb 18                	jmp    10593f <vprintfmt+0x22>
            if (ch == '\0') {
  105927:	85 db                	test   %ebx,%ebx
  105929:	75 05                	jne    105930 <vprintfmt+0x13>
                return;
  10592b:	e9 d1 03 00 00       	jmp    105d01 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105930:	8b 45 0c             	mov    0xc(%ebp),%eax
  105933:	89 44 24 04          	mov    %eax,0x4(%esp)
  105937:	89 1c 24             	mov    %ebx,(%esp)
  10593a:	8b 45 08             	mov    0x8(%ebp),%eax
  10593d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10593f:	8b 45 10             	mov    0x10(%ebp),%eax
  105942:	8d 50 01             	lea    0x1(%eax),%edx
  105945:	89 55 10             	mov    %edx,0x10(%ebp)
  105948:	0f b6 00             	movzbl (%eax),%eax
  10594b:	0f b6 d8             	movzbl %al,%ebx
  10594e:	83 fb 25             	cmp    $0x25,%ebx
  105951:	75 d4                	jne    105927 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105953:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105957:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10595e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105961:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105964:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10596b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10596e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105971:	8b 45 10             	mov    0x10(%ebp),%eax
  105974:	8d 50 01             	lea    0x1(%eax),%edx
  105977:	89 55 10             	mov    %edx,0x10(%ebp)
  10597a:	0f b6 00             	movzbl (%eax),%eax
  10597d:	0f b6 d8             	movzbl %al,%ebx
  105980:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105983:	83 f8 55             	cmp    $0x55,%eax
  105986:	0f 87 44 03 00 00    	ja     105cd0 <vprintfmt+0x3b3>
  10598c:	8b 04 85 70 74 10 00 	mov    0x107470(,%eax,4),%eax
  105993:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105995:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105999:	eb d6                	jmp    105971 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10599b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10599f:	eb d0                	jmp    105971 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1059a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1059a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1059ab:	89 d0                	mov    %edx,%eax
  1059ad:	c1 e0 02             	shl    $0x2,%eax
  1059b0:	01 d0                	add    %edx,%eax
  1059b2:	01 c0                	add    %eax,%eax
  1059b4:	01 d8                	add    %ebx,%eax
  1059b6:	83 e8 30             	sub    $0x30,%eax
  1059b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1059bc:	8b 45 10             	mov    0x10(%ebp),%eax
  1059bf:	0f b6 00             	movzbl (%eax),%eax
  1059c2:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1059c5:	83 fb 2f             	cmp    $0x2f,%ebx
  1059c8:	7e 0b                	jle    1059d5 <vprintfmt+0xb8>
  1059ca:	83 fb 39             	cmp    $0x39,%ebx
  1059cd:	7f 06                	jg     1059d5 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1059cf:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1059d3:	eb d3                	jmp    1059a8 <vprintfmt+0x8b>
            goto process_precision;
  1059d5:	eb 33                	jmp    105a0a <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1059d7:	8b 45 14             	mov    0x14(%ebp),%eax
  1059da:	8d 50 04             	lea    0x4(%eax),%edx
  1059dd:	89 55 14             	mov    %edx,0x14(%ebp)
  1059e0:	8b 00                	mov    (%eax),%eax
  1059e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1059e5:	eb 23                	jmp    105a0a <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1059e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059eb:	79 0c                	jns    1059f9 <vprintfmt+0xdc>
                width = 0;
  1059ed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1059f4:	e9 78 ff ff ff       	jmp    105971 <vprintfmt+0x54>
  1059f9:	e9 73 ff ff ff       	jmp    105971 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1059fe:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105a05:	e9 67 ff ff ff       	jmp    105971 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105a0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a0e:	79 12                	jns    105a22 <vprintfmt+0x105>
                width = precision, precision = -1;
  105a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a13:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105a16:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105a1d:	e9 4f ff ff ff       	jmp    105971 <vprintfmt+0x54>
  105a22:	e9 4a ff ff ff       	jmp    105971 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105a27:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105a2b:	e9 41 ff ff ff       	jmp    105971 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105a30:	8b 45 14             	mov    0x14(%ebp),%eax
  105a33:	8d 50 04             	lea    0x4(%eax),%edx
  105a36:	89 55 14             	mov    %edx,0x14(%ebp)
  105a39:	8b 00                	mov    (%eax),%eax
  105a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a3e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105a42:	89 04 24             	mov    %eax,(%esp)
  105a45:	8b 45 08             	mov    0x8(%ebp),%eax
  105a48:	ff d0                	call   *%eax
            break;
  105a4a:	e9 ac 02 00 00       	jmp    105cfb <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  105a52:	8d 50 04             	lea    0x4(%eax),%edx
  105a55:	89 55 14             	mov    %edx,0x14(%ebp)
  105a58:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105a5a:	85 db                	test   %ebx,%ebx
  105a5c:	79 02                	jns    105a60 <vprintfmt+0x143>
                err = -err;
  105a5e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105a60:	83 fb 06             	cmp    $0x6,%ebx
  105a63:	7f 0b                	jg     105a70 <vprintfmt+0x153>
  105a65:	8b 34 9d 30 74 10 00 	mov    0x107430(,%ebx,4),%esi
  105a6c:	85 f6                	test   %esi,%esi
  105a6e:	75 23                	jne    105a93 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105a70:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105a74:	c7 44 24 08 5d 74 10 	movl   $0x10745d,0x8(%esp)
  105a7b:	00 
  105a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a83:	8b 45 08             	mov    0x8(%ebp),%eax
  105a86:	89 04 24             	mov    %eax,(%esp)
  105a89:	e8 61 fe ff ff       	call   1058ef <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105a8e:	e9 68 02 00 00       	jmp    105cfb <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105a93:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105a97:	c7 44 24 08 66 74 10 	movl   $0x107466,0x8(%esp)
  105a9e:	00 
  105a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa9:	89 04 24             	mov    %eax,(%esp)
  105aac:	e8 3e fe ff ff       	call   1058ef <printfmt>
            }
            break;
  105ab1:	e9 45 02 00 00       	jmp    105cfb <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105ab6:	8b 45 14             	mov    0x14(%ebp),%eax
  105ab9:	8d 50 04             	lea    0x4(%eax),%edx
  105abc:	89 55 14             	mov    %edx,0x14(%ebp)
  105abf:	8b 30                	mov    (%eax),%esi
  105ac1:	85 f6                	test   %esi,%esi
  105ac3:	75 05                	jne    105aca <vprintfmt+0x1ad>
                p = "(null)";
  105ac5:	be 69 74 10 00       	mov    $0x107469,%esi
            }
            if (width > 0 && padc != '-') {
  105aca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105ace:	7e 3e                	jle    105b0e <vprintfmt+0x1f1>
  105ad0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105ad4:	74 38                	je     105b0e <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105ad6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105ad9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ae0:	89 34 24             	mov    %esi,(%esp)
  105ae3:	e8 15 03 00 00       	call   105dfd <strnlen>
  105ae8:	29 c3                	sub    %eax,%ebx
  105aea:	89 d8                	mov    %ebx,%eax
  105aec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105aef:	eb 17                	jmp    105b08 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105af1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  105af8:	89 54 24 04          	mov    %edx,0x4(%esp)
  105afc:	89 04 24             	mov    %eax,(%esp)
  105aff:	8b 45 08             	mov    0x8(%ebp),%eax
  105b02:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105b04:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105b08:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b0c:	7f e3                	jg     105af1 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105b0e:	eb 38                	jmp    105b48 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105b10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105b14:	74 1f                	je     105b35 <vprintfmt+0x218>
  105b16:	83 fb 1f             	cmp    $0x1f,%ebx
  105b19:	7e 05                	jle    105b20 <vprintfmt+0x203>
  105b1b:	83 fb 7e             	cmp    $0x7e,%ebx
  105b1e:	7e 15                	jle    105b35 <vprintfmt+0x218>
                    putch('?', putdat);
  105b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b23:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b27:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b31:	ff d0                	call   *%eax
  105b33:	eb 0f                	jmp    105b44 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b3c:	89 1c 24             	mov    %ebx,(%esp)
  105b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b42:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105b44:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105b48:	89 f0                	mov    %esi,%eax
  105b4a:	8d 70 01             	lea    0x1(%eax),%esi
  105b4d:	0f b6 00             	movzbl (%eax),%eax
  105b50:	0f be d8             	movsbl %al,%ebx
  105b53:	85 db                	test   %ebx,%ebx
  105b55:	74 10                	je     105b67 <vprintfmt+0x24a>
  105b57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105b5b:	78 b3                	js     105b10 <vprintfmt+0x1f3>
  105b5d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105b61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105b65:	79 a9                	jns    105b10 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105b67:	eb 17                	jmp    105b80 <vprintfmt+0x263>
                putch(' ', putdat);
  105b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b70:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105b77:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7a:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105b7c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105b80:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b84:	7f e3                	jg     105b69 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105b86:	e9 70 01 00 00       	jmp    105cfb <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b92:	8d 45 14             	lea    0x14(%ebp),%eax
  105b95:	89 04 24             	mov    %eax,(%esp)
  105b98:	e8 0b fd ff ff       	call   1058a8 <getint>
  105b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ba0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ba9:	85 d2                	test   %edx,%edx
  105bab:	79 26                	jns    105bd3 <vprintfmt+0x2b6>
                putch('-', putdat);
  105bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bb4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbe:	ff d0                	call   *%eax
                num = -(long long)num;
  105bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105bc6:	f7 d8                	neg    %eax
  105bc8:	83 d2 00             	adc    $0x0,%edx
  105bcb:	f7 da                	neg    %edx
  105bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105bd3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105bda:	e9 a8 00 00 00       	jmp    105c87 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105bdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105be2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105be6:	8d 45 14             	lea    0x14(%ebp),%eax
  105be9:	89 04 24             	mov    %eax,(%esp)
  105bec:	e8 68 fc ff ff       	call   105859 <getuint>
  105bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105bf7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105bfe:	e9 84 00 00 00       	jmp    105c87 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105c03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105c06:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c0a:	8d 45 14             	lea    0x14(%ebp),%eax
  105c0d:	89 04 24             	mov    %eax,(%esp)
  105c10:	e8 44 fc ff ff       	call   105859 <getuint>
  105c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105c1b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105c22:	eb 63                	jmp    105c87 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c27:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c2b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105c32:	8b 45 08             	mov    0x8(%ebp),%eax
  105c35:	ff d0                	call   *%eax
            putch('x', putdat);
  105c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c3e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105c45:	8b 45 08             	mov    0x8(%ebp),%eax
  105c48:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  105c4d:	8d 50 04             	lea    0x4(%eax),%edx
  105c50:	89 55 14             	mov    %edx,0x14(%ebp)
  105c53:	8b 00                	mov    (%eax),%eax
  105c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105c5f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105c66:	eb 1f                	jmp    105c87 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c6f:	8d 45 14             	lea    0x14(%ebp),%eax
  105c72:	89 04 24             	mov    %eax,(%esp)
  105c75:	e8 df fb ff ff       	call   105859 <getuint>
  105c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105c80:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105c87:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c8e:	89 54 24 18          	mov    %edx,0x18(%esp)
  105c92:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105c95:	89 54 24 14          	mov    %edx,0x14(%esp)
  105c99:	89 44 24 10          	mov    %eax,0x10(%esp)
  105c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ca3:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ca7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cae:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb5:	89 04 24             	mov    %eax,(%esp)
  105cb8:	e8 97 fa ff ff       	call   105754 <printnum>
            break;
  105cbd:	eb 3c                	jmp    105cfb <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cc6:	89 1c 24             	mov    %ebx,(%esp)
  105cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  105ccc:	ff d0                	call   *%eax
            break;
  105cce:	eb 2b                	jmp    105cfb <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cd7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105cde:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce1:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105ce3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ce7:	eb 04                	jmp    105ced <vprintfmt+0x3d0>
  105ce9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ced:	8b 45 10             	mov    0x10(%ebp),%eax
  105cf0:	83 e8 01             	sub    $0x1,%eax
  105cf3:	0f b6 00             	movzbl (%eax),%eax
  105cf6:	3c 25                	cmp    $0x25,%al
  105cf8:	75 ef                	jne    105ce9 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105cfa:	90                   	nop
        }
    }
  105cfb:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105cfc:	e9 3e fc ff ff       	jmp    10593f <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105d01:	83 c4 40             	add    $0x40,%esp
  105d04:	5b                   	pop    %ebx
  105d05:	5e                   	pop    %esi
  105d06:	5d                   	pop    %ebp
  105d07:	c3                   	ret    

00105d08 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105d08:	55                   	push   %ebp
  105d09:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d0e:	8b 40 08             	mov    0x8(%eax),%eax
  105d11:	8d 50 01             	lea    0x1(%eax),%edx
  105d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d17:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d1d:	8b 10                	mov    (%eax),%edx
  105d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d22:	8b 40 04             	mov    0x4(%eax),%eax
  105d25:	39 c2                	cmp    %eax,%edx
  105d27:	73 12                	jae    105d3b <sprintputch+0x33>
        *b->buf ++ = ch;
  105d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d2c:	8b 00                	mov    (%eax),%eax
  105d2e:	8d 48 01             	lea    0x1(%eax),%ecx
  105d31:	8b 55 0c             	mov    0xc(%ebp),%edx
  105d34:	89 0a                	mov    %ecx,(%edx)
  105d36:	8b 55 08             	mov    0x8(%ebp),%edx
  105d39:	88 10                	mov    %dl,(%eax)
    }
}
  105d3b:	5d                   	pop    %ebp
  105d3c:	c3                   	ret    

00105d3d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105d3d:	55                   	push   %ebp
  105d3e:	89 e5                	mov    %esp,%ebp
  105d40:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105d43:	8d 45 14             	lea    0x14(%ebp),%eax
  105d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d4c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105d50:	8b 45 10             	mov    0x10(%ebp),%eax
  105d53:	89 44 24 08          	mov    %eax,0x8(%esp)
  105d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d61:	89 04 24             	mov    %eax,(%esp)
  105d64:	e8 08 00 00 00       	call   105d71 <vsnprintf>
  105d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105d6f:	c9                   	leave  
  105d70:	c3                   	ret    

00105d71 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105d71:	55                   	push   %ebp
  105d72:	89 e5                	mov    %esp,%ebp
  105d74:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105d77:	8b 45 08             	mov    0x8(%ebp),%eax
  105d7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d80:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d83:	8b 45 08             	mov    0x8(%ebp),%eax
  105d86:	01 d0                	add    %edx,%eax
  105d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105d92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105d96:	74 0a                	je     105da2 <vsnprintf+0x31>
  105d98:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d9e:	39 c2                	cmp    %eax,%edx
  105da0:	76 07                	jbe    105da9 <vsnprintf+0x38>
        return -E_INVAL;
  105da2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105da7:	eb 2a                	jmp    105dd3 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105da9:	8b 45 14             	mov    0x14(%ebp),%eax
  105dac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105db0:	8b 45 10             	mov    0x10(%ebp),%eax
  105db3:	89 44 24 08          	mov    %eax,0x8(%esp)
  105db7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105dba:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dbe:	c7 04 24 08 5d 10 00 	movl   $0x105d08,(%esp)
  105dc5:	e8 53 fb ff ff       	call   10591d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105dcd:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105dd3:	c9                   	leave  
  105dd4:	c3                   	ret    

00105dd5 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105dd5:	55                   	push   %ebp
  105dd6:	89 e5                	mov    %esp,%ebp
  105dd8:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ddb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105de2:	eb 04                	jmp    105de8 <strlen+0x13>
        cnt ++;
  105de4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105de8:	8b 45 08             	mov    0x8(%ebp),%eax
  105deb:	8d 50 01             	lea    0x1(%eax),%edx
  105dee:	89 55 08             	mov    %edx,0x8(%ebp)
  105df1:	0f b6 00             	movzbl (%eax),%eax
  105df4:	84 c0                	test   %al,%al
  105df6:	75 ec                	jne    105de4 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105dfb:	c9                   	leave  
  105dfc:	c3                   	ret    

00105dfd <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105dfd:	55                   	push   %ebp
  105dfe:	89 e5                	mov    %esp,%ebp
  105e00:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105e03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105e0a:	eb 04                	jmp    105e10 <strnlen+0x13>
        cnt ++;
  105e0c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e13:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105e16:	73 10                	jae    105e28 <strnlen+0x2b>
  105e18:	8b 45 08             	mov    0x8(%ebp),%eax
  105e1b:	8d 50 01             	lea    0x1(%eax),%edx
  105e1e:	89 55 08             	mov    %edx,0x8(%ebp)
  105e21:	0f b6 00             	movzbl (%eax),%eax
  105e24:	84 c0                	test   %al,%al
  105e26:	75 e4                	jne    105e0c <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105e2b:	c9                   	leave  
  105e2c:	c3                   	ret    

00105e2d <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105e2d:	55                   	push   %ebp
  105e2e:	89 e5                	mov    %esp,%ebp
  105e30:	57                   	push   %edi
  105e31:	56                   	push   %esi
  105e32:	83 ec 20             	sub    $0x20,%esp
  105e35:	8b 45 08             	mov    0x8(%ebp),%eax
  105e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105e41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e47:	89 d1                	mov    %edx,%ecx
  105e49:	89 c2                	mov    %eax,%edx
  105e4b:	89 ce                	mov    %ecx,%esi
  105e4d:	89 d7                	mov    %edx,%edi
  105e4f:	ac                   	lods   %ds:(%esi),%al
  105e50:	aa                   	stos   %al,%es:(%edi)
  105e51:	84 c0                	test   %al,%al
  105e53:	75 fa                	jne    105e4f <strcpy+0x22>
  105e55:	89 fa                	mov    %edi,%edx
  105e57:	89 f1                	mov    %esi,%ecx
  105e59:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e5c:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105e5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105e65:	83 c4 20             	add    $0x20,%esp
  105e68:	5e                   	pop    %esi
  105e69:	5f                   	pop    %edi
  105e6a:	5d                   	pop    %ebp
  105e6b:	c3                   	ret    

00105e6c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105e6c:	55                   	push   %ebp
  105e6d:	89 e5                	mov    %esp,%ebp
  105e6f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105e72:	8b 45 08             	mov    0x8(%ebp),%eax
  105e75:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105e78:	eb 21                	jmp    105e9b <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e7d:	0f b6 10             	movzbl (%eax),%edx
  105e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e83:	88 10                	mov    %dl,(%eax)
  105e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e88:	0f b6 00             	movzbl (%eax),%eax
  105e8b:	84 c0                	test   %al,%al
  105e8d:	74 04                	je     105e93 <strncpy+0x27>
            src ++;
  105e8f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105e93:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105e97:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105e9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e9f:	75 d9                	jne    105e7a <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105ea1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105ea4:	c9                   	leave  
  105ea5:	c3                   	ret    

00105ea6 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105ea6:	55                   	push   %ebp
  105ea7:	89 e5                	mov    %esp,%ebp
  105ea9:	57                   	push   %edi
  105eaa:	56                   	push   %esi
  105eab:	83 ec 20             	sub    $0x20,%esp
  105eae:	8b 45 08             	mov    0x8(%ebp),%eax
  105eb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ec0:	89 d1                	mov    %edx,%ecx
  105ec2:	89 c2                	mov    %eax,%edx
  105ec4:	89 ce                	mov    %ecx,%esi
  105ec6:	89 d7                	mov    %edx,%edi
  105ec8:	ac                   	lods   %ds:(%esi),%al
  105ec9:	ae                   	scas   %es:(%edi),%al
  105eca:	75 08                	jne    105ed4 <strcmp+0x2e>
  105ecc:	84 c0                	test   %al,%al
  105ece:	75 f8                	jne    105ec8 <strcmp+0x22>
  105ed0:	31 c0                	xor    %eax,%eax
  105ed2:	eb 04                	jmp    105ed8 <strcmp+0x32>
  105ed4:	19 c0                	sbb    %eax,%eax
  105ed6:	0c 01                	or     $0x1,%al
  105ed8:	89 fa                	mov    %edi,%edx
  105eda:	89 f1                	mov    %esi,%ecx
  105edc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105edf:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105ee2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105ee8:	83 c4 20             	add    $0x20,%esp
  105eeb:	5e                   	pop    %esi
  105eec:	5f                   	pop    %edi
  105eed:	5d                   	pop    %ebp
  105eee:	c3                   	ret    

00105eef <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105eef:	55                   	push   %ebp
  105ef0:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105ef2:	eb 0c                	jmp    105f00 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105ef4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ef8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105efc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105f00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f04:	74 1a                	je     105f20 <strncmp+0x31>
  105f06:	8b 45 08             	mov    0x8(%ebp),%eax
  105f09:	0f b6 00             	movzbl (%eax),%eax
  105f0c:	84 c0                	test   %al,%al
  105f0e:	74 10                	je     105f20 <strncmp+0x31>
  105f10:	8b 45 08             	mov    0x8(%ebp),%eax
  105f13:	0f b6 10             	movzbl (%eax),%edx
  105f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f19:	0f b6 00             	movzbl (%eax),%eax
  105f1c:	38 c2                	cmp    %al,%dl
  105f1e:	74 d4                	je     105ef4 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f24:	74 18                	je     105f3e <strncmp+0x4f>
  105f26:	8b 45 08             	mov    0x8(%ebp),%eax
  105f29:	0f b6 00             	movzbl (%eax),%eax
  105f2c:	0f b6 d0             	movzbl %al,%edx
  105f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f32:	0f b6 00             	movzbl (%eax),%eax
  105f35:	0f b6 c0             	movzbl %al,%eax
  105f38:	29 c2                	sub    %eax,%edx
  105f3a:	89 d0                	mov    %edx,%eax
  105f3c:	eb 05                	jmp    105f43 <strncmp+0x54>
  105f3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f43:	5d                   	pop    %ebp
  105f44:	c3                   	ret    

00105f45 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105f45:	55                   	push   %ebp
  105f46:	89 e5                	mov    %esp,%ebp
  105f48:	83 ec 04             	sub    $0x4,%esp
  105f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f4e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105f51:	eb 14                	jmp    105f67 <strchr+0x22>
        if (*s == c) {
  105f53:	8b 45 08             	mov    0x8(%ebp),%eax
  105f56:	0f b6 00             	movzbl (%eax),%eax
  105f59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105f5c:	75 05                	jne    105f63 <strchr+0x1e>
            return (char *)s;
  105f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f61:	eb 13                	jmp    105f76 <strchr+0x31>
        }
        s ++;
  105f63:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105f67:	8b 45 08             	mov    0x8(%ebp),%eax
  105f6a:	0f b6 00             	movzbl (%eax),%eax
  105f6d:	84 c0                	test   %al,%al
  105f6f:	75 e2                	jne    105f53 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f76:	c9                   	leave  
  105f77:	c3                   	ret    

00105f78 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105f78:	55                   	push   %ebp
  105f79:	89 e5                	mov    %esp,%ebp
  105f7b:	83 ec 04             	sub    $0x4,%esp
  105f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f81:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105f84:	eb 11                	jmp    105f97 <strfind+0x1f>
        if (*s == c) {
  105f86:	8b 45 08             	mov    0x8(%ebp),%eax
  105f89:	0f b6 00             	movzbl (%eax),%eax
  105f8c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105f8f:	75 02                	jne    105f93 <strfind+0x1b>
            break;
  105f91:	eb 0e                	jmp    105fa1 <strfind+0x29>
        }
        s ++;
  105f93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105f97:	8b 45 08             	mov    0x8(%ebp),%eax
  105f9a:	0f b6 00             	movzbl (%eax),%eax
  105f9d:	84 c0                	test   %al,%al
  105f9f:	75 e5                	jne    105f86 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105fa1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105fa4:	c9                   	leave  
  105fa5:	c3                   	ret    

00105fa6 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105fa6:	55                   	push   %ebp
  105fa7:	89 e5                	mov    %esp,%ebp
  105fa9:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105fac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105fb3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105fba:	eb 04                	jmp    105fc0 <strtol+0x1a>
        s ++;
  105fbc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  105fc3:	0f b6 00             	movzbl (%eax),%eax
  105fc6:	3c 20                	cmp    $0x20,%al
  105fc8:	74 f2                	je     105fbc <strtol+0x16>
  105fca:	8b 45 08             	mov    0x8(%ebp),%eax
  105fcd:	0f b6 00             	movzbl (%eax),%eax
  105fd0:	3c 09                	cmp    $0x9,%al
  105fd2:	74 e8                	je     105fbc <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  105fd7:	0f b6 00             	movzbl (%eax),%eax
  105fda:	3c 2b                	cmp    $0x2b,%al
  105fdc:	75 06                	jne    105fe4 <strtol+0x3e>
        s ++;
  105fde:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105fe2:	eb 15                	jmp    105ff9 <strtol+0x53>
    }
    else if (*s == '-') {
  105fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  105fe7:	0f b6 00             	movzbl (%eax),%eax
  105fea:	3c 2d                	cmp    $0x2d,%al
  105fec:	75 0b                	jne    105ff9 <strtol+0x53>
        s ++, neg = 1;
  105fee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ff2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105ff9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ffd:	74 06                	je     106005 <strtol+0x5f>
  105fff:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  106003:	75 24                	jne    106029 <strtol+0x83>
  106005:	8b 45 08             	mov    0x8(%ebp),%eax
  106008:	0f b6 00             	movzbl (%eax),%eax
  10600b:	3c 30                	cmp    $0x30,%al
  10600d:	75 1a                	jne    106029 <strtol+0x83>
  10600f:	8b 45 08             	mov    0x8(%ebp),%eax
  106012:	83 c0 01             	add    $0x1,%eax
  106015:	0f b6 00             	movzbl (%eax),%eax
  106018:	3c 78                	cmp    $0x78,%al
  10601a:	75 0d                	jne    106029 <strtol+0x83>
        s += 2, base = 16;
  10601c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  106020:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  106027:	eb 2a                	jmp    106053 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  106029:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10602d:	75 17                	jne    106046 <strtol+0xa0>
  10602f:	8b 45 08             	mov    0x8(%ebp),%eax
  106032:	0f b6 00             	movzbl (%eax),%eax
  106035:	3c 30                	cmp    $0x30,%al
  106037:	75 0d                	jne    106046 <strtol+0xa0>
        s ++, base = 8;
  106039:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10603d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  106044:	eb 0d                	jmp    106053 <strtol+0xad>
    }
    else if (base == 0) {
  106046:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10604a:	75 07                	jne    106053 <strtol+0xad>
        base = 10;
  10604c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  106053:	8b 45 08             	mov    0x8(%ebp),%eax
  106056:	0f b6 00             	movzbl (%eax),%eax
  106059:	3c 2f                	cmp    $0x2f,%al
  10605b:	7e 1b                	jle    106078 <strtol+0xd2>
  10605d:	8b 45 08             	mov    0x8(%ebp),%eax
  106060:	0f b6 00             	movzbl (%eax),%eax
  106063:	3c 39                	cmp    $0x39,%al
  106065:	7f 11                	jg     106078 <strtol+0xd2>
            dig = *s - '0';
  106067:	8b 45 08             	mov    0x8(%ebp),%eax
  10606a:	0f b6 00             	movzbl (%eax),%eax
  10606d:	0f be c0             	movsbl %al,%eax
  106070:	83 e8 30             	sub    $0x30,%eax
  106073:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106076:	eb 48                	jmp    1060c0 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  106078:	8b 45 08             	mov    0x8(%ebp),%eax
  10607b:	0f b6 00             	movzbl (%eax),%eax
  10607e:	3c 60                	cmp    $0x60,%al
  106080:	7e 1b                	jle    10609d <strtol+0xf7>
  106082:	8b 45 08             	mov    0x8(%ebp),%eax
  106085:	0f b6 00             	movzbl (%eax),%eax
  106088:	3c 7a                	cmp    $0x7a,%al
  10608a:	7f 11                	jg     10609d <strtol+0xf7>
            dig = *s - 'a' + 10;
  10608c:	8b 45 08             	mov    0x8(%ebp),%eax
  10608f:	0f b6 00             	movzbl (%eax),%eax
  106092:	0f be c0             	movsbl %al,%eax
  106095:	83 e8 57             	sub    $0x57,%eax
  106098:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10609b:	eb 23                	jmp    1060c0 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10609d:	8b 45 08             	mov    0x8(%ebp),%eax
  1060a0:	0f b6 00             	movzbl (%eax),%eax
  1060a3:	3c 40                	cmp    $0x40,%al
  1060a5:	7e 3d                	jle    1060e4 <strtol+0x13e>
  1060a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1060aa:	0f b6 00             	movzbl (%eax),%eax
  1060ad:	3c 5a                	cmp    $0x5a,%al
  1060af:	7f 33                	jg     1060e4 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1060b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1060b4:	0f b6 00             	movzbl (%eax),%eax
  1060b7:	0f be c0             	movsbl %al,%eax
  1060ba:	83 e8 37             	sub    $0x37,%eax
  1060bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1060c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1060c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  1060c6:	7c 02                	jl     1060ca <strtol+0x124>
            break;
  1060c8:	eb 1a                	jmp    1060e4 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1060ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1060ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  1060d5:	89 c2                	mov    %eax,%edx
  1060d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1060da:	01 d0                	add    %edx,%eax
  1060dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1060df:	e9 6f ff ff ff       	jmp    106053 <strtol+0xad>

    if (endptr) {
  1060e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1060e8:	74 08                	je     1060f2 <strtol+0x14c>
        *endptr = (char *) s;
  1060ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060ed:	8b 55 08             	mov    0x8(%ebp),%edx
  1060f0:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1060f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1060f6:	74 07                	je     1060ff <strtol+0x159>
  1060f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060fb:	f7 d8                	neg    %eax
  1060fd:	eb 03                	jmp    106102 <strtol+0x15c>
  1060ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  106102:	c9                   	leave  
  106103:	c3                   	ret    

00106104 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  106104:	55                   	push   %ebp
  106105:	89 e5                	mov    %esp,%ebp
  106107:	57                   	push   %edi
  106108:	83 ec 24             	sub    $0x24,%esp
  10610b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10610e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106111:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  106115:	8b 55 08             	mov    0x8(%ebp),%edx
  106118:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10611b:	88 45 f7             	mov    %al,-0x9(%ebp)
  10611e:	8b 45 10             	mov    0x10(%ebp),%eax
  106121:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  106124:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  106127:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10612b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10612e:	89 d7                	mov    %edx,%edi
  106130:	f3 aa                	rep stos %al,%es:(%edi)
  106132:	89 fa                	mov    %edi,%edx
  106134:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106137:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10613a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10613d:	83 c4 24             	add    $0x24,%esp
  106140:	5f                   	pop    %edi
  106141:	5d                   	pop    %ebp
  106142:	c3                   	ret    

00106143 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  106143:	55                   	push   %ebp
  106144:	89 e5                	mov    %esp,%ebp
  106146:	57                   	push   %edi
  106147:	56                   	push   %esi
  106148:	53                   	push   %ebx
  106149:	83 ec 30             	sub    $0x30,%esp
  10614c:	8b 45 08             	mov    0x8(%ebp),%eax
  10614f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106152:	8b 45 0c             	mov    0xc(%ebp),%eax
  106155:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106158:	8b 45 10             	mov    0x10(%ebp),%eax
  10615b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10615e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106161:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  106164:	73 42                	jae    1061a8 <memmove+0x65>
  106166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10616c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10616f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106175:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106178:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10617b:	c1 e8 02             	shr    $0x2,%eax
  10617e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  106180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106183:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106186:	89 d7                	mov    %edx,%edi
  106188:	89 c6                	mov    %eax,%esi
  10618a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10618c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10618f:	83 e1 03             	and    $0x3,%ecx
  106192:	74 02                	je     106196 <memmove+0x53>
  106194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106196:	89 f0                	mov    %esi,%eax
  106198:	89 fa                	mov    %edi,%edx
  10619a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10619d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1061a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1061a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1061a6:	eb 36                	jmp    1061de <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1061a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1061ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  1061ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1061b1:	01 c2                	add    %eax,%edx
  1061b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1061b6:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1061b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061bc:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1061bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1061c2:	89 c1                	mov    %eax,%ecx
  1061c4:	89 d8                	mov    %ebx,%eax
  1061c6:	89 d6                	mov    %edx,%esi
  1061c8:	89 c7                	mov    %eax,%edi
  1061ca:	fd                   	std    
  1061cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1061cd:	fc                   	cld    
  1061ce:	89 f8                	mov    %edi,%eax
  1061d0:	89 f2                	mov    %esi,%edx
  1061d2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1061d5:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1061d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  1061db:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1061de:	83 c4 30             	add    $0x30,%esp
  1061e1:	5b                   	pop    %ebx
  1061e2:	5e                   	pop    %esi
  1061e3:	5f                   	pop    %edi
  1061e4:	5d                   	pop    %ebp
  1061e5:	c3                   	ret    

001061e6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1061e6:	55                   	push   %ebp
  1061e7:	89 e5                	mov    %esp,%ebp
  1061e9:	57                   	push   %edi
  1061ea:	56                   	push   %esi
  1061eb:	83 ec 20             	sub    $0x20,%esp
  1061ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1061f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1061f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1061fa:	8b 45 10             	mov    0x10(%ebp),%eax
  1061fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106203:	c1 e8 02             	shr    $0x2,%eax
  106206:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  106208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10620b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10620e:	89 d7                	mov    %edx,%edi
  106210:	89 c6                	mov    %eax,%esi
  106212:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106214:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  106217:	83 e1 03             	and    $0x3,%ecx
  10621a:	74 02                	je     10621e <memcpy+0x38>
  10621c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10621e:	89 f0                	mov    %esi,%eax
  106220:	89 fa                	mov    %edi,%edx
  106222:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106225:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106228:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  10622b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10622e:	83 c4 20             	add    $0x20,%esp
  106231:	5e                   	pop    %esi
  106232:	5f                   	pop    %edi
  106233:	5d                   	pop    %ebp
  106234:	c3                   	ret    

00106235 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  106235:	55                   	push   %ebp
  106236:	89 e5                	mov    %esp,%ebp
  106238:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10623b:	8b 45 08             	mov    0x8(%ebp),%eax
  10623e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  106241:	8b 45 0c             	mov    0xc(%ebp),%eax
  106244:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  106247:	eb 30                	jmp    106279 <memcmp+0x44>
        if (*s1 != *s2) {
  106249:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10624c:	0f b6 10             	movzbl (%eax),%edx
  10624f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106252:	0f b6 00             	movzbl (%eax),%eax
  106255:	38 c2                	cmp    %al,%dl
  106257:	74 18                	je     106271 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106259:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10625c:	0f b6 00             	movzbl (%eax),%eax
  10625f:	0f b6 d0             	movzbl %al,%edx
  106262:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106265:	0f b6 00             	movzbl (%eax),%eax
  106268:	0f b6 c0             	movzbl %al,%eax
  10626b:	29 c2                	sub    %eax,%edx
  10626d:	89 d0                	mov    %edx,%eax
  10626f:	eb 1a                	jmp    10628b <memcmp+0x56>
        }
        s1 ++, s2 ++;
  106271:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  106275:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  106279:	8b 45 10             	mov    0x10(%ebp),%eax
  10627c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10627f:	89 55 10             	mov    %edx,0x10(%ebp)
  106282:	85 c0                	test   %eax,%eax
  106284:	75 c3                	jne    106249 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  106286:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10628b:	c9                   	leave  
  10628c:	c3                   	ret    
