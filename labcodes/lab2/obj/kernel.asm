
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 28 af 11 c0       	mov    $0xc011af28,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 a2 60 00 00       	call   c0106104 <memset>

    cons_init();                // init the console
c0100062:	e8 86 15 00 00       	call   c01015ed <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 a0 62 10 c0 	movl   $0xc01062a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 bc 62 10 c0 	movl   $0xc01062bc,(%esp)
c010007c:	e8 c7 02 00 00       	call   c0100348 <cprintf>

    print_kerninfo();
c0100081:	e8 f6 07 00 00       	call   c010087c <print_kerninfo>

    grade_backtrace();
c0100086:	e8 86 00 00 00       	call   c0100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 cc 45 00 00       	call   c010465c <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 c1 16 00 00       	call   c0101756 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 39 18 00 00       	call   c01018d3 <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 04 0d 00 00       	call   c0100da3 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 20 16 00 00       	call   c01016c4 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	55                   	push   %ebp
c01000a7:	89 e5                	mov    %esp,%ebp
c01000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b3:	00 
c01000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bb:	00 
c01000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c3:	e8 fc 0b 00 00       	call   c0100cc4 <mon_backtrace>
}
c01000c8:	c9                   	leave  
c01000c9:	c3                   	ret    

c01000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000ca:	55                   	push   %ebp
c01000cb:	89 e5                	mov    %esp,%ebp
c01000cd:	53                   	push   %ebx
c01000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000d7:	8d 55 08             	lea    0x8(%ebp),%edx
c01000da:	8b 45 08             	mov    0x8(%ebp),%eax
c01000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e9:	89 04 24             	mov    %eax,(%esp)
c01000ec:	e8 b5 ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000f1:	83 c4 14             	add    $0x14,%esp
c01000f4:	5b                   	pop    %ebx
c01000f5:	5d                   	pop    %ebp
c01000f6:	c3                   	ret    

c01000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f7:	55                   	push   %ebp
c01000f8:	89 e5                	mov    %esp,%ebp
c01000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0100100:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100104:	8b 45 08             	mov    0x8(%ebp),%eax
c0100107:	89 04 24             	mov    %eax,(%esp)
c010010a:	e8 bb ff ff ff       	call   c01000ca <grade_backtrace1>
}
c010010f:	c9                   	leave  
c0100110:	c3                   	ret    

c0100111 <grade_backtrace>:

void
grade_backtrace(void) {
c0100111:	55                   	push   %ebp
c0100112:	89 e5                	mov    %esp,%ebp
c0100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100117:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100123:	ff 
c0100124:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010012f:	e8 c3 ff ff ff       	call   c01000f7 <grade_backtrace0>
}
c0100134:	c9                   	leave  
c0100135:	c3                   	ret    

c0100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100136:	55                   	push   %ebp
c0100137:	89 e5                	mov    %esp,%ebp
c0100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014c:	0f b7 c0             	movzwl %ax,%eax
c010014f:	83 e0 03             	and    $0x3,%eax
c0100152:	89 c2                	mov    %eax,%edx
c0100154:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100159:	89 54 24 08          	mov    %edx,0x8(%esp)
c010015d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100161:	c7 04 24 c1 62 10 c0 	movl   $0xc01062c1,(%esp)
c0100168:	e8 db 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100171:	0f b7 d0             	movzwl %ax,%edx
c0100174:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100179:	89 54 24 08          	mov    %edx,0x8(%esp)
c010017d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100181:	c7 04 24 cf 62 10 c0 	movl   $0xc01062cf,(%esp)
c0100188:	e8 bb 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100191:	0f b7 d0             	movzwl %ax,%edx
c0100194:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100199:	89 54 24 08          	mov    %edx,0x8(%esp)
c010019d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a1:	c7 04 24 dd 62 10 c0 	movl   $0xc01062dd,(%esp)
c01001a8:	e8 9b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b1:	0f b7 d0             	movzwl %ax,%edx
c01001b4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c1:	c7 04 24 eb 62 10 c0 	movl   $0xc01062eb,(%esp)
c01001c8:	e8 7b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d1:	0f b7 d0             	movzwl %ax,%edx
c01001d4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e1:	c7 04 24 f9 62 10 c0 	movl   $0xc01062f9,(%esp)
c01001e8:	e8 5b 01 00 00       	call   c0100348 <cprintf>
    round ++;
c01001ed:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001f2:	83 c0 01             	add    $0x1,%eax
c01001f5:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001fa:	c9                   	leave  
c01001fb:	c3                   	ret    

c01001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001fc:	55                   	push   %ebp
c01001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001ff:	5d                   	pop    %ebp
c0100200:	c3                   	ret    

c0100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100201:	55                   	push   %ebp
c0100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100204:	5d                   	pop    %ebp
c0100205:	c3                   	ret    

c0100206 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100206:	55                   	push   %ebp
c0100207:	89 e5                	mov    %esp,%ebp
c0100209:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020c:	e8 25 ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100211:	c7 04 24 08 63 10 c0 	movl   $0xc0106308,(%esp)
c0100218:	e8 2b 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_user();
c010021d:	e8 da ff ff ff       	call   c01001fc <lab1_switch_to_user>
    lab1_print_cur_status();
c0100222:	e8 0f ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100227:	c7 04 24 28 63 10 c0 	movl   $0xc0106328,(%esp)
c010022e:	e8 15 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_kernel();
c0100233:	e8 c9 ff ff ff       	call   c0100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100238:	e8 f9 fe ff ff       	call   c0100136 <lab1_print_cur_status>
}
c010023d:	c9                   	leave  
c010023e:	c3                   	ret    

c010023f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010023f:	55                   	push   %ebp
c0100240:	89 e5                	mov    %esp,%ebp
c0100242:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100249:	74 13                	je     c010025e <readline+0x1f>
        cprintf("%s", prompt);
c010024b:	8b 45 08             	mov    0x8(%ebp),%eax
c010024e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100252:	c7 04 24 47 63 10 c0 	movl   $0xc0106347,(%esp)
c0100259:	e8 ea 00 00 00       	call   c0100348 <cprintf>
    }
    int i = 0, c;
c010025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100265:	e8 66 01 00 00       	call   c01003d0 <getchar>
c010026a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010026d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100271:	79 07                	jns    c010027a <readline+0x3b>
            return NULL;
c0100273:	b8 00 00 00 00       	mov    $0x0,%eax
c0100278:	eb 79                	jmp    c01002f3 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010027e:	7e 28                	jle    c01002a8 <readline+0x69>
c0100280:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100287:	7f 1f                	jg     c01002a8 <readline+0x69>
            cputchar(c);
c0100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028c:	89 04 24             	mov    %eax,(%esp)
c010028f:	e8 da 00 00 00       	call   c010036e <cputchar>
            buf[i ++] = c;
c0100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100297:	8d 50 01             	lea    0x1(%eax),%edx
c010029a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010029d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a0:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c01002a6:	eb 46                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002a8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002ac:	75 17                	jne    c01002c5 <readline+0x86>
c01002ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b2:	7e 11                	jle    c01002c5 <readline+0x86>
            cputchar(c);
c01002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b7:	89 04 24             	mov    %eax,(%esp)
c01002ba:	e8 af 00 00 00       	call   c010036e <cputchar>
            i --;
c01002bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c3:	eb 29                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c9:	74 06                	je     c01002d1 <readline+0x92>
c01002cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002cf:	75 1d                	jne    c01002ee <readline+0xaf>
            cputchar(c);
c01002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d4:	89 04 24             	mov    %eax,(%esp)
c01002d7:	e8 92 00 00 00       	call   c010036e <cputchar>
            buf[i] = '\0';
c01002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002df:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01002e4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e7:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01002ec:	eb 05                	jmp    c01002f3 <readline+0xb4>
        }
    }
c01002ee:	e9 72 ff ff ff       	jmp    c0100265 <readline+0x26>
}
c01002f3:	c9                   	leave  
c01002f4:	c3                   	ret    

c01002f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f5:	55                   	push   %ebp
c01002f6:	89 e5                	mov    %esp,%ebp
c01002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fe:	89 04 24             	mov    %eax,(%esp)
c0100301:	e8 13 13 00 00       	call   c0101619 <cons_putc>
    (*cnt) ++;
c0100306:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100309:	8b 00                	mov    (%eax),%eax
c010030b:	8d 50 01             	lea    0x1(%eax),%edx
c010030e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100311:	89 10                	mov    %edx,(%eax)
}
c0100313:	c9                   	leave  
c0100314:	c3                   	ret    

c0100315 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100315:	55                   	push   %ebp
c0100316:	89 e5                	mov    %esp,%ebp
c0100318:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100322:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100325:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100329:	8b 45 08             	mov    0x8(%ebp),%eax
c010032c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100330:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100333:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100337:	c7 04 24 f5 02 10 c0 	movl   $0xc01002f5,(%esp)
c010033e:	e8 da 55 00 00       	call   c010591d <vprintfmt>
    return cnt;
c0100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100346:	c9                   	leave  
c0100347:	c3                   	ret    

c0100348 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100348:	55                   	push   %ebp
c0100349:	89 e5                	mov    %esp,%ebp
c010034b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010034e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100354:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100357:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035b:	8b 45 08             	mov    0x8(%ebp),%eax
c010035e:	89 04 24             	mov    %eax,(%esp)
c0100361:	e8 af ff ff ff       	call   c0100315 <vcprintf>
c0100366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036c:	c9                   	leave  
c010036d:	c3                   	ret    

c010036e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010036e:	55                   	push   %ebp
c010036f:	89 e5                	mov    %esp,%ebp
c0100371:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100374:	8b 45 08             	mov    0x8(%ebp),%eax
c0100377:	89 04 24             	mov    %eax,(%esp)
c010037a:	e8 9a 12 00 00       	call   c0101619 <cons_putc>
}
c010037f:	c9                   	leave  
c0100380:	c3                   	ret    

c0100381 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100381:	55                   	push   %ebp
c0100382:	89 e5                	mov    %esp,%ebp
c0100384:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038e:	eb 13                	jmp    c01003a3 <cputs+0x22>
        cputch(c, &cnt);
c0100390:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100397:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039b:	89 04 24             	mov    %eax,(%esp)
c010039e:	e8 52 ff ff ff       	call   c01002f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a6:	8d 50 01             	lea    0x1(%eax),%edx
c01003a9:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ac:	0f b6 00             	movzbl (%eax),%eax
c01003af:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b6:	75 d8                	jne    c0100390 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c6:	e8 2a ff ff ff       	call   c01002f5 <cputch>
    return cnt;
c01003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ce:	c9                   	leave  
c01003cf:	c3                   	ret    

c01003d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d0:	55                   	push   %ebp
c01003d1:	89 e5                	mov    %esp,%ebp
c01003d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d6:	e8 7a 12 00 00       	call   c0101655 <cons_getc>
c01003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e2:	74 f2                	je     c01003d6 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003e7:	c9                   	leave  
c01003e8:	c3                   	ret    

c01003e9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003e9:	55                   	push   %ebp
c01003ea:	89 e5                	mov    %esp,%ebp
c01003ec:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f2:	8b 00                	mov    (%eax),%eax
c01003f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fa:	8b 00                	mov    (%eax),%eax
c01003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100406:	e9 d2 00 00 00       	jmp    c01004dd <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010040e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100411:	01 d0                	add    %edx,%eax
c0100413:	89 c2                	mov    %eax,%edx
c0100415:	c1 ea 1f             	shr    $0x1f,%edx
c0100418:	01 d0                	add    %edx,%eax
c010041a:	d1 f8                	sar    %eax
c010041c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100422:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100425:	eb 04                	jmp    c010042b <stab_binsearch+0x42>
            m --;
c0100427:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010042e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100431:	7c 1f                	jl     c0100452 <stab_binsearch+0x69>
c0100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100436:	89 d0                	mov    %edx,%eax
c0100438:	01 c0                	add    %eax,%eax
c010043a:	01 d0                	add    %edx,%eax
c010043c:	c1 e0 02             	shl    $0x2,%eax
c010043f:	89 c2                	mov    %eax,%edx
c0100441:	8b 45 08             	mov    0x8(%ebp),%eax
c0100444:	01 d0                	add    %edx,%eax
c0100446:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044a:	0f b6 c0             	movzbl %al,%eax
c010044d:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100450:	75 d5                	jne    c0100427 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100452:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100455:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100458:	7d 0b                	jge    c0100465 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010045d:	83 c0 01             	add    $0x1,%eax
c0100460:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100463:	eb 78                	jmp    c01004dd <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100465:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010046f:	89 d0                	mov    %edx,%eax
c0100471:	01 c0                	add    %eax,%eax
c0100473:	01 d0                	add    %edx,%eax
c0100475:	c1 e0 02             	shl    $0x2,%eax
c0100478:	89 c2                	mov    %eax,%edx
c010047a:	8b 45 08             	mov    0x8(%ebp),%eax
c010047d:	01 d0                	add    %edx,%eax
c010047f:	8b 40 08             	mov    0x8(%eax),%eax
c0100482:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100485:	73 13                	jae    c010049a <stab_binsearch+0xb1>
            *region_left = m;
c0100487:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100492:	83 c0 01             	add    $0x1,%eax
c0100495:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100498:	eb 43                	jmp    c01004dd <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049d:	89 d0                	mov    %edx,%eax
c010049f:	01 c0                	add    %eax,%eax
c01004a1:	01 d0                	add    %edx,%eax
c01004a3:	c1 e0 02             	shl    $0x2,%eax
c01004a6:	89 c2                	mov    %eax,%edx
c01004a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ab:	01 d0                	add    %edx,%eax
c01004ad:	8b 40 08             	mov    0x8(%eax),%eax
c01004b0:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b3:	76 16                	jbe    c01004cb <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	83 e8 01             	sub    $0x1,%eax
c01004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c9:	eb 12                	jmp    c01004dd <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d1:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e3:	0f 8e 22 ff ff ff    	jle    c010040b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004ed:	75 0f                	jne    c01004fe <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f2:	8b 00                	mov    (%eax),%eax
c01004f4:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fa:	89 10                	mov    %edx,(%eax)
c01004fc:	eb 3f                	jmp    c010053d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0100501:	8b 00                	mov    (%eax),%eax
c0100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100506:	eb 04                	jmp    c010050c <stab_binsearch+0x123>
c0100508:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050f:	8b 00                	mov    (%eax),%eax
c0100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100514:	7d 1f                	jge    c0100535 <stab_binsearch+0x14c>
c0100516:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100519:	89 d0                	mov    %edx,%eax
c010051b:	01 c0                	add    %eax,%eax
c010051d:	01 d0                	add    %edx,%eax
c010051f:	c1 e0 02             	shl    $0x2,%eax
c0100522:	89 c2                	mov    %eax,%edx
c0100524:	8b 45 08             	mov    0x8(%ebp),%eax
c0100527:	01 d0                	add    %edx,%eax
c0100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010052d:	0f b6 c0             	movzbl %al,%eax
c0100530:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100533:	75 d3                	jne    c0100508 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100535:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100538:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053b:	89 10                	mov    %edx,(%eax)
    }
}
c010053d:	c9                   	leave  
c010053e:	c3                   	ret    

c010053f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010053f:	55                   	push   %ebp
c0100540:	89 e5                	mov    %esp,%ebp
c0100542:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100545:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100548:	c7 00 4c 63 10 c0    	movl   $0xc010634c,(%eax)
    info->eip_line = 0;
c010054e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100558:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055b:	c7 40 08 4c 63 10 c0 	movl   $0xc010634c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100562:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100565:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100572:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100578:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010057f:	c7 45 f4 c8 75 10 c0 	movl   $0xc01075c8,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100586:	c7 45 f0 04 24 11 c0 	movl   $0xc0112404,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010058d:	c7 45 ec 05 24 11 c0 	movl   $0xc0112405,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100594:	c7 45 e8 b5 4e 11 c0 	movl   $0xc0114eb5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a1:	76 0d                	jbe    c01005b0 <debuginfo_eip+0x71>
c01005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a6:	83 e8 01             	sub    $0x1,%eax
c01005a9:	0f b6 00             	movzbl (%eax),%eax
c01005ac:	84 c0                	test   %al,%al
c01005ae:	74 0a                	je     c01005ba <debuginfo_eip+0x7b>
        return -1;
c01005b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b5:	e9 c0 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005c7:	29 c2                	sub    %eax,%edx
c01005c9:	89 d0                	mov    %edx,%eax
c01005cb:	c1 f8 02             	sar    $0x2,%eax
c01005ce:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d4:	83 e8 01             	sub    $0x1,%eax
c01005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005da:	8b 45 08             	mov    0x8(%ebp),%eax
c01005dd:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005e8:	00 
c01005e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fa:	89 04 24             	mov    %eax,(%esp)
c01005fd:	e8 e7 fd ff ff       	call   c01003e9 <stab_binsearch>
    if (lfile == 0)
c0100602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100605:	85 c0                	test   %eax,%eax
c0100607:	75 0a                	jne    c0100613 <debuginfo_eip+0xd4>
        return -1;
c0100609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060e:	e9 67 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100616:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100619:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010061f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100622:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100626:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010062d:	00 
c010062e:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100631:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100635:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100638:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063f:	89 04 24             	mov    %eax,(%esp)
c0100642:	e8 a2 fd ff ff       	call   c01003e9 <stab_binsearch>

    if (lfun <= rfun) {
c0100647:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010064d:	39 c2                	cmp    %eax,%edx
c010064f:	7f 7c                	jg     c01006cd <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100651:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100654:	89 c2                	mov    %eax,%edx
c0100656:	89 d0                	mov    %edx,%eax
c0100658:	01 c0                	add    %eax,%eax
c010065a:	01 d0                	add    %edx,%eax
c010065c:	c1 e0 02             	shl    $0x2,%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100664:	01 d0                	add    %edx,%eax
c0100666:	8b 10                	mov    (%eax),%edx
c0100668:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066e:	29 c1                	sub    %eax,%ecx
c0100670:	89 c8                	mov    %ecx,%eax
c0100672:	39 c2                	cmp    %eax,%edx
c0100674:	73 22                	jae    c0100698 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100676:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100679:	89 c2                	mov    %eax,%edx
c010067b:	89 d0                	mov    %edx,%eax
c010067d:	01 c0                	add    %eax,%eax
c010067f:	01 d0                	add    %edx,%eax
c0100681:	c1 e0 02             	shl    $0x2,%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100689:	01 d0                	add    %edx,%eax
c010068b:	8b 10                	mov    (%eax),%edx
c010068d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100690:	01 c2                	add    %eax,%edx
c0100692:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100695:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100698:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069b:	89 c2                	mov    %eax,%edx
c010069d:	89 d0                	mov    %edx,%eax
c010069f:	01 c0                	add    %eax,%eax
c01006a1:	01 d0                	add    %edx,%eax
c01006a3:	c1 e0 02             	shl    $0x2,%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ab:	01 d0                	add    %edx,%eax
c01006ad:	8b 50 08             	mov    0x8(%eax),%edx
c01006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b9:	8b 40 10             	mov    0x10(%eax),%eax
c01006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006cb:	eb 15                	jmp    c01006e2 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e5:	8b 40 08             	mov    0x8(%eax),%eax
c01006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006ef:	00 
c01006f0:	89 04 24             	mov    %eax,(%esp)
c01006f3:	e8 80 58 00 00       	call   c0105f78 <strfind>
c01006f8:	89 c2                	mov    %eax,%edx
c01006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006fd:	8b 40 08             	mov    0x8(%eax),%eax
c0100700:	29 c2                	sub    %eax,%edx
c0100702:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100708:	8b 45 08             	mov    0x8(%ebp),%eax
c010070b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100716:	00 
c0100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100721:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100728:	89 04 24             	mov    %eax,(%esp)
c010072b:	e8 b9 fc ff ff       	call   c01003e9 <stab_binsearch>
    if (lline <= rline) {
c0100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100736:	39 c2                	cmp    %eax,%edx
c0100738:	7f 24                	jg     c010075e <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073d:	89 c2                	mov    %eax,%edx
c010073f:	89 d0                	mov    %edx,%eax
c0100741:	01 c0                	add    %eax,%eax
c0100743:	01 d0                	add    %edx,%eax
c0100745:	c1 e0 02             	shl    $0x2,%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074d:	01 d0                	add    %edx,%eax
c010074f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100753:	0f b7 d0             	movzwl %ax,%edx
c0100756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100759:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075c:	eb 13                	jmp    c0100771 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100763:	e9 12 01 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076b:	83 e8 01             	sub    $0x1,%eax
c010076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100777:	39 c2                	cmp    %eax,%edx
c0100779:	7c 56                	jl     c01007d1 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077e:	89 c2                	mov    %eax,%edx
c0100780:	89 d0                	mov    %edx,%eax
c0100782:	01 c0                	add    %eax,%eax
c0100784:	01 d0                	add    %edx,%eax
c0100786:	c1 e0 02             	shl    $0x2,%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078e:	01 d0                	add    %edx,%eax
c0100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100794:	3c 84                	cmp    $0x84,%al
c0100796:	74 39                	je     c01007d1 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	89 d0                	mov    %edx,%eax
c010079f:	01 c0                	add    %eax,%eax
c01007a1:	01 d0                	add    %edx,%eax
c01007a3:	c1 e0 02             	shl    $0x2,%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ab:	01 d0                	add    %edx,%eax
c01007ad:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b1:	3c 64                	cmp    $0x64,%al
c01007b3:	75 b3                	jne    c0100768 <debuginfo_eip+0x229>
c01007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b8:	89 c2                	mov    %eax,%edx
c01007ba:	89 d0                	mov    %edx,%eax
c01007bc:	01 c0                	add    %eax,%eax
c01007be:	01 d0                	add    %edx,%eax
c01007c0:	c1 e0 02             	shl    $0x2,%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c8:	01 d0                	add    %edx,%eax
c01007ca:	8b 40 08             	mov    0x8(%eax),%eax
c01007cd:	85 c0                	test   %eax,%eax
c01007cf:	74 97                	je     c0100768 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007d7:	39 c2                	cmp    %eax,%edx
c01007d9:	7c 46                	jl     c0100821 <debuginfo_eip+0x2e2>
c01007db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007de:	89 c2                	mov    %eax,%edx
c01007e0:	89 d0                	mov    %edx,%eax
c01007e2:	01 c0                	add    %eax,%eax
c01007e4:	01 d0                	add    %edx,%eax
c01007e6:	c1 e0 02             	shl    $0x2,%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ee:	01 d0                	add    %edx,%eax
c01007f0:	8b 10                	mov    (%eax),%edx
c01007f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007f8:	29 c1                	sub    %eax,%ecx
c01007fa:	89 c8                	mov    %ecx,%eax
c01007fc:	39 c2                	cmp    %eax,%edx
c01007fe:	73 21                	jae    c0100821 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100803:	89 c2                	mov    %eax,%edx
c0100805:	89 d0                	mov    %edx,%eax
c0100807:	01 c0                	add    %eax,%eax
c0100809:	01 d0                	add    %edx,%eax
c010080b:	c1 e0 02             	shl    $0x2,%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100813:	01 d0                	add    %edx,%eax
c0100815:	8b 10                	mov    (%eax),%edx
c0100817:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081a:	01 c2                	add    %eax,%edx
c010081c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100821:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100824:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100827:	39 c2                	cmp    %eax,%edx
c0100829:	7d 4a                	jge    c0100875 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082e:	83 c0 01             	add    $0x1,%eax
c0100831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100834:	eb 18                	jmp    c010084e <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100836:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100839:	8b 40 14             	mov    0x14(%eax),%eax
c010083c:	8d 50 01             	lea    0x1(%eax),%edx
c010083f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100842:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100848:	83 c0 01             	add    $0x1,%eax
c010084b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100851:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100854:	39 c2                	cmp    %eax,%edx
c0100856:	7d 1d                	jge    c0100875 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	89 d0                	mov    %edx,%eax
c010085f:	01 c0                	add    %eax,%eax
c0100861:	01 d0                	add    %edx,%eax
c0100863:	c1 e0 02             	shl    $0x2,%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086b:	01 d0                	add    %edx,%eax
c010086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100871:	3c a0                	cmp    $0xa0,%al
c0100873:	74 c1                	je     c0100836 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100875:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087a:	c9                   	leave  
c010087b:	c3                   	ret    

c010087c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087c:	55                   	push   %ebp
c010087d:	89 e5                	mov    %esp,%ebp
c010087f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100882:	c7 04 24 56 63 10 c0 	movl   $0xc0106356,(%esp)
c0100889:	e8 ba fa ff ff       	call   c0100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088e:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100895:	c0 
c0100896:	c7 04 24 6f 63 10 c0 	movl   $0xc010636f,(%esp)
c010089d:	e8 a6 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a2:	c7 44 24 04 8d 62 10 	movl   $0xc010628d,0x4(%esp)
c01008a9:	c0 
c01008aa:	c7 04 24 87 63 10 c0 	movl   $0xc0106387,(%esp)
c01008b1:	e8 92 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b6:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c01008bd:	c0 
c01008be:	c7 04 24 9f 63 10 c0 	movl   $0xc010639f,(%esp)
c01008c5:	e8 7e fa ff ff       	call   c0100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008ca:	c7 44 24 04 28 af 11 	movl   $0xc011af28,0x4(%esp)
c01008d1:	c0 
c01008d2:	c7 04 24 b7 63 10 c0 	movl   $0xc01063b7,(%esp)
c01008d9:	e8 6a fa ff ff       	call   c0100348 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008de:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c01008e3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008e9:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01008ee:	29 c2                	sub    %eax,%edx
c01008f0:	89 d0                	mov    %edx,%eax
c01008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f8:	85 c0                	test   %eax,%eax
c01008fa:	0f 48 c2             	cmovs  %edx,%eax
c01008fd:	c1 f8 0a             	sar    $0xa,%eax
c0100900:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100904:	c7 04 24 d0 63 10 c0 	movl   $0xc01063d0,(%esp)
c010090b:	e8 38 fa ff ff       	call   c0100348 <cprintf>
}
c0100910:	c9                   	leave  
c0100911:	c3                   	ret    

c0100912 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100912:	55                   	push   %ebp
c0100913:	89 e5                	mov    %esp,%ebp
c0100915:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091b:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010091e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100922:	8b 45 08             	mov    0x8(%ebp),%eax
c0100925:	89 04 24             	mov    %eax,(%esp)
c0100928:	e8 12 fc ff ff       	call   c010053f <debuginfo_eip>
c010092d:	85 c0                	test   %eax,%eax
c010092f:	74 15                	je     c0100946 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100931:	8b 45 08             	mov    0x8(%ebp),%eax
c0100934:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100938:	c7 04 24 fa 63 10 c0 	movl   $0xc01063fa,(%esp)
c010093f:	e8 04 fa ff ff       	call   c0100348 <cprintf>
c0100944:	eb 6d                	jmp    c01009b3 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010094d:	eb 1c                	jmp    c010096b <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100955:	01 d0                	add    %edx,%eax
c0100957:	0f b6 00             	movzbl (%eax),%eax
c010095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100963:	01 ca                	add    %ecx,%edx
c0100965:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100971:	7f dc                	jg     c010094f <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097c:	01 d0                	add    %edx,%eax
c010097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100984:	8b 55 08             	mov    0x8(%ebp),%edx
c0100987:	89 d1                	mov    %edx,%ecx
c0100989:	29 c1                	sub    %eax,%ecx
c010098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010099f:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a7:	c7 04 24 16 64 10 c0 	movl   $0xc0106416,(%esp)
c01009ae:	e8 95 f9 ff ff       	call   c0100348 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b3:	c9                   	leave  
c01009b4:	c3                   	ret    

c01009b5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b5:	55                   	push   %ebp
c01009b6:	89 e5                	mov    %esp,%ebp
c01009b8:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009bb:	8b 45 04             	mov    0x4(%ebp),%eax
c01009be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c4:	c9                   	leave  
c01009c5:	c3                   	ret    

c01009c6 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c6:	55                   	push   %ebp
c01009c7:	89 e5                	mov    %esp,%ebp
c01009c9:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cc:	89 e8                	mov    %ebp,%eax
c01009ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t valueEbp = read_ebp();
c01009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t valueEip = read_eip();
c01009d7:	e8 d9 ff ff ff       	call   c01009b5 <read_eip>
c01009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i = 0 ;
c01009df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(i ; i < STACKFRAME_DEPTH; i++) {
c01009e6:	e9 92 00 00 00       	jmp    c0100a7d <print_stackframe+0xb7>
	    if(valueEbp != 0) {
c01009eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01009ef:	0f 84 84 00 00 00    	je     c0100a79 <print_stackframe+0xb3>
		cprintf("ebp:0x%08x eip:0x%08x args:", valueEbp, valueEip);
c01009f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a03:	c7 04 24 28 64 10 c0 	movl   $0xc0106428,(%esp)
c0100a0a:	e8 39 f9 ff ff       	call   c0100348 <cprintf>
		int j = 0;
c0100a0f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for(j ; j < 4; j++) {
c0100a16:	eb 2e                	jmp    c0100a46 <print_stackframe+0x80>
		    uint32_t args =  *((uint32_t*)valueEbp + 2 + j);
c0100a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a25:	01 d0                	add    %edx,%eax
c0100a27:	83 c0 08             	add    $0x8,%eax
c0100a2a:	8b 00                	mov    (%eax),%eax
c0100a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		    cprintf("0x%08x ", args);
c0100a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a36:	c7 04 24 44 64 10 c0 	movl   $0xc0106444,(%esp)
c0100a3d:	e8 06 f9 ff ff       	call   c0100348 <cprintf>
	int i = 0 ;
	for(i ; i < STACKFRAME_DEPTH; i++) {
	    if(valueEbp != 0) {
		cprintf("ebp:0x%08x eip:0x%08x args:", valueEbp, valueEip);
		int j = 0;
		for(j ; j < 4; j++) {
c0100a42:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a46:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4a:	7e cc                	jle    c0100a18 <print_stackframe+0x52>
		    uint32_t args =  *((uint32_t*)valueEbp + 2 + j);
		    cprintf("0x%08x ", args);
		}
		cprintf("\n");
c0100a4c:	c7 04 24 4c 64 10 c0 	movl   $0xc010644c,(%esp)
c0100a53:	e8 f0 f8 ff ff       	call   c0100348 <cprintf>
		print_debuginfo(valueEip - 1);
c0100a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5b:	83 e8 01             	sub    $0x1,%eax
c0100a5e:	89 04 24             	mov    %eax,(%esp)
c0100a61:	e8 ac fe ff ff       	call   c0100912 <print_debuginfo>
		valueEip = *((uint32_t*)valueEbp + 1);
c0100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a69:	83 c0 04             	add    $0x4,%eax
c0100a6c:	8b 00                	mov    (%eax),%eax
c0100a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		valueEbp = *((uint32_t*)valueEbp);
c0100a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a74:	8b 00                	mov    (%eax),%eax
c0100a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t valueEbp = read_ebp();
	uint32_t valueEip = read_eip();
	int i = 0 ;
	for(i ; i < STACKFRAME_DEPTH; i++) {
c0100a79:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a7d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a81:	0f 8e 64 ff ff ff    	jle    c01009eb <print_stackframe+0x25>
		print_debuginfo(valueEip - 1);
		valueEip = *((uint32_t*)valueEbp + 1);
		valueEbp = *((uint32_t*)valueEbp);
	    }
	}
}
c0100a87:	c9                   	leave  
c0100a88:	c3                   	ret    

c0100a89 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a89:	55                   	push   %ebp
c0100a8a:	89 e5                	mov    %esp,%ebp
c0100a8c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a96:	eb 0c                	jmp    c0100aa4 <parse+0x1b>
            *buf ++ = '\0';
c0100a98:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9b:	8d 50 01             	lea    0x1(%eax),%edx
c0100a9e:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa1:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa7:	0f b6 00             	movzbl (%eax),%eax
c0100aaa:	84 c0                	test   %al,%al
c0100aac:	74 1d                	je     c0100acb <parse+0x42>
c0100aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab1:	0f b6 00             	movzbl (%eax),%eax
c0100ab4:	0f be c0             	movsbl %al,%eax
c0100ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100abb:	c7 04 24 d0 64 10 c0 	movl   $0xc01064d0,(%esp)
c0100ac2:	e8 7e 54 00 00       	call   c0105f45 <strchr>
c0100ac7:	85 c0                	test   %eax,%eax
c0100ac9:	75 cd                	jne    c0100a98 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ace:	0f b6 00             	movzbl (%eax),%eax
c0100ad1:	84 c0                	test   %al,%al
c0100ad3:	75 02                	jne    c0100ad7 <parse+0x4e>
            break;
c0100ad5:	eb 67                	jmp    c0100b3e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100adb:	75 14                	jne    c0100af1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100add:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ae4:	00 
c0100ae5:	c7 04 24 d5 64 10 c0 	movl   $0xc01064d5,(%esp)
c0100aec:	e8 57 f8 ff ff       	call   c0100348 <cprintf>
        }
        argv[argc ++] = buf;
c0100af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af4:	8d 50 01             	lea    0x1(%eax),%edx
c0100af7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100afa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b04:	01 c2                	add    %eax,%edx
c0100b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b09:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0b:	eb 04                	jmp    c0100b11 <parse+0x88>
            buf ++;
c0100b0d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b14:	0f b6 00             	movzbl (%eax),%eax
c0100b17:	84 c0                	test   %al,%al
c0100b19:	74 1d                	je     c0100b38 <parse+0xaf>
c0100b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1e:	0f b6 00             	movzbl (%eax),%eax
c0100b21:	0f be c0             	movsbl %al,%eax
c0100b24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b28:	c7 04 24 d0 64 10 c0 	movl   $0xc01064d0,(%esp)
c0100b2f:	e8 11 54 00 00       	call   c0105f45 <strchr>
c0100b34:	85 c0                	test   %eax,%eax
c0100b36:	74 d5                	je     c0100b0d <parse+0x84>
            buf ++;
        }
    }
c0100b38:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b39:	e9 66 ff ff ff       	jmp    c0100aa4 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b41:	c9                   	leave  
c0100b42:	c3                   	ret    

c0100b43 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b43:	55                   	push   %ebp
c0100b44:	89 e5                	mov    %esp,%ebp
c0100b46:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b49:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b53:	89 04 24             	mov    %eax,(%esp)
c0100b56:	e8 2e ff ff ff       	call   c0100a89 <parse>
c0100b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b62:	75 0a                	jne    c0100b6e <runcmd+0x2b>
        return 0;
c0100b64:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b69:	e9 85 00 00 00       	jmp    c0100bf3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b75:	eb 5c                	jmp    c0100bd3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b77:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b7d:	89 d0                	mov    %edx,%eax
c0100b7f:	01 c0                	add    %eax,%eax
c0100b81:	01 d0                	add    %edx,%eax
c0100b83:	c1 e0 02             	shl    $0x2,%eax
c0100b86:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100b8b:	8b 00                	mov    (%eax),%eax
c0100b8d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b91:	89 04 24             	mov    %eax,(%esp)
c0100b94:	e8 0d 53 00 00       	call   c0105ea6 <strcmp>
c0100b99:	85 c0                	test   %eax,%eax
c0100b9b:	75 32                	jne    c0100bcf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba0:	89 d0                	mov    %edx,%eax
c0100ba2:	01 c0                	add    %eax,%eax
c0100ba4:	01 d0                	add    %edx,%eax
c0100ba6:	c1 e0 02             	shl    $0x2,%eax
c0100ba9:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100bae:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bb4:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bba:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bbe:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc1:	83 c2 04             	add    $0x4,%edx
c0100bc4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc8:	89 0c 24             	mov    %ecx,(%esp)
c0100bcb:	ff d0                	call   *%eax
c0100bcd:	eb 24                	jmp    c0100bf3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bcf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd6:	83 f8 02             	cmp    $0x2,%eax
c0100bd9:	76 9c                	jbe    c0100b77 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bdb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bde:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be2:	c7 04 24 f3 64 10 c0 	movl   $0xc01064f3,(%esp)
c0100be9:	e8 5a f7 ff ff       	call   c0100348 <cprintf>
    return 0;
c0100bee:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf3:	c9                   	leave  
c0100bf4:	c3                   	ret    

c0100bf5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf5:	55                   	push   %ebp
c0100bf6:	89 e5                	mov    %esp,%ebp
c0100bf8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bfb:	c7 04 24 0c 65 10 c0 	movl   $0xc010650c,(%esp)
c0100c02:	e8 41 f7 ff ff       	call   c0100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c07:	c7 04 24 34 65 10 c0 	movl   $0xc0106534,(%esp)
c0100c0e:	e8 35 f7 ff ff       	call   c0100348 <cprintf>

    if (tf != NULL) {
c0100c13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c17:	74 0b                	je     c0100c24 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c19:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1c:	89 04 24             	mov    %eax,(%esp)
c0100c1f:	e8 a7 0f 00 00       	call   c0101bcb <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c24:	c7 04 24 59 65 10 c0 	movl   $0xc0106559,(%esp)
c0100c2b:	e8 0f f6 ff ff       	call   c010023f <readline>
c0100c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c37:	74 18                	je     c0100c51 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c39:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c43:	89 04 24             	mov    %eax,(%esp)
c0100c46:	e8 f8 fe ff ff       	call   c0100b43 <runcmd>
c0100c4b:	85 c0                	test   %eax,%eax
c0100c4d:	79 02                	jns    c0100c51 <kmonitor+0x5c>
                break;
c0100c4f:	eb 02                	jmp    c0100c53 <kmonitor+0x5e>
            }
        }
    }
c0100c51:	eb d1                	jmp    c0100c24 <kmonitor+0x2f>
}
c0100c53:	c9                   	leave  
c0100c54:	c3                   	ret    

c0100c55 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c55:	55                   	push   %ebp
c0100c56:	89 e5                	mov    %esp,%ebp
c0100c58:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c62:	eb 3f                	jmp    c0100ca3 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c64:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c67:	89 d0                	mov    %edx,%eax
c0100c69:	01 c0                	add    %eax,%eax
c0100c6b:	01 d0                	add    %edx,%eax
c0100c6d:	c1 e0 02             	shl    $0x2,%eax
c0100c70:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c75:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c78:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7b:	89 d0                	mov    %edx,%eax
c0100c7d:	01 c0                	add    %eax,%eax
c0100c7f:	01 d0                	add    %edx,%eax
c0100c81:	c1 e0 02             	shl    $0x2,%eax
c0100c84:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c89:	8b 00                	mov    (%eax),%eax
c0100c8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c93:	c7 04 24 5d 65 10 c0 	movl   $0xc010655d,(%esp)
c0100c9a:	e8 a9 f6 ff ff       	call   c0100348 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca6:	83 f8 02             	cmp    $0x2,%eax
c0100ca9:	76 b9                	jbe    c0100c64 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb0:	c9                   	leave  
c0100cb1:	c3                   	ret    

c0100cb2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb2:	55                   	push   %ebp
c0100cb3:	89 e5                	mov    %esp,%ebp
c0100cb5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb8:	e8 bf fb ff ff       	call   c010087c <print_kerninfo>
    return 0;
c0100cbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc2:	c9                   	leave  
c0100cc3:	c3                   	ret    

c0100cc4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc4:	55                   	push   %ebp
c0100cc5:	89 e5                	mov    %esp,%ebp
c0100cc7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cca:	e8 f7 fc ff ff       	call   c01009c6 <print_stackframe>
    return 0;
c0100ccf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd4:	c9                   	leave  
c0100cd5:	c3                   	ret    

c0100cd6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cd6:	55                   	push   %ebp
c0100cd7:	89 e5                	mov    %esp,%ebp
c0100cd9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cdc:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c0100ce1:	85 c0                	test   %eax,%eax
c0100ce3:	74 02                	je     c0100ce7 <__panic+0x11>
        goto panic_dead;
c0100ce5:	eb 59                	jmp    c0100d40 <__panic+0x6a>
    }
    is_panic = 1;
c0100ce7:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c0100cee:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf1:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cfa:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d05:	c7 04 24 66 65 10 c0 	movl   $0xc0106566,(%esp)
c0100d0c:	e8 37 f6 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d18:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d1b:	89 04 24             	mov    %eax,(%esp)
c0100d1e:	e8 f2 f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d23:	c7 04 24 82 65 10 c0 	movl   $0xc0106582,(%esp)
c0100d2a:	e8 19 f6 ff ff       	call   c0100348 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d2f:	c7 04 24 84 65 10 c0 	movl   $0xc0106584,(%esp)
c0100d36:	e8 0d f6 ff ff       	call   c0100348 <cprintf>
    print_stackframe();
c0100d3b:	e8 86 fc ff ff       	call   c01009c6 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d40:	e8 85 09 00 00       	call   c01016ca <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d4c:	e8 a4 fe ff ff       	call   c0100bf5 <kmonitor>
    }
c0100d51:	eb f2                	jmp    c0100d45 <__panic+0x6f>

c0100d53 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d53:	55                   	push   %ebp
c0100d54:	89 e5                	mov    %esp,%ebp
c0100d56:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d59:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d62:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d66:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d6d:	c7 04 24 96 65 10 c0 	movl   $0xc0106596,(%esp)
c0100d74:	e8 cf f5 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d80:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d83:	89 04 24             	mov    %eax,(%esp)
c0100d86:	e8 8a f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d8b:	c7 04 24 82 65 10 c0 	movl   $0xc0106582,(%esp)
c0100d92:	e8 b1 f5 ff ff       	call   c0100348 <cprintf>
    va_end(ap);
}
c0100d97:	c9                   	leave  
c0100d98:	c3                   	ret    

c0100d99 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d99:	55                   	push   %ebp
c0100d9a:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d9c:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c0100da1:	5d                   	pop    %ebp
c0100da2:	c3                   	ret    

c0100da3 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100da3:	55                   	push   %ebp
c0100da4:	89 e5                	mov    %esp,%ebp
c0100da6:	83 ec 28             	sub    $0x28,%esp
c0100da9:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100daf:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100db3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100db7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dbb:	ee                   	out    %al,(%dx)
c0100dbc:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dc2:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dc6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dca:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dce:	ee                   	out    %al,(%dx)
c0100dcf:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dd5:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dd9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ddd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100de1:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100de2:	c7 05 0c af 11 c0 00 	movl   $0x0,0xc011af0c
c0100de9:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dec:	c7 04 24 b4 65 10 c0 	movl   $0xc01065b4,(%esp)
c0100df3:	e8 50 f5 ff ff       	call   c0100348 <cprintf>
    pic_enable(IRQ_TIMER);
c0100df8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dff:	e8 24 09 00 00       	call   c0101728 <pic_enable>
}
c0100e04:	c9                   	leave  
c0100e05:	c3                   	ret    

c0100e06 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e06:	55                   	push   %ebp
c0100e07:	89 e5                	mov    %esp,%ebp
c0100e09:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e0c:	9c                   	pushf  
c0100e0d:	58                   	pop    %eax
c0100e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e14:	25 00 02 00 00       	and    $0x200,%eax
c0100e19:	85 c0                	test   %eax,%eax
c0100e1b:	74 0c                	je     c0100e29 <__intr_save+0x23>
        intr_disable();
c0100e1d:	e8 a8 08 00 00       	call   c01016ca <intr_disable>
        return 1;
c0100e22:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e27:	eb 05                	jmp    c0100e2e <__intr_save+0x28>
    }
    return 0;
c0100e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e2e:	c9                   	leave  
c0100e2f:	c3                   	ret    

c0100e30 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e30:	55                   	push   %ebp
c0100e31:	89 e5                	mov    %esp,%ebp
c0100e33:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e3a:	74 05                	je     c0100e41 <__intr_restore+0x11>
        intr_enable();
c0100e3c:	e8 83 08 00 00       	call   c01016c4 <intr_enable>
    }
}
c0100e41:	c9                   	leave  
c0100e42:	c3                   	ret    

c0100e43 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e43:	55                   	push   %ebp
c0100e44:	89 e5                	mov    %esp,%ebp
c0100e46:	83 ec 10             	sub    $0x10,%esp
c0100e49:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e4f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e53:	89 c2                	mov    %eax,%edx
c0100e55:	ec                   	in     (%dx),%al
c0100e56:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e59:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e5f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e63:	89 c2                	mov    %eax,%edx
c0100e65:	ec                   	in     (%dx),%al
c0100e66:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e69:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e6f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e73:	89 c2                	mov    %eax,%edx
c0100e75:	ec                   	in     (%dx),%al
c0100e76:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e79:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e7f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e83:	89 c2                	mov    %eax,%edx
c0100e85:	ec                   	in     (%dx),%al
c0100e86:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e89:	c9                   	leave  
c0100e8a:	c3                   	ret    

c0100e8b <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e8b:	55                   	push   %ebp
c0100e8c:	89 e5                	mov    %esp,%ebp
c0100e8e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e91:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9b:	0f b7 00             	movzwl (%eax),%eax
c0100e9e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea5:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100eaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ead:	0f b7 00             	movzwl (%eax),%eax
c0100eb0:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100eb4:	74 12                	je     c0100ec8 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eb6:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ebd:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100ec4:	b4 03 
c0100ec6:	eb 13                	jmp    c0100edb <cga_init+0x50>
    } else {
        *cp = was;
c0100ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ecb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ecf:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ed2:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100ed9:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100edb:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ee2:	0f b7 c0             	movzwl %ax,%eax
c0100ee5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ee9:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eed:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ef1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ef5:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ef6:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100efd:	83 c0 01             	add    $0x1,%eax
c0100f00:	0f b7 c0             	movzwl %ax,%eax
c0100f03:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f07:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f0b:	89 c2                	mov    %eax,%edx
c0100f0d:	ec                   	in     (%dx),%al
c0100f0e:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f11:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f15:	0f b6 c0             	movzbl %al,%eax
c0100f18:	c1 e0 08             	shl    $0x8,%eax
c0100f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f1e:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f25:	0f b7 c0             	movzwl %ax,%eax
c0100f28:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f2c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f30:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f34:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f38:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f39:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f40:	83 c0 01             	add    $0x1,%eax
c0100f43:	0f b7 c0             	movzwl %ax,%eax
c0100f46:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f4a:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f4e:	89 c2                	mov    %eax,%edx
c0100f50:	ec                   	in     (%dx),%al
c0100f51:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f54:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f58:	0f b6 c0             	movzbl %al,%eax
c0100f5b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f61:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f69:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100f6f:	c9                   	leave  
c0100f70:	c3                   	ret    

c0100f71 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f71:	55                   	push   %ebp
c0100f72:	89 e5                	mov    %esp,%ebp
c0100f74:	83 ec 48             	sub    $0x48,%esp
c0100f77:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f7d:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f81:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f85:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f89:	ee                   	out    %al,(%dx)
c0100f8a:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f90:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f94:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f98:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f9c:	ee                   	out    %al,(%dx)
c0100f9d:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fa3:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fa7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fab:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100faf:	ee                   	out    %al,(%dx)
c0100fb0:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fb6:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fba:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fbe:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fc2:	ee                   	out    %al,(%dx)
c0100fc3:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fc9:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fcd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fd1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fd5:	ee                   	out    %al,(%dx)
c0100fd6:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fdc:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fe0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fe4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fe8:	ee                   	out    %al,(%dx)
c0100fe9:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fef:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100ff3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100ff7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ffb:	ee                   	out    %al,(%dx)
c0100ffc:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101002:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101006:	89 c2                	mov    %eax,%edx
c0101008:	ec                   	in     (%dx),%al
c0101009:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c010100c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101010:	3c ff                	cmp    $0xff,%al
c0101012:	0f 95 c0             	setne  %al
c0101015:	0f b6 c0             	movzbl %al,%eax
c0101018:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c010101d:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101023:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101027:	89 c2                	mov    %eax,%edx
c0101029:	ec                   	in     (%dx),%al
c010102a:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010102d:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101033:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101037:	89 c2                	mov    %eax,%edx
c0101039:	ec                   	in     (%dx),%al
c010103a:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010103d:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101042:	85 c0                	test   %eax,%eax
c0101044:	74 0c                	je     c0101052 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101046:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010104d:	e8 d6 06 00 00       	call   c0101728 <pic_enable>
    }
}
c0101052:	c9                   	leave  
c0101053:	c3                   	ret    

c0101054 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101054:	55                   	push   %ebp
c0101055:	89 e5                	mov    %esp,%ebp
c0101057:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010105a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101061:	eb 09                	jmp    c010106c <lpt_putc_sub+0x18>
        delay();
c0101063:	e8 db fd ff ff       	call   c0100e43 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101068:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010106c:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101072:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101076:	89 c2                	mov    %eax,%edx
c0101078:	ec                   	in     (%dx),%al
c0101079:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010107c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101080:	84 c0                	test   %al,%al
c0101082:	78 09                	js     c010108d <lpt_putc_sub+0x39>
c0101084:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010108b:	7e d6                	jle    c0101063 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010108d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101090:	0f b6 c0             	movzbl %al,%eax
c0101093:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101099:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010109c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010a0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010a4:	ee                   	out    %al,(%dx)
c01010a5:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010ab:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010af:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010b3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010b7:	ee                   	out    %al,(%dx)
c01010b8:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010be:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010c2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010c6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010ca:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010cb:	c9                   	leave  
c01010cc:	c3                   	ret    

c01010cd <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010cd:	55                   	push   %ebp
c01010ce:	89 e5                	mov    %esp,%ebp
c01010d0:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010d3:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010d7:	74 0d                	je     c01010e6 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01010dc:	89 04 24             	mov    %eax,(%esp)
c01010df:	e8 70 ff ff ff       	call   c0101054 <lpt_putc_sub>
c01010e4:	eb 24                	jmp    c010110a <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010e6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010ed:	e8 62 ff ff ff       	call   c0101054 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010f2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010f9:	e8 56 ff ff ff       	call   c0101054 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010fe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101105:	e8 4a ff ff ff       	call   c0101054 <lpt_putc_sub>
    }
}
c010110a:	c9                   	leave  
c010110b:	c3                   	ret    

c010110c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010110c:	55                   	push   %ebp
c010110d:	89 e5                	mov    %esp,%ebp
c010110f:	53                   	push   %ebx
c0101110:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101113:	8b 45 08             	mov    0x8(%ebp),%eax
c0101116:	b0 00                	mov    $0x0,%al
c0101118:	85 c0                	test   %eax,%eax
c010111a:	75 07                	jne    c0101123 <cga_putc+0x17>
        c |= 0x0700;
c010111c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101123:	8b 45 08             	mov    0x8(%ebp),%eax
c0101126:	0f b6 c0             	movzbl %al,%eax
c0101129:	83 f8 0a             	cmp    $0xa,%eax
c010112c:	74 4c                	je     c010117a <cga_putc+0x6e>
c010112e:	83 f8 0d             	cmp    $0xd,%eax
c0101131:	74 57                	je     c010118a <cga_putc+0x7e>
c0101133:	83 f8 08             	cmp    $0x8,%eax
c0101136:	0f 85 88 00 00 00    	jne    c01011c4 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010113c:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101143:	66 85 c0             	test   %ax,%ax
c0101146:	74 30                	je     c0101178 <cga_putc+0x6c>
            crt_pos --;
c0101148:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010114f:	83 e8 01             	sub    $0x1,%eax
c0101152:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101158:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c010115d:	0f b7 15 44 a4 11 c0 	movzwl 0xc011a444,%edx
c0101164:	0f b7 d2             	movzwl %dx,%edx
c0101167:	01 d2                	add    %edx,%edx
c0101169:	01 c2                	add    %eax,%edx
c010116b:	8b 45 08             	mov    0x8(%ebp),%eax
c010116e:	b0 00                	mov    $0x0,%al
c0101170:	83 c8 20             	or     $0x20,%eax
c0101173:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101176:	eb 72                	jmp    c01011ea <cga_putc+0xde>
c0101178:	eb 70                	jmp    c01011ea <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010117a:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101181:	83 c0 50             	add    $0x50,%eax
c0101184:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010118a:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c0101191:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c0101198:	0f b7 c1             	movzwl %cx,%eax
c010119b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011a1:	c1 e8 10             	shr    $0x10,%eax
c01011a4:	89 c2                	mov    %eax,%edx
c01011a6:	66 c1 ea 06          	shr    $0x6,%dx
c01011aa:	89 d0                	mov    %edx,%eax
c01011ac:	c1 e0 02             	shl    $0x2,%eax
c01011af:	01 d0                	add    %edx,%eax
c01011b1:	c1 e0 04             	shl    $0x4,%eax
c01011b4:	29 c1                	sub    %eax,%ecx
c01011b6:	89 ca                	mov    %ecx,%edx
c01011b8:	89 d8                	mov    %ebx,%eax
c01011ba:	29 d0                	sub    %edx,%eax
c01011bc:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01011c2:	eb 26                	jmp    c01011ea <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011c4:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011ca:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011d1:	8d 50 01             	lea    0x1(%eax),%edx
c01011d4:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c01011db:	0f b7 c0             	movzwl %ax,%eax
c01011de:	01 c0                	add    %eax,%eax
c01011e0:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01011e6:	66 89 02             	mov    %ax,(%edx)
        break;
c01011e9:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011ea:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011f1:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011f5:	76 5b                	jbe    c0101252 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011f7:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c01011fc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101202:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101207:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010120e:	00 
c010120f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101213:	89 04 24             	mov    %eax,(%esp)
c0101216:	e8 28 4f 00 00       	call   c0106143 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121b:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101222:	eb 15                	jmp    c0101239 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101224:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101229:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010122c:	01 d2                	add    %edx,%edx
c010122e:	01 d0                	add    %edx,%eax
c0101230:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101235:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101239:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101240:	7e e2                	jle    c0101224 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101242:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101249:	83 e8 50             	sub    $0x50,%eax
c010124c:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101252:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101259:	0f b7 c0             	movzwl %ax,%eax
c010125c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101260:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101264:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101268:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010126c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010126d:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101274:	66 c1 e8 08          	shr    $0x8,%ax
c0101278:	0f b6 c0             	movzbl %al,%eax
c010127b:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c0101282:	83 c2 01             	add    $0x1,%edx
c0101285:	0f b7 d2             	movzwl %dx,%edx
c0101288:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010128c:	88 45 ed             	mov    %al,-0x13(%ebp)
c010128f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101293:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101297:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101298:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c010129f:	0f b7 c0             	movzwl %ax,%eax
c01012a2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012a6:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012aa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012ae:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012b2:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012b3:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01012ba:	0f b6 c0             	movzbl %al,%eax
c01012bd:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01012c4:	83 c2 01             	add    $0x1,%edx
c01012c7:	0f b7 d2             	movzwl %dx,%edx
c01012ca:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ce:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012d1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012d5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012d9:	ee                   	out    %al,(%dx)
}
c01012da:	83 c4 34             	add    $0x34,%esp
c01012dd:	5b                   	pop    %ebx
c01012de:	5d                   	pop    %ebp
c01012df:	c3                   	ret    

c01012e0 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012e0:	55                   	push   %ebp
c01012e1:	89 e5                	mov    %esp,%ebp
c01012e3:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012ed:	eb 09                	jmp    c01012f8 <serial_putc_sub+0x18>
        delay();
c01012ef:	e8 4f fb ff ff       	call   c0100e43 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012f8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012fe:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101302:	89 c2                	mov    %eax,%edx
c0101304:	ec                   	in     (%dx),%al
c0101305:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101308:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010130c:	0f b6 c0             	movzbl %al,%eax
c010130f:	83 e0 20             	and    $0x20,%eax
c0101312:	85 c0                	test   %eax,%eax
c0101314:	75 09                	jne    c010131f <serial_putc_sub+0x3f>
c0101316:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010131d:	7e d0                	jle    c01012ef <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010131f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101322:	0f b6 c0             	movzbl %al,%eax
c0101325:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010132b:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010132e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101332:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101336:	ee                   	out    %al,(%dx)
}
c0101337:	c9                   	leave  
c0101338:	c3                   	ret    

c0101339 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101339:	55                   	push   %ebp
c010133a:	89 e5                	mov    %esp,%ebp
c010133c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010133f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101343:	74 0d                	je     c0101352 <serial_putc+0x19>
        serial_putc_sub(c);
c0101345:	8b 45 08             	mov    0x8(%ebp),%eax
c0101348:	89 04 24             	mov    %eax,(%esp)
c010134b:	e8 90 ff ff ff       	call   c01012e0 <serial_putc_sub>
c0101350:	eb 24                	jmp    c0101376 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101352:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101359:	e8 82 ff ff ff       	call   c01012e0 <serial_putc_sub>
        serial_putc_sub(' ');
c010135e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101365:	e8 76 ff ff ff       	call   c01012e0 <serial_putc_sub>
        serial_putc_sub('\b');
c010136a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101371:	e8 6a ff ff ff       	call   c01012e0 <serial_putc_sub>
    }
}
c0101376:	c9                   	leave  
c0101377:	c3                   	ret    

c0101378 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101378:	55                   	push   %ebp
c0101379:	89 e5                	mov    %esp,%ebp
c010137b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010137e:	eb 33                	jmp    c01013b3 <cons_intr+0x3b>
        if (c != 0) {
c0101380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101384:	74 2d                	je     c01013b3 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101386:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010138b:	8d 50 01             	lea    0x1(%eax),%edx
c010138e:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c0101394:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101397:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010139d:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c01013a2:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013a7:	75 0a                	jne    c01013b3 <cons_intr+0x3b>
                cons.wpos = 0;
c01013a9:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c01013b0:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01013b6:	ff d0                	call   *%eax
c01013b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013bb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013bf:	75 bf                	jne    c0101380 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013c1:	c9                   	leave  
c01013c2:	c3                   	ret    

c01013c3 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013c3:	55                   	push   %ebp
c01013c4:	89 e5                	mov    %esp,%ebp
c01013c6:	83 ec 10             	sub    $0x10,%esp
c01013c9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013cf:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013d3:	89 c2                	mov    %eax,%edx
c01013d5:	ec                   	in     (%dx),%al
c01013d6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013d9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013dd:	0f b6 c0             	movzbl %al,%eax
c01013e0:	83 e0 01             	and    $0x1,%eax
c01013e3:	85 c0                	test   %eax,%eax
c01013e5:	75 07                	jne    c01013ee <serial_proc_data+0x2b>
        return -1;
c01013e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013ec:	eb 2a                	jmp    c0101418 <serial_proc_data+0x55>
c01013ee:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013f4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013f8:	89 c2                	mov    %eax,%edx
c01013fa:	ec                   	in     (%dx),%al
c01013fb:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013fe:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101402:	0f b6 c0             	movzbl %al,%eax
c0101405:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101408:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c010140c:	75 07                	jne    c0101415 <serial_proc_data+0x52>
        c = '\b';
c010140e:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101415:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101418:	c9                   	leave  
c0101419:	c3                   	ret    

c010141a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010141a:	55                   	push   %ebp
c010141b:	89 e5                	mov    %esp,%ebp
c010141d:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101420:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101425:	85 c0                	test   %eax,%eax
c0101427:	74 0c                	je     c0101435 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101429:	c7 04 24 c3 13 10 c0 	movl   $0xc01013c3,(%esp)
c0101430:	e8 43 ff ff ff       	call   c0101378 <cons_intr>
    }
}
c0101435:	c9                   	leave  
c0101436:	c3                   	ret    

c0101437 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101437:	55                   	push   %ebp
c0101438:	89 e5                	mov    %esp,%ebp
c010143a:	83 ec 38             	sub    $0x38,%esp
c010143d:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101443:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101447:	89 c2                	mov    %eax,%edx
c0101449:	ec                   	in     (%dx),%al
c010144a:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010144d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101451:	0f b6 c0             	movzbl %al,%eax
c0101454:	83 e0 01             	and    $0x1,%eax
c0101457:	85 c0                	test   %eax,%eax
c0101459:	75 0a                	jne    c0101465 <kbd_proc_data+0x2e>
        return -1;
c010145b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101460:	e9 59 01 00 00       	jmp    c01015be <kbd_proc_data+0x187>
c0101465:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010146b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010146f:	89 c2                	mov    %eax,%edx
c0101471:	ec                   	in     (%dx),%al
c0101472:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101475:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101479:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010147c:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101480:	75 17                	jne    c0101499 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101482:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101487:	83 c8 40             	or     $0x40,%eax
c010148a:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c010148f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101494:	e9 25 01 00 00       	jmp    c01015be <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101499:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149d:	84 c0                	test   %al,%al
c010149f:	79 47                	jns    c01014e8 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014a1:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014a6:	83 e0 40             	and    $0x40,%eax
c01014a9:	85 c0                	test   %eax,%eax
c01014ab:	75 09                	jne    c01014b6 <kbd_proc_data+0x7f>
c01014ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b1:	83 e0 7f             	and    $0x7f,%eax
c01014b4:	eb 04                	jmp    c01014ba <kbd_proc_data+0x83>
c01014b6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ba:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014bd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c1:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014c8:	83 c8 40             	or     $0x40,%eax
c01014cb:	0f b6 c0             	movzbl %al,%eax
c01014ce:	f7 d0                	not    %eax
c01014d0:	89 c2                	mov    %eax,%edx
c01014d2:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014d7:	21 d0                	and    %edx,%eax
c01014d9:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014de:	b8 00 00 00 00       	mov    $0x0,%eax
c01014e3:	e9 d6 00 00 00       	jmp    c01015be <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014e8:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014ed:	83 e0 40             	and    $0x40,%eax
c01014f0:	85 c0                	test   %eax,%eax
c01014f2:	74 11                	je     c0101505 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014f4:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014f8:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014fd:	83 e0 bf             	and    $0xffffffbf,%eax
c0101500:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c0101505:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101509:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c0101510:	0f b6 d0             	movzbl %al,%edx
c0101513:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101518:	09 d0                	or     %edx,%eax
c010151a:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c010151f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101523:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c010152a:	0f b6 d0             	movzbl %al,%edx
c010152d:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101532:	31 d0                	xor    %edx,%eax
c0101534:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101539:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010153e:	83 e0 03             	and    $0x3,%eax
c0101541:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c0101548:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010154c:	01 d0                	add    %edx,%eax
c010154e:	0f b6 00             	movzbl (%eax),%eax
c0101551:	0f b6 c0             	movzbl %al,%eax
c0101554:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101557:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010155c:	83 e0 08             	and    $0x8,%eax
c010155f:	85 c0                	test   %eax,%eax
c0101561:	74 22                	je     c0101585 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101563:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101567:	7e 0c                	jle    c0101575 <kbd_proc_data+0x13e>
c0101569:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010156d:	7f 06                	jg     c0101575 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010156f:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101573:	eb 10                	jmp    c0101585 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101575:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101579:	7e 0a                	jle    c0101585 <kbd_proc_data+0x14e>
c010157b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010157f:	7f 04                	jg     c0101585 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101581:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101585:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010158a:	f7 d0                	not    %eax
c010158c:	83 e0 06             	and    $0x6,%eax
c010158f:	85 c0                	test   %eax,%eax
c0101591:	75 28                	jne    c01015bb <kbd_proc_data+0x184>
c0101593:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010159a:	75 1f                	jne    c01015bb <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010159c:	c7 04 24 cf 65 10 c0 	movl   $0xc01065cf,(%esp)
c01015a3:	e8 a0 ed ff ff       	call   c0100348 <cprintf>
c01015a8:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015ae:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015b2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015b6:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015ba:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015be:	c9                   	leave  
c01015bf:	c3                   	ret    

c01015c0 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015c0:	55                   	push   %ebp
c01015c1:	89 e5                	mov    %esp,%ebp
c01015c3:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015c6:	c7 04 24 37 14 10 c0 	movl   $0xc0101437,(%esp)
c01015cd:	e8 a6 fd ff ff       	call   c0101378 <cons_intr>
}
c01015d2:	c9                   	leave  
c01015d3:	c3                   	ret    

c01015d4 <kbd_init>:

static void
kbd_init(void) {
c01015d4:	55                   	push   %ebp
c01015d5:	89 e5                	mov    %esp,%ebp
c01015d7:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015da:	e8 e1 ff ff ff       	call   c01015c0 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015e6:	e8 3d 01 00 00       	call   c0101728 <pic_enable>
}
c01015eb:	c9                   	leave  
c01015ec:	c3                   	ret    

c01015ed <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015ed:	55                   	push   %ebp
c01015ee:	89 e5                	mov    %esp,%ebp
c01015f0:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015f3:	e8 93 f8 ff ff       	call   c0100e8b <cga_init>
    serial_init();
c01015f8:	e8 74 f9 ff ff       	call   c0100f71 <serial_init>
    kbd_init();
c01015fd:	e8 d2 ff ff ff       	call   c01015d4 <kbd_init>
    if (!serial_exists) {
c0101602:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101607:	85 c0                	test   %eax,%eax
c0101609:	75 0c                	jne    c0101617 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010160b:	c7 04 24 db 65 10 c0 	movl   $0xc01065db,(%esp)
c0101612:	e8 31 ed ff ff       	call   c0100348 <cprintf>
    }
}
c0101617:	c9                   	leave  
c0101618:	c3                   	ret    

c0101619 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101619:	55                   	push   %ebp
c010161a:	89 e5                	mov    %esp,%ebp
c010161c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010161f:	e8 e2 f7 ff ff       	call   c0100e06 <__intr_save>
c0101624:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101627:	8b 45 08             	mov    0x8(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 9b fa ff ff       	call   c01010cd <lpt_putc>
        cga_putc(c);
c0101632:	8b 45 08             	mov    0x8(%ebp),%eax
c0101635:	89 04 24             	mov    %eax,(%esp)
c0101638:	e8 cf fa ff ff       	call   c010110c <cga_putc>
        serial_putc(c);
c010163d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101640:	89 04 24             	mov    %eax,(%esp)
c0101643:	e8 f1 fc ff ff       	call   c0101339 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101648:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010164b:	89 04 24             	mov    %eax,(%esp)
c010164e:	e8 dd f7 ff ff       	call   c0100e30 <__intr_restore>
}
c0101653:	c9                   	leave  
c0101654:	c3                   	ret    

c0101655 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101655:	55                   	push   %ebp
c0101656:	89 e5                	mov    %esp,%ebp
c0101658:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010165b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101662:	e8 9f f7 ff ff       	call   c0100e06 <__intr_save>
c0101667:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010166a:	e8 ab fd ff ff       	call   c010141a <serial_intr>
        kbd_intr();
c010166f:	e8 4c ff ff ff       	call   c01015c0 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101674:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c010167a:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010167f:	39 c2                	cmp    %eax,%edx
c0101681:	74 31                	je     c01016b4 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101683:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c0101688:	8d 50 01             	lea    0x1(%eax),%edx
c010168b:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c0101691:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c0101698:	0f b6 c0             	movzbl %al,%eax
c010169b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010169e:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c01016a3:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016a8:	75 0a                	jne    c01016b4 <cons_getc+0x5f>
                cons.rpos = 0;
c01016aa:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c01016b1:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016b7:	89 04 24             	mov    %eax,(%esp)
c01016ba:	e8 71 f7 ff ff       	call   c0100e30 <__intr_restore>
    return c;
c01016bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016c2:	c9                   	leave  
c01016c3:	c3                   	ret    

c01016c4 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016c4:	55                   	push   %ebp
c01016c5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016c7:	fb                   	sti    
    sti();
}
c01016c8:	5d                   	pop    %ebp
c01016c9:	c3                   	ret    

c01016ca <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016ca:	55                   	push   %ebp
c01016cb:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016cd:	fa                   	cli    
    cli();
}
c01016ce:	5d                   	pop    %ebp
c01016cf:	c3                   	ret    

c01016d0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016d0:	55                   	push   %ebp
c01016d1:	89 e5                	mov    %esp,%ebp
c01016d3:	83 ec 14             	sub    $0x14,%esp
c01016d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01016d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e1:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c01016e7:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c01016ec:	85 c0                	test   %eax,%eax
c01016ee:	74 36                	je     c0101726 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016f0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f4:	0f b6 c0             	movzbl %al,%eax
c01016f7:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016fd:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101700:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101704:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101708:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101709:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010170d:	66 c1 e8 08          	shr    $0x8,%ax
c0101711:	0f b6 c0             	movzbl %al,%eax
c0101714:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010171a:	88 45 f9             	mov    %al,-0x7(%ebp)
c010171d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101721:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101725:	ee                   	out    %al,(%dx)
    }
}
c0101726:	c9                   	leave  
c0101727:	c3                   	ret    

c0101728 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101728:	55                   	push   %ebp
c0101729:	89 e5                	mov    %esp,%ebp
c010172b:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010172e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101731:	ba 01 00 00 00       	mov    $0x1,%edx
c0101736:	89 c1                	mov    %eax,%ecx
c0101738:	d3 e2                	shl    %cl,%edx
c010173a:	89 d0                	mov    %edx,%eax
c010173c:	f7 d0                	not    %eax
c010173e:	89 c2                	mov    %eax,%edx
c0101740:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101747:	21 d0                	and    %edx,%eax
c0101749:	0f b7 c0             	movzwl %ax,%eax
c010174c:	89 04 24             	mov    %eax,(%esp)
c010174f:	e8 7c ff ff ff       	call   c01016d0 <pic_setmask>
}
c0101754:	c9                   	leave  
c0101755:	c3                   	ret    

c0101756 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101756:	55                   	push   %ebp
c0101757:	89 e5                	mov    %esp,%ebp
c0101759:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010175c:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c0101763:	00 00 00 
c0101766:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010176c:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101770:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101774:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101778:	ee                   	out    %al,(%dx)
c0101779:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010177f:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101783:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101787:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010178b:	ee                   	out    %al,(%dx)
c010178c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101792:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101796:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010179a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010179e:	ee                   	out    %al,(%dx)
c010179f:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01017a5:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01017a9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01017ad:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017b1:	ee                   	out    %al,(%dx)
c01017b2:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017b8:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017bc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017c0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017c4:	ee                   	out    %al,(%dx)
c01017c5:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017cb:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017cf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017d3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017d7:	ee                   	out    %al,(%dx)
c01017d8:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017de:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017e2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017e6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017ea:	ee                   	out    %al,(%dx)
c01017eb:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017f1:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017f5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017f9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017fd:	ee                   	out    %al,(%dx)
c01017fe:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0101804:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0101808:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010180c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101810:	ee                   	out    %al,(%dx)
c0101811:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101817:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010181b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010181f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101823:	ee                   	out    %al,(%dx)
c0101824:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010182a:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010182e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101832:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101836:	ee                   	out    %al,(%dx)
c0101837:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010183d:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101841:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101845:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101849:	ee                   	out    %al,(%dx)
c010184a:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101850:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101854:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101858:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010185c:	ee                   	out    %al,(%dx)
c010185d:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101863:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101867:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010186b:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010186f:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101870:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101877:	66 83 f8 ff          	cmp    $0xffff,%ax
c010187b:	74 12                	je     c010188f <pic_init+0x139>
        pic_setmask(irq_mask);
c010187d:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101884:	0f b7 c0             	movzwl %ax,%eax
c0101887:	89 04 24             	mov    %eax,(%esp)
c010188a:	e8 41 fe ff ff       	call   c01016d0 <pic_setmask>
    }
}
c010188f:	c9                   	leave  
c0101890:	c3                   	ret    

c0101891 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101891:	55                   	push   %ebp
c0101892:	89 e5                	mov    %esp,%ebp
c0101894:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101897:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010189e:	00 
c010189f:	c7 04 24 00 66 10 c0 	movl   $0xc0106600,(%esp)
c01018a6:	e8 9d ea ff ff       	call   c0100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018ab:	c7 04 24 0a 66 10 c0 	movl   $0xc010660a,(%esp)
c01018b2:	e8 91 ea ff ff       	call   c0100348 <cprintf>
    panic("EOT: kernel seems ok.");
c01018b7:	c7 44 24 08 18 66 10 	movl   $0xc0106618,0x8(%esp)
c01018be:	c0 
c01018bf:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018c6:	00 
c01018c7:	c7 04 24 2e 66 10 c0 	movl   $0xc010662e,(%esp)
c01018ce:	e8 03 f4 ff ff       	call   c0100cd6 <__panic>

c01018d3 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018d3:	55                   	push   %ebp
c01018d4:	89 e5                	mov    %esp,%ebp
c01018d6:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
c01018d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i; i < 256 ; i++) {
c01018e0:	e9 83 02 00 00       	jmp    c0101b68 <idt_init+0x295>
	    if(i != T_SYSCALL && i != T_SWITCH_TOK && i >= IRQ_OFFSET) {
c01018e5:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c01018ec:	0f 84 d8 00 00 00    	je     c01019ca <idt_init+0xf7>
c01018f2:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
c01018f6:	0f 84 ce 00 00 00    	je     c01019ca <idt_init+0xf7>
c01018fc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
c0101900:	0f 8e c4 00 00 00    	jle    c01019ca <idt_init+0xf7>
	       SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101906:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101909:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c0101910:	89 c2                	mov    %eax,%edx
c0101912:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101915:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c010191c:	c0 
c010191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101920:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c0101927:	c0 08 00 
c010192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192d:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101934:	c0 
c0101935:	83 e2 e0             	and    $0xffffffe0,%edx
c0101938:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c010193f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101942:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101949:	c0 
c010194a:	83 e2 1f             	and    $0x1f,%edx
c010194d:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101954:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101957:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010195e:	c0 
c010195f:	83 e2 f0             	and    $0xfffffff0,%edx
c0101962:	83 ca 0e             	or     $0xe,%edx
c0101965:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196f:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101976:	c0 
c0101977:	83 e2 ef             	and    $0xffffffef,%edx
c010197a:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101981:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101984:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010198b:	c0 
c010198c:	83 e2 9f             	and    $0xffffff9f,%edx
c010198f:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101999:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c01019a0:	c0 
c01019a1:	83 ca 80             	or     $0xffffff80,%edx
c01019a4:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c01019ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ae:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01019b5:	c1 e8 10             	shr    $0x10,%eax
c01019b8:	89 c2                	mov    %eax,%edx
c01019ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019bd:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c01019c4:	c0 
c01019c5:	e9 9a 01 00 00       	jmp    c0101b64 <idt_init+0x291>
	    } else {
	    	if(i == T_SYSCALL || i == T_SWITCH_TOK) {
c01019ca:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c01019d1:	74 0a                	je     c01019dd <idt_init+0x10a>
c01019d3:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
c01019d7:	0f 85 c1 00 00 00    	jne    c0101a9e <idt_init+0x1cb>
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);		
c01019dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e0:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01019e7:	89 c2                	mov    %eax,%edx
c01019e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ec:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c01019f3:	c0 
c01019f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f7:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c01019fe:	c0 08 00 
c0101a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a04:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101a0b:	c0 
c0101a0c:	83 e2 e0             	and    $0xffffffe0,%edx
c0101a0f:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a19:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101a20:	c0 
c0101a21:	83 e2 1f             	and    $0x1f,%edx
c0101a24:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a2e:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101a35:	c0 
c0101a36:	83 ca 0f             	or     $0xf,%edx
c0101a39:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a43:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101a4a:	c0 
c0101a4b:	83 e2 ef             	and    $0xffffffef,%edx
c0101a4e:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101a55:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a58:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101a5f:	c0 
c0101a60:	83 ca 60             	or     $0x60,%edx
c0101a63:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101a6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a6d:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101a74:	c0 
c0101a75:	83 ca 80             	or     $0xffffff80,%edx
c0101a78:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101a7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a82:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c0101a89:	c1 e8 10             	shr    $0x10,%eax
c0101a8c:	89 c2                	mov    %eax,%edx
c0101a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a91:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c0101a98:	c0 
c0101a99:	e9 c6 00 00 00       	jmp    c0101b64 <idt_init+0x291>
		} else if(i < IRQ_OFFSET) {
c0101a9e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
c0101aa2:	0f 8f bc 00 00 00    	jg     c0101b64 <idt_init+0x291>
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);		
c0101aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aab:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c0101ab2:	89 c2                	mov    %eax,%edx
c0101ab4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ab7:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c0101abe:	c0 
c0101abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ac2:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c0101ac9:	c0 08 00 
c0101acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101acf:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101ad6:	c0 
c0101ad7:	83 e2 e0             	and    $0xffffffe0,%edx
c0101ada:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ae4:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101aeb:	c0 
c0101aec:	83 e2 1f             	and    $0x1f,%edx
c0101aef:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101af6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101af9:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101b00:	c0 
c0101b01:	83 ca 0f             	or     $0xf,%edx
c0101b04:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101b0e:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101b15:	c0 
c0101b16:	83 e2 ef             	and    $0xffffffef,%edx
c0101b19:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101b20:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101b23:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101b2a:	c0 
c0101b2b:	83 e2 9f             	and    $0xffffff9f,%edx
c0101b2e:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101b35:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101b38:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101b3f:	c0 
c0101b40:	83 ca 80             	or     $0xffffff80,%edx
c0101b43:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101b4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101b4d:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c0101b54:	c1 e8 10             	shr    $0x10,%eax
c0101b57:	89 c2                	mov    %eax,%edx
c0101b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101b5c:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c0101b63:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
	for(i; i < 256 ; i++) {
c0101b64:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101b68:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101b6f:	0f 8e 70 fd ff ff    	jle    c01018e5 <idt_init+0x12>
c0101b75:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101b7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b7f:	0f 01 18             	lidtl  (%eax)
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);		
		}
	    }
	}
	lidt(&idt_pd);
}
c0101b82:	c9                   	leave  
c0101b83:	c3                   	ret    

c0101b84 <trapname>:

static const char *
trapname(int trapno) {
c0101b84:	55                   	push   %ebp
c0101b85:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101b87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8a:	83 f8 13             	cmp    $0x13,%eax
c0101b8d:	77 0c                	ja     c0101b9b <trapname+0x17>
        return excnames[trapno];
c0101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b92:	8b 04 85 80 69 10 c0 	mov    -0x3fef9680(,%eax,4),%eax
c0101b99:	eb 18                	jmp    c0101bb3 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101b9b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101b9f:	7e 0d                	jle    c0101bae <trapname+0x2a>
c0101ba1:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101ba5:	7f 07                	jg     c0101bae <trapname+0x2a>
        return "Hardware Interrupt";
c0101ba7:	b8 3f 66 10 c0       	mov    $0xc010663f,%eax
c0101bac:	eb 05                	jmp    c0101bb3 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101bae:	b8 52 66 10 c0       	mov    $0xc0106652,%eax
}
c0101bb3:	5d                   	pop    %ebp
c0101bb4:	c3                   	ret    

c0101bb5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101bb5:	55                   	push   %ebp
c0101bb6:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bbf:	66 83 f8 08          	cmp    $0x8,%ax
c0101bc3:	0f 94 c0             	sete   %al
c0101bc6:	0f b6 c0             	movzbl %al,%eax
}
c0101bc9:	5d                   	pop    %ebp
c0101bca:	c3                   	ret    

c0101bcb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101bcb:	55                   	push   %ebp
c0101bcc:	89 e5                	mov    %esp,%ebp
c0101bce:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd8:	c7 04 24 93 66 10 c0 	movl   $0xc0106693,(%esp)
c0101bdf:	e8 64 e7 ff ff       	call   c0100348 <cprintf>
    print_regs(&tf->tf_regs);
c0101be4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be7:	89 04 24             	mov    %eax,(%esp)
c0101bea:	e8 a1 01 00 00       	call   c0101d90 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101bef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf2:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101bf6:	0f b7 c0             	movzwl %ax,%eax
c0101bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bfd:	c7 04 24 a4 66 10 c0 	movl   $0xc01066a4,(%esp)
c0101c04:	e8 3f e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101c10:	0f b7 c0             	movzwl %ax,%eax
c0101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c17:	c7 04 24 b7 66 10 c0 	movl   $0xc01066b7,(%esp)
c0101c1e:	e8 25 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c26:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101c2a:	0f b7 c0             	movzwl %ax,%eax
c0101c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c31:	c7 04 24 ca 66 10 c0 	movl   $0xc01066ca,(%esp)
c0101c38:	e8 0b e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101c3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c40:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101c44:	0f b7 c0             	movzwl %ax,%eax
c0101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4b:	c7 04 24 dd 66 10 c0 	movl   $0xc01066dd,(%esp)
c0101c52:	e8 f1 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101c57:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5a:	8b 40 30             	mov    0x30(%eax),%eax
c0101c5d:	89 04 24             	mov    %eax,(%esp)
c0101c60:	e8 1f ff ff ff       	call   c0101b84 <trapname>
c0101c65:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c68:	8b 52 30             	mov    0x30(%edx),%edx
c0101c6b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101c6f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101c73:	c7 04 24 f0 66 10 c0 	movl   $0xc01066f0,(%esp)
c0101c7a:	e8 c9 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101c7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c82:	8b 40 34             	mov    0x34(%eax),%eax
c0101c85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c89:	c7 04 24 02 67 10 c0 	movl   $0xc0106702,(%esp)
c0101c90:	e8 b3 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c98:	8b 40 38             	mov    0x38(%eax),%eax
c0101c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9f:	c7 04 24 11 67 10 c0 	movl   $0xc0106711,(%esp)
c0101ca6:	e8 9d e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101cab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cae:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101cb2:	0f b7 c0             	movzwl %ax,%eax
c0101cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb9:	c7 04 24 20 67 10 c0 	movl   $0xc0106720,(%esp)
c0101cc0:	e8 83 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc8:	8b 40 40             	mov    0x40(%eax),%eax
c0101ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ccf:	c7 04 24 33 67 10 c0 	movl   $0xc0106733,(%esp)
c0101cd6:	e8 6d e6 ff ff       	call   c0100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101cdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101ce2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101ce9:	eb 3e                	jmp    c0101d29 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cee:	8b 50 40             	mov    0x40(%eax),%edx
c0101cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cf4:	21 d0                	and    %edx,%eax
c0101cf6:	85 c0                	test   %eax,%eax
c0101cf8:	74 28                	je     c0101d22 <print_trapframe+0x157>
c0101cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cfd:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101d04:	85 c0                	test   %eax,%eax
c0101d06:	74 1a                	je     c0101d22 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d0b:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101d12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d16:	c7 04 24 42 67 10 c0 	movl   $0xc0106742,(%esp)
c0101d1d:	e8 26 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101d22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101d26:	d1 65 f0             	shll   -0x10(%ebp)
c0101d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d2c:	83 f8 17             	cmp    $0x17,%eax
c0101d2f:	76 ba                	jbe    c0101ceb <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101d31:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d34:	8b 40 40             	mov    0x40(%eax),%eax
c0101d37:	25 00 30 00 00       	and    $0x3000,%eax
c0101d3c:	c1 e8 0c             	shr    $0xc,%eax
c0101d3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d43:	c7 04 24 46 67 10 c0 	movl   $0xc0106746,(%esp)
c0101d4a:	e8 f9 e5 ff ff       	call   c0100348 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d52:	89 04 24             	mov    %eax,(%esp)
c0101d55:	e8 5b fe ff ff       	call   c0101bb5 <trap_in_kernel>
c0101d5a:	85 c0                	test   %eax,%eax
c0101d5c:	75 30                	jne    c0101d8e <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d61:	8b 40 44             	mov    0x44(%eax),%eax
c0101d64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d68:	c7 04 24 4f 67 10 c0 	movl   $0xc010674f,(%esp)
c0101d6f:	e8 d4 e5 ff ff       	call   c0100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101d74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d77:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101d7b:	0f b7 c0             	movzwl %ax,%eax
c0101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d82:	c7 04 24 5e 67 10 c0 	movl   $0xc010675e,(%esp)
c0101d89:	e8 ba e5 ff ff       	call   c0100348 <cprintf>
    }
}
c0101d8e:	c9                   	leave  
c0101d8f:	c3                   	ret    

c0101d90 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101d90:	55                   	push   %ebp
c0101d91:	89 e5                	mov    %esp,%ebp
c0101d93:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101d96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d99:	8b 00                	mov    (%eax),%eax
c0101d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d9f:	c7 04 24 71 67 10 c0 	movl   $0xc0106771,(%esp)
c0101da6:	e8 9d e5 ff ff       	call   c0100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101dab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dae:	8b 40 04             	mov    0x4(%eax),%eax
c0101db1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101db5:	c7 04 24 80 67 10 c0 	movl   $0xc0106780,(%esp)
c0101dbc:	e8 87 e5 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101dc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dc4:	8b 40 08             	mov    0x8(%eax),%eax
c0101dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dcb:	c7 04 24 8f 67 10 c0 	movl   $0xc010678f,(%esp)
c0101dd2:	e8 71 e5 ff ff       	call   c0100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dda:	8b 40 0c             	mov    0xc(%eax),%eax
c0101ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101de1:	c7 04 24 9e 67 10 c0 	movl   $0xc010679e,(%esp)
c0101de8:	e8 5b e5 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df0:	8b 40 10             	mov    0x10(%eax),%eax
c0101df3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101df7:	c7 04 24 ad 67 10 c0 	movl   $0xc01067ad,(%esp)
c0101dfe:	e8 45 e5 ff ff       	call   c0100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101e03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e06:	8b 40 14             	mov    0x14(%eax),%eax
c0101e09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e0d:	c7 04 24 bc 67 10 c0 	movl   $0xc01067bc,(%esp)
c0101e14:	e8 2f e5 ff ff       	call   c0100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101e19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e1c:	8b 40 18             	mov    0x18(%eax),%eax
c0101e1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e23:	c7 04 24 cb 67 10 c0 	movl   $0xc01067cb,(%esp)
c0101e2a:	e8 19 e5 ff ff       	call   c0100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101e2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e32:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101e35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e39:	c7 04 24 da 67 10 c0 	movl   $0xc01067da,(%esp)
c0101e40:	e8 03 e5 ff ff       	call   c0100348 <cprintf>
}
c0101e45:	c9                   	leave  
c0101e46:	c3                   	ret    

c0101e47 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101e47:	55                   	push   %ebp
c0101e48:	89 e5                	mov    %esp,%ebp
c0101e4a:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e50:	8b 40 30             	mov    0x30(%eax),%eax
c0101e53:	83 f8 2f             	cmp    $0x2f,%eax
c0101e56:	77 21                	ja     c0101e79 <trap_dispatch+0x32>
c0101e58:	83 f8 2e             	cmp    $0x2e,%eax
c0101e5b:	0f 83 04 01 00 00    	jae    c0101f65 <trap_dispatch+0x11e>
c0101e61:	83 f8 21             	cmp    $0x21,%eax
c0101e64:	0f 84 81 00 00 00    	je     c0101eeb <trap_dispatch+0xa4>
c0101e6a:	83 f8 24             	cmp    $0x24,%eax
c0101e6d:	74 56                	je     c0101ec5 <trap_dispatch+0x7e>
c0101e6f:	83 f8 20             	cmp    $0x20,%eax
c0101e72:	74 16                	je     c0101e8a <trap_dispatch+0x43>
c0101e74:	e9 b4 00 00 00       	jmp    c0101f2d <trap_dispatch+0xe6>
c0101e79:	83 e8 78             	sub    $0x78,%eax
c0101e7c:	83 f8 01             	cmp    $0x1,%eax
c0101e7f:	0f 87 a8 00 00 00    	ja     c0101f2d <trap_dispatch+0xe6>
c0101e85:	e9 87 00 00 00       	jmp    c0101f11 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks = ticks + 1;
c0101e8a:	a1 0c af 11 c0       	mov    0xc011af0c,%eax
c0101e8f:	83 c0 01             	add    $0x1,%eax
c0101e92:	a3 0c af 11 c0       	mov    %eax,0xc011af0c
	if(ticks % 100 == 0) {
c0101e97:	8b 0d 0c af 11 c0    	mov    0xc011af0c,%ecx
c0101e9d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101ea2:	89 c8                	mov    %ecx,%eax
c0101ea4:	f7 e2                	mul    %edx
c0101ea6:	89 d0                	mov    %edx,%eax
c0101ea8:	c1 e8 05             	shr    $0x5,%eax
c0101eab:	6b c0 64             	imul   $0x64,%eax,%eax
c0101eae:	29 c1                	sub    %eax,%ecx
c0101eb0:	89 c8                	mov    %ecx,%eax
c0101eb2:	85 c0                	test   %eax,%eax
c0101eb4:	75 0a                	jne    c0101ec0 <trap_dispatch+0x79>
	   print_ticks();	
c0101eb6:	e8 d6 f9 ff ff       	call   c0101891 <print_ticks>
	}
        break;
c0101ebb:	e9 a6 00 00 00       	jmp    c0101f66 <trap_dispatch+0x11f>
c0101ec0:	e9 a1 00 00 00       	jmp    c0101f66 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101ec5:	e8 8b f7 ff ff       	call   c0101655 <cons_getc>
c0101eca:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ecd:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ed1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ed5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101edd:	c7 04 24 e9 67 10 c0 	movl   $0xc01067e9,(%esp)
c0101ee4:	e8 5f e4 ff ff       	call   c0100348 <cprintf>
        break;
c0101ee9:	eb 7b                	jmp    c0101f66 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101eeb:	e8 65 f7 ff ff       	call   c0101655 <cons_getc>
c0101ef0:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101ef3:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ef7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101efb:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101eff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101f03:	c7 04 24 fb 67 10 c0 	movl   $0xc01067fb,(%esp)
c0101f0a:	e8 39 e4 ff ff       	call   c0100348 <cprintf>
        break;
c0101f0f:	eb 55                	jmp    c0101f66 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101f11:	c7 44 24 08 0a 68 10 	movl   $0xc010680a,0x8(%esp)
c0101f18:	c0 
c0101f19:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0101f20:	00 
c0101f21:	c7 04 24 2e 66 10 c0 	movl   $0xc010662e,(%esp)
c0101f28:	e8 a9 ed ff ff       	call   c0100cd6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101f2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f30:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f34:	0f b7 c0             	movzwl %ax,%eax
c0101f37:	83 e0 03             	and    $0x3,%eax
c0101f3a:	85 c0                	test   %eax,%eax
c0101f3c:	75 28                	jne    c0101f66 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101f3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f41:	89 04 24             	mov    %eax,(%esp)
c0101f44:	e8 82 fc ff ff       	call   c0101bcb <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101f49:	c7 44 24 08 1a 68 10 	movl   $0xc010681a,0x8(%esp)
c0101f50:	c0 
c0101f51:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0101f58:	00 
c0101f59:	c7 04 24 2e 66 10 c0 	movl   $0xc010662e,(%esp)
c0101f60:	e8 71 ed ff ff       	call   c0100cd6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101f65:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101f66:	c9                   	leave  
c0101f67:	c3                   	ret    

c0101f68 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101f68:	55                   	push   %ebp
c0101f69:	89 e5                	mov    %esp,%ebp
c0101f6b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f71:	89 04 24             	mov    %eax,(%esp)
c0101f74:	e8 ce fe ff ff       	call   c0101e47 <trap_dispatch>
}
c0101f79:	c9                   	leave  
c0101f7a:	c3                   	ret    

c0101f7b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101f7b:	1e                   	push   %ds
    pushl %es
c0101f7c:	06                   	push   %es
    pushl %fs
c0101f7d:	0f a0                	push   %fs
    pushl %gs
c0101f7f:	0f a8                	push   %gs
    pushal
c0101f81:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101f82:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101f87:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101f89:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101f8b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101f8c:	e8 d7 ff ff ff       	call   c0101f68 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101f91:	5c                   	pop    %esp

c0101f92 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101f92:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101f93:	0f a9                	pop    %gs
    popl %fs
c0101f95:	0f a1                	pop    %fs
    popl %es
c0101f97:	07                   	pop    %es
    popl %ds
c0101f98:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101f99:	83 c4 08             	add    $0x8,%esp
    iret
c0101f9c:	cf                   	iret   

c0101f9d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f9d:	6a 00                	push   $0x0
  pushl $0
c0101f9f:	6a 00                	push   $0x0
  jmp __alltraps
c0101fa1:	e9 d5 ff ff ff       	jmp    c0101f7b <__alltraps>

c0101fa6 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101fa6:	6a 00                	push   $0x0
  pushl $1
c0101fa8:	6a 01                	push   $0x1
  jmp __alltraps
c0101faa:	e9 cc ff ff ff       	jmp    c0101f7b <__alltraps>

c0101faf <vector2>:
.globl vector2
vector2:
  pushl $0
c0101faf:	6a 00                	push   $0x0
  pushl $2
c0101fb1:	6a 02                	push   $0x2
  jmp __alltraps
c0101fb3:	e9 c3 ff ff ff       	jmp    c0101f7b <__alltraps>

c0101fb8 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101fb8:	6a 00                	push   $0x0
  pushl $3
c0101fba:	6a 03                	push   $0x3
  jmp __alltraps
c0101fbc:	e9 ba ff ff ff       	jmp    c0101f7b <__alltraps>

c0101fc1 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101fc1:	6a 00                	push   $0x0
  pushl $4
c0101fc3:	6a 04                	push   $0x4
  jmp __alltraps
c0101fc5:	e9 b1 ff ff ff       	jmp    c0101f7b <__alltraps>

c0101fca <vector5>:
.globl vector5
vector5:
  pushl $0
c0101fca:	6a 00                	push   $0x0
  pushl $5
c0101fcc:	6a 05                	push   $0x5
  jmp __alltraps
c0101fce:	e9 a8 ff ff ff       	jmp    c0101f7b <__alltraps>

c0101fd3 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101fd3:	6a 00                	push   $0x0
  pushl $6
c0101fd5:	6a 06                	push   $0x6
  jmp __alltraps
c0101fd7:	e9 9f ff ff ff       	jmp    c0101f7b <__alltraps>

c0101fdc <vector7>:
.globl vector7
vector7:
  pushl $0
c0101fdc:	6a 00                	push   $0x0
  pushl $7
c0101fde:	6a 07                	push   $0x7
  jmp __alltraps
c0101fe0:	e9 96 ff ff ff       	jmp    c0101f7b <__alltraps>

c0101fe5 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101fe5:	6a 08                	push   $0x8
  jmp __alltraps
c0101fe7:	e9 8f ff ff ff       	jmp    c0101f7b <__alltraps>

c0101fec <vector9>:
.globl vector9
vector9:
  pushl $0
c0101fec:	6a 00                	push   $0x0
  pushl $9
c0101fee:	6a 09                	push   $0x9
  jmp __alltraps
c0101ff0:	e9 86 ff ff ff       	jmp    c0101f7b <__alltraps>

c0101ff5 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101ff5:	6a 0a                	push   $0xa
  jmp __alltraps
c0101ff7:	e9 7f ff ff ff       	jmp    c0101f7b <__alltraps>

c0101ffc <vector11>:
.globl vector11
vector11:
  pushl $11
c0101ffc:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ffe:	e9 78 ff ff ff       	jmp    c0101f7b <__alltraps>

c0102003 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102003:	6a 0c                	push   $0xc
  jmp __alltraps
c0102005:	e9 71 ff ff ff       	jmp    c0101f7b <__alltraps>

c010200a <vector13>:
.globl vector13
vector13:
  pushl $13
c010200a:	6a 0d                	push   $0xd
  jmp __alltraps
c010200c:	e9 6a ff ff ff       	jmp    c0101f7b <__alltraps>

c0102011 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102011:	6a 0e                	push   $0xe
  jmp __alltraps
c0102013:	e9 63 ff ff ff       	jmp    c0101f7b <__alltraps>

c0102018 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102018:	6a 00                	push   $0x0
  pushl $15
c010201a:	6a 0f                	push   $0xf
  jmp __alltraps
c010201c:	e9 5a ff ff ff       	jmp    c0101f7b <__alltraps>

c0102021 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102021:	6a 00                	push   $0x0
  pushl $16
c0102023:	6a 10                	push   $0x10
  jmp __alltraps
c0102025:	e9 51 ff ff ff       	jmp    c0101f7b <__alltraps>

c010202a <vector17>:
.globl vector17
vector17:
  pushl $17
c010202a:	6a 11                	push   $0x11
  jmp __alltraps
c010202c:	e9 4a ff ff ff       	jmp    c0101f7b <__alltraps>

c0102031 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $18
c0102033:	6a 12                	push   $0x12
  jmp __alltraps
c0102035:	e9 41 ff ff ff       	jmp    c0101f7b <__alltraps>

c010203a <vector19>:
.globl vector19
vector19:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $19
c010203c:	6a 13                	push   $0x13
  jmp __alltraps
c010203e:	e9 38 ff ff ff       	jmp    c0101f7b <__alltraps>

c0102043 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $20
c0102045:	6a 14                	push   $0x14
  jmp __alltraps
c0102047:	e9 2f ff ff ff       	jmp    c0101f7b <__alltraps>

c010204c <vector21>:
.globl vector21
vector21:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $21
c010204e:	6a 15                	push   $0x15
  jmp __alltraps
c0102050:	e9 26 ff ff ff       	jmp    c0101f7b <__alltraps>

c0102055 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $22
c0102057:	6a 16                	push   $0x16
  jmp __alltraps
c0102059:	e9 1d ff ff ff       	jmp    c0101f7b <__alltraps>

c010205e <vector23>:
.globl vector23
vector23:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $23
c0102060:	6a 17                	push   $0x17
  jmp __alltraps
c0102062:	e9 14 ff ff ff       	jmp    c0101f7b <__alltraps>

c0102067 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $24
c0102069:	6a 18                	push   $0x18
  jmp __alltraps
c010206b:	e9 0b ff ff ff       	jmp    c0101f7b <__alltraps>

c0102070 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $25
c0102072:	6a 19                	push   $0x19
  jmp __alltraps
c0102074:	e9 02 ff ff ff       	jmp    c0101f7b <__alltraps>

c0102079 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $26
c010207b:	6a 1a                	push   $0x1a
  jmp __alltraps
c010207d:	e9 f9 fe ff ff       	jmp    c0101f7b <__alltraps>

c0102082 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $27
c0102084:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102086:	e9 f0 fe ff ff       	jmp    c0101f7b <__alltraps>

c010208b <vector28>:
.globl vector28
vector28:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $28
c010208d:	6a 1c                	push   $0x1c
  jmp __alltraps
c010208f:	e9 e7 fe ff ff       	jmp    c0101f7b <__alltraps>

c0102094 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $29
c0102096:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102098:	e9 de fe ff ff       	jmp    c0101f7b <__alltraps>

c010209d <vector30>:
.globl vector30
vector30:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $30
c010209f:	6a 1e                	push   $0x1e
  jmp __alltraps
c01020a1:	e9 d5 fe ff ff       	jmp    c0101f7b <__alltraps>

c01020a6 <vector31>:
.globl vector31
vector31:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $31
c01020a8:	6a 1f                	push   $0x1f
  jmp __alltraps
c01020aa:	e9 cc fe ff ff       	jmp    c0101f7b <__alltraps>

c01020af <vector32>:
.globl vector32
vector32:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $32
c01020b1:	6a 20                	push   $0x20
  jmp __alltraps
c01020b3:	e9 c3 fe ff ff       	jmp    c0101f7b <__alltraps>

c01020b8 <vector33>:
.globl vector33
vector33:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $33
c01020ba:	6a 21                	push   $0x21
  jmp __alltraps
c01020bc:	e9 ba fe ff ff       	jmp    c0101f7b <__alltraps>

c01020c1 <vector34>:
.globl vector34
vector34:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $34
c01020c3:	6a 22                	push   $0x22
  jmp __alltraps
c01020c5:	e9 b1 fe ff ff       	jmp    c0101f7b <__alltraps>

c01020ca <vector35>:
.globl vector35
vector35:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $35
c01020cc:	6a 23                	push   $0x23
  jmp __alltraps
c01020ce:	e9 a8 fe ff ff       	jmp    c0101f7b <__alltraps>

c01020d3 <vector36>:
.globl vector36
vector36:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $36
c01020d5:	6a 24                	push   $0x24
  jmp __alltraps
c01020d7:	e9 9f fe ff ff       	jmp    c0101f7b <__alltraps>

c01020dc <vector37>:
.globl vector37
vector37:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $37
c01020de:	6a 25                	push   $0x25
  jmp __alltraps
c01020e0:	e9 96 fe ff ff       	jmp    c0101f7b <__alltraps>

c01020e5 <vector38>:
.globl vector38
vector38:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $38
c01020e7:	6a 26                	push   $0x26
  jmp __alltraps
c01020e9:	e9 8d fe ff ff       	jmp    c0101f7b <__alltraps>

c01020ee <vector39>:
.globl vector39
vector39:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $39
c01020f0:	6a 27                	push   $0x27
  jmp __alltraps
c01020f2:	e9 84 fe ff ff       	jmp    c0101f7b <__alltraps>

c01020f7 <vector40>:
.globl vector40
vector40:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $40
c01020f9:	6a 28                	push   $0x28
  jmp __alltraps
c01020fb:	e9 7b fe ff ff       	jmp    c0101f7b <__alltraps>

c0102100 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $41
c0102102:	6a 29                	push   $0x29
  jmp __alltraps
c0102104:	e9 72 fe ff ff       	jmp    c0101f7b <__alltraps>

c0102109 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $42
c010210b:	6a 2a                	push   $0x2a
  jmp __alltraps
c010210d:	e9 69 fe ff ff       	jmp    c0101f7b <__alltraps>

c0102112 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $43
c0102114:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102116:	e9 60 fe ff ff       	jmp    c0101f7b <__alltraps>

c010211b <vector44>:
.globl vector44
vector44:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $44
c010211d:	6a 2c                	push   $0x2c
  jmp __alltraps
c010211f:	e9 57 fe ff ff       	jmp    c0101f7b <__alltraps>

c0102124 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $45
c0102126:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102128:	e9 4e fe ff ff       	jmp    c0101f7b <__alltraps>

c010212d <vector46>:
.globl vector46
vector46:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $46
c010212f:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102131:	e9 45 fe ff ff       	jmp    c0101f7b <__alltraps>

c0102136 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $47
c0102138:	6a 2f                	push   $0x2f
  jmp __alltraps
c010213a:	e9 3c fe ff ff       	jmp    c0101f7b <__alltraps>

c010213f <vector48>:
.globl vector48
vector48:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $48
c0102141:	6a 30                	push   $0x30
  jmp __alltraps
c0102143:	e9 33 fe ff ff       	jmp    c0101f7b <__alltraps>

c0102148 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $49
c010214a:	6a 31                	push   $0x31
  jmp __alltraps
c010214c:	e9 2a fe ff ff       	jmp    c0101f7b <__alltraps>

c0102151 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $50
c0102153:	6a 32                	push   $0x32
  jmp __alltraps
c0102155:	e9 21 fe ff ff       	jmp    c0101f7b <__alltraps>

c010215a <vector51>:
.globl vector51
vector51:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $51
c010215c:	6a 33                	push   $0x33
  jmp __alltraps
c010215e:	e9 18 fe ff ff       	jmp    c0101f7b <__alltraps>

c0102163 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $52
c0102165:	6a 34                	push   $0x34
  jmp __alltraps
c0102167:	e9 0f fe ff ff       	jmp    c0101f7b <__alltraps>

c010216c <vector53>:
.globl vector53
vector53:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $53
c010216e:	6a 35                	push   $0x35
  jmp __alltraps
c0102170:	e9 06 fe ff ff       	jmp    c0101f7b <__alltraps>

c0102175 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $54
c0102177:	6a 36                	push   $0x36
  jmp __alltraps
c0102179:	e9 fd fd ff ff       	jmp    c0101f7b <__alltraps>

c010217e <vector55>:
.globl vector55
vector55:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $55
c0102180:	6a 37                	push   $0x37
  jmp __alltraps
c0102182:	e9 f4 fd ff ff       	jmp    c0101f7b <__alltraps>

c0102187 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $56
c0102189:	6a 38                	push   $0x38
  jmp __alltraps
c010218b:	e9 eb fd ff ff       	jmp    c0101f7b <__alltraps>

c0102190 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $57
c0102192:	6a 39                	push   $0x39
  jmp __alltraps
c0102194:	e9 e2 fd ff ff       	jmp    c0101f7b <__alltraps>

c0102199 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $58
c010219b:	6a 3a                	push   $0x3a
  jmp __alltraps
c010219d:	e9 d9 fd ff ff       	jmp    c0101f7b <__alltraps>

c01021a2 <vector59>:
.globl vector59
vector59:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $59
c01021a4:	6a 3b                	push   $0x3b
  jmp __alltraps
c01021a6:	e9 d0 fd ff ff       	jmp    c0101f7b <__alltraps>

c01021ab <vector60>:
.globl vector60
vector60:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $60
c01021ad:	6a 3c                	push   $0x3c
  jmp __alltraps
c01021af:	e9 c7 fd ff ff       	jmp    c0101f7b <__alltraps>

c01021b4 <vector61>:
.globl vector61
vector61:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $61
c01021b6:	6a 3d                	push   $0x3d
  jmp __alltraps
c01021b8:	e9 be fd ff ff       	jmp    c0101f7b <__alltraps>

c01021bd <vector62>:
.globl vector62
vector62:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $62
c01021bf:	6a 3e                	push   $0x3e
  jmp __alltraps
c01021c1:	e9 b5 fd ff ff       	jmp    c0101f7b <__alltraps>

c01021c6 <vector63>:
.globl vector63
vector63:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $63
c01021c8:	6a 3f                	push   $0x3f
  jmp __alltraps
c01021ca:	e9 ac fd ff ff       	jmp    c0101f7b <__alltraps>

c01021cf <vector64>:
.globl vector64
vector64:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $64
c01021d1:	6a 40                	push   $0x40
  jmp __alltraps
c01021d3:	e9 a3 fd ff ff       	jmp    c0101f7b <__alltraps>

c01021d8 <vector65>:
.globl vector65
vector65:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $65
c01021da:	6a 41                	push   $0x41
  jmp __alltraps
c01021dc:	e9 9a fd ff ff       	jmp    c0101f7b <__alltraps>

c01021e1 <vector66>:
.globl vector66
vector66:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $66
c01021e3:	6a 42                	push   $0x42
  jmp __alltraps
c01021e5:	e9 91 fd ff ff       	jmp    c0101f7b <__alltraps>

c01021ea <vector67>:
.globl vector67
vector67:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $67
c01021ec:	6a 43                	push   $0x43
  jmp __alltraps
c01021ee:	e9 88 fd ff ff       	jmp    c0101f7b <__alltraps>

c01021f3 <vector68>:
.globl vector68
vector68:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $68
c01021f5:	6a 44                	push   $0x44
  jmp __alltraps
c01021f7:	e9 7f fd ff ff       	jmp    c0101f7b <__alltraps>

c01021fc <vector69>:
.globl vector69
vector69:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $69
c01021fe:	6a 45                	push   $0x45
  jmp __alltraps
c0102200:	e9 76 fd ff ff       	jmp    c0101f7b <__alltraps>

c0102205 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $70
c0102207:	6a 46                	push   $0x46
  jmp __alltraps
c0102209:	e9 6d fd ff ff       	jmp    c0101f7b <__alltraps>

c010220e <vector71>:
.globl vector71
vector71:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $71
c0102210:	6a 47                	push   $0x47
  jmp __alltraps
c0102212:	e9 64 fd ff ff       	jmp    c0101f7b <__alltraps>

c0102217 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $72
c0102219:	6a 48                	push   $0x48
  jmp __alltraps
c010221b:	e9 5b fd ff ff       	jmp    c0101f7b <__alltraps>

c0102220 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $73
c0102222:	6a 49                	push   $0x49
  jmp __alltraps
c0102224:	e9 52 fd ff ff       	jmp    c0101f7b <__alltraps>

c0102229 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $74
c010222b:	6a 4a                	push   $0x4a
  jmp __alltraps
c010222d:	e9 49 fd ff ff       	jmp    c0101f7b <__alltraps>

c0102232 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $75
c0102234:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102236:	e9 40 fd ff ff       	jmp    c0101f7b <__alltraps>

c010223b <vector76>:
.globl vector76
vector76:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $76
c010223d:	6a 4c                	push   $0x4c
  jmp __alltraps
c010223f:	e9 37 fd ff ff       	jmp    c0101f7b <__alltraps>

c0102244 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102244:	6a 00                	push   $0x0
  pushl $77
c0102246:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102248:	e9 2e fd ff ff       	jmp    c0101f7b <__alltraps>

c010224d <vector78>:
.globl vector78
vector78:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $78
c010224f:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102251:	e9 25 fd ff ff       	jmp    c0101f7b <__alltraps>

c0102256 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $79
c0102258:	6a 4f                	push   $0x4f
  jmp __alltraps
c010225a:	e9 1c fd ff ff       	jmp    c0101f7b <__alltraps>

c010225f <vector80>:
.globl vector80
vector80:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $80
c0102261:	6a 50                	push   $0x50
  jmp __alltraps
c0102263:	e9 13 fd ff ff       	jmp    c0101f7b <__alltraps>

c0102268 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102268:	6a 00                	push   $0x0
  pushl $81
c010226a:	6a 51                	push   $0x51
  jmp __alltraps
c010226c:	e9 0a fd ff ff       	jmp    c0101f7b <__alltraps>

c0102271 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $82
c0102273:	6a 52                	push   $0x52
  jmp __alltraps
c0102275:	e9 01 fd ff ff       	jmp    c0101f7b <__alltraps>

c010227a <vector83>:
.globl vector83
vector83:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $83
c010227c:	6a 53                	push   $0x53
  jmp __alltraps
c010227e:	e9 f8 fc ff ff       	jmp    c0101f7b <__alltraps>

c0102283 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $84
c0102285:	6a 54                	push   $0x54
  jmp __alltraps
c0102287:	e9 ef fc ff ff       	jmp    c0101f7b <__alltraps>

c010228c <vector85>:
.globl vector85
vector85:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $85
c010228e:	6a 55                	push   $0x55
  jmp __alltraps
c0102290:	e9 e6 fc ff ff       	jmp    c0101f7b <__alltraps>

c0102295 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102295:	6a 00                	push   $0x0
  pushl $86
c0102297:	6a 56                	push   $0x56
  jmp __alltraps
c0102299:	e9 dd fc ff ff       	jmp    c0101f7b <__alltraps>

c010229e <vector87>:
.globl vector87
vector87:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $87
c01022a0:	6a 57                	push   $0x57
  jmp __alltraps
c01022a2:	e9 d4 fc ff ff       	jmp    c0101f7b <__alltraps>

c01022a7 <vector88>:
.globl vector88
vector88:
  pushl $0
c01022a7:	6a 00                	push   $0x0
  pushl $88
c01022a9:	6a 58                	push   $0x58
  jmp __alltraps
c01022ab:	e9 cb fc ff ff       	jmp    c0101f7b <__alltraps>

c01022b0 <vector89>:
.globl vector89
vector89:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $89
c01022b2:	6a 59                	push   $0x59
  jmp __alltraps
c01022b4:	e9 c2 fc ff ff       	jmp    c0101f7b <__alltraps>

c01022b9 <vector90>:
.globl vector90
vector90:
  pushl $0
c01022b9:	6a 00                	push   $0x0
  pushl $90
c01022bb:	6a 5a                	push   $0x5a
  jmp __alltraps
c01022bd:	e9 b9 fc ff ff       	jmp    c0101f7b <__alltraps>

c01022c2 <vector91>:
.globl vector91
vector91:
  pushl $0
c01022c2:	6a 00                	push   $0x0
  pushl $91
c01022c4:	6a 5b                	push   $0x5b
  jmp __alltraps
c01022c6:	e9 b0 fc ff ff       	jmp    c0101f7b <__alltraps>

c01022cb <vector92>:
.globl vector92
vector92:
  pushl $0
c01022cb:	6a 00                	push   $0x0
  pushl $92
c01022cd:	6a 5c                	push   $0x5c
  jmp __alltraps
c01022cf:	e9 a7 fc ff ff       	jmp    c0101f7b <__alltraps>

c01022d4 <vector93>:
.globl vector93
vector93:
  pushl $0
c01022d4:	6a 00                	push   $0x0
  pushl $93
c01022d6:	6a 5d                	push   $0x5d
  jmp __alltraps
c01022d8:	e9 9e fc ff ff       	jmp    c0101f7b <__alltraps>

c01022dd <vector94>:
.globl vector94
vector94:
  pushl $0
c01022dd:	6a 00                	push   $0x0
  pushl $94
c01022df:	6a 5e                	push   $0x5e
  jmp __alltraps
c01022e1:	e9 95 fc ff ff       	jmp    c0101f7b <__alltraps>

c01022e6 <vector95>:
.globl vector95
vector95:
  pushl $0
c01022e6:	6a 00                	push   $0x0
  pushl $95
c01022e8:	6a 5f                	push   $0x5f
  jmp __alltraps
c01022ea:	e9 8c fc ff ff       	jmp    c0101f7b <__alltraps>

c01022ef <vector96>:
.globl vector96
vector96:
  pushl $0
c01022ef:	6a 00                	push   $0x0
  pushl $96
c01022f1:	6a 60                	push   $0x60
  jmp __alltraps
c01022f3:	e9 83 fc ff ff       	jmp    c0101f7b <__alltraps>

c01022f8 <vector97>:
.globl vector97
vector97:
  pushl $0
c01022f8:	6a 00                	push   $0x0
  pushl $97
c01022fa:	6a 61                	push   $0x61
  jmp __alltraps
c01022fc:	e9 7a fc ff ff       	jmp    c0101f7b <__alltraps>

c0102301 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102301:	6a 00                	push   $0x0
  pushl $98
c0102303:	6a 62                	push   $0x62
  jmp __alltraps
c0102305:	e9 71 fc ff ff       	jmp    c0101f7b <__alltraps>

c010230a <vector99>:
.globl vector99
vector99:
  pushl $0
c010230a:	6a 00                	push   $0x0
  pushl $99
c010230c:	6a 63                	push   $0x63
  jmp __alltraps
c010230e:	e9 68 fc ff ff       	jmp    c0101f7b <__alltraps>

c0102313 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102313:	6a 00                	push   $0x0
  pushl $100
c0102315:	6a 64                	push   $0x64
  jmp __alltraps
c0102317:	e9 5f fc ff ff       	jmp    c0101f7b <__alltraps>

c010231c <vector101>:
.globl vector101
vector101:
  pushl $0
c010231c:	6a 00                	push   $0x0
  pushl $101
c010231e:	6a 65                	push   $0x65
  jmp __alltraps
c0102320:	e9 56 fc ff ff       	jmp    c0101f7b <__alltraps>

c0102325 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102325:	6a 00                	push   $0x0
  pushl $102
c0102327:	6a 66                	push   $0x66
  jmp __alltraps
c0102329:	e9 4d fc ff ff       	jmp    c0101f7b <__alltraps>

c010232e <vector103>:
.globl vector103
vector103:
  pushl $0
c010232e:	6a 00                	push   $0x0
  pushl $103
c0102330:	6a 67                	push   $0x67
  jmp __alltraps
c0102332:	e9 44 fc ff ff       	jmp    c0101f7b <__alltraps>

c0102337 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102337:	6a 00                	push   $0x0
  pushl $104
c0102339:	6a 68                	push   $0x68
  jmp __alltraps
c010233b:	e9 3b fc ff ff       	jmp    c0101f7b <__alltraps>

c0102340 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102340:	6a 00                	push   $0x0
  pushl $105
c0102342:	6a 69                	push   $0x69
  jmp __alltraps
c0102344:	e9 32 fc ff ff       	jmp    c0101f7b <__alltraps>

c0102349 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102349:	6a 00                	push   $0x0
  pushl $106
c010234b:	6a 6a                	push   $0x6a
  jmp __alltraps
c010234d:	e9 29 fc ff ff       	jmp    c0101f7b <__alltraps>

c0102352 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102352:	6a 00                	push   $0x0
  pushl $107
c0102354:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102356:	e9 20 fc ff ff       	jmp    c0101f7b <__alltraps>

c010235b <vector108>:
.globl vector108
vector108:
  pushl $0
c010235b:	6a 00                	push   $0x0
  pushl $108
c010235d:	6a 6c                	push   $0x6c
  jmp __alltraps
c010235f:	e9 17 fc ff ff       	jmp    c0101f7b <__alltraps>

c0102364 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102364:	6a 00                	push   $0x0
  pushl $109
c0102366:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102368:	e9 0e fc ff ff       	jmp    c0101f7b <__alltraps>

c010236d <vector110>:
.globl vector110
vector110:
  pushl $0
c010236d:	6a 00                	push   $0x0
  pushl $110
c010236f:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102371:	e9 05 fc ff ff       	jmp    c0101f7b <__alltraps>

c0102376 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102376:	6a 00                	push   $0x0
  pushl $111
c0102378:	6a 6f                	push   $0x6f
  jmp __alltraps
c010237a:	e9 fc fb ff ff       	jmp    c0101f7b <__alltraps>

c010237f <vector112>:
.globl vector112
vector112:
  pushl $0
c010237f:	6a 00                	push   $0x0
  pushl $112
c0102381:	6a 70                	push   $0x70
  jmp __alltraps
c0102383:	e9 f3 fb ff ff       	jmp    c0101f7b <__alltraps>

c0102388 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102388:	6a 00                	push   $0x0
  pushl $113
c010238a:	6a 71                	push   $0x71
  jmp __alltraps
c010238c:	e9 ea fb ff ff       	jmp    c0101f7b <__alltraps>

c0102391 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102391:	6a 00                	push   $0x0
  pushl $114
c0102393:	6a 72                	push   $0x72
  jmp __alltraps
c0102395:	e9 e1 fb ff ff       	jmp    c0101f7b <__alltraps>

c010239a <vector115>:
.globl vector115
vector115:
  pushl $0
c010239a:	6a 00                	push   $0x0
  pushl $115
c010239c:	6a 73                	push   $0x73
  jmp __alltraps
c010239e:	e9 d8 fb ff ff       	jmp    c0101f7b <__alltraps>

c01023a3 <vector116>:
.globl vector116
vector116:
  pushl $0
c01023a3:	6a 00                	push   $0x0
  pushl $116
c01023a5:	6a 74                	push   $0x74
  jmp __alltraps
c01023a7:	e9 cf fb ff ff       	jmp    c0101f7b <__alltraps>

c01023ac <vector117>:
.globl vector117
vector117:
  pushl $0
c01023ac:	6a 00                	push   $0x0
  pushl $117
c01023ae:	6a 75                	push   $0x75
  jmp __alltraps
c01023b0:	e9 c6 fb ff ff       	jmp    c0101f7b <__alltraps>

c01023b5 <vector118>:
.globl vector118
vector118:
  pushl $0
c01023b5:	6a 00                	push   $0x0
  pushl $118
c01023b7:	6a 76                	push   $0x76
  jmp __alltraps
c01023b9:	e9 bd fb ff ff       	jmp    c0101f7b <__alltraps>

c01023be <vector119>:
.globl vector119
vector119:
  pushl $0
c01023be:	6a 00                	push   $0x0
  pushl $119
c01023c0:	6a 77                	push   $0x77
  jmp __alltraps
c01023c2:	e9 b4 fb ff ff       	jmp    c0101f7b <__alltraps>

c01023c7 <vector120>:
.globl vector120
vector120:
  pushl $0
c01023c7:	6a 00                	push   $0x0
  pushl $120
c01023c9:	6a 78                	push   $0x78
  jmp __alltraps
c01023cb:	e9 ab fb ff ff       	jmp    c0101f7b <__alltraps>

c01023d0 <vector121>:
.globl vector121
vector121:
  pushl $0
c01023d0:	6a 00                	push   $0x0
  pushl $121
c01023d2:	6a 79                	push   $0x79
  jmp __alltraps
c01023d4:	e9 a2 fb ff ff       	jmp    c0101f7b <__alltraps>

c01023d9 <vector122>:
.globl vector122
vector122:
  pushl $0
c01023d9:	6a 00                	push   $0x0
  pushl $122
c01023db:	6a 7a                	push   $0x7a
  jmp __alltraps
c01023dd:	e9 99 fb ff ff       	jmp    c0101f7b <__alltraps>

c01023e2 <vector123>:
.globl vector123
vector123:
  pushl $0
c01023e2:	6a 00                	push   $0x0
  pushl $123
c01023e4:	6a 7b                	push   $0x7b
  jmp __alltraps
c01023e6:	e9 90 fb ff ff       	jmp    c0101f7b <__alltraps>

c01023eb <vector124>:
.globl vector124
vector124:
  pushl $0
c01023eb:	6a 00                	push   $0x0
  pushl $124
c01023ed:	6a 7c                	push   $0x7c
  jmp __alltraps
c01023ef:	e9 87 fb ff ff       	jmp    c0101f7b <__alltraps>

c01023f4 <vector125>:
.globl vector125
vector125:
  pushl $0
c01023f4:	6a 00                	push   $0x0
  pushl $125
c01023f6:	6a 7d                	push   $0x7d
  jmp __alltraps
c01023f8:	e9 7e fb ff ff       	jmp    c0101f7b <__alltraps>

c01023fd <vector126>:
.globl vector126
vector126:
  pushl $0
c01023fd:	6a 00                	push   $0x0
  pushl $126
c01023ff:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102401:	e9 75 fb ff ff       	jmp    c0101f7b <__alltraps>

c0102406 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102406:	6a 00                	push   $0x0
  pushl $127
c0102408:	6a 7f                	push   $0x7f
  jmp __alltraps
c010240a:	e9 6c fb ff ff       	jmp    c0101f7b <__alltraps>

c010240f <vector128>:
.globl vector128
vector128:
  pushl $0
c010240f:	6a 00                	push   $0x0
  pushl $128
c0102411:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102416:	e9 60 fb ff ff       	jmp    c0101f7b <__alltraps>

c010241b <vector129>:
.globl vector129
vector129:
  pushl $0
c010241b:	6a 00                	push   $0x0
  pushl $129
c010241d:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102422:	e9 54 fb ff ff       	jmp    c0101f7b <__alltraps>

c0102427 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102427:	6a 00                	push   $0x0
  pushl $130
c0102429:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010242e:	e9 48 fb ff ff       	jmp    c0101f7b <__alltraps>

c0102433 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102433:	6a 00                	push   $0x0
  pushl $131
c0102435:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010243a:	e9 3c fb ff ff       	jmp    c0101f7b <__alltraps>

c010243f <vector132>:
.globl vector132
vector132:
  pushl $0
c010243f:	6a 00                	push   $0x0
  pushl $132
c0102441:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102446:	e9 30 fb ff ff       	jmp    c0101f7b <__alltraps>

c010244b <vector133>:
.globl vector133
vector133:
  pushl $0
c010244b:	6a 00                	push   $0x0
  pushl $133
c010244d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102452:	e9 24 fb ff ff       	jmp    c0101f7b <__alltraps>

c0102457 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102457:	6a 00                	push   $0x0
  pushl $134
c0102459:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010245e:	e9 18 fb ff ff       	jmp    c0101f7b <__alltraps>

c0102463 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102463:	6a 00                	push   $0x0
  pushl $135
c0102465:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010246a:	e9 0c fb ff ff       	jmp    c0101f7b <__alltraps>

c010246f <vector136>:
.globl vector136
vector136:
  pushl $0
c010246f:	6a 00                	push   $0x0
  pushl $136
c0102471:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102476:	e9 00 fb ff ff       	jmp    c0101f7b <__alltraps>

c010247b <vector137>:
.globl vector137
vector137:
  pushl $0
c010247b:	6a 00                	push   $0x0
  pushl $137
c010247d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102482:	e9 f4 fa ff ff       	jmp    c0101f7b <__alltraps>

c0102487 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102487:	6a 00                	push   $0x0
  pushl $138
c0102489:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010248e:	e9 e8 fa ff ff       	jmp    c0101f7b <__alltraps>

c0102493 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102493:	6a 00                	push   $0x0
  pushl $139
c0102495:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010249a:	e9 dc fa ff ff       	jmp    c0101f7b <__alltraps>

c010249f <vector140>:
.globl vector140
vector140:
  pushl $0
c010249f:	6a 00                	push   $0x0
  pushl $140
c01024a1:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01024a6:	e9 d0 fa ff ff       	jmp    c0101f7b <__alltraps>

c01024ab <vector141>:
.globl vector141
vector141:
  pushl $0
c01024ab:	6a 00                	push   $0x0
  pushl $141
c01024ad:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01024b2:	e9 c4 fa ff ff       	jmp    c0101f7b <__alltraps>

c01024b7 <vector142>:
.globl vector142
vector142:
  pushl $0
c01024b7:	6a 00                	push   $0x0
  pushl $142
c01024b9:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01024be:	e9 b8 fa ff ff       	jmp    c0101f7b <__alltraps>

c01024c3 <vector143>:
.globl vector143
vector143:
  pushl $0
c01024c3:	6a 00                	push   $0x0
  pushl $143
c01024c5:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01024ca:	e9 ac fa ff ff       	jmp    c0101f7b <__alltraps>

c01024cf <vector144>:
.globl vector144
vector144:
  pushl $0
c01024cf:	6a 00                	push   $0x0
  pushl $144
c01024d1:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01024d6:	e9 a0 fa ff ff       	jmp    c0101f7b <__alltraps>

c01024db <vector145>:
.globl vector145
vector145:
  pushl $0
c01024db:	6a 00                	push   $0x0
  pushl $145
c01024dd:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01024e2:	e9 94 fa ff ff       	jmp    c0101f7b <__alltraps>

c01024e7 <vector146>:
.globl vector146
vector146:
  pushl $0
c01024e7:	6a 00                	push   $0x0
  pushl $146
c01024e9:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01024ee:	e9 88 fa ff ff       	jmp    c0101f7b <__alltraps>

c01024f3 <vector147>:
.globl vector147
vector147:
  pushl $0
c01024f3:	6a 00                	push   $0x0
  pushl $147
c01024f5:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01024fa:	e9 7c fa ff ff       	jmp    c0101f7b <__alltraps>

c01024ff <vector148>:
.globl vector148
vector148:
  pushl $0
c01024ff:	6a 00                	push   $0x0
  pushl $148
c0102501:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102506:	e9 70 fa ff ff       	jmp    c0101f7b <__alltraps>

c010250b <vector149>:
.globl vector149
vector149:
  pushl $0
c010250b:	6a 00                	push   $0x0
  pushl $149
c010250d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102512:	e9 64 fa ff ff       	jmp    c0101f7b <__alltraps>

c0102517 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102517:	6a 00                	push   $0x0
  pushl $150
c0102519:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010251e:	e9 58 fa ff ff       	jmp    c0101f7b <__alltraps>

c0102523 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102523:	6a 00                	push   $0x0
  pushl $151
c0102525:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010252a:	e9 4c fa ff ff       	jmp    c0101f7b <__alltraps>

c010252f <vector152>:
.globl vector152
vector152:
  pushl $0
c010252f:	6a 00                	push   $0x0
  pushl $152
c0102531:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102536:	e9 40 fa ff ff       	jmp    c0101f7b <__alltraps>

c010253b <vector153>:
.globl vector153
vector153:
  pushl $0
c010253b:	6a 00                	push   $0x0
  pushl $153
c010253d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102542:	e9 34 fa ff ff       	jmp    c0101f7b <__alltraps>

c0102547 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102547:	6a 00                	push   $0x0
  pushl $154
c0102549:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010254e:	e9 28 fa ff ff       	jmp    c0101f7b <__alltraps>

c0102553 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102553:	6a 00                	push   $0x0
  pushl $155
c0102555:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010255a:	e9 1c fa ff ff       	jmp    c0101f7b <__alltraps>

c010255f <vector156>:
.globl vector156
vector156:
  pushl $0
c010255f:	6a 00                	push   $0x0
  pushl $156
c0102561:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102566:	e9 10 fa ff ff       	jmp    c0101f7b <__alltraps>

c010256b <vector157>:
.globl vector157
vector157:
  pushl $0
c010256b:	6a 00                	push   $0x0
  pushl $157
c010256d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102572:	e9 04 fa ff ff       	jmp    c0101f7b <__alltraps>

c0102577 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102577:	6a 00                	push   $0x0
  pushl $158
c0102579:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010257e:	e9 f8 f9 ff ff       	jmp    c0101f7b <__alltraps>

c0102583 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102583:	6a 00                	push   $0x0
  pushl $159
c0102585:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010258a:	e9 ec f9 ff ff       	jmp    c0101f7b <__alltraps>

c010258f <vector160>:
.globl vector160
vector160:
  pushl $0
c010258f:	6a 00                	push   $0x0
  pushl $160
c0102591:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102596:	e9 e0 f9 ff ff       	jmp    c0101f7b <__alltraps>

c010259b <vector161>:
.globl vector161
vector161:
  pushl $0
c010259b:	6a 00                	push   $0x0
  pushl $161
c010259d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01025a2:	e9 d4 f9 ff ff       	jmp    c0101f7b <__alltraps>

c01025a7 <vector162>:
.globl vector162
vector162:
  pushl $0
c01025a7:	6a 00                	push   $0x0
  pushl $162
c01025a9:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01025ae:	e9 c8 f9 ff ff       	jmp    c0101f7b <__alltraps>

c01025b3 <vector163>:
.globl vector163
vector163:
  pushl $0
c01025b3:	6a 00                	push   $0x0
  pushl $163
c01025b5:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01025ba:	e9 bc f9 ff ff       	jmp    c0101f7b <__alltraps>

c01025bf <vector164>:
.globl vector164
vector164:
  pushl $0
c01025bf:	6a 00                	push   $0x0
  pushl $164
c01025c1:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01025c6:	e9 b0 f9 ff ff       	jmp    c0101f7b <__alltraps>

c01025cb <vector165>:
.globl vector165
vector165:
  pushl $0
c01025cb:	6a 00                	push   $0x0
  pushl $165
c01025cd:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01025d2:	e9 a4 f9 ff ff       	jmp    c0101f7b <__alltraps>

c01025d7 <vector166>:
.globl vector166
vector166:
  pushl $0
c01025d7:	6a 00                	push   $0x0
  pushl $166
c01025d9:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01025de:	e9 98 f9 ff ff       	jmp    c0101f7b <__alltraps>

c01025e3 <vector167>:
.globl vector167
vector167:
  pushl $0
c01025e3:	6a 00                	push   $0x0
  pushl $167
c01025e5:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01025ea:	e9 8c f9 ff ff       	jmp    c0101f7b <__alltraps>

c01025ef <vector168>:
.globl vector168
vector168:
  pushl $0
c01025ef:	6a 00                	push   $0x0
  pushl $168
c01025f1:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01025f6:	e9 80 f9 ff ff       	jmp    c0101f7b <__alltraps>

c01025fb <vector169>:
.globl vector169
vector169:
  pushl $0
c01025fb:	6a 00                	push   $0x0
  pushl $169
c01025fd:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102602:	e9 74 f9 ff ff       	jmp    c0101f7b <__alltraps>

c0102607 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102607:	6a 00                	push   $0x0
  pushl $170
c0102609:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010260e:	e9 68 f9 ff ff       	jmp    c0101f7b <__alltraps>

c0102613 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102613:	6a 00                	push   $0x0
  pushl $171
c0102615:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010261a:	e9 5c f9 ff ff       	jmp    c0101f7b <__alltraps>

c010261f <vector172>:
.globl vector172
vector172:
  pushl $0
c010261f:	6a 00                	push   $0x0
  pushl $172
c0102621:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102626:	e9 50 f9 ff ff       	jmp    c0101f7b <__alltraps>

c010262b <vector173>:
.globl vector173
vector173:
  pushl $0
c010262b:	6a 00                	push   $0x0
  pushl $173
c010262d:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102632:	e9 44 f9 ff ff       	jmp    c0101f7b <__alltraps>

c0102637 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102637:	6a 00                	push   $0x0
  pushl $174
c0102639:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010263e:	e9 38 f9 ff ff       	jmp    c0101f7b <__alltraps>

c0102643 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102643:	6a 00                	push   $0x0
  pushl $175
c0102645:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010264a:	e9 2c f9 ff ff       	jmp    c0101f7b <__alltraps>

c010264f <vector176>:
.globl vector176
vector176:
  pushl $0
c010264f:	6a 00                	push   $0x0
  pushl $176
c0102651:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102656:	e9 20 f9 ff ff       	jmp    c0101f7b <__alltraps>

c010265b <vector177>:
.globl vector177
vector177:
  pushl $0
c010265b:	6a 00                	push   $0x0
  pushl $177
c010265d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102662:	e9 14 f9 ff ff       	jmp    c0101f7b <__alltraps>

c0102667 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102667:	6a 00                	push   $0x0
  pushl $178
c0102669:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010266e:	e9 08 f9 ff ff       	jmp    c0101f7b <__alltraps>

c0102673 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102673:	6a 00                	push   $0x0
  pushl $179
c0102675:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010267a:	e9 fc f8 ff ff       	jmp    c0101f7b <__alltraps>

c010267f <vector180>:
.globl vector180
vector180:
  pushl $0
c010267f:	6a 00                	push   $0x0
  pushl $180
c0102681:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102686:	e9 f0 f8 ff ff       	jmp    c0101f7b <__alltraps>

c010268b <vector181>:
.globl vector181
vector181:
  pushl $0
c010268b:	6a 00                	push   $0x0
  pushl $181
c010268d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102692:	e9 e4 f8 ff ff       	jmp    c0101f7b <__alltraps>

c0102697 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102697:	6a 00                	push   $0x0
  pushl $182
c0102699:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010269e:	e9 d8 f8 ff ff       	jmp    c0101f7b <__alltraps>

c01026a3 <vector183>:
.globl vector183
vector183:
  pushl $0
c01026a3:	6a 00                	push   $0x0
  pushl $183
c01026a5:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01026aa:	e9 cc f8 ff ff       	jmp    c0101f7b <__alltraps>

c01026af <vector184>:
.globl vector184
vector184:
  pushl $0
c01026af:	6a 00                	push   $0x0
  pushl $184
c01026b1:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01026b6:	e9 c0 f8 ff ff       	jmp    c0101f7b <__alltraps>

c01026bb <vector185>:
.globl vector185
vector185:
  pushl $0
c01026bb:	6a 00                	push   $0x0
  pushl $185
c01026bd:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01026c2:	e9 b4 f8 ff ff       	jmp    c0101f7b <__alltraps>

c01026c7 <vector186>:
.globl vector186
vector186:
  pushl $0
c01026c7:	6a 00                	push   $0x0
  pushl $186
c01026c9:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01026ce:	e9 a8 f8 ff ff       	jmp    c0101f7b <__alltraps>

c01026d3 <vector187>:
.globl vector187
vector187:
  pushl $0
c01026d3:	6a 00                	push   $0x0
  pushl $187
c01026d5:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01026da:	e9 9c f8 ff ff       	jmp    c0101f7b <__alltraps>

c01026df <vector188>:
.globl vector188
vector188:
  pushl $0
c01026df:	6a 00                	push   $0x0
  pushl $188
c01026e1:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01026e6:	e9 90 f8 ff ff       	jmp    c0101f7b <__alltraps>

c01026eb <vector189>:
.globl vector189
vector189:
  pushl $0
c01026eb:	6a 00                	push   $0x0
  pushl $189
c01026ed:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01026f2:	e9 84 f8 ff ff       	jmp    c0101f7b <__alltraps>

c01026f7 <vector190>:
.globl vector190
vector190:
  pushl $0
c01026f7:	6a 00                	push   $0x0
  pushl $190
c01026f9:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01026fe:	e9 78 f8 ff ff       	jmp    c0101f7b <__alltraps>

c0102703 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102703:	6a 00                	push   $0x0
  pushl $191
c0102705:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010270a:	e9 6c f8 ff ff       	jmp    c0101f7b <__alltraps>

c010270f <vector192>:
.globl vector192
vector192:
  pushl $0
c010270f:	6a 00                	push   $0x0
  pushl $192
c0102711:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102716:	e9 60 f8 ff ff       	jmp    c0101f7b <__alltraps>

c010271b <vector193>:
.globl vector193
vector193:
  pushl $0
c010271b:	6a 00                	push   $0x0
  pushl $193
c010271d:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102722:	e9 54 f8 ff ff       	jmp    c0101f7b <__alltraps>

c0102727 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102727:	6a 00                	push   $0x0
  pushl $194
c0102729:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010272e:	e9 48 f8 ff ff       	jmp    c0101f7b <__alltraps>

c0102733 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102733:	6a 00                	push   $0x0
  pushl $195
c0102735:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010273a:	e9 3c f8 ff ff       	jmp    c0101f7b <__alltraps>

c010273f <vector196>:
.globl vector196
vector196:
  pushl $0
c010273f:	6a 00                	push   $0x0
  pushl $196
c0102741:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102746:	e9 30 f8 ff ff       	jmp    c0101f7b <__alltraps>

c010274b <vector197>:
.globl vector197
vector197:
  pushl $0
c010274b:	6a 00                	push   $0x0
  pushl $197
c010274d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102752:	e9 24 f8 ff ff       	jmp    c0101f7b <__alltraps>

c0102757 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102757:	6a 00                	push   $0x0
  pushl $198
c0102759:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010275e:	e9 18 f8 ff ff       	jmp    c0101f7b <__alltraps>

c0102763 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102763:	6a 00                	push   $0x0
  pushl $199
c0102765:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010276a:	e9 0c f8 ff ff       	jmp    c0101f7b <__alltraps>

c010276f <vector200>:
.globl vector200
vector200:
  pushl $0
c010276f:	6a 00                	push   $0x0
  pushl $200
c0102771:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102776:	e9 00 f8 ff ff       	jmp    c0101f7b <__alltraps>

c010277b <vector201>:
.globl vector201
vector201:
  pushl $0
c010277b:	6a 00                	push   $0x0
  pushl $201
c010277d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102782:	e9 f4 f7 ff ff       	jmp    c0101f7b <__alltraps>

c0102787 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102787:	6a 00                	push   $0x0
  pushl $202
c0102789:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010278e:	e9 e8 f7 ff ff       	jmp    c0101f7b <__alltraps>

c0102793 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102793:	6a 00                	push   $0x0
  pushl $203
c0102795:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010279a:	e9 dc f7 ff ff       	jmp    c0101f7b <__alltraps>

c010279f <vector204>:
.globl vector204
vector204:
  pushl $0
c010279f:	6a 00                	push   $0x0
  pushl $204
c01027a1:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01027a6:	e9 d0 f7 ff ff       	jmp    c0101f7b <__alltraps>

c01027ab <vector205>:
.globl vector205
vector205:
  pushl $0
c01027ab:	6a 00                	push   $0x0
  pushl $205
c01027ad:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01027b2:	e9 c4 f7 ff ff       	jmp    c0101f7b <__alltraps>

c01027b7 <vector206>:
.globl vector206
vector206:
  pushl $0
c01027b7:	6a 00                	push   $0x0
  pushl $206
c01027b9:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01027be:	e9 b8 f7 ff ff       	jmp    c0101f7b <__alltraps>

c01027c3 <vector207>:
.globl vector207
vector207:
  pushl $0
c01027c3:	6a 00                	push   $0x0
  pushl $207
c01027c5:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01027ca:	e9 ac f7 ff ff       	jmp    c0101f7b <__alltraps>

c01027cf <vector208>:
.globl vector208
vector208:
  pushl $0
c01027cf:	6a 00                	push   $0x0
  pushl $208
c01027d1:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01027d6:	e9 a0 f7 ff ff       	jmp    c0101f7b <__alltraps>

c01027db <vector209>:
.globl vector209
vector209:
  pushl $0
c01027db:	6a 00                	push   $0x0
  pushl $209
c01027dd:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01027e2:	e9 94 f7 ff ff       	jmp    c0101f7b <__alltraps>

c01027e7 <vector210>:
.globl vector210
vector210:
  pushl $0
c01027e7:	6a 00                	push   $0x0
  pushl $210
c01027e9:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01027ee:	e9 88 f7 ff ff       	jmp    c0101f7b <__alltraps>

c01027f3 <vector211>:
.globl vector211
vector211:
  pushl $0
c01027f3:	6a 00                	push   $0x0
  pushl $211
c01027f5:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01027fa:	e9 7c f7 ff ff       	jmp    c0101f7b <__alltraps>

c01027ff <vector212>:
.globl vector212
vector212:
  pushl $0
c01027ff:	6a 00                	push   $0x0
  pushl $212
c0102801:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102806:	e9 70 f7 ff ff       	jmp    c0101f7b <__alltraps>

c010280b <vector213>:
.globl vector213
vector213:
  pushl $0
c010280b:	6a 00                	push   $0x0
  pushl $213
c010280d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102812:	e9 64 f7 ff ff       	jmp    c0101f7b <__alltraps>

c0102817 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102817:	6a 00                	push   $0x0
  pushl $214
c0102819:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010281e:	e9 58 f7 ff ff       	jmp    c0101f7b <__alltraps>

c0102823 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102823:	6a 00                	push   $0x0
  pushl $215
c0102825:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010282a:	e9 4c f7 ff ff       	jmp    c0101f7b <__alltraps>

c010282f <vector216>:
.globl vector216
vector216:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $216
c0102831:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102836:	e9 40 f7 ff ff       	jmp    c0101f7b <__alltraps>

c010283b <vector217>:
.globl vector217
vector217:
  pushl $0
c010283b:	6a 00                	push   $0x0
  pushl $217
c010283d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102842:	e9 34 f7 ff ff       	jmp    c0101f7b <__alltraps>

c0102847 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102847:	6a 00                	push   $0x0
  pushl $218
c0102849:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010284e:	e9 28 f7 ff ff       	jmp    c0101f7b <__alltraps>

c0102853 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $219
c0102855:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010285a:	e9 1c f7 ff ff       	jmp    c0101f7b <__alltraps>

c010285f <vector220>:
.globl vector220
vector220:
  pushl $0
c010285f:	6a 00                	push   $0x0
  pushl $220
c0102861:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102866:	e9 10 f7 ff ff       	jmp    c0101f7b <__alltraps>

c010286b <vector221>:
.globl vector221
vector221:
  pushl $0
c010286b:	6a 00                	push   $0x0
  pushl $221
c010286d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102872:	e9 04 f7 ff ff       	jmp    c0101f7b <__alltraps>

c0102877 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102877:	6a 00                	push   $0x0
  pushl $222
c0102879:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010287e:	e9 f8 f6 ff ff       	jmp    c0101f7b <__alltraps>

c0102883 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102883:	6a 00                	push   $0x0
  pushl $223
c0102885:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010288a:	e9 ec f6 ff ff       	jmp    c0101f7b <__alltraps>

c010288f <vector224>:
.globl vector224
vector224:
  pushl $0
c010288f:	6a 00                	push   $0x0
  pushl $224
c0102891:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102896:	e9 e0 f6 ff ff       	jmp    c0101f7b <__alltraps>

c010289b <vector225>:
.globl vector225
vector225:
  pushl $0
c010289b:	6a 00                	push   $0x0
  pushl $225
c010289d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01028a2:	e9 d4 f6 ff ff       	jmp    c0101f7b <__alltraps>

c01028a7 <vector226>:
.globl vector226
vector226:
  pushl $0
c01028a7:	6a 00                	push   $0x0
  pushl $226
c01028a9:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01028ae:	e9 c8 f6 ff ff       	jmp    c0101f7b <__alltraps>

c01028b3 <vector227>:
.globl vector227
vector227:
  pushl $0
c01028b3:	6a 00                	push   $0x0
  pushl $227
c01028b5:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01028ba:	e9 bc f6 ff ff       	jmp    c0101f7b <__alltraps>

c01028bf <vector228>:
.globl vector228
vector228:
  pushl $0
c01028bf:	6a 00                	push   $0x0
  pushl $228
c01028c1:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01028c6:	e9 b0 f6 ff ff       	jmp    c0101f7b <__alltraps>

c01028cb <vector229>:
.globl vector229
vector229:
  pushl $0
c01028cb:	6a 00                	push   $0x0
  pushl $229
c01028cd:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01028d2:	e9 a4 f6 ff ff       	jmp    c0101f7b <__alltraps>

c01028d7 <vector230>:
.globl vector230
vector230:
  pushl $0
c01028d7:	6a 00                	push   $0x0
  pushl $230
c01028d9:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01028de:	e9 98 f6 ff ff       	jmp    c0101f7b <__alltraps>

c01028e3 <vector231>:
.globl vector231
vector231:
  pushl $0
c01028e3:	6a 00                	push   $0x0
  pushl $231
c01028e5:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01028ea:	e9 8c f6 ff ff       	jmp    c0101f7b <__alltraps>

c01028ef <vector232>:
.globl vector232
vector232:
  pushl $0
c01028ef:	6a 00                	push   $0x0
  pushl $232
c01028f1:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01028f6:	e9 80 f6 ff ff       	jmp    c0101f7b <__alltraps>

c01028fb <vector233>:
.globl vector233
vector233:
  pushl $0
c01028fb:	6a 00                	push   $0x0
  pushl $233
c01028fd:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102902:	e9 74 f6 ff ff       	jmp    c0101f7b <__alltraps>

c0102907 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102907:	6a 00                	push   $0x0
  pushl $234
c0102909:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010290e:	e9 68 f6 ff ff       	jmp    c0101f7b <__alltraps>

c0102913 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102913:	6a 00                	push   $0x0
  pushl $235
c0102915:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010291a:	e9 5c f6 ff ff       	jmp    c0101f7b <__alltraps>

c010291f <vector236>:
.globl vector236
vector236:
  pushl $0
c010291f:	6a 00                	push   $0x0
  pushl $236
c0102921:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102926:	e9 50 f6 ff ff       	jmp    c0101f7b <__alltraps>

c010292b <vector237>:
.globl vector237
vector237:
  pushl $0
c010292b:	6a 00                	push   $0x0
  pushl $237
c010292d:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102932:	e9 44 f6 ff ff       	jmp    c0101f7b <__alltraps>

c0102937 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102937:	6a 00                	push   $0x0
  pushl $238
c0102939:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010293e:	e9 38 f6 ff ff       	jmp    c0101f7b <__alltraps>

c0102943 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102943:	6a 00                	push   $0x0
  pushl $239
c0102945:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010294a:	e9 2c f6 ff ff       	jmp    c0101f7b <__alltraps>

c010294f <vector240>:
.globl vector240
vector240:
  pushl $0
c010294f:	6a 00                	push   $0x0
  pushl $240
c0102951:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102956:	e9 20 f6 ff ff       	jmp    c0101f7b <__alltraps>

c010295b <vector241>:
.globl vector241
vector241:
  pushl $0
c010295b:	6a 00                	push   $0x0
  pushl $241
c010295d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102962:	e9 14 f6 ff ff       	jmp    c0101f7b <__alltraps>

c0102967 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102967:	6a 00                	push   $0x0
  pushl $242
c0102969:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010296e:	e9 08 f6 ff ff       	jmp    c0101f7b <__alltraps>

c0102973 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102973:	6a 00                	push   $0x0
  pushl $243
c0102975:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010297a:	e9 fc f5 ff ff       	jmp    c0101f7b <__alltraps>

c010297f <vector244>:
.globl vector244
vector244:
  pushl $0
c010297f:	6a 00                	push   $0x0
  pushl $244
c0102981:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102986:	e9 f0 f5 ff ff       	jmp    c0101f7b <__alltraps>

c010298b <vector245>:
.globl vector245
vector245:
  pushl $0
c010298b:	6a 00                	push   $0x0
  pushl $245
c010298d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102992:	e9 e4 f5 ff ff       	jmp    c0101f7b <__alltraps>

c0102997 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102997:	6a 00                	push   $0x0
  pushl $246
c0102999:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010299e:	e9 d8 f5 ff ff       	jmp    c0101f7b <__alltraps>

c01029a3 <vector247>:
.globl vector247
vector247:
  pushl $0
c01029a3:	6a 00                	push   $0x0
  pushl $247
c01029a5:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01029aa:	e9 cc f5 ff ff       	jmp    c0101f7b <__alltraps>

c01029af <vector248>:
.globl vector248
vector248:
  pushl $0
c01029af:	6a 00                	push   $0x0
  pushl $248
c01029b1:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01029b6:	e9 c0 f5 ff ff       	jmp    c0101f7b <__alltraps>

c01029bb <vector249>:
.globl vector249
vector249:
  pushl $0
c01029bb:	6a 00                	push   $0x0
  pushl $249
c01029bd:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01029c2:	e9 b4 f5 ff ff       	jmp    c0101f7b <__alltraps>

c01029c7 <vector250>:
.globl vector250
vector250:
  pushl $0
c01029c7:	6a 00                	push   $0x0
  pushl $250
c01029c9:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01029ce:	e9 a8 f5 ff ff       	jmp    c0101f7b <__alltraps>

c01029d3 <vector251>:
.globl vector251
vector251:
  pushl $0
c01029d3:	6a 00                	push   $0x0
  pushl $251
c01029d5:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01029da:	e9 9c f5 ff ff       	jmp    c0101f7b <__alltraps>

c01029df <vector252>:
.globl vector252
vector252:
  pushl $0
c01029df:	6a 00                	push   $0x0
  pushl $252
c01029e1:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01029e6:	e9 90 f5 ff ff       	jmp    c0101f7b <__alltraps>

c01029eb <vector253>:
.globl vector253
vector253:
  pushl $0
c01029eb:	6a 00                	push   $0x0
  pushl $253
c01029ed:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01029f2:	e9 84 f5 ff ff       	jmp    c0101f7b <__alltraps>

c01029f7 <vector254>:
.globl vector254
vector254:
  pushl $0
c01029f7:	6a 00                	push   $0x0
  pushl $254
c01029f9:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01029fe:	e9 78 f5 ff ff       	jmp    c0101f7b <__alltraps>

c0102a03 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102a03:	6a 00                	push   $0x0
  pushl $255
c0102a05:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102a0a:	e9 6c f5 ff ff       	jmp    c0101f7b <__alltraps>

c0102a0f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102a0f:	55                   	push   %ebp
c0102a10:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102a12:	8b 55 08             	mov    0x8(%ebp),%edx
c0102a15:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0102a1a:	29 c2                	sub    %eax,%edx
c0102a1c:	89 d0                	mov    %edx,%eax
c0102a1e:	c1 f8 02             	sar    $0x2,%eax
c0102a21:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102a27:	5d                   	pop    %ebp
c0102a28:	c3                   	ret    

c0102a29 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102a29:	55                   	push   %ebp
c0102a2a:	89 e5                	mov    %esp,%ebp
c0102a2c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102a2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a32:	89 04 24             	mov    %eax,(%esp)
c0102a35:	e8 d5 ff ff ff       	call   c0102a0f <page2ppn>
c0102a3a:	c1 e0 0c             	shl    $0xc,%eax
}
c0102a3d:	c9                   	leave  
c0102a3e:	c3                   	ret    

c0102a3f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102a3f:	55                   	push   %ebp
c0102a40:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102a42:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a45:	8b 00                	mov    (%eax),%eax
}
c0102a47:	5d                   	pop    %ebp
c0102a48:	c3                   	ret    

c0102a49 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102a49:	55                   	push   %ebp
c0102a4a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102a4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a52:	89 10                	mov    %edx,(%eax)
}
c0102a54:	5d                   	pop    %ebp
c0102a55:	c3                   	ret    

c0102a56 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102a56:	55                   	push   %ebp
c0102a57:	89 e5                	mov    %esp,%ebp
c0102a59:	83 ec 10             	sub    $0x10,%esp
c0102a5c:	c7 45 fc 10 af 11 c0 	movl   $0xc011af10,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102a63:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a66:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102a69:	89 50 04             	mov    %edx,0x4(%eax)
c0102a6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a6f:	8b 50 04             	mov    0x4(%eax),%edx
c0102a72:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a75:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102a77:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c0102a7e:	00 00 00 
}
c0102a81:	c9                   	leave  
c0102a82:	c3                   	ret    

c0102a83 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102a83:	55                   	push   %ebp
c0102a84:	89 e5                	mov    %esp,%ebp
c0102a86:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102a89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102a8d:	75 24                	jne    c0102ab3 <default_init_memmap+0x30>
c0102a8f:	c7 44 24 0c d0 69 10 	movl   $0xc01069d0,0xc(%esp)
c0102a96:	c0 
c0102a97:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0102a9e:	c0 
c0102a9f:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102aa6:	00 
c0102aa7:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0102aae:	e8 23 e2 ff ff       	call   c0100cd6 <__panic>
    struct Page *p = base;
c0102ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102ab9:	eb 7d                	jmp    c0102b38 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0102abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102abe:	83 c0 04             	add    $0x4,%eax
c0102ac1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102ac8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ace:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102ad1:	0f a3 10             	bt     %edx,(%eax)
c0102ad4:	19 c0                	sbb    %eax,%eax
c0102ad6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102ad9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102add:	0f 95 c0             	setne  %al
c0102ae0:	0f b6 c0             	movzbl %al,%eax
c0102ae3:	85 c0                	test   %eax,%eax
c0102ae5:	75 24                	jne    c0102b0b <default_init_memmap+0x88>
c0102ae7:	c7 44 24 0c 01 6a 10 	movl   $0xc0106a01,0xc(%esp)
c0102aee:	c0 
c0102aef:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0102af6:	c0 
c0102af7:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0102afe:	00 
c0102aff:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0102b06:	e8 cb e1 ff ff       	call   c0100cd6 <__panic>
	//初始化flags，property
        p->flags = p->property = 0;
c0102b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b18:	8b 50 08             	mov    0x8(%eax),%edx
c0102b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b1e:	89 50 04             	mov    %edx,0x4(%eax)
	//初始化ref
        set_page_ref(p, 0);
c0102b21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102b28:	00 
c0102b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b2c:	89 04 24             	mov    %eax,(%esp)
c0102b2f:	e8 15 ff ff ff       	call   c0102a49 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102b34:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102b38:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b3b:	89 d0                	mov    %edx,%eax
c0102b3d:	c1 e0 02             	shl    $0x2,%eax
c0102b40:	01 d0                	add    %edx,%eax
c0102b42:	c1 e0 02             	shl    $0x2,%eax
c0102b45:	89 c2                	mov    %eax,%edx
c0102b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b4a:	01 d0                	add    %edx,%eax
c0102b4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102b4f:	0f 85 66 ff ff ff    	jne    c0102abb <default_init_memmap+0x38>
        p->flags = p->property = 0;
	//初始化ref
        set_page_ref(p, 0);
    }
    //第一页并且空闲的页面property置为块的总数
    base->property = n;
c0102b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b58:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b5b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b61:	83 c0 04             	add    $0x4,%eax
c0102b64:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102b6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102b74:	0f ab 10             	bts    %edx,(%eax)
    //we should update the sum of the free memory blocks
    nr_free += n;
c0102b77:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b80:	01 d0                	add    %edx,%eax
c0102b82:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    list_add(&free_list, &(base->page_link));
c0102b87:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b8a:	83 c0 0c             	add    $0xc,%eax
c0102b8d:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
c0102b94:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102b97:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b9a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102b9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102ba0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102ba3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102ba6:	8b 40 04             	mov    0x4(%eax),%eax
c0102ba9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102bac:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102baf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102bb2:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102bb5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102bb8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102bbb:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102bbe:	89 10                	mov    %edx,(%eax)
c0102bc0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102bc3:	8b 10                	mov    (%eax),%edx
c0102bc5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102bc8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102bcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102bce:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102bd1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102bd4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102bd7:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102bda:	89 10                	mov    %edx,(%eax)
}
c0102bdc:	c9                   	leave  
c0102bdd:	c3                   	ret    

c0102bde <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102bde:	55                   	push   %ebp
c0102bdf:	89 e5                	mov    %esp,%ebp
c0102be1:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102be4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102be8:	75 24                	jne    c0102c0e <default_alloc_pages+0x30>
c0102bea:	c7 44 24 0c d0 69 10 	movl   $0xc01069d0,0xc(%esp)
c0102bf1:	c0 
c0102bf2:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0102bf9:	c0 
c0102bfa:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
c0102c01:	00 
c0102c02:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0102c09:	e8 c8 e0 ff ff       	call   c0100cd6 <__panic>
    //如果当前要分配的块数大于总共的空闲块总数
    if (n > nr_free) {
c0102c0e:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102c13:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102c16:	73 0a                	jae    c0102c22 <default_alloc_pages+0x44>
        return NULL;
c0102c18:	b8 00 00 00 00       	mov    $0x0,%eax
c0102c1d:	e9 95 01 00 00       	jmp    c0102db7 <default_alloc_pages+0x1d9>
    }
    struct Page *page = NULL;
c0102c22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    //search the free list
    list_entry_t *le = &free_list;
c0102c29:	c7 45 f0 10 af 11 c0 	movl   $0xc011af10,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102c30:	eb 1c                	jmp    c0102c4e <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c35:	83 e8 0c             	sub    $0xc,%eax
c0102c38:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//the num of free pages in this block >= n
        if (p->property >= n) {
c0102c3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c3e:	8b 40 08             	mov    0x8(%eax),%eax
c0102c41:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102c44:	72 08                	jb     c0102c4e <default_alloc_pages+0x70>
            page = p;
c0102c46:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102c4c:	eb 18                	jmp    c0102c66 <default_alloc_pages+0x88>
c0102c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c51:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102c54:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102c57:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    //search the free list
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c5d:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102c64:	75 cc                	jne    c0102c32 <default_alloc_pages+0x54>
            break;
        }
    }
    
    //Some flag bits of this page should be set
    if (page != NULL) {
c0102c66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102c6a:	0f 84 42 01 00 00    	je     c0102db2 <default_alloc_pages+0x1d4>
	//first `n` pages can be malloced
	struct Page *pi = page + 1;
c0102c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c73:	83 c0 14             	add    $0x14,%eax
c0102c76:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for(pi; pi != page + n; pi++) {
c0102c79:	eb 21                	jmp    c0102c9c <default_alloc_pages+0xbe>
	    pi->property = 0;
c0102c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    set_page_ref(pi, 0);
c0102c85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c8c:	00 
c0102c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c90:	89 04 24             	mov    %eax,(%esp)
c0102c93:	e8 b1 fd ff ff       	call   c0102a49 <set_page_ref>
    
    //Some flag bits of this page should be set
    if (page != NULL) {
	//first `n` pages can be malloced
	struct Page *pi = page + 1;
	for(pi; pi != page + n; pi++) {
c0102c98:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c0102c9c:	8b 55 08             	mov    0x8(%ebp),%edx
c0102c9f:	89 d0                	mov    %edx,%eax
c0102ca1:	c1 e0 02             	shl    $0x2,%eax
c0102ca4:	01 d0                	add    %edx,%eax
c0102ca6:	c1 e0 02             	shl    $0x2,%eax
c0102ca9:	89 c2                	mov    %eax,%edx
c0102cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cae:	01 d0                	add    %edx,%eax
c0102cb0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102cb3:	75 c6                	jne    c0102c7b <default_alloc_pages+0x9d>
	    pi->property = 0;
	    set_page_ref(pi, 0);
	}
        //list_del(&(page->page_link));
        if (page->property > n) {
c0102cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cb8:	8b 40 08             	mov    0x8(%eax),%eax
c0102cbb:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102cbe:	0f 86 98 00 00 00    	jbe    c0102d5c <default_alloc_pages+0x17e>
            struct Page *p = page + n;
c0102cc4:	8b 55 08             	mov    0x8(%ebp),%edx
c0102cc7:	89 d0                	mov    %edx,%eax
c0102cc9:	c1 e0 02             	shl    $0x2,%eax
c0102ccc:	01 d0                	add    %edx,%eax
c0102cce:	c1 e0 02             	shl    $0x2,%eax
c0102cd1:	89 c2                	mov    %eax,%edx
c0102cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cd6:	01 d0                	add    %edx,%eax
c0102cd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    //re-caculate number of the rest of this free block
            p->property = page->property - n;
c0102cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cde:	8b 40 08             	mov    0x8(%eax),%eax
c0102ce1:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ce4:	89 c2                	mov    %eax,%edx
c0102ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ce9:	89 50 08             	mov    %edx,0x8(%eax)
	    SetPageProperty(p);
c0102cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102cef:	83 c0 04             	add    $0x4,%eax
c0102cf2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102cf9:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102cfc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102cff:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d02:	0f ab 10             	bts    %edx,(%eax)
	    //分裂后的块插入当前块后面，以保证列表的顺序性
            list_add(&(page->page_link), &(p->page_link));
c0102d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d08:	83 c0 0c             	add    $0xc,%eax
c0102d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102d0e:	83 c2 0c             	add    $0xc,%edx
c0102d11:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102d14:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102d17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d1a:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102d1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d20:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102d23:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d26:	8b 40 04             	mov    0x4(%eax),%eax
c0102d29:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102d2c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102d2f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102d32:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102d35:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102d38:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d3b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d3e:	89 10                	mov    %edx,(%eax)
c0102d40:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d43:	8b 10                	mov    (%eax),%edx
c0102d45:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d48:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102d4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d4e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d51:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102d54:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d57:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102d5a:	89 10                	mov    %edx,(%eax)
    }
	//re-caculate nr-free
        nr_free = nr_free - n;
c0102d5c:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102d61:	2b 45 08             	sub    0x8(%ebp),%eax
c0102d64:	a3 18 af 11 c0       	mov    %eax,0xc011af18
	//unlink the pages from 'free_list'
	list_del(&(page->page_link));
c0102d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d6c:	83 c0 0c             	add    $0xc,%eax
c0102d6f:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d72:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d75:	8b 40 04             	mov    0x4(%eax),%eax
c0102d78:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d7b:	8b 12                	mov    (%edx),%edx
c0102d7d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0102d80:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d83:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d86:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102d89:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d8c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d8f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d92:	89 10                	mov    %edx,(%eax)
        ClearPageProperty(page);
c0102d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d97:	83 c0 04             	add    $0x4,%eax
c0102d9a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0102da1:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102da4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102da7:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102daa:	0f b3 10             	btr    %edx,(%eax)
    } else {
	return NULL;
    }
    return page;
c0102dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db0:	eb 05                	jmp    c0102db7 <default_alloc_pages+0x1d9>
        nr_free = nr_free - n;
	//unlink the pages from 'free_list'
	list_del(&(page->page_link));
        ClearPageProperty(page);
    } else {
	return NULL;
c0102db2:	b8 00 00 00 00       	mov    $0x0,%eax
    }
    return page;
}
c0102db7:	c9                   	leave  
c0102db8:	c3                   	ret    

c0102db9 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102db9:	55                   	push   %ebp
c0102dba:	89 e5                	mov    %esp,%ebp
c0102dbc:	81 ec b8 00 00 00    	sub    $0xb8,%esp
    assert(n > 0);
c0102dc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102dc6:	75 24                	jne    c0102dec <default_free_pages+0x33>
c0102dc8:	c7 44 24 0c d0 69 10 	movl   $0xc01069d0,0xc(%esp)
c0102dcf:	c0 
c0102dd0:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0102dd7:	c0 
c0102dd8:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0102ddf:	00 
c0102de0:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0102de7:	e8 ea de ff ff       	call   c0100cd6 <__panic>
    struct Page *p = base;
c0102dec:	8b 45 08             	mov    0x8(%ebp),%eax
c0102def:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102df2:	e9 9d 00 00 00       	jmp    c0102e94 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dfa:	83 c0 04             	add    $0x4,%eax
c0102dfd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c0102e04:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102e07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102e0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102e0d:	0f a3 10             	bt     %edx,(%eax)
c0102e10:	19 c0                	sbb    %eax,%eax
c0102e12:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c0102e15:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0102e19:	0f 95 c0             	setne  %al
c0102e1c:	0f b6 c0             	movzbl %al,%eax
c0102e1f:	85 c0                	test   %eax,%eax
c0102e21:	75 2c                	jne    c0102e4f <default_free_pages+0x96>
c0102e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e26:	83 c0 04             	add    $0x4,%eax
c0102e29:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0102e30:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102e33:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102e36:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102e39:	0f a3 10             	bt     %edx,(%eax)
c0102e3c:	19 c0                	sbb    %eax,%eax
c0102e3e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return oldbit != 0;
c0102e41:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0102e45:	0f 95 c0             	setne  %al
c0102e48:	0f b6 c0             	movzbl %al,%eax
c0102e4b:	85 c0                	test   %eax,%eax
c0102e4d:	74 24                	je     c0102e73 <default_free_pages+0xba>
c0102e4f:	c7 44 24 0c 14 6a 10 	movl   $0xc0106a14,0xc(%esp)
c0102e56:	c0 
c0102e57:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0102e5e:	c0 
c0102e5f:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0102e66:	00 
c0102e67:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0102e6e:	e8 63 de ff ff       	call   c0100cd6 <__panic>
        p->flags = 0;
c0102e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102e7d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102e84:	00 
c0102e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e88:	89 04 24             	mov    %eax,(%esp)
c0102e8b:	e8 b9 fb ff ff       	call   c0102a49 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102e90:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102e94:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e97:	89 d0                	mov    %edx,%eax
c0102e99:	c1 e0 02             	shl    $0x2,%eax
c0102e9c:	01 d0                	add    %edx,%eax
c0102e9e:	c1 e0 02             	shl    $0x2,%eax
c0102ea1:	89 c2                	mov    %eax,%edx
c0102ea3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ea6:	01 d0                	add    %edx,%eax
c0102ea8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102eab:	0f 85 46 ff ff ff    	jne    c0102df7 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102eb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102eb7:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102eba:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ebd:	83 c0 04             	add    $0x4,%eax
c0102ec0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102ec7:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102eca:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102ecd:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102ed0:	0f ab 10             	bts    %edx,(%eax)
    struct Page *behind = NULL;//记录后面可以合并的
c0102ed3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    struct Page *before = NULL;//记录前面可以合并的
c0102eda:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    bool hasBehind = 0;//是否有后面可以合并的
c0102ee1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    bool hasBefore = 0;//是否有前面可以合并的
c0102ee8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bool bigSmall = 0;//base地址附近没有可以合并的块，记录base块应该插入p的前还是后？
c0102eef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102ef6:	c7 45 b8 10 af 11 c0 	movl   $0xc011af10,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102efd:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102f00:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102f03:	89 45 dc             	mov    %eax,-0x24(%ebp)
    while (le != &free_list) {
c0102f06:	e9 9b 00 00 00       	jmp    c0102fa6 <default_free_pages+0x1ed>
        p = le2page(le, page_link);
c0102f0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102f0e:	83 e8 0c             	sub    $0xc,%eax
c0102f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f14:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102f17:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102f1a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102f1d:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);	
c0102f20:	89 45 dc             	mov    %eax,-0x24(%ebp)
	//找到base前面可以合并的块
        if (p + p->property == base) {
c0102f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f26:	8b 50 08             	mov    0x8(%eax),%edx
c0102f29:	89 d0                	mov    %edx,%eax
c0102f2b:	c1 e0 02             	shl    $0x2,%eax
c0102f2e:	01 d0                	add    %edx,%eax
c0102f30:	c1 e0 02             	shl    $0x2,%eax
c0102f33:	89 c2                	mov    %eax,%edx
c0102f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f38:	01 d0                	add    %edx,%eax
c0102f3a:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102f3d:	75 0f                	jne    c0102f4e <default_free_pages+0x195>
            before = p;
c0102f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f42:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    hasBefore = 1;
c0102f45:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102f4c:	eb 2b                	jmp    c0102f79 <default_free_pages+0x1c0>
        }
	//找到base后面可以合并的块
        else if (base + base->property == p) {
c0102f4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f51:	8b 50 08             	mov    0x8(%eax),%edx
c0102f54:	89 d0                	mov    %edx,%eax
c0102f56:	c1 e0 02             	shl    $0x2,%eax
c0102f59:	01 d0                	add    %edx,%eax
c0102f5b:	c1 e0 02             	shl    $0x2,%eax
c0102f5e:	89 c2                	mov    %eax,%edx
c0102f60:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f63:	01 d0                	add    %edx,%eax
c0102f65:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f68:	75 0f                	jne    c0102f79 <default_free_pages+0x1c0>
            behind = p;
c0102f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    hasBehind = 1;
c0102f70:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	    break;//后面的找到就没比较继续遍历了
c0102f77:	eb 3a                	jmp    c0102fb3 <default_free_pages+0x1fa>
        }
	//超过了base及其块的范围仍未找到可以合并的
	if(p > base && p != base + base->property) {
c0102f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f7c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102f7f:	76 25                	jbe    c0102fa6 <default_free_pages+0x1ed>
c0102f81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f84:	8b 50 08             	mov    0x8(%eax),%edx
c0102f87:	89 d0                	mov    %edx,%eax
c0102f89:	c1 e0 02             	shl    $0x2,%eax
c0102f8c:	01 d0                	add    %edx,%eax
c0102f8e:	c1 e0 02             	shl    $0x2,%eax
c0102f91:	89 c2                	mov    %eax,%edx
c0102f93:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f96:	01 d0                	add    %edx,%eax
c0102f98:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f9b:	74 09                	je     c0102fa6 <default_free_pages+0x1ed>
	    bigSmall = 1; //p在base的后面
c0102f9d:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	    break;//此时没有必要继续遍历了
c0102fa4:	eb 0d                	jmp    c0102fb3 <default_free_pages+0x1fa>
    struct Page *before = NULL;//记录前面可以合并的
    bool hasBehind = 0;//是否有后面可以合并的
    bool hasBefore = 0;//是否有前面可以合并的
    bool bigSmall = 0;//base地址附近没有可以合并的块，记录base块应该插入p的前还是后？
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102fa6:	81 7d dc 10 af 11 c0 	cmpl   $0xc011af10,-0x24(%ebp)
c0102fad:	0f 85 58 ff ff ff    	jne    c0102f0b <default_free_pages+0x152>
	    bigSmall = 1; //p在base的后面
	    break;//此时没有必要继续遍历了
        }
    }
    
    nr_free = nr_free + n;
c0102fb3:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102fbc:	01 d0                	add    %edx,%eax
c0102fbe:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    
    //没有可以合并的，直接将base加入链表即可
    if(!hasBefore && !hasBehind && bigSmall) {
c0102fc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102fc7:	75 58                	jne    c0103021 <default_free_pages+0x268>
c0102fc9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102fcd:	75 52                	jne    c0103021 <default_free_pages+0x268>
c0102fcf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102fd3:	74 4c                	je     c0103021 <default_free_pages+0x268>
	list_add_before(&(p->page_link), &(base->page_link));//base在p前的情况
c0102fd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fd8:	83 c0 0c             	add    $0xc,%eax
c0102fdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102fde:	83 c2 0c             	add    $0xc,%edx
c0102fe1:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0102fe4:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102fe7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102fea:	8b 00                	mov    (%eax),%eax
c0102fec:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102fef:	89 55 a8             	mov    %edx,-0x58(%ebp)
c0102ff2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102ff5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102ff8:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ffb:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ffe:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103001:	89 10                	mov    %edx,(%eax)
c0103003:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103006:	8b 10                	mov    (%eax),%edx
c0103008:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010300b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010300e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103011:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103014:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103017:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010301a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010301d:	89 10                	mov    %edx,(%eax)
c010301f:	eb 5a                	jmp    c010307b <default_free_pages+0x2c2>
    } else if(!hasBefore && !hasBehind && !bigSmall) {
c0103021:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103025:	75 54                	jne    c010307b <default_free_pages+0x2c2>
c0103027:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010302b:	75 4e                	jne    c010307b <default_free_pages+0x2c2>
c010302d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103031:	75 48                	jne    c010307b <default_free_pages+0x2c2>
	list_add_before(&free_list, &(base->page_link));
c0103033:	8b 45 08             	mov    0x8(%ebp),%eax
c0103036:	83 c0 0c             	add    $0xc,%eax
c0103039:	c7 45 9c 10 af 11 c0 	movl   $0xc011af10,-0x64(%ebp)
c0103040:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103043:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103046:	8b 00                	mov    (%eax),%eax
c0103048:	8b 55 98             	mov    -0x68(%ebp),%edx
c010304b:	89 55 94             	mov    %edx,-0x6c(%ebp)
c010304e:	89 45 90             	mov    %eax,-0x70(%ebp)
c0103051:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103054:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103057:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010305a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010305d:	89 10                	mov    %edx,(%eax)
c010305f:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103062:	8b 10                	mov    (%eax),%edx
c0103064:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103067:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010306a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010306d:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103070:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103073:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103076:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103079:	89 10                	mov    %edx,(%eax)
    }
    
    //合并操作
    //先合并前面的块
    if(hasBefore) {
c010307b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010307f:	74 33                	je     c01030b4 <default_free_pages+0x2fb>
    	before->property = before->property + base->property;
c0103081:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103084:	8b 50 08             	mov    0x8(%eax),%edx
c0103087:	8b 45 08             	mov    0x8(%ebp),%eax
c010308a:	8b 40 08             	mov    0x8(%eax),%eax
c010308d:	01 c2                	add    %eax,%edx
c010308f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103092:	89 50 08             	mov    %edx,0x8(%eax)
	    ClearPageProperty(base);
c0103095:	8b 45 08             	mov    0x8(%ebp),%eax
c0103098:	83 c0 04             	add    $0x4,%eax
c010309b:	c7 45 88 01 00 00 00 	movl   $0x1,-0x78(%ebp)
c01030a2:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01030a5:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01030a8:	8b 55 88             	mov    -0x78(%ebp),%edx
c01030ab:	0f b3 10             	btr    %edx,(%eax)
	    base = before; //此时base是合并后的块
c01030ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030b1:	89 45 08             	mov    %eax,0x8(%ebp)
    }
    //继续合并后面的块
    if(hasBehind) {
c01030b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01030b8:	0f 84 f9 00 00 00    	je     c01031b7 <default_free_pages+0x3fe>
    	base->property = base->property + behind->property;
c01030be:	8b 45 08             	mov    0x8(%ebp),%eax
c01030c1:	8b 50 08             	mov    0x8(%eax),%edx
c01030c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030c7:	8b 40 08             	mov    0x8(%eax),%eax
c01030ca:	01 c2                	add    %eax,%edx
c01030cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01030cf:	89 50 08             	mov    %edx,0x8(%eax)
	    ClearPageProperty(behind);
c01030d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030d5:	83 c0 04             	add    $0x4,%eax
c01030d8:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%ebp)
c01030df:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01030e5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01030eb:	8b 55 80             	mov    -0x80(%ebp),%edx
c01030ee:	0f b3 10             	btr    %edx,(%eax)
        if(!hasBefore) {
c01030f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01030f5:	75 7a                	jne    c0103171 <default_free_pages+0x3b8>
        list_add_before(&(behind->page_link), &(base->page_link));
c01030f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01030fa:	83 c0 0c             	add    $0xc,%eax
c01030fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103100:	83 c2 0c             	add    $0xc,%edx
c0103103:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
c0103109:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010310f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0103115:	8b 00                	mov    (%eax),%eax
c0103117:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c010311d:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
c0103123:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
c0103129:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c010312f:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103135:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c010313b:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c0103141:	89 10                	mov    %edx,(%eax)
c0103143:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c0103149:	8b 10                	mov    (%eax),%edx
c010314b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0103151:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103154:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c010315a:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
c0103160:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103163:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0103169:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c010316f:	89 10                	mov    %edx,(%eax)
        }
	    list_del(&(behind->page_link));
c0103171:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103174:	83 c0 0c             	add    $0xc,%eax
c0103177:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010317d:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c0103183:	8b 40 04             	mov    0x4(%eax),%eax
c0103186:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
c010318c:	8b 12                	mov    (%edx),%edx
c010318e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
c0103194:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010319a:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
c01031a0:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
c01031a6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01031a9:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
c01031af:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
c01031b5:	89 10                	mov    %edx,(%eax)
    }
    
    //list_add(&free_list, &(base->page_link));
}
c01031b7:	c9                   	leave  
c01031b8:	c3                   	ret    

c01031b9 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01031b9:	55                   	push   %ebp
c01031ba:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01031bc:	a1 18 af 11 c0       	mov    0xc011af18,%eax
}
c01031c1:	5d                   	pop    %ebp
c01031c2:	c3                   	ret    

c01031c3 <basic_check>:

static void
basic_check(void) {
c01031c3:	55                   	push   %ebp
c01031c4:	89 e5                	mov    %esp,%ebp
c01031c6:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01031c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01031d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01031dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031e3:	e8 9d 0e 00 00       	call   c0104085 <alloc_pages>
c01031e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01031ef:	75 24                	jne    c0103215 <basic_check+0x52>
c01031f1:	c7 44 24 0c 39 6a 10 	movl   $0xc0106a39,0xc(%esp)
c01031f8:	c0 
c01031f9:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103200:	c0 
c0103201:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103208:	00 
c0103209:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103210:	e8 c1 da ff ff       	call   c0100cd6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103215:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010321c:	e8 64 0e 00 00       	call   c0104085 <alloc_pages>
c0103221:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103224:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103228:	75 24                	jne    c010324e <basic_check+0x8b>
c010322a:	c7 44 24 0c 55 6a 10 	movl   $0xc0106a55,0xc(%esp)
c0103231:	c0 
c0103232:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103239:	c0 
c010323a:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103241:	00 
c0103242:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103249:	e8 88 da ff ff       	call   c0100cd6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010324e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103255:	e8 2b 0e 00 00       	call   c0104085 <alloc_pages>
c010325a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010325d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103261:	75 24                	jne    c0103287 <basic_check+0xc4>
c0103263:	c7 44 24 0c 71 6a 10 	movl   $0xc0106a71,0xc(%esp)
c010326a:	c0 
c010326b:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103272:	c0 
c0103273:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c010327a:	00 
c010327b:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103282:	e8 4f da ff ff       	call   c0100cd6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103287:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010328a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010328d:	74 10                	je     c010329f <basic_check+0xdc>
c010328f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103292:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103295:	74 08                	je     c010329f <basic_check+0xdc>
c0103297:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010329a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010329d:	75 24                	jne    c01032c3 <basic_check+0x100>
c010329f:	c7 44 24 0c 90 6a 10 	movl   $0xc0106a90,0xc(%esp)
c01032a6:	c0 
c01032a7:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c01032ae:	c0 
c01032af:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01032b6:	00 
c01032b7:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c01032be:	e8 13 da ff ff       	call   c0100cd6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01032c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032c6:	89 04 24             	mov    %eax,(%esp)
c01032c9:	e8 71 f7 ff ff       	call   c0102a3f <page_ref>
c01032ce:	85 c0                	test   %eax,%eax
c01032d0:	75 1e                	jne    c01032f0 <basic_check+0x12d>
c01032d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032d5:	89 04 24             	mov    %eax,(%esp)
c01032d8:	e8 62 f7 ff ff       	call   c0102a3f <page_ref>
c01032dd:	85 c0                	test   %eax,%eax
c01032df:	75 0f                	jne    c01032f0 <basic_check+0x12d>
c01032e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e4:	89 04 24             	mov    %eax,(%esp)
c01032e7:	e8 53 f7 ff ff       	call   c0102a3f <page_ref>
c01032ec:	85 c0                	test   %eax,%eax
c01032ee:	74 24                	je     c0103314 <basic_check+0x151>
c01032f0:	c7 44 24 0c b4 6a 10 	movl   $0xc0106ab4,0xc(%esp)
c01032f7:	c0 
c01032f8:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c01032ff:	c0 
c0103300:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103307:	00 
c0103308:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c010330f:	e8 c2 d9 ff ff       	call   c0100cd6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103314:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103317:	89 04 24             	mov    %eax,(%esp)
c010331a:	e8 0a f7 ff ff       	call   c0102a29 <page2pa>
c010331f:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0103325:	c1 e2 0c             	shl    $0xc,%edx
c0103328:	39 d0                	cmp    %edx,%eax
c010332a:	72 24                	jb     c0103350 <basic_check+0x18d>
c010332c:	c7 44 24 0c f0 6a 10 	movl   $0xc0106af0,0xc(%esp)
c0103333:	c0 
c0103334:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c010333b:	c0 
c010333c:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103343:	00 
c0103344:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c010334b:	e8 86 d9 ff ff       	call   c0100cd6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103350:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103353:	89 04 24             	mov    %eax,(%esp)
c0103356:	e8 ce f6 ff ff       	call   c0102a29 <page2pa>
c010335b:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0103361:	c1 e2 0c             	shl    $0xc,%edx
c0103364:	39 d0                	cmp    %edx,%eax
c0103366:	72 24                	jb     c010338c <basic_check+0x1c9>
c0103368:	c7 44 24 0c 0d 6b 10 	movl   $0xc0106b0d,0xc(%esp)
c010336f:	c0 
c0103370:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103377:	c0 
c0103378:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c010337f:	00 
c0103380:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103387:	e8 4a d9 ff ff       	call   c0100cd6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010338f:	89 04 24             	mov    %eax,(%esp)
c0103392:	e8 92 f6 ff ff       	call   c0102a29 <page2pa>
c0103397:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c010339d:	c1 e2 0c             	shl    $0xc,%edx
c01033a0:	39 d0                	cmp    %edx,%eax
c01033a2:	72 24                	jb     c01033c8 <basic_check+0x205>
c01033a4:	c7 44 24 0c 2a 6b 10 	movl   $0xc0106b2a,0xc(%esp)
c01033ab:	c0 
c01033ac:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c01033b3:	c0 
c01033b4:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01033bb:	00 
c01033bc:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c01033c3:	e8 0e d9 ff ff       	call   c0100cd6 <__panic>

    list_entry_t free_list_store = free_list;
c01033c8:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c01033cd:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c01033d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01033d6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01033d9:	c7 45 e0 10 af 11 c0 	movl   $0xc011af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01033e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01033e6:	89 50 04             	mov    %edx,0x4(%eax)
c01033e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033ec:	8b 50 04             	mov    0x4(%eax),%edx
c01033ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033f2:	89 10                	mov    %edx,(%eax)
c01033f4:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01033fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033fe:	8b 40 04             	mov    0x4(%eax),%eax
c0103401:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103404:	0f 94 c0             	sete   %al
c0103407:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010340a:	85 c0                	test   %eax,%eax
c010340c:	75 24                	jne    c0103432 <basic_check+0x26f>
c010340e:	c7 44 24 0c 47 6b 10 	movl   $0xc0106b47,0xc(%esp)
c0103415:	c0 
c0103416:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c010341d:	c0 
c010341e:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0103425:	00 
c0103426:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c010342d:	e8 a4 d8 ff ff       	call   c0100cd6 <__panic>

    unsigned int nr_free_store = nr_free;
c0103432:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103437:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010343a:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c0103441:	00 00 00 

    assert(alloc_page() == NULL);
c0103444:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010344b:	e8 35 0c 00 00       	call   c0104085 <alloc_pages>
c0103450:	85 c0                	test   %eax,%eax
c0103452:	74 24                	je     c0103478 <basic_check+0x2b5>
c0103454:	c7 44 24 0c 5e 6b 10 	movl   $0xc0106b5e,0xc(%esp)
c010345b:	c0 
c010345c:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103463:	c0 
c0103464:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c010346b:	00 
c010346c:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103473:	e8 5e d8 ff ff       	call   c0100cd6 <__panic>

    free_page(p0);
c0103478:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010347f:	00 
c0103480:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103483:	89 04 24             	mov    %eax,(%esp)
c0103486:	e8 32 0c 00 00       	call   c01040bd <free_pages>
    free_page(p1);
c010348b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103492:	00 
c0103493:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103496:	89 04 24             	mov    %eax,(%esp)
c0103499:	e8 1f 0c 00 00       	call   c01040bd <free_pages>
    free_page(p2);
c010349e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01034a5:	00 
c01034a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034a9:	89 04 24             	mov    %eax,(%esp)
c01034ac:	e8 0c 0c 00 00       	call   c01040bd <free_pages>
    assert(nr_free == 3);
c01034b1:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c01034b6:	83 f8 03             	cmp    $0x3,%eax
c01034b9:	74 24                	je     c01034df <basic_check+0x31c>
c01034bb:	c7 44 24 0c 73 6b 10 	movl   $0xc0106b73,0xc(%esp)
c01034c2:	c0 
c01034c3:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c01034ca:	c0 
c01034cb:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c01034d2:	00 
c01034d3:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c01034da:	e8 f7 d7 ff ff       	call   c0100cd6 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01034df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034e6:	e8 9a 0b 00 00       	call   c0104085 <alloc_pages>
c01034eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01034ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01034f2:	75 24                	jne    c0103518 <basic_check+0x355>
c01034f4:	c7 44 24 0c 39 6a 10 	movl   $0xc0106a39,0xc(%esp)
c01034fb:	c0 
c01034fc:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103503:	c0 
c0103504:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c010350b:	00 
c010350c:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103513:	e8 be d7 ff ff       	call   c0100cd6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103518:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010351f:	e8 61 0b 00 00       	call   c0104085 <alloc_pages>
c0103524:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103527:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010352b:	75 24                	jne    c0103551 <basic_check+0x38e>
c010352d:	c7 44 24 0c 55 6a 10 	movl   $0xc0106a55,0xc(%esp)
c0103534:	c0 
c0103535:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c010353c:	c0 
c010353d:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0103544:	00 
c0103545:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c010354c:	e8 85 d7 ff ff       	call   c0100cd6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103551:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103558:	e8 28 0b 00 00       	call   c0104085 <alloc_pages>
c010355d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103564:	75 24                	jne    c010358a <basic_check+0x3c7>
c0103566:	c7 44 24 0c 71 6a 10 	movl   $0xc0106a71,0xc(%esp)
c010356d:	c0 
c010356e:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103575:	c0 
c0103576:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c010357d:	00 
c010357e:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103585:	e8 4c d7 ff ff       	call   c0100cd6 <__panic>

    assert(alloc_page() == NULL);
c010358a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103591:	e8 ef 0a 00 00       	call   c0104085 <alloc_pages>
c0103596:	85 c0                	test   %eax,%eax
c0103598:	74 24                	je     c01035be <basic_check+0x3fb>
c010359a:	c7 44 24 0c 5e 6b 10 	movl   $0xc0106b5e,0xc(%esp)
c01035a1:	c0 
c01035a2:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c01035a9:	c0 
c01035aa:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01035b1:	00 
c01035b2:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c01035b9:	e8 18 d7 ff ff       	call   c0100cd6 <__panic>

    free_page(p0);
c01035be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035c5:	00 
c01035c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035c9:	89 04 24             	mov    %eax,(%esp)
c01035cc:	e8 ec 0a 00 00       	call   c01040bd <free_pages>
c01035d1:	c7 45 d8 10 af 11 c0 	movl   $0xc011af10,-0x28(%ebp)
c01035d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035db:	8b 40 04             	mov    0x4(%eax),%eax
c01035de:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01035e1:	0f 94 c0             	sete   %al
c01035e4:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01035e7:	85 c0                	test   %eax,%eax
c01035e9:	74 24                	je     c010360f <basic_check+0x44c>
c01035eb:	c7 44 24 0c 80 6b 10 	movl   $0xc0106b80,0xc(%esp)
c01035f2:	c0 
c01035f3:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c01035fa:	c0 
c01035fb:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0103602:	00 
c0103603:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c010360a:	e8 c7 d6 ff ff       	call   c0100cd6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010360f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103616:	e8 6a 0a 00 00       	call   c0104085 <alloc_pages>
c010361b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010361e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103621:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103624:	74 24                	je     c010364a <basic_check+0x487>
c0103626:	c7 44 24 0c 98 6b 10 	movl   $0xc0106b98,0xc(%esp)
c010362d:	c0 
c010362e:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103635:	c0 
c0103636:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c010363d:	00 
c010363e:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103645:	e8 8c d6 ff ff       	call   c0100cd6 <__panic>
    assert(alloc_page() == NULL);
c010364a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103651:	e8 2f 0a 00 00       	call   c0104085 <alloc_pages>
c0103656:	85 c0                	test   %eax,%eax
c0103658:	74 24                	je     c010367e <basic_check+0x4bb>
c010365a:	c7 44 24 0c 5e 6b 10 	movl   $0xc0106b5e,0xc(%esp)
c0103661:	c0 
c0103662:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103669:	c0 
c010366a:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0103671:	00 
c0103672:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103679:	e8 58 d6 ff ff       	call   c0100cd6 <__panic>

    assert(nr_free == 0);
c010367e:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103683:	85 c0                	test   %eax,%eax
c0103685:	74 24                	je     c01036ab <basic_check+0x4e8>
c0103687:	c7 44 24 0c b1 6b 10 	movl   $0xc0106bb1,0xc(%esp)
c010368e:	c0 
c010368f:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103696:	c0 
c0103697:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c010369e:	00 
c010369f:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c01036a6:	e8 2b d6 ff ff       	call   c0100cd6 <__panic>
    free_list = free_list_store;
c01036ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01036ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01036b1:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c01036b6:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    nr_free = nr_free_store;
c01036bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036bf:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_page(p);
c01036c4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036cb:	00 
c01036cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036cf:	89 04 24             	mov    %eax,(%esp)
c01036d2:	e8 e6 09 00 00       	call   c01040bd <free_pages>
    free_page(p1);
c01036d7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036de:	00 
c01036df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036e2:	89 04 24             	mov    %eax,(%esp)
c01036e5:	e8 d3 09 00 00       	call   c01040bd <free_pages>
    free_page(p2);
c01036ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036f1:	00 
c01036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f5:	89 04 24             	mov    %eax,(%esp)
c01036f8:	e8 c0 09 00 00       	call   c01040bd <free_pages>
}
c01036fd:	c9                   	leave  
c01036fe:	c3                   	ret    

c01036ff <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01036ff:	55                   	push   %ebp
c0103700:	89 e5                	mov    %esp,%ebp
c0103702:	53                   	push   %ebx
c0103703:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103709:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103710:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103717:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010371e:	eb 6b                	jmp    c010378b <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103720:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103723:	83 e8 0c             	sub    $0xc,%eax
c0103726:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103729:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010372c:	83 c0 04             	add    $0x4,%eax
c010372f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103736:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103739:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010373c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010373f:	0f a3 10             	bt     %edx,(%eax)
c0103742:	19 c0                	sbb    %eax,%eax
c0103744:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103747:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010374b:	0f 95 c0             	setne  %al
c010374e:	0f b6 c0             	movzbl %al,%eax
c0103751:	85 c0                	test   %eax,%eax
c0103753:	75 24                	jne    c0103779 <default_check+0x7a>
c0103755:	c7 44 24 0c be 6b 10 	movl   $0xc0106bbe,0xc(%esp)
c010375c:	c0 
c010375d:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103764:	c0 
c0103765:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c010376c:	00 
c010376d:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103774:	e8 5d d5 ff ff       	call   c0100cd6 <__panic>
        count ++, total += p->property;
c0103779:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010377d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103780:	8b 50 08             	mov    0x8(%eax),%edx
c0103783:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103786:	01 d0                	add    %edx,%eax
c0103788:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010378b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010378e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103791:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103794:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103797:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010379a:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c01037a1:	0f 85 79 ff ff ff    	jne    c0103720 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01037a7:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01037aa:	e8 40 09 00 00       	call   c01040ef <nr_free_pages>
c01037af:	39 c3                	cmp    %eax,%ebx
c01037b1:	74 24                	je     c01037d7 <default_check+0xd8>
c01037b3:	c7 44 24 0c ce 6b 10 	movl   $0xc0106bce,0xc(%esp)
c01037ba:	c0 
c01037bb:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c01037c2:	c0 
c01037c3:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c01037ca:	00 
c01037cb:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c01037d2:	e8 ff d4 ff ff       	call   c0100cd6 <__panic>

    basic_check();
c01037d7:	e8 e7 f9 ff ff       	call   c01031c3 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01037dc:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01037e3:	e8 9d 08 00 00       	call   c0104085 <alloc_pages>
c01037e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01037eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01037ef:	75 24                	jne    c0103815 <default_check+0x116>
c01037f1:	c7 44 24 0c e7 6b 10 	movl   $0xc0106be7,0xc(%esp)
c01037f8:	c0 
c01037f9:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103800:	c0 
c0103801:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0103808:	00 
c0103809:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103810:	e8 c1 d4 ff ff       	call   c0100cd6 <__panic>
    assert(!PageProperty(p0));
c0103815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103818:	83 c0 04             	add    $0x4,%eax
c010381b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103822:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103825:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103828:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010382b:	0f a3 10             	bt     %edx,(%eax)
c010382e:	19 c0                	sbb    %eax,%eax
c0103830:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103833:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103837:	0f 95 c0             	setne  %al
c010383a:	0f b6 c0             	movzbl %al,%eax
c010383d:	85 c0                	test   %eax,%eax
c010383f:	74 24                	je     c0103865 <default_check+0x166>
c0103841:	c7 44 24 0c f2 6b 10 	movl   $0xc0106bf2,0xc(%esp)
c0103848:	c0 
c0103849:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103850:	c0 
c0103851:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0103858:	00 
c0103859:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103860:	e8 71 d4 ff ff       	call   c0100cd6 <__panic>

    list_entry_t free_list_store = free_list;
c0103865:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c010386a:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c0103870:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103873:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103876:	c7 45 b4 10 af 11 c0 	movl   $0xc011af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010387d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103880:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103883:	89 50 04             	mov    %edx,0x4(%eax)
c0103886:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103889:	8b 50 04             	mov    0x4(%eax),%edx
c010388c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010388f:	89 10                	mov    %edx,(%eax)
c0103891:	c7 45 b0 10 af 11 c0 	movl   $0xc011af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103898:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010389b:	8b 40 04             	mov    0x4(%eax),%eax
c010389e:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01038a1:	0f 94 c0             	sete   %al
c01038a4:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01038a7:	85 c0                	test   %eax,%eax
c01038a9:	75 24                	jne    c01038cf <default_check+0x1d0>
c01038ab:	c7 44 24 0c 47 6b 10 	movl   $0xc0106b47,0xc(%esp)
c01038b2:	c0 
c01038b3:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c01038ba:	c0 
c01038bb:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c01038c2:	00 
c01038c3:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c01038ca:	e8 07 d4 ff ff       	call   c0100cd6 <__panic>
    assert(alloc_page() == NULL);
c01038cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038d6:	e8 aa 07 00 00       	call   c0104085 <alloc_pages>
c01038db:	85 c0                	test   %eax,%eax
c01038dd:	74 24                	je     c0103903 <default_check+0x204>
c01038df:	c7 44 24 0c 5e 6b 10 	movl   $0xc0106b5e,0xc(%esp)
c01038e6:	c0 
c01038e7:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c01038ee:	c0 
c01038ef:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c01038f6:	00 
c01038f7:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c01038fe:	e8 d3 d3 ff ff       	call   c0100cd6 <__panic>

    unsigned int nr_free_store = nr_free;
c0103903:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103908:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010390b:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c0103912:	00 00 00 

    free_pages(p0 + 2, 3);
c0103915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103918:	83 c0 28             	add    $0x28,%eax
c010391b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103922:	00 
c0103923:	89 04 24             	mov    %eax,(%esp)
c0103926:	e8 92 07 00 00       	call   c01040bd <free_pages>
    assert(alloc_pages(4) == NULL);
c010392b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103932:	e8 4e 07 00 00       	call   c0104085 <alloc_pages>
c0103937:	85 c0                	test   %eax,%eax
c0103939:	74 24                	je     c010395f <default_check+0x260>
c010393b:	c7 44 24 0c 04 6c 10 	movl   $0xc0106c04,0xc(%esp)
c0103942:	c0 
c0103943:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c010394a:	c0 
c010394b:	c7 44 24 04 44 01 00 	movl   $0x144,0x4(%esp)
c0103952:	00 
c0103953:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c010395a:	e8 77 d3 ff ff       	call   c0100cd6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010395f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103962:	83 c0 28             	add    $0x28,%eax
c0103965:	83 c0 04             	add    $0x4,%eax
c0103968:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010396f:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103972:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103975:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103978:	0f a3 10             	bt     %edx,(%eax)
c010397b:	19 c0                	sbb    %eax,%eax
c010397d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103980:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103984:	0f 95 c0             	setne  %al
c0103987:	0f b6 c0             	movzbl %al,%eax
c010398a:	85 c0                	test   %eax,%eax
c010398c:	74 0e                	je     c010399c <default_check+0x29d>
c010398e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103991:	83 c0 28             	add    $0x28,%eax
c0103994:	8b 40 08             	mov    0x8(%eax),%eax
c0103997:	83 f8 03             	cmp    $0x3,%eax
c010399a:	74 24                	je     c01039c0 <default_check+0x2c1>
c010399c:	c7 44 24 0c 1c 6c 10 	movl   $0xc0106c1c,0xc(%esp)
c01039a3:	c0 
c01039a4:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c01039ab:	c0 
c01039ac:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c01039b3:	00 
c01039b4:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c01039bb:	e8 16 d3 ff ff       	call   c0100cd6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01039c0:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01039c7:	e8 b9 06 00 00       	call   c0104085 <alloc_pages>
c01039cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01039cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01039d3:	75 24                	jne    c01039f9 <default_check+0x2fa>
c01039d5:	c7 44 24 0c 48 6c 10 	movl   $0xc0106c48,0xc(%esp)
c01039dc:	c0 
c01039dd:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c01039e4:	c0 
c01039e5:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c01039ec:	00 
c01039ed:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c01039f4:	e8 dd d2 ff ff       	call   c0100cd6 <__panic>
    assert(alloc_page() == NULL);
c01039f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a00:	e8 80 06 00 00       	call   c0104085 <alloc_pages>
c0103a05:	85 c0                	test   %eax,%eax
c0103a07:	74 24                	je     c0103a2d <default_check+0x32e>
c0103a09:	c7 44 24 0c 5e 6b 10 	movl   $0xc0106b5e,0xc(%esp)
c0103a10:	c0 
c0103a11:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103a18:	c0 
c0103a19:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
c0103a20:	00 
c0103a21:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103a28:	e8 a9 d2 ff ff       	call   c0100cd6 <__panic>
    assert(p0 + 2 == p1);
c0103a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a30:	83 c0 28             	add    $0x28,%eax
c0103a33:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103a36:	74 24                	je     c0103a5c <default_check+0x35d>
c0103a38:	c7 44 24 0c 66 6c 10 	movl   $0xc0106c66,0xc(%esp)
c0103a3f:	c0 
c0103a40:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103a47:	c0 
c0103a48:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
c0103a4f:	00 
c0103a50:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103a57:	e8 7a d2 ff ff       	call   c0100cd6 <__panic>

    p2 = p0 + 1;
c0103a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a5f:	83 c0 14             	add    $0x14,%eax
c0103a62:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103a65:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a6c:	00 
c0103a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a70:	89 04 24             	mov    %eax,(%esp)
c0103a73:	e8 45 06 00 00       	call   c01040bd <free_pages>
    free_pages(p1, 3);
c0103a78:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103a7f:	00 
c0103a80:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a83:	89 04 24             	mov    %eax,(%esp)
c0103a86:	e8 32 06 00 00       	call   c01040bd <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103a8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a8e:	83 c0 04             	add    $0x4,%eax
c0103a91:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103a98:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103a9b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103a9e:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103aa1:	0f a3 10             	bt     %edx,(%eax)
c0103aa4:	19 c0                	sbb    %eax,%eax
c0103aa6:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103aa9:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103aad:	0f 95 c0             	setne  %al
c0103ab0:	0f b6 c0             	movzbl %al,%eax
c0103ab3:	85 c0                	test   %eax,%eax
c0103ab5:	74 0b                	je     c0103ac2 <default_check+0x3c3>
c0103ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103aba:	8b 40 08             	mov    0x8(%eax),%eax
c0103abd:	83 f8 01             	cmp    $0x1,%eax
c0103ac0:	74 24                	je     c0103ae6 <default_check+0x3e7>
c0103ac2:	c7 44 24 0c 74 6c 10 	movl   $0xc0106c74,0xc(%esp)
c0103ac9:	c0 
c0103aca:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103ad1:	c0 
c0103ad2:	c7 44 24 04 4d 01 00 	movl   $0x14d,0x4(%esp)
c0103ad9:	00 
c0103ada:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103ae1:	e8 f0 d1 ff ff       	call   c0100cd6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103ae6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ae9:	83 c0 04             	add    $0x4,%eax
c0103aec:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103af3:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103af6:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103af9:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103afc:	0f a3 10             	bt     %edx,(%eax)
c0103aff:	19 c0                	sbb    %eax,%eax
c0103b01:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103b04:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103b08:	0f 95 c0             	setne  %al
c0103b0b:	0f b6 c0             	movzbl %al,%eax
c0103b0e:	85 c0                	test   %eax,%eax
c0103b10:	74 0b                	je     c0103b1d <default_check+0x41e>
c0103b12:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103b15:	8b 40 08             	mov    0x8(%eax),%eax
c0103b18:	83 f8 03             	cmp    $0x3,%eax
c0103b1b:	74 24                	je     c0103b41 <default_check+0x442>
c0103b1d:	c7 44 24 0c 9c 6c 10 	movl   $0xc0106c9c,0xc(%esp)
c0103b24:	c0 
c0103b25:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103b2c:	c0 
c0103b2d:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
c0103b34:	00 
c0103b35:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103b3c:	e8 95 d1 ff ff       	call   c0100cd6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103b41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b48:	e8 38 05 00 00       	call   c0104085 <alloc_pages>
c0103b4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103b50:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b53:	83 e8 14             	sub    $0x14,%eax
c0103b56:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103b59:	74 24                	je     c0103b7f <default_check+0x480>
c0103b5b:	c7 44 24 0c c2 6c 10 	movl   $0xc0106cc2,0xc(%esp)
c0103b62:	c0 
c0103b63:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103b6a:	c0 
c0103b6b:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
c0103b72:	00 
c0103b73:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103b7a:	e8 57 d1 ff ff       	call   c0100cd6 <__panic>
    free_page(p0);
c0103b7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b86:	00 
c0103b87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b8a:	89 04 24             	mov    %eax,(%esp)
c0103b8d:	e8 2b 05 00 00       	call   c01040bd <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103b92:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103b99:	e8 e7 04 00 00       	call   c0104085 <alloc_pages>
c0103b9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ba1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103ba4:	83 c0 14             	add    $0x14,%eax
c0103ba7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103baa:	74 24                	je     c0103bd0 <default_check+0x4d1>
c0103bac:	c7 44 24 0c e0 6c 10 	movl   $0xc0106ce0,0xc(%esp)
c0103bb3:	c0 
c0103bb4:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103bbb:	c0 
c0103bbc:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0103bc3:	00 
c0103bc4:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103bcb:	e8 06 d1 ff ff       	call   c0100cd6 <__panic>

    free_pages(p0, 2);
c0103bd0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103bd7:	00 
c0103bd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bdb:	89 04 24             	mov    %eax,(%esp)
c0103bde:	e8 da 04 00 00       	call   c01040bd <free_pages>
    free_page(p2);
c0103be3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103bea:	00 
c0103beb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103bee:	89 04 24             	mov    %eax,(%esp)
c0103bf1:	e8 c7 04 00 00       	call   c01040bd <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103bf6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103bfd:	e8 83 04 00 00       	call   c0104085 <alloc_pages>
c0103c02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103c09:	75 24                	jne    c0103c2f <default_check+0x530>
c0103c0b:	c7 44 24 0c 00 6d 10 	movl   $0xc0106d00,0xc(%esp)
c0103c12:	c0 
c0103c13:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103c1a:	c0 
c0103c1b:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c0103c22:	00 
c0103c23:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103c2a:	e8 a7 d0 ff ff       	call   c0100cd6 <__panic>
    assert(alloc_page() == NULL);
c0103c2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c36:	e8 4a 04 00 00       	call   c0104085 <alloc_pages>
c0103c3b:	85 c0                	test   %eax,%eax
c0103c3d:	74 24                	je     c0103c63 <default_check+0x564>
c0103c3f:	c7 44 24 0c 5e 6b 10 	movl   $0xc0106b5e,0xc(%esp)
c0103c46:	c0 
c0103c47:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103c4e:	c0 
c0103c4f:	c7 44 24 04 58 01 00 	movl   $0x158,0x4(%esp)
c0103c56:	00 
c0103c57:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103c5e:	e8 73 d0 ff ff       	call   c0100cd6 <__panic>

    assert(nr_free == 0);
c0103c63:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103c68:	85 c0                	test   %eax,%eax
c0103c6a:	74 24                	je     c0103c90 <default_check+0x591>
c0103c6c:	c7 44 24 0c b1 6b 10 	movl   $0xc0106bb1,0xc(%esp)
c0103c73:	c0 
c0103c74:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103c7b:	c0 
c0103c7c:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
c0103c83:	00 
c0103c84:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103c8b:	e8 46 d0 ff ff       	call   c0100cd6 <__panic>
    nr_free = nr_free_store;
c0103c90:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c93:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_list = free_list_store;
c0103c98:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103c9b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103c9e:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c0103ca3:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    free_pages(p0, 5);
c0103ca9:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103cb0:	00 
c0103cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cb4:	89 04 24             	mov    %eax,(%esp)
c0103cb7:	e8 01 04 00 00       	call   c01040bd <free_pages>

    le = &free_list;
c0103cbc:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103cc3:	eb 1d                	jmp    c0103ce2 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cc8:	83 e8 0c             	sub    $0xc,%eax
c0103ccb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103cce:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103cd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103cd5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103cd8:	8b 40 08             	mov    0x8(%eax),%eax
c0103cdb:	29 c2                	sub    %eax,%edx
c0103cdd:	89 d0                	mov    %edx,%eax
c0103cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ce5:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103ce8:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103ceb:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103cee:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103cf1:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c0103cf8:	75 cb                	jne    c0103cc5 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103cfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103cfe:	74 24                	je     c0103d24 <default_check+0x625>
c0103d00:	c7 44 24 0c 1e 6d 10 	movl   $0xc0106d1e,0xc(%esp)
c0103d07:	c0 
c0103d08:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103d0f:	c0 
c0103d10:	c7 44 24 04 65 01 00 	movl   $0x165,0x4(%esp)
c0103d17:	00 
c0103d18:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103d1f:	e8 b2 cf ff ff       	call   c0100cd6 <__panic>
    assert(total == 0);
c0103d24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103d28:	74 24                	je     c0103d4e <default_check+0x64f>
c0103d2a:	c7 44 24 0c 29 6d 10 	movl   $0xc0106d29,0xc(%esp)
c0103d31:	c0 
c0103d32:	c7 44 24 08 d6 69 10 	movl   $0xc01069d6,0x8(%esp)
c0103d39:	c0 
c0103d3a:	c7 44 24 04 66 01 00 	movl   $0x166,0x4(%esp)
c0103d41:	00 
c0103d42:	c7 04 24 eb 69 10 c0 	movl   $0xc01069eb,(%esp)
c0103d49:	e8 88 cf ff ff       	call   c0100cd6 <__panic>
}
c0103d4e:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103d54:	5b                   	pop    %ebx
c0103d55:	5d                   	pop    %ebp
c0103d56:	c3                   	ret    

c0103d57 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103d57:	55                   	push   %ebp
c0103d58:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103d5a:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d5d:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0103d62:	29 c2                	sub    %eax,%edx
c0103d64:	89 d0                	mov    %edx,%eax
c0103d66:	c1 f8 02             	sar    $0x2,%eax
c0103d69:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103d6f:	5d                   	pop    %ebp
c0103d70:	c3                   	ret    

c0103d71 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103d71:	55                   	push   %ebp
c0103d72:	89 e5                	mov    %esp,%ebp
c0103d74:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d7a:	89 04 24             	mov    %eax,(%esp)
c0103d7d:	e8 d5 ff ff ff       	call   c0103d57 <page2ppn>
c0103d82:	c1 e0 0c             	shl    $0xc,%eax
}
c0103d85:	c9                   	leave  
c0103d86:	c3                   	ret    

c0103d87 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103d87:	55                   	push   %ebp
c0103d88:	89 e5                	mov    %esp,%ebp
c0103d8a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103d8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d90:	c1 e8 0c             	shr    $0xc,%eax
c0103d93:	89 c2                	mov    %eax,%edx
c0103d95:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103d9a:	39 c2                	cmp    %eax,%edx
c0103d9c:	72 1c                	jb     c0103dba <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103d9e:	c7 44 24 08 64 6d 10 	movl   $0xc0106d64,0x8(%esp)
c0103da5:	c0 
c0103da6:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103dad:	00 
c0103dae:	c7 04 24 83 6d 10 c0 	movl   $0xc0106d83,(%esp)
c0103db5:	e8 1c cf ff ff       	call   c0100cd6 <__panic>
    }
    return &pages[PPN(pa)];
c0103dba:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0103dc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dc3:	c1 e8 0c             	shr    $0xc,%eax
c0103dc6:	89 c2                	mov    %eax,%edx
c0103dc8:	89 d0                	mov    %edx,%eax
c0103dca:	c1 e0 02             	shl    $0x2,%eax
c0103dcd:	01 d0                	add    %edx,%eax
c0103dcf:	c1 e0 02             	shl    $0x2,%eax
c0103dd2:	01 c8                	add    %ecx,%eax
}
c0103dd4:	c9                   	leave  
c0103dd5:	c3                   	ret    

c0103dd6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103dd6:	55                   	push   %ebp
c0103dd7:	89 e5                	mov    %esp,%ebp
c0103dd9:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103ddc:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ddf:	89 04 24             	mov    %eax,(%esp)
c0103de2:	e8 8a ff ff ff       	call   c0103d71 <page2pa>
c0103de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ded:	c1 e8 0c             	shr    $0xc,%eax
c0103df0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103df3:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103df8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103dfb:	72 23                	jb     c0103e20 <page2kva+0x4a>
c0103dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e00:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e04:	c7 44 24 08 94 6d 10 	movl   $0xc0106d94,0x8(%esp)
c0103e0b:	c0 
c0103e0c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103e13:	00 
c0103e14:	c7 04 24 83 6d 10 c0 	movl   $0xc0106d83,(%esp)
c0103e1b:	e8 b6 ce ff ff       	call   c0100cd6 <__panic>
c0103e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e23:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103e28:	c9                   	leave  
c0103e29:	c3                   	ret    

c0103e2a <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103e2a:	55                   	push   %ebp
c0103e2b:	89 e5                	mov    %esp,%ebp
c0103e2d:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103e30:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e33:	83 e0 01             	and    $0x1,%eax
c0103e36:	85 c0                	test   %eax,%eax
c0103e38:	75 1c                	jne    c0103e56 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103e3a:	c7 44 24 08 b8 6d 10 	movl   $0xc0106db8,0x8(%esp)
c0103e41:	c0 
c0103e42:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103e49:	00 
c0103e4a:	c7 04 24 83 6d 10 c0 	movl   $0xc0106d83,(%esp)
c0103e51:	e8 80 ce ff ff       	call   c0100cd6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103e56:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e5e:	89 04 24             	mov    %eax,(%esp)
c0103e61:	e8 21 ff ff ff       	call   c0103d87 <pa2page>
}
c0103e66:	c9                   	leave  
c0103e67:	c3                   	ret    

c0103e68 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103e68:	55                   	push   %ebp
c0103e69:	89 e5                	mov    %esp,%ebp
c0103e6b:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103e6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e76:	89 04 24             	mov    %eax,(%esp)
c0103e79:	e8 09 ff ff ff       	call   c0103d87 <pa2page>
}
c0103e7e:	c9                   	leave  
c0103e7f:	c3                   	ret    

c0103e80 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103e80:	55                   	push   %ebp
c0103e81:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103e83:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e86:	8b 00                	mov    (%eax),%eax
}
c0103e88:	5d                   	pop    %ebp
c0103e89:	c3                   	ret    

c0103e8a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103e8a:	55                   	push   %ebp
c0103e8b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103e8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e90:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103e93:	89 10                	mov    %edx,(%eax)
}
c0103e95:	5d                   	pop    %ebp
c0103e96:	c3                   	ret    

c0103e97 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103e97:	55                   	push   %ebp
c0103e98:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103e9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e9d:	8b 00                	mov    (%eax),%eax
c0103e9f:	8d 50 01             	lea    0x1(%eax),%edx
c0103ea2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ea5:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ea7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103eaa:	8b 00                	mov    (%eax),%eax
}
c0103eac:	5d                   	pop    %ebp
c0103ead:	c3                   	ret    

c0103eae <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103eae:	55                   	push   %ebp
c0103eaf:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103eb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103eb4:	8b 00                	mov    (%eax),%eax
c0103eb6:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103eb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ebc:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ebe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ec1:	8b 00                	mov    (%eax),%eax
}
c0103ec3:	5d                   	pop    %ebp
c0103ec4:	c3                   	ret    

c0103ec5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103ec5:	55                   	push   %ebp
c0103ec6:	89 e5                	mov    %esp,%ebp
c0103ec8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103ecb:	9c                   	pushf  
c0103ecc:	58                   	pop    %eax
c0103ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103ed3:	25 00 02 00 00       	and    $0x200,%eax
c0103ed8:	85 c0                	test   %eax,%eax
c0103eda:	74 0c                	je     c0103ee8 <__intr_save+0x23>
        intr_disable();
c0103edc:	e8 e9 d7 ff ff       	call   c01016ca <intr_disable>
        return 1;
c0103ee1:	b8 01 00 00 00       	mov    $0x1,%eax
c0103ee6:	eb 05                	jmp    c0103eed <__intr_save+0x28>
    }
    return 0;
c0103ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103eed:	c9                   	leave  
c0103eee:	c3                   	ret    

c0103eef <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103eef:	55                   	push   %ebp
c0103ef0:	89 e5                	mov    %esp,%ebp
c0103ef2:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103ef5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103ef9:	74 05                	je     c0103f00 <__intr_restore+0x11>
        intr_enable();
c0103efb:	e8 c4 d7 ff ff       	call   c01016c4 <intr_enable>
    }
}
c0103f00:	c9                   	leave  
c0103f01:	c3                   	ret    

c0103f02 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103f02:	55                   	push   %ebp
c0103f03:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103f05:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f08:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103f0b:	b8 23 00 00 00       	mov    $0x23,%eax
c0103f10:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103f12:	b8 23 00 00 00       	mov    $0x23,%eax
c0103f17:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103f19:	b8 10 00 00 00       	mov    $0x10,%eax
c0103f1e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103f20:	b8 10 00 00 00       	mov    $0x10,%eax
c0103f25:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103f27:	b8 10 00 00 00       	mov    $0x10,%eax
c0103f2c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103f2e:	ea 35 3f 10 c0 08 00 	ljmp   $0x8,$0xc0103f35
}
c0103f35:	5d                   	pop    %ebp
c0103f36:	c3                   	ret    

c0103f37 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103f37:	55                   	push   %ebp
c0103f38:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103f3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f3d:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0103f42:	5d                   	pop    %ebp
c0103f43:	c3                   	ret    

c0103f44 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103f44:	55                   	push   %ebp
c0103f45:	89 e5                	mov    %esp,%ebp
c0103f47:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103f4a:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103f4f:	89 04 24             	mov    %eax,(%esp)
c0103f52:	e8 e0 ff ff ff       	call   c0103f37 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103f57:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0103f5e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103f60:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103f67:	68 00 
c0103f69:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103f6e:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103f74:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103f79:	c1 e8 10             	shr    $0x10,%eax
c0103f7c:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103f81:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103f88:	83 e0 f0             	and    $0xfffffff0,%eax
c0103f8b:	83 c8 09             	or     $0x9,%eax
c0103f8e:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103f93:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103f9a:	83 e0 ef             	and    $0xffffffef,%eax
c0103f9d:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103fa2:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103fa9:	83 e0 9f             	and    $0xffffff9f,%eax
c0103fac:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103fb1:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103fb8:	83 c8 80             	or     $0xffffff80,%eax
c0103fbb:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103fc0:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103fc7:	83 e0 f0             	and    $0xfffffff0,%eax
c0103fca:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103fcf:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103fd6:	83 e0 ef             	and    $0xffffffef,%eax
c0103fd9:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103fde:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103fe5:	83 e0 df             	and    $0xffffffdf,%eax
c0103fe8:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103fed:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ff4:	83 c8 40             	or     $0x40,%eax
c0103ff7:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ffc:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0104003:	83 e0 7f             	and    $0x7f,%eax
c0104006:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c010400b:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0104010:	c1 e8 18             	shr    $0x18,%eax
c0104013:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104018:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c010401f:	e8 de fe ff ff       	call   c0103f02 <lgdt>
c0104024:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c010402a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c010402e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104031:	c9                   	leave  
c0104032:	c3                   	ret    

c0104033 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104033:	55                   	push   %ebp
c0104034:	89 e5                	mov    %esp,%ebp
c0104036:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104039:	c7 05 1c af 11 c0 48 	movl   $0xc0106d48,0xc011af1c
c0104040:	6d 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104043:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0104048:	8b 00                	mov    (%eax),%eax
c010404a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010404e:	c7 04 24 e4 6d 10 c0 	movl   $0xc0106de4,(%esp)
c0104055:	e8 ee c2 ff ff       	call   c0100348 <cprintf>
    pmm_manager->init();
c010405a:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c010405f:	8b 40 04             	mov    0x4(%eax),%eax
c0104062:	ff d0                	call   *%eax
}
c0104064:	c9                   	leave  
c0104065:	c3                   	ret    

c0104066 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104066:	55                   	push   %ebp
c0104067:	89 e5                	mov    %esp,%ebp
c0104069:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c010406c:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0104071:	8b 40 08             	mov    0x8(%eax),%eax
c0104074:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104077:	89 54 24 04          	mov    %edx,0x4(%esp)
c010407b:	8b 55 08             	mov    0x8(%ebp),%edx
c010407e:	89 14 24             	mov    %edx,(%esp)
c0104081:	ff d0                	call   *%eax
}
c0104083:	c9                   	leave  
c0104084:	c3                   	ret    

c0104085 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104085:	55                   	push   %ebp
c0104086:	89 e5                	mov    %esp,%ebp
c0104088:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c010408b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0104092:	e8 2e fe ff ff       	call   c0103ec5 <__intr_save>
c0104097:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c010409a:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c010409f:	8b 40 0c             	mov    0xc(%eax),%eax
c01040a2:	8b 55 08             	mov    0x8(%ebp),%edx
c01040a5:	89 14 24             	mov    %edx,(%esp)
c01040a8:	ff d0                	call   *%eax
c01040aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c01040ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040b0:	89 04 24             	mov    %eax,(%esp)
c01040b3:	e8 37 fe ff ff       	call   c0103eef <__intr_restore>
    return page;
c01040b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01040bb:	c9                   	leave  
c01040bc:	c3                   	ret    

c01040bd <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01040bd:	55                   	push   %ebp
c01040be:	89 e5                	mov    %esp,%ebp
c01040c0:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01040c3:	e8 fd fd ff ff       	call   c0103ec5 <__intr_save>
c01040c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01040cb:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c01040d0:	8b 40 10             	mov    0x10(%eax),%eax
c01040d3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040d6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01040da:	8b 55 08             	mov    0x8(%ebp),%edx
c01040dd:	89 14 24             	mov    %edx,(%esp)
c01040e0:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01040e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040e5:	89 04 24             	mov    %eax,(%esp)
c01040e8:	e8 02 fe ff ff       	call   c0103eef <__intr_restore>
}
c01040ed:	c9                   	leave  
c01040ee:	c3                   	ret    

c01040ef <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01040ef:	55                   	push   %ebp
c01040f0:	89 e5                	mov    %esp,%ebp
c01040f2:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01040f5:	e8 cb fd ff ff       	call   c0103ec5 <__intr_save>
c01040fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01040fd:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0104102:	8b 40 14             	mov    0x14(%eax),%eax
c0104105:	ff d0                	call   *%eax
c0104107:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c010410a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010410d:	89 04 24             	mov    %eax,(%esp)
c0104110:	e8 da fd ff ff       	call   c0103eef <__intr_restore>
    return ret;
c0104115:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104118:	c9                   	leave  
c0104119:	c3                   	ret    

c010411a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c010411a:	55                   	push   %ebp
c010411b:	89 e5                	mov    %esp,%ebp
c010411d:	57                   	push   %edi
c010411e:	56                   	push   %esi
c010411f:	53                   	push   %ebx
c0104120:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104126:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010412d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104134:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c010413b:	c7 04 24 fb 6d 10 c0 	movl   $0xc0106dfb,(%esp)
c0104142:	e8 01 c2 ff ff       	call   c0100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104147:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010414e:	e9 15 01 00 00       	jmp    c0104268 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104153:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104156:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104159:	89 d0                	mov    %edx,%eax
c010415b:	c1 e0 02             	shl    $0x2,%eax
c010415e:	01 d0                	add    %edx,%eax
c0104160:	c1 e0 02             	shl    $0x2,%eax
c0104163:	01 c8                	add    %ecx,%eax
c0104165:	8b 50 08             	mov    0x8(%eax),%edx
c0104168:	8b 40 04             	mov    0x4(%eax),%eax
c010416b:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010416e:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104171:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104174:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104177:	89 d0                	mov    %edx,%eax
c0104179:	c1 e0 02             	shl    $0x2,%eax
c010417c:	01 d0                	add    %edx,%eax
c010417e:	c1 e0 02             	shl    $0x2,%eax
c0104181:	01 c8                	add    %ecx,%eax
c0104183:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104186:	8b 58 10             	mov    0x10(%eax),%ebx
c0104189:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010418c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010418f:	01 c8                	add    %ecx,%eax
c0104191:	11 da                	adc    %ebx,%edx
c0104193:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104196:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104199:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010419c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010419f:	89 d0                	mov    %edx,%eax
c01041a1:	c1 e0 02             	shl    $0x2,%eax
c01041a4:	01 d0                	add    %edx,%eax
c01041a6:	c1 e0 02             	shl    $0x2,%eax
c01041a9:	01 c8                	add    %ecx,%eax
c01041ab:	83 c0 14             	add    $0x14,%eax
c01041ae:	8b 00                	mov    (%eax),%eax
c01041b0:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01041b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01041b9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01041bc:	83 c0 ff             	add    $0xffffffff,%eax
c01041bf:	83 d2 ff             	adc    $0xffffffff,%edx
c01041c2:	89 c6                	mov    %eax,%esi
c01041c4:	89 d7                	mov    %edx,%edi
c01041c6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01041c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041cc:	89 d0                	mov    %edx,%eax
c01041ce:	c1 e0 02             	shl    $0x2,%eax
c01041d1:	01 d0                	add    %edx,%eax
c01041d3:	c1 e0 02             	shl    $0x2,%eax
c01041d6:	01 c8                	add    %ecx,%eax
c01041d8:	8b 48 0c             	mov    0xc(%eax),%ecx
c01041db:	8b 58 10             	mov    0x10(%eax),%ebx
c01041de:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01041e4:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01041e8:	89 74 24 14          	mov    %esi,0x14(%esp)
c01041ec:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01041f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041f3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01041f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01041fa:	89 54 24 10          	mov    %edx,0x10(%esp)
c01041fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104202:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104206:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c010420d:	e8 36 c1 ff ff       	call   c0100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104212:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104215:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104218:	89 d0                	mov    %edx,%eax
c010421a:	c1 e0 02             	shl    $0x2,%eax
c010421d:	01 d0                	add    %edx,%eax
c010421f:	c1 e0 02             	shl    $0x2,%eax
c0104222:	01 c8                	add    %ecx,%eax
c0104224:	83 c0 14             	add    $0x14,%eax
c0104227:	8b 00                	mov    (%eax),%eax
c0104229:	83 f8 01             	cmp    $0x1,%eax
c010422c:	75 36                	jne    c0104264 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c010422e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104231:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104234:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104237:	77 2b                	ja     c0104264 <page_init+0x14a>
c0104239:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010423c:	72 05                	jb     c0104243 <page_init+0x129>
c010423e:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104241:	73 21                	jae    c0104264 <page_init+0x14a>
c0104243:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104247:	77 1b                	ja     c0104264 <page_init+0x14a>
c0104249:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010424d:	72 09                	jb     c0104258 <page_init+0x13e>
c010424f:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104256:	77 0c                	ja     c0104264 <page_init+0x14a>
                maxpa = end;
c0104258:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010425b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010425e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104261:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104264:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104268:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010426b:	8b 00                	mov    (%eax),%eax
c010426d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104270:	0f 8f dd fe ff ff    	jg     c0104153 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104276:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010427a:	72 1d                	jb     c0104299 <page_init+0x17f>
c010427c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104280:	77 09                	ja     c010428b <page_init+0x171>
c0104282:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104289:	76 0e                	jbe    c0104299 <page_init+0x17f>
        maxpa = KMEMSIZE;
c010428b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104292:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104299:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010429c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010429f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01042a3:	c1 ea 0c             	shr    $0xc,%edx
c01042a6:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01042ab:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01042b2:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c01042b7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01042ba:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01042bd:	01 d0                	add    %edx,%eax
c01042bf:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01042c2:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01042c5:	ba 00 00 00 00       	mov    $0x0,%edx
c01042ca:	f7 75 ac             	divl   -0x54(%ebp)
c01042cd:	89 d0                	mov    %edx,%eax
c01042cf:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01042d2:	29 c2                	sub    %eax,%edx
c01042d4:	89 d0                	mov    %edx,%eax
c01042d6:	a3 24 af 11 c0       	mov    %eax,0xc011af24

    for (i = 0; i < npage; i ++) {
c01042db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01042e2:	eb 2f                	jmp    c0104313 <page_init+0x1f9>
        SetPageReserved(pages + i);
c01042e4:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c01042ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01042ed:	89 d0                	mov    %edx,%eax
c01042ef:	c1 e0 02             	shl    $0x2,%eax
c01042f2:	01 d0                	add    %edx,%eax
c01042f4:	c1 e0 02             	shl    $0x2,%eax
c01042f7:	01 c8                	add    %ecx,%eax
c01042f9:	83 c0 04             	add    $0x4,%eax
c01042fc:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104303:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104306:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104309:	8b 55 90             	mov    -0x70(%ebp),%edx
c010430c:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c010430f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104313:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104316:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010431b:	39 c2                	cmp    %eax,%edx
c010431d:	72 c5                	jb     c01042e4 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010431f:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0104325:	89 d0                	mov    %edx,%eax
c0104327:	c1 e0 02             	shl    $0x2,%eax
c010432a:	01 d0                	add    %edx,%eax
c010432c:	c1 e0 02             	shl    $0x2,%eax
c010432f:	89 c2                	mov    %eax,%edx
c0104331:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104336:	01 d0                	add    %edx,%eax
c0104338:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010433b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104342:	77 23                	ja     c0104367 <page_init+0x24d>
c0104344:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104347:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010434b:	c7 44 24 08 38 6e 10 	movl   $0xc0106e38,0x8(%esp)
c0104352:	c0 
c0104353:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010435a:	00 
c010435b:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104362:	e8 6f c9 ff ff       	call   c0100cd6 <__panic>
c0104367:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010436a:	05 00 00 00 40       	add    $0x40000000,%eax
c010436f:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104372:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104379:	e9 74 01 00 00       	jmp    c01044f2 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010437e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104381:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104384:	89 d0                	mov    %edx,%eax
c0104386:	c1 e0 02             	shl    $0x2,%eax
c0104389:	01 d0                	add    %edx,%eax
c010438b:	c1 e0 02             	shl    $0x2,%eax
c010438e:	01 c8                	add    %ecx,%eax
c0104390:	8b 50 08             	mov    0x8(%eax),%edx
c0104393:	8b 40 04             	mov    0x4(%eax),%eax
c0104396:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104399:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010439c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010439f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01043a2:	89 d0                	mov    %edx,%eax
c01043a4:	c1 e0 02             	shl    $0x2,%eax
c01043a7:	01 d0                	add    %edx,%eax
c01043a9:	c1 e0 02             	shl    $0x2,%eax
c01043ac:	01 c8                	add    %ecx,%eax
c01043ae:	8b 48 0c             	mov    0xc(%eax),%ecx
c01043b1:	8b 58 10             	mov    0x10(%eax),%ebx
c01043b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01043ba:	01 c8                	add    %ecx,%eax
c01043bc:	11 da                	adc    %ebx,%edx
c01043be:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01043c1:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01043c4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01043c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01043ca:	89 d0                	mov    %edx,%eax
c01043cc:	c1 e0 02             	shl    $0x2,%eax
c01043cf:	01 d0                	add    %edx,%eax
c01043d1:	c1 e0 02             	shl    $0x2,%eax
c01043d4:	01 c8                	add    %ecx,%eax
c01043d6:	83 c0 14             	add    $0x14,%eax
c01043d9:	8b 00                	mov    (%eax),%eax
c01043db:	83 f8 01             	cmp    $0x1,%eax
c01043de:	0f 85 0a 01 00 00    	jne    c01044ee <page_init+0x3d4>
            if (begin < freemem) {
c01043e4:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01043e7:	ba 00 00 00 00       	mov    $0x0,%edx
c01043ec:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01043ef:	72 17                	jb     c0104408 <page_init+0x2ee>
c01043f1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01043f4:	77 05                	ja     c01043fb <page_init+0x2e1>
c01043f6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01043f9:	76 0d                	jbe    c0104408 <page_init+0x2ee>
                begin = freemem;
c01043fb:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01043fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104401:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104408:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010440c:	72 1d                	jb     c010442b <page_init+0x311>
c010440e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104412:	77 09                	ja     c010441d <page_init+0x303>
c0104414:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010441b:	76 0e                	jbe    c010442b <page_init+0x311>
                end = KMEMSIZE;
c010441d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104424:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010442b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010442e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104431:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104434:	0f 87 b4 00 00 00    	ja     c01044ee <page_init+0x3d4>
c010443a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010443d:	72 09                	jb     c0104448 <page_init+0x32e>
c010443f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104442:	0f 83 a6 00 00 00    	jae    c01044ee <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104448:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010444f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104452:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104455:	01 d0                	add    %edx,%eax
c0104457:	83 e8 01             	sub    $0x1,%eax
c010445a:	89 45 98             	mov    %eax,-0x68(%ebp)
c010445d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104460:	ba 00 00 00 00       	mov    $0x0,%edx
c0104465:	f7 75 9c             	divl   -0x64(%ebp)
c0104468:	89 d0                	mov    %edx,%eax
c010446a:	8b 55 98             	mov    -0x68(%ebp),%edx
c010446d:	29 c2                	sub    %eax,%edx
c010446f:	89 d0                	mov    %edx,%eax
c0104471:	ba 00 00 00 00       	mov    $0x0,%edx
c0104476:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104479:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010447c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010447f:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104482:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104485:	ba 00 00 00 00       	mov    $0x0,%edx
c010448a:	89 c7                	mov    %eax,%edi
c010448c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104492:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104495:	89 d0                	mov    %edx,%eax
c0104497:	83 e0 00             	and    $0x0,%eax
c010449a:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010449d:	8b 45 80             	mov    -0x80(%ebp),%eax
c01044a0:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01044a3:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01044a6:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01044a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01044ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01044af:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01044b2:	77 3a                	ja     c01044ee <page_init+0x3d4>
c01044b4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01044b7:	72 05                	jb     c01044be <page_init+0x3a4>
c01044b9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01044bc:	73 30                	jae    c01044ee <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01044be:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01044c1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01044c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01044c7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01044ca:	29 c8                	sub    %ecx,%eax
c01044cc:	19 da                	sbb    %ebx,%edx
c01044ce:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01044d2:	c1 ea 0c             	shr    $0xc,%edx
c01044d5:	89 c3                	mov    %eax,%ebx
c01044d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01044da:	89 04 24             	mov    %eax,(%esp)
c01044dd:	e8 a5 f8 ff ff       	call   c0103d87 <pa2page>
c01044e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01044e6:	89 04 24             	mov    %eax,(%esp)
c01044e9:	e8 78 fb ff ff       	call   c0104066 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01044ee:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01044f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01044f5:	8b 00                	mov    (%eax),%eax
c01044f7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01044fa:	0f 8f 7e fe ff ff    	jg     c010437e <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104500:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104506:	5b                   	pop    %ebx
c0104507:	5e                   	pop    %esi
c0104508:	5f                   	pop    %edi
c0104509:	5d                   	pop    %ebp
c010450a:	c3                   	ret    

c010450b <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010450b:	55                   	push   %ebp
c010450c:	89 e5                	mov    %esp,%ebp
c010450e:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104511:	8b 45 14             	mov    0x14(%ebp),%eax
c0104514:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104517:	31 d0                	xor    %edx,%eax
c0104519:	25 ff 0f 00 00       	and    $0xfff,%eax
c010451e:	85 c0                	test   %eax,%eax
c0104520:	74 24                	je     c0104546 <boot_map_segment+0x3b>
c0104522:	c7 44 24 0c 6a 6e 10 	movl   $0xc0106e6a,0xc(%esp)
c0104529:	c0 
c010452a:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104531:	c0 
c0104532:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104539:	00 
c010453a:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104541:	e8 90 c7 ff ff       	call   c0100cd6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104546:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010454d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104550:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104555:	89 c2                	mov    %eax,%edx
c0104557:	8b 45 10             	mov    0x10(%ebp),%eax
c010455a:	01 c2                	add    %eax,%edx
c010455c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010455f:	01 d0                	add    %edx,%eax
c0104561:	83 e8 01             	sub    $0x1,%eax
c0104564:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104567:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010456a:	ba 00 00 00 00       	mov    $0x0,%edx
c010456f:	f7 75 f0             	divl   -0x10(%ebp)
c0104572:	89 d0                	mov    %edx,%eax
c0104574:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104577:	29 c2                	sub    %eax,%edx
c0104579:	89 d0                	mov    %edx,%eax
c010457b:	c1 e8 0c             	shr    $0xc,%eax
c010457e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104581:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104584:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104587:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010458a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010458f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104592:	8b 45 14             	mov    0x14(%ebp),%eax
c0104595:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010459b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01045a0:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01045a3:	eb 6b                	jmp    c0104610 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01045a5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01045ac:	00 
c01045ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b7:	89 04 24             	mov    %eax,(%esp)
c01045ba:	e8 82 01 00 00       	call   c0104741 <get_pte>
c01045bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01045c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01045c6:	75 24                	jne    c01045ec <boot_map_segment+0xe1>
c01045c8:	c7 44 24 0c 96 6e 10 	movl   $0xc0106e96,0xc(%esp)
c01045cf:	c0 
c01045d0:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c01045d7:	c0 
c01045d8:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01045df:	00 
c01045e0:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c01045e7:	e8 ea c6 ff ff       	call   c0100cd6 <__panic>
        *ptep = pa | PTE_P | perm;
c01045ec:	8b 45 18             	mov    0x18(%ebp),%eax
c01045ef:	8b 55 14             	mov    0x14(%ebp),%edx
c01045f2:	09 d0                	or     %edx,%eax
c01045f4:	83 c8 01             	or     $0x1,%eax
c01045f7:	89 c2                	mov    %eax,%edx
c01045f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045fc:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01045fe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104602:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104609:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104614:	75 8f                	jne    c01045a5 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104616:	c9                   	leave  
c0104617:	c3                   	ret    

c0104618 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104618:	55                   	push   %ebp
c0104619:	89 e5                	mov    %esp,%ebp
c010461b:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010461e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104625:	e8 5b fa ff ff       	call   c0104085 <alloc_pages>
c010462a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010462d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104631:	75 1c                	jne    c010464f <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104633:	c7 44 24 08 a3 6e 10 	movl   $0xc0106ea3,0x8(%esp)
c010463a:	c0 
c010463b:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104642:	00 
c0104643:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c010464a:	e8 87 c6 ff ff       	call   c0100cd6 <__panic>
    }
    return page2kva(p);
c010464f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104652:	89 04 24             	mov    %eax,(%esp)
c0104655:	e8 7c f7 ff ff       	call   c0103dd6 <page2kva>
}
c010465a:	c9                   	leave  
c010465b:	c3                   	ret    

c010465c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010465c:	55                   	push   %ebp
c010465d:	89 e5                	mov    %esp,%ebp
c010465f:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104662:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104667:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010466a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104671:	77 23                	ja     c0104696 <pmm_init+0x3a>
c0104673:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104676:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010467a:	c7 44 24 08 38 6e 10 	movl   $0xc0106e38,0x8(%esp)
c0104681:	c0 
c0104682:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104689:	00 
c010468a:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104691:	e8 40 c6 ff ff       	call   c0100cd6 <__panic>
c0104696:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104699:	05 00 00 00 40       	add    $0x40000000,%eax
c010469e:	a3 20 af 11 c0       	mov    %eax,0xc011af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01046a3:	e8 8b f9 ff ff       	call   c0104033 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01046a8:	e8 6d fa ff ff       	call   c010411a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01046ad:	e8 ee 03 00 00       	call   c0104aa0 <check_alloc_page>

    check_pgdir();
c01046b2:	e8 07 04 00 00       	call   c0104abe <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01046b7:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01046bc:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01046c2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01046c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01046ca:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01046d1:	77 23                	ja     c01046f6 <pmm_init+0x9a>
c01046d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046da:	c7 44 24 08 38 6e 10 	movl   $0xc0106e38,0x8(%esp)
c01046e1:	c0 
c01046e2:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01046e9:	00 
c01046ea:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c01046f1:	e8 e0 c5 ff ff       	call   c0100cd6 <__panic>
c01046f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046f9:	05 00 00 00 40       	add    $0x40000000,%eax
c01046fe:	83 c8 03             	or     $0x3,%eax
c0104701:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104703:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104708:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010470f:	00 
c0104710:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104717:	00 
c0104718:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010471f:	38 
c0104720:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104727:	c0 
c0104728:	89 04 24             	mov    %eax,(%esp)
c010472b:	e8 db fd ff ff       	call   c010450b <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104730:	e8 0f f8 ff ff       	call   c0103f44 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104735:	e8 1f 0a 00 00       	call   c0105159 <check_boot_pgdir>

    print_pgdir();
c010473a:	e8 a7 0e 00 00       	call   c01055e6 <print_pgdir>

}
c010473f:	c9                   	leave  
c0104740:	c3                   	ret    

c0104741 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104741:	55                   	push   %ebp
c0104742:	89 e5                	mov    %esp,%ebp
c0104744:	83 ec 48             	sub    $0x48,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
	// (1) find page directory entry
	pde_t *pdep = pgdir + PDX(la);
c0104747:	8b 45 0c             	mov    0xc(%ebp),%eax
c010474a:	c1 e8 16             	shr    $0x16,%eax
c010474d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104754:	8b 45 08             	mov    0x8(%ebp),%eax
c0104757:	01 d0                	add    %edx,%eax
c0104759:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//（2）check if entry is not present
	if(!(PTE_P & *pdep)) {   //不存在
c010475c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010475f:	8b 00                	mov    (%eax),%eax
c0104761:	83 e0 01             	and    $0x1,%eax
c0104764:	85 c0                	test   %eax,%eax
c0104766:	0f 85 b7 00 00 00    	jne    c0104823 <get_pte+0xe2>
	//(3) check if creating is needed
	    if(create) {	//需要创建二级页表
c010476c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104770:	0f 84 a6 00 00 00    	je     c010481c <get_pte+0xdb>
	       struct Page* newPage = alloc_page();//创建一个新的页面
c0104776:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010477d:	e8 03 f9 ff ff       	call   c0104085 <alloc_pages>
c0104782:	89 45 f0             	mov    %eax,-0x10(%ebp)
	// (4) set page reference
	       set_page_ref(newPage, 1);
c0104785:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010478c:	00 
c010478d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104790:	89 04 24             	mov    %eax,(%esp)
c0104793:	e8 f2 f6 ff ff       	call   c0103e8a <set_page_ref>
	//(5) get linear address of page
	       uintptr_t paPage = page2pa(newPage);
c0104798:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010479b:	89 04 24             	mov    %eax,(%esp)
c010479e:	e8 ce f5 ff ff       	call   c0103d71 <page2pa>
c01047a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	       pte_t laPage = KADDR(paPage);
c01047a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01047ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01047af:	c1 e8 0c             	shr    $0xc,%eax
c01047b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01047b5:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01047ba:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01047bd:	72 23                	jb     c01047e2 <get_pte+0xa1>
c01047bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01047c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047c6:	c7 44 24 08 94 6d 10 	movl   $0xc0106d94,0x8(%esp)
c01047cd:	c0 
c01047ce:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
c01047d5:	00 
c01047d6:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c01047dd:	e8 f4 c4 ff ff       	call   c0100cd6 <__panic>
c01047e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01047e5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01047ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
	//(6) clear page content using memset
	       memset(laPage, 0, PGSIZE);
c01047ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047f0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01047f7:	00 
c01047f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01047ff:	00 
c0104800:	89 04 24             	mov    %eax,(%esp)
c0104803:	e8 fc 18 00 00       	call   c0106104 <memset>
	//(7) set page directory entry's permission
	       *pdep = ((paPage & ~0x0FFF) | PTE_U | PTE_W | PTE_P);
c0104808:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010480b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104810:	83 c8 07             	or     $0x7,%eax
c0104813:	89 c2                	mov    %eax,%edx
c0104815:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104818:	89 10                	mov    %edx,(%eax)
c010481a:	eb 07                	jmp    c0104823 <get_pte+0xe2>
	    } else {
	        return NULL;
c010481c:	b8 00 00 00 00       	mov    $0x0,%eax
c0104821:	eb 62                	jmp    c0104885 <get_pte+0x144>
	    }
	}
	// (8) return page table entry
	pte_t *pte = (pte_t *)(KADDR((*pdep & ~0xFFF))) + PTX(la);
c0104823:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104826:	8b 00                	mov    (%eax),%eax
c0104828:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010482d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104830:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104833:	c1 e8 0c             	shr    $0xc,%eax
c0104836:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104839:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010483e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104841:	72 23                	jb     c0104866 <get_pte+0x125>
c0104843:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104846:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010484a:	c7 44 24 08 94 6d 10 	movl   $0xc0106d94,0x8(%esp)
c0104851:	c0 
c0104852:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
c0104859:	00 
c010485a:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104861:	e8 70 c4 ff ff       	call   c0100cd6 <__panic>
c0104866:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104869:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010486e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104871:	c1 ea 0c             	shr    $0xc,%edx
c0104874:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c010487a:	c1 e2 02             	shl    $0x2,%edx
c010487d:	01 d0                	add    %edx,%eax
c010487f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	return pte; 
c0104882:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0104885:	c9                   	leave  
c0104886:	c3                   	ret    

c0104887 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104887:	55                   	push   %ebp
c0104888:	89 e5                	mov    %esp,%ebp
c010488a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010488d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104894:	00 
c0104895:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104898:	89 44 24 04          	mov    %eax,0x4(%esp)
c010489c:	8b 45 08             	mov    0x8(%ebp),%eax
c010489f:	89 04 24             	mov    %eax,(%esp)
c01048a2:	e8 9a fe ff ff       	call   c0104741 <get_pte>
c01048a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01048aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01048ae:	74 08                	je     c01048b8 <get_page+0x31>
        *ptep_store = ptep;
c01048b0:	8b 45 10             	mov    0x10(%ebp),%eax
c01048b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01048b6:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01048b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048bc:	74 1b                	je     c01048d9 <get_page+0x52>
c01048be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048c1:	8b 00                	mov    (%eax),%eax
c01048c3:	83 e0 01             	and    $0x1,%eax
c01048c6:	85 c0                	test   %eax,%eax
c01048c8:	74 0f                	je     c01048d9 <get_page+0x52>
        return pte2page(*ptep);
c01048ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048cd:	8b 00                	mov    (%eax),%eax
c01048cf:	89 04 24             	mov    %eax,(%esp)
c01048d2:	e8 53 f5 ff ff       	call   c0103e2a <pte2page>
c01048d7:	eb 05                	jmp    c01048de <get_page+0x57>
    }
    return NULL;
c01048d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01048de:	c9                   	leave  
c01048df:	c3                   	ret    

c01048e0 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01048e0:	55                   	push   %ebp
c01048e1:	89 e5                	mov    %esp,%ebp
c01048e3:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
	//(1)check if this page table entry is present
	if((*ptep & PTE_P) == 1) {
c01048e6:	8b 45 10             	mov    0x10(%ebp),%eax
c01048e9:	8b 00                	mov    (%eax),%eax
c01048eb:	83 e0 01             	and    $0x1,%eax
c01048ee:	85 c0                	test   %eax,%eax
c01048f0:	74 52                	je     c0104944 <page_remove_pte+0x64>
	//(2)find correspending page to pte
	    struct Page* page = pte2page(*ptep);
c01048f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01048f5:	8b 00                	mov    (%eax),%eax
c01048f7:	89 04 24             	mov    %eax,(%esp)
c01048fa:	e8 2b f5 ff ff       	call   c0103e2a <pte2page>
c01048ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//(3)decrease page reference
	    page_ref_dec(page);
c0104902:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104905:	89 04 24             	mov    %eax,(%esp)
c0104908:	e8 a1 f5 ff ff       	call   c0103eae <page_ref_dec>
	//(4)and free this page when page reference reachs 0
	    if(page->ref == 0) {
c010490d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104910:	8b 00                	mov    (%eax),%eax
c0104912:	85 c0                	test   %eax,%eax
c0104914:	75 13                	jne    c0104929 <page_remove_pte+0x49>
	    	free_page(page);
c0104916:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010491d:	00 
c010491e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104921:	89 04 24             	mov    %eax,(%esp)
c0104924:	e8 94 f7 ff ff       	call   c01040bd <free_pages>
	    }
	//(5)clear second page table entry
	    *ptep = 0;
c0104929:	8b 45 10             	mov    0x10(%ebp),%eax
c010492c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//(6)flush tlb
	    tlb_invalidate(pgdir, la);
c0104932:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104935:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104939:	8b 45 08             	mov    0x8(%ebp),%eax
c010493c:	89 04 24             	mov    %eax,(%esp)
c010493f:	e8 ff 00 00 00       	call   c0104a43 <tlb_invalidate>
	}
}
c0104944:	c9                   	leave  
c0104945:	c3                   	ret    

c0104946 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104946:	55                   	push   %ebp
c0104947:	89 e5                	mov    %esp,%ebp
c0104949:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010494c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104953:	00 
c0104954:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104957:	89 44 24 04          	mov    %eax,0x4(%esp)
c010495b:	8b 45 08             	mov    0x8(%ebp),%eax
c010495e:	89 04 24             	mov    %eax,(%esp)
c0104961:	e8 db fd ff ff       	call   c0104741 <get_pte>
c0104966:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104969:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010496d:	74 19                	je     c0104988 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010496f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104972:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104976:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104979:	89 44 24 04          	mov    %eax,0x4(%esp)
c010497d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104980:	89 04 24             	mov    %eax,(%esp)
c0104983:	e8 58 ff ff ff       	call   c01048e0 <page_remove_pte>
    }
}
c0104988:	c9                   	leave  
c0104989:	c3                   	ret    

c010498a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010498a:	55                   	push   %ebp
c010498b:	89 e5                	mov    %esp,%ebp
c010498d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104990:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104997:	00 
c0104998:	8b 45 10             	mov    0x10(%ebp),%eax
c010499b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010499f:	8b 45 08             	mov    0x8(%ebp),%eax
c01049a2:	89 04 24             	mov    %eax,(%esp)
c01049a5:	e8 97 fd ff ff       	call   c0104741 <get_pte>
c01049aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01049ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01049b1:	75 0a                	jne    c01049bd <page_insert+0x33>
        return -E_NO_MEM;
c01049b3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01049b8:	e9 84 00 00 00       	jmp    c0104a41 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01049bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049c0:	89 04 24             	mov    %eax,(%esp)
c01049c3:	e8 cf f4 ff ff       	call   c0103e97 <page_ref_inc>
    if (*ptep & PTE_P) {
c01049c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049cb:	8b 00                	mov    (%eax),%eax
c01049cd:	83 e0 01             	and    $0x1,%eax
c01049d0:	85 c0                	test   %eax,%eax
c01049d2:	74 3e                	je     c0104a12 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01049d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d7:	8b 00                	mov    (%eax),%eax
c01049d9:	89 04 24             	mov    %eax,(%esp)
c01049dc:	e8 49 f4 ff ff       	call   c0103e2a <pte2page>
c01049e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01049e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01049ea:	75 0d                	jne    c01049f9 <page_insert+0x6f>
            page_ref_dec(page);
c01049ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049ef:	89 04 24             	mov    %eax,(%esp)
c01049f2:	e8 b7 f4 ff ff       	call   c0103eae <page_ref_dec>
c01049f7:	eb 19                	jmp    c0104a12 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01049f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049fc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104a00:	8b 45 10             	mov    0x10(%ebp),%eax
c0104a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a0a:	89 04 24             	mov    %eax,(%esp)
c0104a0d:	e8 ce fe ff ff       	call   c01048e0 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104a12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a15:	89 04 24             	mov    %eax,(%esp)
c0104a18:	e8 54 f3 ff ff       	call   c0103d71 <page2pa>
c0104a1d:	0b 45 14             	or     0x14(%ebp),%eax
c0104a20:	83 c8 01             	or     $0x1,%eax
c0104a23:	89 c2                	mov    %eax,%edx
c0104a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a28:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104a2a:	8b 45 10             	mov    0x10(%ebp),%eax
c0104a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104a31:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a34:	89 04 24             	mov    %eax,(%esp)
c0104a37:	e8 07 00 00 00       	call   c0104a43 <tlb_invalidate>
    return 0;
c0104a3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104a41:	c9                   	leave  
c0104a42:	c3                   	ret    

c0104a43 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104a43:	55                   	push   %ebp
c0104a44:	89 e5                	mov    %esp,%ebp
c0104a46:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104a49:	0f 20 d8             	mov    %cr3,%eax
c0104a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104a52:	89 c2                	mov    %eax,%edx
c0104a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a5a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104a61:	77 23                	ja     c0104a86 <tlb_invalidate+0x43>
c0104a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a66:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a6a:	c7 44 24 08 38 6e 10 	movl   $0xc0106e38,0x8(%esp)
c0104a71:	c0 
c0104a72:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0104a79:	00 
c0104a7a:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104a81:	e8 50 c2 ff ff       	call   c0100cd6 <__panic>
c0104a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a89:	05 00 00 00 40       	add    $0x40000000,%eax
c0104a8e:	39 c2                	cmp    %eax,%edx
c0104a90:	75 0c                	jne    c0104a9e <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104a92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a95:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a9b:	0f 01 38             	invlpg (%eax)
    }
}
c0104a9e:	c9                   	leave  
c0104a9f:	c3                   	ret    

c0104aa0 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104aa0:	55                   	push   %ebp
c0104aa1:	89 e5                	mov    %esp,%ebp
c0104aa3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104aa6:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0104aab:	8b 40 18             	mov    0x18(%eax),%eax
c0104aae:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104ab0:	c7 04 24 bc 6e 10 c0 	movl   $0xc0106ebc,(%esp)
c0104ab7:	e8 8c b8 ff ff       	call   c0100348 <cprintf>
}
c0104abc:	c9                   	leave  
c0104abd:	c3                   	ret    

c0104abe <check_pgdir>:

static void
check_pgdir(void) {
c0104abe:	55                   	push   %ebp
c0104abf:	89 e5                	mov    %esp,%ebp
c0104ac1:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104ac4:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104ac9:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104ace:	76 24                	jbe    c0104af4 <check_pgdir+0x36>
c0104ad0:	c7 44 24 0c db 6e 10 	movl   $0xc0106edb,0xc(%esp)
c0104ad7:	c0 
c0104ad8:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104adf:	c0 
c0104ae0:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104ae7:	00 
c0104ae8:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104aef:	e8 e2 c1 ff ff       	call   c0100cd6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104af4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104af9:	85 c0                	test   %eax,%eax
c0104afb:	74 0e                	je     c0104b0b <check_pgdir+0x4d>
c0104afd:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b02:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104b07:	85 c0                	test   %eax,%eax
c0104b09:	74 24                	je     c0104b2f <check_pgdir+0x71>
c0104b0b:	c7 44 24 0c f8 6e 10 	movl   $0xc0106ef8,0xc(%esp)
c0104b12:	c0 
c0104b13:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104b1a:	c0 
c0104b1b:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104b22:	00 
c0104b23:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104b2a:	e8 a7 c1 ff ff       	call   c0100cd6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104b2f:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b34:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b3b:	00 
c0104b3c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b43:	00 
c0104b44:	89 04 24             	mov    %eax,(%esp)
c0104b47:	e8 3b fd ff ff       	call   c0104887 <get_page>
c0104b4c:	85 c0                	test   %eax,%eax
c0104b4e:	74 24                	je     c0104b74 <check_pgdir+0xb6>
c0104b50:	c7 44 24 0c 30 6f 10 	movl   $0xc0106f30,0xc(%esp)
c0104b57:	c0 
c0104b58:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104b5f:	c0 
c0104b60:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0104b67:	00 
c0104b68:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104b6f:	e8 62 c1 ff ff       	call   c0100cd6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104b74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b7b:	e8 05 f5 ff ff       	call   c0104085 <alloc_pages>
c0104b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104b83:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b88:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104b8f:	00 
c0104b90:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b97:	00 
c0104b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b9b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b9f:	89 04 24             	mov    %eax,(%esp)
c0104ba2:	e8 e3 fd ff ff       	call   c010498a <page_insert>
c0104ba7:	85 c0                	test   %eax,%eax
c0104ba9:	74 24                	je     c0104bcf <check_pgdir+0x111>
c0104bab:	c7 44 24 0c 58 6f 10 	movl   $0xc0106f58,0xc(%esp)
c0104bb2:	c0 
c0104bb3:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104bba:	c0 
c0104bbb:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0104bc2:	00 
c0104bc3:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104bca:	e8 07 c1 ff ff       	call   c0100cd6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104bcf:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104bd4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104bdb:	00 
c0104bdc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104be3:	00 
c0104be4:	89 04 24             	mov    %eax,(%esp)
c0104be7:	e8 55 fb ff ff       	call   c0104741 <get_pte>
c0104bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104bef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104bf3:	75 24                	jne    c0104c19 <check_pgdir+0x15b>
c0104bf5:	c7 44 24 0c 84 6f 10 	movl   $0xc0106f84,0xc(%esp)
c0104bfc:	c0 
c0104bfd:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104c04:	c0 
c0104c05:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104c0c:	00 
c0104c0d:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104c14:	e8 bd c0 ff ff       	call   c0100cd6 <__panic>
    assert(pte2page(*ptep) == p1);
c0104c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c1c:	8b 00                	mov    (%eax),%eax
c0104c1e:	89 04 24             	mov    %eax,(%esp)
c0104c21:	e8 04 f2 ff ff       	call   c0103e2a <pte2page>
c0104c26:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104c29:	74 24                	je     c0104c4f <check_pgdir+0x191>
c0104c2b:	c7 44 24 0c b1 6f 10 	movl   $0xc0106fb1,0xc(%esp)
c0104c32:	c0 
c0104c33:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104c3a:	c0 
c0104c3b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104c42:	00 
c0104c43:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104c4a:	e8 87 c0 ff ff       	call   c0100cd6 <__panic>
    assert(page_ref(p1) == 1);
c0104c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c52:	89 04 24             	mov    %eax,(%esp)
c0104c55:	e8 26 f2 ff ff       	call   c0103e80 <page_ref>
c0104c5a:	83 f8 01             	cmp    $0x1,%eax
c0104c5d:	74 24                	je     c0104c83 <check_pgdir+0x1c5>
c0104c5f:	c7 44 24 0c c7 6f 10 	movl   $0xc0106fc7,0xc(%esp)
c0104c66:	c0 
c0104c67:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104c6e:	c0 
c0104c6f:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104c76:	00 
c0104c77:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104c7e:	e8 53 c0 ff ff       	call   c0100cd6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104c83:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104c88:	8b 00                	mov    (%eax),%eax
c0104c8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c95:	c1 e8 0c             	shr    $0xc,%eax
c0104c98:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104c9b:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104ca0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104ca3:	72 23                	jb     c0104cc8 <check_pgdir+0x20a>
c0104ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ca8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104cac:	c7 44 24 08 94 6d 10 	movl   $0xc0106d94,0x8(%esp)
c0104cb3:	c0 
c0104cb4:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104cbb:	00 
c0104cbc:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104cc3:	e8 0e c0 ff ff       	call   c0100cd6 <__panic>
c0104cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ccb:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104cd0:	83 c0 04             	add    $0x4,%eax
c0104cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104cd6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104cdb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ce2:	00 
c0104ce3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104cea:	00 
c0104ceb:	89 04 24             	mov    %eax,(%esp)
c0104cee:	e8 4e fa ff ff       	call   c0104741 <get_pte>
c0104cf3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104cf6:	74 24                	je     c0104d1c <check_pgdir+0x25e>
c0104cf8:	c7 44 24 0c dc 6f 10 	movl   $0xc0106fdc,0xc(%esp)
c0104cff:	c0 
c0104d00:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104d07:	c0 
c0104d08:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104d0f:	00 
c0104d10:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104d17:	e8 ba bf ff ff       	call   c0100cd6 <__panic>

    p2 = alloc_page();
c0104d1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d23:	e8 5d f3 ff ff       	call   c0104085 <alloc_pages>
c0104d28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104d2b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104d30:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104d37:	00 
c0104d38:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104d3f:	00 
c0104d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104d43:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d47:	89 04 24             	mov    %eax,(%esp)
c0104d4a:	e8 3b fc ff ff       	call   c010498a <page_insert>
c0104d4f:	85 c0                	test   %eax,%eax
c0104d51:	74 24                	je     c0104d77 <check_pgdir+0x2b9>
c0104d53:	c7 44 24 0c 04 70 10 	movl   $0xc0107004,0xc(%esp)
c0104d5a:	c0 
c0104d5b:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104d62:	c0 
c0104d63:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104d6a:	00 
c0104d6b:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104d72:	e8 5f bf ff ff       	call   c0100cd6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104d77:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104d7c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d83:	00 
c0104d84:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d8b:	00 
c0104d8c:	89 04 24             	mov    %eax,(%esp)
c0104d8f:	e8 ad f9 ff ff       	call   c0104741 <get_pte>
c0104d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d9b:	75 24                	jne    c0104dc1 <check_pgdir+0x303>
c0104d9d:	c7 44 24 0c 3c 70 10 	movl   $0xc010703c,0xc(%esp)
c0104da4:	c0 
c0104da5:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104dac:	c0 
c0104dad:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104db4:	00 
c0104db5:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104dbc:	e8 15 bf ff ff       	call   c0100cd6 <__panic>
    assert(*ptep & PTE_U);
c0104dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dc4:	8b 00                	mov    (%eax),%eax
c0104dc6:	83 e0 04             	and    $0x4,%eax
c0104dc9:	85 c0                	test   %eax,%eax
c0104dcb:	75 24                	jne    c0104df1 <check_pgdir+0x333>
c0104dcd:	c7 44 24 0c 6c 70 10 	movl   $0xc010706c,0xc(%esp)
c0104dd4:	c0 
c0104dd5:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104ddc:	c0 
c0104ddd:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104de4:	00 
c0104de5:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104dec:	e8 e5 be ff ff       	call   c0100cd6 <__panic>
    assert(*ptep & PTE_W);
c0104df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104df4:	8b 00                	mov    (%eax),%eax
c0104df6:	83 e0 02             	and    $0x2,%eax
c0104df9:	85 c0                	test   %eax,%eax
c0104dfb:	75 24                	jne    c0104e21 <check_pgdir+0x363>
c0104dfd:	c7 44 24 0c 7a 70 10 	movl   $0xc010707a,0xc(%esp)
c0104e04:	c0 
c0104e05:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104e0c:	c0 
c0104e0d:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104e14:	00 
c0104e15:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104e1c:	e8 b5 be ff ff       	call   c0100cd6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104e21:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e26:	8b 00                	mov    (%eax),%eax
c0104e28:	83 e0 04             	and    $0x4,%eax
c0104e2b:	85 c0                	test   %eax,%eax
c0104e2d:	75 24                	jne    c0104e53 <check_pgdir+0x395>
c0104e2f:	c7 44 24 0c 88 70 10 	movl   $0xc0107088,0xc(%esp)
c0104e36:	c0 
c0104e37:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104e3e:	c0 
c0104e3f:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104e46:	00 
c0104e47:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104e4e:	e8 83 be ff ff       	call   c0100cd6 <__panic>
    assert(page_ref(p2) == 1);
c0104e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e56:	89 04 24             	mov    %eax,(%esp)
c0104e59:	e8 22 f0 ff ff       	call   c0103e80 <page_ref>
c0104e5e:	83 f8 01             	cmp    $0x1,%eax
c0104e61:	74 24                	je     c0104e87 <check_pgdir+0x3c9>
c0104e63:	c7 44 24 0c 9e 70 10 	movl   $0xc010709e,0xc(%esp)
c0104e6a:	c0 
c0104e6b:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104e72:	c0 
c0104e73:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104e7a:	00 
c0104e7b:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104e82:	e8 4f be ff ff       	call   c0100cd6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104e87:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e8c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104e93:	00 
c0104e94:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104e9b:	00 
c0104e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104e9f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ea3:	89 04 24             	mov    %eax,(%esp)
c0104ea6:	e8 df fa ff ff       	call   c010498a <page_insert>
c0104eab:	85 c0                	test   %eax,%eax
c0104ead:	74 24                	je     c0104ed3 <check_pgdir+0x415>
c0104eaf:	c7 44 24 0c b0 70 10 	movl   $0xc01070b0,0xc(%esp)
c0104eb6:	c0 
c0104eb7:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104ebe:	c0 
c0104ebf:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104ec6:	00 
c0104ec7:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104ece:	e8 03 be ff ff       	call   c0100cd6 <__panic>
    assert(page_ref(p1) == 2);
c0104ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed6:	89 04 24             	mov    %eax,(%esp)
c0104ed9:	e8 a2 ef ff ff       	call   c0103e80 <page_ref>
c0104ede:	83 f8 02             	cmp    $0x2,%eax
c0104ee1:	74 24                	je     c0104f07 <check_pgdir+0x449>
c0104ee3:	c7 44 24 0c dc 70 10 	movl   $0xc01070dc,0xc(%esp)
c0104eea:	c0 
c0104eeb:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104ef2:	c0 
c0104ef3:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104efa:	00 
c0104efb:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104f02:	e8 cf bd ff ff       	call   c0100cd6 <__panic>
    assert(page_ref(p2) == 0);
c0104f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f0a:	89 04 24             	mov    %eax,(%esp)
c0104f0d:	e8 6e ef ff ff       	call   c0103e80 <page_ref>
c0104f12:	85 c0                	test   %eax,%eax
c0104f14:	74 24                	je     c0104f3a <check_pgdir+0x47c>
c0104f16:	c7 44 24 0c ee 70 10 	movl   $0xc01070ee,0xc(%esp)
c0104f1d:	c0 
c0104f1e:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104f25:	c0 
c0104f26:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104f2d:	00 
c0104f2e:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104f35:	e8 9c bd ff ff       	call   c0100cd6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104f3a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104f3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f46:	00 
c0104f47:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104f4e:	00 
c0104f4f:	89 04 24             	mov    %eax,(%esp)
c0104f52:	e8 ea f7 ff ff       	call   c0104741 <get_pte>
c0104f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104f5e:	75 24                	jne    c0104f84 <check_pgdir+0x4c6>
c0104f60:	c7 44 24 0c 3c 70 10 	movl   $0xc010703c,0xc(%esp)
c0104f67:	c0 
c0104f68:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104f6f:	c0 
c0104f70:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104f77:	00 
c0104f78:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104f7f:	e8 52 bd ff ff       	call   c0100cd6 <__panic>
    assert(pte2page(*ptep) == p1);
c0104f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f87:	8b 00                	mov    (%eax),%eax
c0104f89:	89 04 24             	mov    %eax,(%esp)
c0104f8c:	e8 99 ee ff ff       	call   c0103e2a <pte2page>
c0104f91:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f94:	74 24                	je     c0104fba <check_pgdir+0x4fc>
c0104f96:	c7 44 24 0c b1 6f 10 	movl   $0xc0106fb1,0xc(%esp)
c0104f9d:	c0 
c0104f9e:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104fa5:	c0 
c0104fa6:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104fad:	00 
c0104fae:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104fb5:	e8 1c bd ff ff       	call   c0100cd6 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fbd:	8b 00                	mov    (%eax),%eax
c0104fbf:	83 e0 04             	and    $0x4,%eax
c0104fc2:	85 c0                	test   %eax,%eax
c0104fc4:	74 24                	je     c0104fea <check_pgdir+0x52c>
c0104fc6:	c7 44 24 0c 00 71 10 	movl   $0xc0107100,0xc(%esp)
c0104fcd:	c0 
c0104fce:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0104fd5:	c0 
c0104fd6:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104fdd:	00 
c0104fde:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0104fe5:	e8 ec bc ff ff       	call   c0100cd6 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104fea:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104fef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ff6:	00 
c0104ff7:	89 04 24             	mov    %eax,(%esp)
c0104ffa:	e8 47 f9 ff ff       	call   c0104946 <page_remove>
    assert(page_ref(p1) == 1);
c0104fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105002:	89 04 24             	mov    %eax,(%esp)
c0105005:	e8 76 ee ff ff       	call   c0103e80 <page_ref>
c010500a:	83 f8 01             	cmp    $0x1,%eax
c010500d:	74 24                	je     c0105033 <check_pgdir+0x575>
c010500f:	c7 44 24 0c c7 6f 10 	movl   $0xc0106fc7,0xc(%esp)
c0105016:	c0 
c0105017:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c010501e:	c0 
c010501f:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0105026:	00 
c0105027:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c010502e:	e8 a3 bc ff ff       	call   c0100cd6 <__panic>
    assert(page_ref(p2) == 0);
c0105033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105036:	89 04 24             	mov    %eax,(%esp)
c0105039:	e8 42 ee ff ff       	call   c0103e80 <page_ref>
c010503e:	85 c0                	test   %eax,%eax
c0105040:	74 24                	je     c0105066 <check_pgdir+0x5a8>
c0105042:	c7 44 24 0c ee 70 10 	movl   $0xc01070ee,0xc(%esp)
c0105049:	c0 
c010504a:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0105051:	c0 
c0105052:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0105059:	00 
c010505a:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0105061:	e8 70 bc ff ff       	call   c0100cd6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105066:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010506b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105072:	00 
c0105073:	89 04 24             	mov    %eax,(%esp)
c0105076:	e8 cb f8 ff ff       	call   c0104946 <page_remove>
    assert(page_ref(p1) == 0);
c010507b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010507e:	89 04 24             	mov    %eax,(%esp)
c0105081:	e8 fa ed ff ff       	call   c0103e80 <page_ref>
c0105086:	85 c0                	test   %eax,%eax
c0105088:	74 24                	je     c01050ae <check_pgdir+0x5f0>
c010508a:	c7 44 24 0c 15 71 10 	movl   $0xc0107115,0xc(%esp)
c0105091:	c0 
c0105092:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0105099:	c0 
c010509a:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c01050a1:	00 
c01050a2:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c01050a9:	e8 28 bc ff ff       	call   c0100cd6 <__panic>
    assert(page_ref(p2) == 0);
c01050ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050b1:	89 04 24             	mov    %eax,(%esp)
c01050b4:	e8 c7 ed ff ff       	call   c0103e80 <page_ref>
c01050b9:	85 c0                	test   %eax,%eax
c01050bb:	74 24                	je     c01050e1 <check_pgdir+0x623>
c01050bd:	c7 44 24 0c ee 70 10 	movl   $0xc01070ee,0xc(%esp)
c01050c4:	c0 
c01050c5:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c01050cc:	c0 
c01050cd:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c01050d4:	00 
c01050d5:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c01050dc:	e8 f5 bb ff ff       	call   c0100cd6 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01050e1:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01050e6:	8b 00                	mov    (%eax),%eax
c01050e8:	89 04 24             	mov    %eax,(%esp)
c01050eb:	e8 78 ed ff ff       	call   c0103e68 <pde2page>
c01050f0:	89 04 24             	mov    %eax,(%esp)
c01050f3:	e8 88 ed ff ff       	call   c0103e80 <page_ref>
c01050f8:	83 f8 01             	cmp    $0x1,%eax
c01050fb:	74 24                	je     c0105121 <check_pgdir+0x663>
c01050fd:	c7 44 24 0c 28 71 10 	movl   $0xc0107128,0xc(%esp)
c0105104:	c0 
c0105105:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c010510c:	c0 
c010510d:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0105114:	00 
c0105115:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c010511c:	e8 b5 bb ff ff       	call   c0100cd6 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0105121:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0105126:	8b 00                	mov    (%eax),%eax
c0105128:	89 04 24             	mov    %eax,(%esp)
c010512b:	e8 38 ed ff ff       	call   c0103e68 <pde2page>
c0105130:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105137:	00 
c0105138:	89 04 24             	mov    %eax,(%esp)
c010513b:	e8 7d ef ff ff       	call   c01040bd <free_pages>
    boot_pgdir[0] = 0;
c0105140:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0105145:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c010514b:	c7 04 24 4f 71 10 c0 	movl   $0xc010714f,(%esp)
c0105152:	e8 f1 b1 ff ff       	call   c0100348 <cprintf>
}
c0105157:	c9                   	leave  
c0105158:	c3                   	ret    

c0105159 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105159:	55                   	push   %ebp
c010515a:	89 e5                	mov    %esp,%ebp
c010515c:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010515f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105166:	e9 ca 00 00 00       	jmp    c0105235 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c010516b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010516e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105171:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105174:	c1 e8 0c             	shr    $0xc,%eax
c0105177:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010517a:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010517f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105182:	72 23                	jb     c01051a7 <check_boot_pgdir+0x4e>
c0105184:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105187:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010518b:	c7 44 24 08 94 6d 10 	movl   $0xc0106d94,0x8(%esp)
c0105192:	c0 
c0105193:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c010519a:	00 
c010519b:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c01051a2:	e8 2f bb ff ff       	call   c0100cd6 <__panic>
c01051a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051aa:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01051af:	89 c2                	mov    %eax,%edx
c01051b1:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01051b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01051bd:	00 
c01051be:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051c2:	89 04 24             	mov    %eax,(%esp)
c01051c5:	e8 77 f5 ff ff       	call   c0104741 <get_pte>
c01051ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01051cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01051d1:	75 24                	jne    c01051f7 <check_boot_pgdir+0x9e>
c01051d3:	c7 44 24 0c 6c 71 10 	movl   $0xc010716c,0xc(%esp)
c01051da:	c0 
c01051db:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c01051e2:	c0 
c01051e3:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c01051ea:	00 
c01051eb:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c01051f2:	e8 df ba ff ff       	call   c0100cd6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01051f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01051fa:	8b 00                	mov    (%eax),%eax
c01051fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105201:	89 c2                	mov    %eax,%edx
c0105203:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105206:	39 c2                	cmp    %eax,%edx
c0105208:	74 24                	je     c010522e <check_boot_pgdir+0xd5>
c010520a:	c7 44 24 0c a9 71 10 	movl   $0xc01071a9,0xc(%esp)
c0105211:	c0 
c0105212:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0105219:	c0 
c010521a:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105221:	00 
c0105222:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0105229:	e8 a8 ba ff ff       	call   c0100cd6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010522e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105235:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105238:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010523d:	39 c2                	cmp    %eax,%edx
c010523f:	0f 82 26 ff ff ff    	jb     c010516b <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105245:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010524a:	05 ac 0f 00 00       	add    $0xfac,%eax
c010524f:	8b 00                	mov    (%eax),%eax
c0105251:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105256:	89 c2                	mov    %eax,%edx
c0105258:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010525d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105260:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0105267:	77 23                	ja     c010528c <check_boot_pgdir+0x133>
c0105269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010526c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105270:	c7 44 24 08 38 6e 10 	movl   $0xc0106e38,0x8(%esp)
c0105277:	c0 
c0105278:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c010527f:	00 
c0105280:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0105287:	e8 4a ba ff ff       	call   c0100cd6 <__panic>
c010528c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010528f:	05 00 00 00 40       	add    $0x40000000,%eax
c0105294:	39 c2                	cmp    %eax,%edx
c0105296:	74 24                	je     c01052bc <check_boot_pgdir+0x163>
c0105298:	c7 44 24 0c c0 71 10 	movl   $0xc01071c0,0xc(%esp)
c010529f:	c0 
c01052a0:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c01052a7:	c0 
c01052a8:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c01052af:	00 
c01052b0:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c01052b7:	e8 1a ba ff ff       	call   c0100cd6 <__panic>

    assert(boot_pgdir[0] == 0);
c01052bc:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01052c1:	8b 00                	mov    (%eax),%eax
c01052c3:	85 c0                	test   %eax,%eax
c01052c5:	74 24                	je     c01052eb <check_boot_pgdir+0x192>
c01052c7:	c7 44 24 0c f4 71 10 	movl   $0xc01071f4,0xc(%esp)
c01052ce:	c0 
c01052cf:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c01052d6:	c0 
c01052d7:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c01052de:	00 
c01052df:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c01052e6:	e8 eb b9 ff ff       	call   c0100cd6 <__panic>

    struct Page *p;
    p = alloc_page();
c01052eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052f2:	e8 8e ed ff ff       	call   c0104085 <alloc_pages>
c01052f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01052fa:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01052ff:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105306:	00 
c0105307:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c010530e:	00 
c010530f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105312:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105316:	89 04 24             	mov    %eax,(%esp)
c0105319:	e8 6c f6 ff ff       	call   c010498a <page_insert>
c010531e:	85 c0                	test   %eax,%eax
c0105320:	74 24                	je     c0105346 <check_boot_pgdir+0x1ed>
c0105322:	c7 44 24 0c 08 72 10 	movl   $0xc0107208,0xc(%esp)
c0105329:	c0 
c010532a:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0105331:	c0 
c0105332:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105339:	00 
c010533a:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0105341:	e8 90 b9 ff ff       	call   c0100cd6 <__panic>
    assert(page_ref(p) == 1);
c0105346:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105349:	89 04 24             	mov    %eax,(%esp)
c010534c:	e8 2f eb ff ff       	call   c0103e80 <page_ref>
c0105351:	83 f8 01             	cmp    $0x1,%eax
c0105354:	74 24                	je     c010537a <check_boot_pgdir+0x221>
c0105356:	c7 44 24 0c 36 72 10 	movl   $0xc0107236,0xc(%esp)
c010535d:	c0 
c010535e:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0105365:	c0 
c0105366:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c010536d:	00 
c010536e:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0105375:	e8 5c b9 ff ff       	call   c0100cd6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010537a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010537f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105386:	00 
c0105387:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010538e:	00 
c010538f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105392:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105396:	89 04 24             	mov    %eax,(%esp)
c0105399:	e8 ec f5 ff ff       	call   c010498a <page_insert>
c010539e:	85 c0                	test   %eax,%eax
c01053a0:	74 24                	je     c01053c6 <check_boot_pgdir+0x26d>
c01053a2:	c7 44 24 0c 48 72 10 	movl   $0xc0107248,0xc(%esp)
c01053a9:	c0 
c01053aa:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c01053b1:	c0 
c01053b2:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c01053b9:	00 
c01053ba:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c01053c1:	e8 10 b9 ff ff       	call   c0100cd6 <__panic>
    assert(page_ref(p) == 2);
c01053c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053c9:	89 04 24             	mov    %eax,(%esp)
c01053cc:	e8 af ea ff ff       	call   c0103e80 <page_ref>
c01053d1:	83 f8 02             	cmp    $0x2,%eax
c01053d4:	74 24                	je     c01053fa <check_boot_pgdir+0x2a1>
c01053d6:	c7 44 24 0c 7f 72 10 	movl   $0xc010727f,0xc(%esp)
c01053dd:	c0 
c01053de:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c01053e5:	c0 
c01053e6:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c01053ed:	00 
c01053ee:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c01053f5:	e8 dc b8 ff ff       	call   c0100cd6 <__panic>

    const char *str = "ucore: Hello world!!";
c01053fa:	c7 45 dc 90 72 10 c0 	movl   $0xc0107290,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105401:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105404:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105408:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010540f:	e8 19 0a 00 00       	call   c0105e2d <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105414:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010541b:	00 
c010541c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105423:	e8 7e 0a 00 00       	call   c0105ea6 <strcmp>
c0105428:	85 c0                	test   %eax,%eax
c010542a:	74 24                	je     c0105450 <check_boot_pgdir+0x2f7>
c010542c:	c7 44 24 0c a8 72 10 	movl   $0xc01072a8,0xc(%esp)
c0105433:	c0 
c0105434:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c010543b:	c0 
c010543c:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105443:	00 
c0105444:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c010544b:	e8 86 b8 ff ff       	call   c0100cd6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105450:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105453:	89 04 24             	mov    %eax,(%esp)
c0105456:	e8 7b e9 ff ff       	call   c0103dd6 <page2kva>
c010545b:	05 00 01 00 00       	add    $0x100,%eax
c0105460:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105463:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010546a:	e8 66 09 00 00       	call   c0105dd5 <strlen>
c010546f:	85 c0                	test   %eax,%eax
c0105471:	74 24                	je     c0105497 <check_boot_pgdir+0x33e>
c0105473:	c7 44 24 0c e0 72 10 	movl   $0xc01072e0,0xc(%esp)
c010547a:	c0 
c010547b:	c7 44 24 08 81 6e 10 	movl   $0xc0106e81,0x8(%esp)
c0105482:	c0 
c0105483:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c010548a:	00 
c010548b:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0105492:	e8 3f b8 ff ff       	call   c0100cd6 <__panic>

    free_page(p);
c0105497:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010549e:	00 
c010549f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054a2:	89 04 24             	mov    %eax,(%esp)
c01054a5:	e8 13 ec ff ff       	call   c01040bd <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c01054aa:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01054af:	8b 00                	mov    (%eax),%eax
c01054b1:	89 04 24             	mov    %eax,(%esp)
c01054b4:	e8 af e9 ff ff       	call   c0103e68 <pde2page>
c01054b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01054c0:	00 
c01054c1:	89 04 24             	mov    %eax,(%esp)
c01054c4:	e8 f4 eb ff ff       	call   c01040bd <free_pages>
    boot_pgdir[0] = 0;
c01054c9:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01054ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01054d4:	c7 04 24 04 73 10 c0 	movl   $0xc0107304,(%esp)
c01054db:	e8 68 ae ff ff       	call   c0100348 <cprintf>
}
c01054e0:	c9                   	leave  
c01054e1:	c3                   	ret    

c01054e2 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01054e2:	55                   	push   %ebp
c01054e3:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01054e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e8:	83 e0 04             	and    $0x4,%eax
c01054eb:	85 c0                	test   %eax,%eax
c01054ed:	74 07                	je     c01054f6 <perm2str+0x14>
c01054ef:	b8 75 00 00 00       	mov    $0x75,%eax
c01054f4:	eb 05                	jmp    c01054fb <perm2str+0x19>
c01054f6:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01054fb:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c0105500:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105507:	8b 45 08             	mov    0x8(%ebp),%eax
c010550a:	83 e0 02             	and    $0x2,%eax
c010550d:	85 c0                	test   %eax,%eax
c010550f:	74 07                	je     c0105518 <perm2str+0x36>
c0105511:	b8 77 00 00 00       	mov    $0x77,%eax
c0105516:	eb 05                	jmp    c010551d <perm2str+0x3b>
c0105518:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010551d:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c0105522:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c0105529:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c010552e:	5d                   	pop    %ebp
c010552f:	c3                   	ret    

c0105530 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105530:	55                   	push   %ebp
c0105531:	89 e5                	mov    %esp,%ebp
c0105533:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105536:	8b 45 10             	mov    0x10(%ebp),%eax
c0105539:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010553c:	72 0a                	jb     c0105548 <get_pgtable_items+0x18>
        return 0;
c010553e:	b8 00 00 00 00       	mov    $0x0,%eax
c0105543:	e9 9c 00 00 00       	jmp    c01055e4 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105548:	eb 04                	jmp    c010554e <get_pgtable_items+0x1e>
        start ++;
c010554a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010554e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105551:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105554:	73 18                	jae    c010556e <get_pgtable_items+0x3e>
c0105556:	8b 45 10             	mov    0x10(%ebp),%eax
c0105559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105560:	8b 45 14             	mov    0x14(%ebp),%eax
c0105563:	01 d0                	add    %edx,%eax
c0105565:	8b 00                	mov    (%eax),%eax
c0105567:	83 e0 01             	and    $0x1,%eax
c010556a:	85 c0                	test   %eax,%eax
c010556c:	74 dc                	je     c010554a <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c010556e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105571:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105574:	73 69                	jae    c01055df <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105576:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010557a:	74 08                	je     c0105584 <get_pgtable_items+0x54>
            *left_store = start;
c010557c:	8b 45 18             	mov    0x18(%ebp),%eax
c010557f:	8b 55 10             	mov    0x10(%ebp),%edx
c0105582:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105584:	8b 45 10             	mov    0x10(%ebp),%eax
c0105587:	8d 50 01             	lea    0x1(%eax),%edx
c010558a:	89 55 10             	mov    %edx,0x10(%ebp)
c010558d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105594:	8b 45 14             	mov    0x14(%ebp),%eax
c0105597:	01 d0                	add    %edx,%eax
c0105599:	8b 00                	mov    (%eax),%eax
c010559b:	83 e0 07             	and    $0x7,%eax
c010559e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01055a1:	eb 04                	jmp    c01055a7 <get_pgtable_items+0x77>
            start ++;
c01055a3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01055a7:	8b 45 10             	mov    0x10(%ebp),%eax
c01055aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01055ad:	73 1d                	jae    c01055cc <get_pgtable_items+0x9c>
c01055af:	8b 45 10             	mov    0x10(%ebp),%eax
c01055b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01055b9:	8b 45 14             	mov    0x14(%ebp),%eax
c01055bc:	01 d0                	add    %edx,%eax
c01055be:	8b 00                	mov    (%eax),%eax
c01055c0:	83 e0 07             	and    $0x7,%eax
c01055c3:	89 c2                	mov    %eax,%edx
c01055c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055c8:	39 c2                	cmp    %eax,%edx
c01055ca:	74 d7                	je     c01055a3 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01055cc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01055d0:	74 08                	je     c01055da <get_pgtable_items+0xaa>
            *right_store = start;
c01055d2:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01055d5:	8b 55 10             	mov    0x10(%ebp),%edx
c01055d8:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01055da:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055dd:	eb 05                	jmp    c01055e4 <get_pgtable_items+0xb4>
    }
    return 0;
c01055df:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01055e4:	c9                   	leave  
c01055e5:	c3                   	ret    

c01055e6 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01055e6:	55                   	push   %ebp
c01055e7:	89 e5                	mov    %esp,%ebp
c01055e9:	57                   	push   %edi
c01055ea:	56                   	push   %esi
c01055eb:	53                   	push   %ebx
c01055ec:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01055ef:	c7 04 24 24 73 10 c0 	movl   $0xc0107324,(%esp)
c01055f6:	e8 4d ad ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
c01055fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105602:	e9 fa 00 00 00       	jmp    c0105701 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010560a:	89 04 24             	mov    %eax,(%esp)
c010560d:	e8 d0 fe ff ff       	call   c01054e2 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105612:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105615:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105618:	29 d1                	sub    %edx,%ecx
c010561a:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010561c:	89 d6                	mov    %edx,%esi
c010561e:	c1 e6 16             	shl    $0x16,%esi
c0105621:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105624:	89 d3                	mov    %edx,%ebx
c0105626:	c1 e3 16             	shl    $0x16,%ebx
c0105629:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010562c:	89 d1                	mov    %edx,%ecx
c010562e:	c1 e1 16             	shl    $0x16,%ecx
c0105631:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105634:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105637:	29 d7                	sub    %edx,%edi
c0105639:	89 fa                	mov    %edi,%edx
c010563b:	89 44 24 14          	mov    %eax,0x14(%esp)
c010563f:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105643:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105647:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010564b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010564f:	c7 04 24 55 73 10 c0 	movl   $0xc0107355,(%esp)
c0105656:	e8 ed ac ff ff       	call   c0100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010565b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010565e:	c1 e0 0a             	shl    $0xa,%eax
c0105661:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105664:	eb 54                	jmp    c01056ba <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105669:	89 04 24             	mov    %eax,(%esp)
c010566c:	e8 71 fe ff ff       	call   c01054e2 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105671:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105674:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105677:	29 d1                	sub    %edx,%ecx
c0105679:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010567b:	89 d6                	mov    %edx,%esi
c010567d:	c1 e6 0c             	shl    $0xc,%esi
c0105680:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105683:	89 d3                	mov    %edx,%ebx
c0105685:	c1 e3 0c             	shl    $0xc,%ebx
c0105688:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010568b:	c1 e2 0c             	shl    $0xc,%edx
c010568e:	89 d1                	mov    %edx,%ecx
c0105690:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105693:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105696:	29 d7                	sub    %edx,%edi
c0105698:	89 fa                	mov    %edi,%edx
c010569a:	89 44 24 14          	mov    %eax,0x14(%esp)
c010569e:	89 74 24 10          	mov    %esi,0x10(%esp)
c01056a2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01056a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01056aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056ae:	c7 04 24 74 73 10 c0 	movl   $0xc0107374,(%esp)
c01056b5:	e8 8e ac ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01056ba:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01056bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01056c2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01056c5:	89 ce                	mov    %ecx,%esi
c01056c7:	c1 e6 0a             	shl    $0xa,%esi
c01056ca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01056cd:	89 cb                	mov    %ecx,%ebx
c01056cf:	c1 e3 0a             	shl    $0xa,%ebx
c01056d2:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01056d5:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01056d9:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01056dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01056e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01056e4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056e8:	89 74 24 04          	mov    %esi,0x4(%esp)
c01056ec:	89 1c 24             	mov    %ebx,(%esp)
c01056ef:	e8 3c fe ff ff       	call   c0105530 <get_pgtable_items>
c01056f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01056f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01056fb:	0f 85 65 ff ff ff    	jne    c0105666 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105701:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105706:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105709:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010570c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105710:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105713:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105717:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010571b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010571f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105726:	00 
c0105727:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010572e:	e8 fd fd ff ff       	call   c0105530 <get_pgtable_items>
c0105733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105736:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010573a:	0f 85 c7 fe ff ff    	jne    c0105607 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105740:	c7 04 24 98 73 10 c0 	movl   $0xc0107398,(%esp)
c0105747:	e8 fc ab ff ff       	call   c0100348 <cprintf>
}
c010574c:	83 c4 4c             	add    $0x4c,%esp
c010574f:	5b                   	pop    %ebx
c0105750:	5e                   	pop    %esi
c0105751:	5f                   	pop    %edi
c0105752:	5d                   	pop    %ebp
c0105753:	c3                   	ret    

c0105754 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105754:	55                   	push   %ebp
c0105755:	89 e5                	mov    %esp,%ebp
c0105757:	83 ec 58             	sub    $0x58,%esp
c010575a:	8b 45 10             	mov    0x10(%ebp),%eax
c010575d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105760:	8b 45 14             	mov    0x14(%ebp),%eax
c0105763:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105766:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105769:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010576c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010576f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105772:	8b 45 18             	mov    0x18(%ebp),%eax
c0105775:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105778:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010577b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010577e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105781:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105784:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105787:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010578a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010578e:	74 1c                	je     c01057ac <printnum+0x58>
c0105790:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105793:	ba 00 00 00 00       	mov    $0x0,%edx
c0105798:	f7 75 e4             	divl   -0x1c(%ebp)
c010579b:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010579e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057a1:	ba 00 00 00 00       	mov    $0x0,%edx
c01057a6:	f7 75 e4             	divl   -0x1c(%ebp)
c01057a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057af:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057b2:	f7 75 e4             	divl   -0x1c(%ebp)
c01057b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01057b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01057bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057be:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01057c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057c4:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01057c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057ca:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01057cd:	8b 45 18             	mov    0x18(%ebp),%eax
c01057d0:	ba 00 00 00 00       	mov    $0x0,%edx
c01057d5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01057d8:	77 56                	ja     c0105830 <printnum+0xdc>
c01057da:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01057dd:	72 05                	jb     c01057e4 <printnum+0x90>
c01057df:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01057e2:	77 4c                	ja     c0105830 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01057e4:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01057e7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01057ea:	8b 45 20             	mov    0x20(%ebp),%eax
c01057ed:	89 44 24 18          	mov    %eax,0x18(%esp)
c01057f1:	89 54 24 14          	mov    %edx,0x14(%esp)
c01057f5:	8b 45 18             	mov    0x18(%ebp),%eax
c01057f8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01057fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105802:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105806:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010580a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010580d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105811:	8b 45 08             	mov    0x8(%ebp),%eax
c0105814:	89 04 24             	mov    %eax,(%esp)
c0105817:	e8 38 ff ff ff       	call   c0105754 <printnum>
c010581c:	eb 1c                	jmp    c010583a <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010581e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105821:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105825:	8b 45 20             	mov    0x20(%ebp),%eax
c0105828:	89 04 24             	mov    %eax,(%esp)
c010582b:	8b 45 08             	mov    0x8(%ebp),%eax
c010582e:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105830:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105834:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105838:	7f e4                	jg     c010581e <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010583a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010583d:	05 4c 74 10 c0       	add    $0xc010744c,%eax
c0105842:	0f b6 00             	movzbl (%eax),%eax
c0105845:	0f be c0             	movsbl %al,%eax
c0105848:	8b 55 0c             	mov    0xc(%ebp),%edx
c010584b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010584f:	89 04 24             	mov    %eax,(%esp)
c0105852:	8b 45 08             	mov    0x8(%ebp),%eax
c0105855:	ff d0                	call   *%eax
}
c0105857:	c9                   	leave  
c0105858:	c3                   	ret    

c0105859 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105859:	55                   	push   %ebp
c010585a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010585c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105860:	7e 14                	jle    c0105876 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105862:	8b 45 08             	mov    0x8(%ebp),%eax
c0105865:	8b 00                	mov    (%eax),%eax
c0105867:	8d 48 08             	lea    0x8(%eax),%ecx
c010586a:	8b 55 08             	mov    0x8(%ebp),%edx
c010586d:	89 0a                	mov    %ecx,(%edx)
c010586f:	8b 50 04             	mov    0x4(%eax),%edx
c0105872:	8b 00                	mov    (%eax),%eax
c0105874:	eb 30                	jmp    c01058a6 <getuint+0x4d>
    }
    else if (lflag) {
c0105876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010587a:	74 16                	je     c0105892 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010587c:	8b 45 08             	mov    0x8(%ebp),%eax
c010587f:	8b 00                	mov    (%eax),%eax
c0105881:	8d 48 04             	lea    0x4(%eax),%ecx
c0105884:	8b 55 08             	mov    0x8(%ebp),%edx
c0105887:	89 0a                	mov    %ecx,(%edx)
c0105889:	8b 00                	mov    (%eax),%eax
c010588b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105890:	eb 14                	jmp    c01058a6 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105892:	8b 45 08             	mov    0x8(%ebp),%eax
c0105895:	8b 00                	mov    (%eax),%eax
c0105897:	8d 48 04             	lea    0x4(%eax),%ecx
c010589a:	8b 55 08             	mov    0x8(%ebp),%edx
c010589d:	89 0a                	mov    %ecx,(%edx)
c010589f:	8b 00                	mov    (%eax),%eax
c01058a1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01058a6:	5d                   	pop    %ebp
c01058a7:	c3                   	ret    

c01058a8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01058a8:	55                   	push   %ebp
c01058a9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01058ab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01058af:	7e 14                	jle    c01058c5 <getint+0x1d>
        return va_arg(*ap, long long);
c01058b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b4:	8b 00                	mov    (%eax),%eax
c01058b6:	8d 48 08             	lea    0x8(%eax),%ecx
c01058b9:	8b 55 08             	mov    0x8(%ebp),%edx
c01058bc:	89 0a                	mov    %ecx,(%edx)
c01058be:	8b 50 04             	mov    0x4(%eax),%edx
c01058c1:	8b 00                	mov    (%eax),%eax
c01058c3:	eb 28                	jmp    c01058ed <getint+0x45>
    }
    else if (lflag) {
c01058c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01058c9:	74 12                	je     c01058dd <getint+0x35>
        return va_arg(*ap, long);
c01058cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ce:	8b 00                	mov    (%eax),%eax
c01058d0:	8d 48 04             	lea    0x4(%eax),%ecx
c01058d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01058d6:	89 0a                	mov    %ecx,(%edx)
c01058d8:	8b 00                	mov    (%eax),%eax
c01058da:	99                   	cltd   
c01058db:	eb 10                	jmp    c01058ed <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01058dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e0:	8b 00                	mov    (%eax),%eax
c01058e2:	8d 48 04             	lea    0x4(%eax),%ecx
c01058e5:	8b 55 08             	mov    0x8(%ebp),%edx
c01058e8:	89 0a                	mov    %ecx,(%edx)
c01058ea:	8b 00                	mov    (%eax),%eax
c01058ec:	99                   	cltd   
    }
}
c01058ed:	5d                   	pop    %ebp
c01058ee:	c3                   	ret    

c01058ef <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01058ef:	55                   	push   %ebp
c01058f0:	89 e5                	mov    %esp,%ebp
c01058f2:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01058f5:	8d 45 14             	lea    0x14(%ebp),%eax
c01058f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01058fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105902:	8b 45 10             	mov    0x10(%ebp),%eax
c0105905:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105909:	8b 45 0c             	mov    0xc(%ebp),%eax
c010590c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105910:	8b 45 08             	mov    0x8(%ebp),%eax
c0105913:	89 04 24             	mov    %eax,(%esp)
c0105916:	e8 02 00 00 00       	call   c010591d <vprintfmt>
    va_end(ap);
}
c010591b:	c9                   	leave  
c010591c:	c3                   	ret    

c010591d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010591d:	55                   	push   %ebp
c010591e:	89 e5                	mov    %esp,%ebp
c0105920:	56                   	push   %esi
c0105921:	53                   	push   %ebx
c0105922:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105925:	eb 18                	jmp    c010593f <vprintfmt+0x22>
            if (ch == '\0') {
c0105927:	85 db                	test   %ebx,%ebx
c0105929:	75 05                	jne    c0105930 <vprintfmt+0x13>
                return;
c010592b:	e9 d1 03 00 00       	jmp    c0105d01 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105930:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105933:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105937:	89 1c 24             	mov    %ebx,(%esp)
c010593a:	8b 45 08             	mov    0x8(%ebp),%eax
c010593d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010593f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105942:	8d 50 01             	lea    0x1(%eax),%edx
c0105945:	89 55 10             	mov    %edx,0x10(%ebp)
c0105948:	0f b6 00             	movzbl (%eax),%eax
c010594b:	0f b6 d8             	movzbl %al,%ebx
c010594e:	83 fb 25             	cmp    $0x25,%ebx
c0105951:	75 d4                	jne    c0105927 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105953:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105957:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010595e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105961:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105964:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010596b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010596e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105971:	8b 45 10             	mov    0x10(%ebp),%eax
c0105974:	8d 50 01             	lea    0x1(%eax),%edx
c0105977:	89 55 10             	mov    %edx,0x10(%ebp)
c010597a:	0f b6 00             	movzbl (%eax),%eax
c010597d:	0f b6 d8             	movzbl %al,%ebx
c0105980:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105983:	83 f8 55             	cmp    $0x55,%eax
c0105986:	0f 87 44 03 00 00    	ja     c0105cd0 <vprintfmt+0x3b3>
c010598c:	8b 04 85 70 74 10 c0 	mov    -0x3fef8b90(,%eax,4),%eax
c0105993:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105995:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105999:	eb d6                	jmp    c0105971 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010599b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010599f:	eb d0                	jmp    c0105971 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01059a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01059a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01059ab:	89 d0                	mov    %edx,%eax
c01059ad:	c1 e0 02             	shl    $0x2,%eax
c01059b0:	01 d0                	add    %edx,%eax
c01059b2:	01 c0                	add    %eax,%eax
c01059b4:	01 d8                	add    %ebx,%eax
c01059b6:	83 e8 30             	sub    $0x30,%eax
c01059b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01059bc:	8b 45 10             	mov    0x10(%ebp),%eax
c01059bf:	0f b6 00             	movzbl (%eax),%eax
c01059c2:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01059c5:	83 fb 2f             	cmp    $0x2f,%ebx
c01059c8:	7e 0b                	jle    c01059d5 <vprintfmt+0xb8>
c01059ca:	83 fb 39             	cmp    $0x39,%ebx
c01059cd:	7f 06                	jg     c01059d5 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01059cf:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01059d3:	eb d3                	jmp    c01059a8 <vprintfmt+0x8b>
            goto process_precision;
c01059d5:	eb 33                	jmp    c0105a0a <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01059d7:	8b 45 14             	mov    0x14(%ebp),%eax
c01059da:	8d 50 04             	lea    0x4(%eax),%edx
c01059dd:	89 55 14             	mov    %edx,0x14(%ebp)
c01059e0:	8b 00                	mov    (%eax),%eax
c01059e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01059e5:	eb 23                	jmp    c0105a0a <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01059e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059eb:	79 0c                	jns    c01059f9 <vprintfmt+0xdc>
                width = 0;
c01059ed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01059f4:	e9 78 ff ff ff       	jmp    c0105971 <vprintfmt+0x54>
c01059f9:	e9 73 ff ff ff       	jmp    c0105971 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01059fe:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105a05:	e9 67 ff ff ff       	jmp    c0105971 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105a0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a0e:	79 12                	jns    c0105a22 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a13:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105a16:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105a1d:	e9 4f ff ff ff       	jmp    c0105971 <vprintfmt+0x54>
c0105a22:	e9 4a ff ff ff       	jmp    c0105971 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105a27:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105a2b:	e9 41 ff ff ff       	jmp    c0105971 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105a30:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a33:	8d 50 04             	lea    0x4(%eax),%edx
c0105a36:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a39:	8b 00                	mov    (%eax),%eax
c0105a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a3e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a42:	89 04 24             	mov    %eax,(%esp)
c0105a45:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a48:	ff d0                	call   *%eax
            break;
c0105a4a:	e9 ac 02 00 00       	jmp    c0105cfb <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105a4f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a52:	8d 50 04             	lea    0x4(%eax),%edx
c0105a55:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a58:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105a5a:	85 db                	test   %ebx,%ebx
c0105a5c:	79 02                	jns    c0105a60 <vprintfmt+0x143>
                err = -err;
c0105a5e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105a60:	83 fb 06             	cmp    $0x6,%ebx
c0105a63:	7f 0b                	jg     c0105a70 <vprintfmt+0x153>
c0105a65:	8b 34 9d 30 74 10 c0 	mov    -0x3fef8bd0(,%ebx,4),%esi
c0105a6c:	85 f6                	test   %esi,%esi
c0105a6e:	75 23                	jne    c0105a93 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105a70:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105a74:	c7 44 24 08 5d 74 10 	movl   $0xc010745d,0x8(%esp)
c0105a7b:	c0 
c0105a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a83:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a86:	89 04 24             	mov    %eax,(%esp)
c0105a89:	e8 61 fe ff ff       	call   c01058ef <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105a8e:	e9 68 02 00 00       	jmp    c0105cfb <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105a93:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105a97:	c7 44 24 08 66 74 10 	movl   $0xc0107466,0x8(%esp)
c0105a9e:	c0 
c0105a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa9:	89 04 24             	mov    %eax,(%esp)
c0105aac:	e8 3e fe ff ff       	call   c01058ef <printfmt>
            }
            break;
c0105ab1:	e9 45 02 00 00       	jmp    c0105cfb <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105ab6:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ab9:	8d 50 04             	lea    0x4(%eax),%edx
c0105abc:	89 55 14             	mov    %edx,0x14(%ebp)
c0105abf:	8b 30                	mov    (%eax),%esi
c0105ac1:	85 f6                	test   %esi,%esi
c0105ac3:	75 05                	jne    c0105aca <vprintfmt+0x1ad>
                p = "(null)";
c0105ac5:	be 69 74 10 c0       	mov    $0xc0107469,%esi
            }
            if (width > 0 && padc != '-') {
c0105aca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105ace:	7e 3e                	jle    c0105b0e <vprintfmt+0x1f1>
c0105ad0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105ad4:	74 38                	je     c0105b0e <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105ad6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105ad9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105adc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ae0:	89 34 24             	mov    %esi,(%esp)
c0105ae3:	e8 15 03 00 00       	call   c0105dfd <strnlen>
c0105ae8:	29 c3                	sub    %eax,%ebx
c0105aea:	89 d8                	mov    %ebx,%eax
c0105aec:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105aef:	eb 17                	jmp    c0105b08 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105af1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105af5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105af8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105afc:	89 04 24             	mov    %eax,(%esp)
c0105aff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b02:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105b04:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105b08:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b0c:	7f e3                	jg     c0105af1 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105b0e:	eb 38                	jmp    c0105b48 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105b10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105b14:	74 1f                	je     c0105b35 <vprintfmt+0x218>
c0105b16:	83 fb 1f             	cmp    $0x1f,%ebx
c0105b19:	7e 05                	jle    c0105b20 <vprintfmt+0x203>
c0105b1b:	83 fb 7e             	cmp    $0x7e,%ebx
c0105b1e:	7e 15                	jle    c0105b35 <vprintfmt+0x218>
                    putch('?', putdat);
c0105b20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b27:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b31:	ff d0                	call   *%eax
c0105b33:	eb 0f                	jmp    c0105b44 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105b35:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b3c:	89 1c 24             	mov    %ebx,(%esp)
c0105b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b42:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105b44:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105b48:	89 f0                	mov    %esi,%eax
c0105b4a:	8d 70 01             	lea    0x1(%eax),%esi
c0105b4d:	0f b6 00             	movzbl (%eax),%eax
c0105b50:	0f be d8             	movsbl %al,%ebx
c0105b53:	85 db                	test   %ebx,%ebx
c0105b55:	74 10                	je     c0105b67 <vprintfmt+0x24a>
c0105b57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105b5b:	78 b3                	js     c0105b10 <vprintfmt+0x1f3>
c0105b5d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105b61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105b65:	79 a9                	jns    c0105b10 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105b67:	eb 17                	jmp    c0105b80 <vprintfmt+0x263>
                putch(' ', putdat);
c0105b69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b70:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7a:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105b7c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105b80:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b84:	7f e3                	jg     c0105b69 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105b86:	e9 70 01 00 00       	jmp    c0105cfb <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b92:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b95:	89 04 24             	mov    %eax,(%esp)
c0105b98:	e8 0b fd ff ff       	call   c01058a8 <getint>
c0105b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ba0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ba9:	85 d2                	test   %edx,%edx
c0105bab:	79 26                	jns    c0105bd3 <vprintfmt+0x2b6>
                putch('-', putdat);
c0105bad:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bb4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbe:	ff d0                	call   *%eax
                num = -(long long)num;
c0105bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105bc6:	f7 d8                	neg    %eax
c0105bc8:	83 d2 00             	adc    $0x0,%edx
c0105bcb:	f7 da                	neg    %edx
c0105bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105bd3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105bda:	e9 a8 00 00 00       	jmp    c0105c87 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105bdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105be2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105be6:	8d 45 14             	lea    0x14(%ebp),%eax
c0105be9:	89 04 24             	mov    %eax,(%esp)
c0105bec:	e8 68 fc ff ff       	call   c0105859 <getuint>
c0105bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105bf7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105bfe:	e9 84 00 00 00       	jmp    c0105c87 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105c03:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c0a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c0d:	89 04 24             	mov    %eax,(%esp)
c0105c10:	e8 44 fc ff ff       	call   c0105859 <getuint>
c0105c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105c1b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105c22:	eb 63                	jmp    c0105c87 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105c24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c2b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c35:	ff d0                	call   *%eax
            putch('x', putdat);
c0105c37:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c3e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105c45:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c48:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105c4a:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c4d:	8d 50 04             	lea    0x4(%eax),%edx
c0105c50:	89 55 14             	mov    %edx,0x14(%ebp)
c0105c53:	8b 00                	mov    (%eax),%eax
c0105c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105c5f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105c66:	eb 1f                	jmp    c0105c87 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c6f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c72:	89 04 24             	mov    %eax,(%esp)
c0105c75:	e8 df fb ff ff       	call   c0105859 <getuint>
c0105c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105c80:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105c87:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c8e:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105c92:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105c95:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105c99:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ca3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ca7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105cab:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb5:	89 04 24             	mov    %eax,(%esp)
c0105cb8:	e8 97 fa ff ff       	call   c0105754 <printnum>
            break;
c0105cbd:	eb 3c                	jmp    c0105cfb <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cc6:	89 1c 24             	mov    %ebx,(%esp)
c0105cc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ccc:	ff d0                	call   *%eax
            break;
c0105cce:	eb 2b                	jmp    c0105cfb <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cd7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105cde:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce1:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105ce3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105ce7:	eb 04                	jmp    c0105ced <vprintfmt+0x3d0>
c0105ce9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105ced:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cf0:	83 e8 01             	sub    $0x1,%eax
c0105cf3:	0f b6 00             	movzbl (%eax),%eax
c0105cf6:	3c 25                	cmp    $0x25,%al
c0105cf8:	75 ef                	jne    c0105ce9 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105cfa:	90                   	nop
        }
    }
c0105cfb:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105cfc:	e9 3e fc ff ff       	jmp    c010593f <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105d01:	83 c4 40             	add    $0x40,%esp
c0105d04:	5b                   	pop    %ebx
c0105d05:	5e                   	pop    %esi
c0105d06:	5d                   	pop    %ebp
c0105d07:	c3                   	ret    

c0105d08 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105d08:	55                   	push   %ebp
c0105d09:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d0e:	8b 40 08             	mov    0x8(%eax),%eax
c0105d11:	8d 50 01             	lea    0x1(%eax),%edx
c0105d14:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d17:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d1d:	8b 10                	mov    (%eax),%edx
c0105d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d22:	8b 40 04             	mov    0x4(%eax),%eax
c0105d25:	39 c2                	cmp    %eax,%edx
c0105d27:	73 12                	jae    c0105d3b <sprintputch+0x33>
        *b->buf ++ = ch;
c0105d29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d2c:	8b 00                	mov    (%eax),%eax
c0105d2e:	8d 48 01             	lea    0x1(%eax),%ecx
c0105d31:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105d34:	89 0a                	mov    %ecx,(%edx)
c0105d36:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d39:	88 10                	mov    %dl,(%eax)
    }
}
c0105d3b:	5d                   	pop    %ebp
c0105d3c:	c3                   	ret    

c0105d3d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105d3d:	55                   	push   %ebp
c0105d3e:	89 e5                	mov    %esp,%ebp
c0105d40:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105d43:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d4c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d50:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d53:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d61:	89 04 24             	mov    %eax,(%esp)
c0105d64:	e8 08 00 00 00       	call   c0105d71 <vsnprintf>
c0105d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105d6f:	c9                   	leave  
c0105d70:	c3                   	ret    

c0105d71 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105d71:	55                   	push   %ebp
c0105d72:	89 e5                	mov    %esp,%ebp
c0105d74:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d80:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d83:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d86:	01 d0                	add    %edx,%eax
c0105d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105d92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105d96:	74 0a                	je     c0105da2 <vsnprintf+0x31>
c0105d98:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d9e:	39 c2                	cmp    %eax,%edx
c0105da0:	76 07                	jbe    c0105da9 <vsnprintf+0x38>
        return -E_INVAL;
c0105da2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105da7:	eb 2a                	jmp    c0105dd3 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105da9:	8b 45 14             	mov    0x14(%ebp),%eax
c0105dac:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105db0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105db3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105db7:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105dba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dbe:	c7 04 24 08 5d 10 c0 	movl   $0xc0105d08,(%esp)
c0105dc5:	e8 53 fb ff ff       	call   c010591d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105dcd:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105dd3:	c9                   	leave  
c0105dd4:	c3                   	ret    

c0105dd5 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105dd5:	55                   	push   %ebp
c0105dd6:	89 e5                	mov    %esp,%ebp
c0105dd8:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ddb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105de2:	eb 04                	jmp    c0105de8 <strlen+0x13>
        cnt ++;
c0105de4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105de8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105deb:	8d 50 01             	lea    0x1(%eax),%edx
c0105dee:	89 55 08             	mov    %edx,0x8(%ebp)
c0105df1:	0f b6 00             	movzbl (%eax),%eax
c0105df4:	84 c0                	test   %al,%al
c0105df6:	75 ec                	jne    c0105de4 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105dfb:	c9                   	leave  
c0105dfc:	c3                   	ret    

c0105dfd <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105dfd:	55                   	push   %ebp
c0105dfe:	89 e5                	mov    %esp,%ebp
c0105e00:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105e03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105e0a:	eb 04                	jmp    c0105e10 <strnlen+0x13>
        cnt ++;
c0105e0c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e13:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105e16:	73 10                	jae    c0105e28 <strnlen+0x2b>
c0105e18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e1b:	8d 50 01             	lea    0x1(%eax),%edx
c0105e1e:	89 55 08             	mov    %edx,0x8(%ebp)
c0105e21:	0f b6 00             	movzbl (%eax),%eax
c0105e24:	84 c0                	test   %al,%al
c0105e26:	75 e4                	jne    c0105e0c <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105e2b:	c9                   	leave  
c0105e2c:	c3                   	ret    

c0105e2d <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105e2d:	55                   	push   %ebp
c0105e2e:	89 e5                	mov    %esp,%ebp
c0105e30:	57                   	push   %edi
c0105e31:	56                   	push   %esi
c0105e32:	83 ec 20             	sub    $0x20,%esp
c0105e35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105e41:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e47:	89 d1                	mov    %edx,%ecx
c0105e49:	89 c2                	mov    %eax,%edx
c0105e4b:	89 ce                	mov    %ecx,%esi
c0105e4d:	89 d7                	mov    %edx,%edi
c0105e4f:	ac                   	lods   %ds:(%esi),%al
c0105e50:	aa                   	stos   %al,%es:(%edi)
c0105e51:	84 c0                	test   %al,%al
c0105e53:	75 fa                	jne    c0105e4f <strcpy+0x22>
c0105e55:	89 fa                	mov    %edi,%edx
c0105e57:	89 f1                	mov    %esi,%ecx
c0105e59:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e5c:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105e5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105e65:	83 c4 20             	add    $0x20,%esp
c0105e68:	5e                   	pop    %esi
c0105e69:	5f                   	pop    %edi
c0105e6a:	5d                   	pop    %ebp
c0105e6b:	c3                   	ret    

c0105e6c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105e6c:	55                   	push   %ebp
c0105e6d:	89 e5                	mov    %esp,%ebp
c0105e6f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105e72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e75:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105e78:	eb 21                	jmp    c0105e9b <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e7d:	0f b6 10             	movzbl (%eax),%edx
c0105e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e83:	88 10                	mov    %dl,(%eax)
c0105e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e88:	0f b6 00             	movzbl (%eax),%eax
c0105e8b:	84 c0                	test   %al,%al
c0105e8d:	74 04                	je     c0105e93 <strncpy+0x27>
            src ++;
c0105e8f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105e93:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105e97:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105e9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e9f:	75 d9                	jne    c0105e7a <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105ea1:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ea4:	c9                   	leave  
c0105ea5:	c3                   	ret    

c0105ea6 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105ea6:	55                   	push   %ebp
c0105ea7:	89 e5                	mov    %esp,%ebp
c0105ea9:	57                   	push   %edi
c0105eaa:	56                   	push   %esi
c0105eab:	83 ec 20             	sub    $0x20,%esp
c0105eae:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ec0:	89 d1                	mov    %edx,%ecx
c0105ec2:	89 c2                	mov    %eax,%edx
c0105ec4:	89 ce                	mov    %ecx,%esi
c0105ec6:	89 d7                	mov    %edx,%edi
c0105ec8:	ac                   	lods   %ds:(%esi),%al
c0105ec9:	ae                   	scas   %es:(%edi),%al
c0105eca:	75 08                	jne    c0105ed4 <strcmp+0x2e>
c0105ecc:	84 c0                	test   %al,%al
c0105ece:	75 f8                	jne    c0105ec8 <strcmp+0x22>
c0105ed0:	31 c0                	xor    %eax,%eax
c0105ed2:	eb 04                	jmp    c0105ed8 <strcmp+0x32>
c0105ed4:	19 c0                	sbb    %eax,%eax
c0105ed6:	0c 01                	or     $0x1,%al
c0105ed8:	89 fa                	mov    %edi,%edx
c0105eda:	89 f1                	mov    %esi,%ecx
c0105edc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105edf:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105ee2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105ee8:	83 c4 20             	add    $0x20,%esp
c0105eeb:	5e                   	pop    %esi
c0105eec:	5f                   	pop    %edi
c0105eed:	5d                   	pop    %ebp
c0105eee:	c3                   	ret    

c0105eef <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105eef:	55                   	push   %ebp
c0105ef0:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105ef2:	eb 0c                	jmp    c0105f00 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105ef4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105ef8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105efc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105f00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f04:	74 1a                	je     c0105f20 <strncmp+0x31>
c0105f06:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f09:	0f b6 00             	movzbl (%eax),%eax
c0105f0c:	84 c0                	test   %al,%al
c0105f0e:	74 10                	je     c0105f20 <strncmp+0x31>
c0105f10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f13:	0f b6 10             	movzbl (%eax),%edx
c0105f16:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f19:	0f b6 00             	movzbl (%eax),%eax
c0105f1c:	38 c2                	cmp    %al,%dl
c0105f1e:	74 d4                	je     c0105ef4 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f24:	74 18                	je     c0105f3e <strncmp+0x4f>
c0105f26:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f29:	0f b6 00             	movzbl (%eax),%eax
c0105f2c:	0f b6 d0             	movzbl %al,%edx
c0105f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f32:	0f b6 00             	movzbl (%eax),%eax
c0105f35:	0f b6 c0             	movzbl %al,%eax
c0105f38:	29 c2                	sub    %eax,%edx
c0105f3a:	89 d0                	mov    %edx,%eax
c0105f3c:	eb 05                	jmp    c0105f43 <strncmp+0x54>
c0105f3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f43:	5d                   	pop    %ebp
c0105f44:	c3                   	ret    

c0105f45 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105f45:	55                   	push   %ebp
c0105f46:	89 e5                	mov    %esp,%ebp
c0105f48:	83 ec 04             	sub    $0x4,%esp
c0105f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f4e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105f51:	eb 14                	jmp    c0105f67 <strchr+0x22>
        if (*s == c) {
c0105f53:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f56:	0f b6 00             	movzbl (%eax),%eax
c0105f59:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105f5c:	75 05                	jne    c0105f63 <strchr+0x1e>
            return (char *)s;
c0105f5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f61:	eb 13                	jmp    c0105f76 <strchr+0x31>
        }
        s ++;
c0105f63:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105f67:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f6a:	0f b6 00             	movzbl (%eax),%eax
c0105f6d:	84 c0                	test   %al,%al
c0105f6f:	75 e2                	jne    c0105f53 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f76:	c9                   	leave  
c0105f77:	c3                   	ret    

c0105f78 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105f78:	55                   	push   %ebp
c0105f79:	89 e5                	mov    %esp,%ebp
c0105f7b:	83 ec 04             	sub    $0x4,%esp
c0105f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f81:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105f84:	eb 11                	jmp    c0105f97 <strfind+0x1f>
        if (*s == c) {
c0105f86:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f89:	0f b6 00             	movzbl (%eax),%eax
c0105f8c:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105f8f:	75 02                	jne    c0105f93 <strfind+0x1b>
            break;
c0105f91:	eb 0e                	jmp    c0105fa1 <strfind+0x29>
        }
        s ++;
c0105f93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105f97:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f9a:	0f b6 00             	movzbl (%eax),%eax
c0105f9d:	84 c0                	test   %al,%al
c0105f9f:	75 e5                	jne    c0105f86 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105fa1:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105fa4:	c9                   	leave  
c0105fa5:	c3                   	ret    

c0105fa6 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105fa6:	55                   	push   %ebp
c0105fa7:	89 e5                	mov    %esp,%ebp
c0105fa9:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105fac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105fb3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105fba:	eb 04                	jmp    c0105fc0 <strtol+0x1a>
        s ++;
c0105fbc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105fc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fc3:	0f b6 00             	movzbl (%eax),%eax
c0105fc6:	3c 20                	cmp    $0x20,%al
c0105fc8:	74 f2                	je     c0105fbc <strtol+0x16>
c0105fca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fcd:	0f b6 00             	movzbl (%eax),%eax
c0105fd0:	3c 09                	cmp    $0x9,%al
c0105fd2:	74 e8                	je     c0105fbc <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105fd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fd7:	0f b6 00             	movzbl (%eax),%eax
c0105fda:	3c 2b                	cmp    $0x2b,%al
c0105fdc:	75 06                	jne    c0105fe4 <strtol+0x3e>
        s ++;
c0105fde:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105fe2:	eb 15                	jmp    c0105ff9 <strtol+0x53>
    }
    else if (*s == '-') {
c0105fe4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fe7:	0f b6 00             	movzbl (%eax),%eax
c0105fea:	3c 2d                	cmp    $0x2d,%al
c0105fec:	75 0b                	jne    c0105ff9 <strtol+0x53>
        s ++, neg = 1;
c0105fee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ff2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105ff9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ffd:	74 06                	je     c0106005 <strtol+0x5f>
c0105fff:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0106003:	75 24                	jne    c0106029 <strtol+0x83>
c0106005:	8b 45 08             	mov    0x8(%ebp),%eax
c0106008:	0f b6 00             	movzbl (%eax),%eax
c010600b:	3c 30                	cmp    $0x30,%al
c010600d:	75 1a                	jne    c0106029 <strtol+0x83>
c010600f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106012:	83 c0 01             	add    $0x1,%eax
c0106015:	0f b6 00             	movzbl (%eax),%eax
c0106018:	3c 78                	cmp    $0x78,%al
c010601a:	75 0d                	jne    c0106029 <strtol+0x83>
        s += 2, base = 16;
c010601c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0106020:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0106027:	eb 2a                	jmp    c0106053 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0106029:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010602d:	75 17                	jne    c0106046 <strtol+0xa0>
c010602f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106032:	0f b6 00             	movzbl (%eax),%eax
c0106035:	3c 30                	cmp    $0x30,%al
c0106037:	75 0d                	jne    c0106046 <strtol+0xa0>
        s ++, base = 8;
c0106039:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010603d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0106044:	eb 0d                	jmp    c0106053 <strtol+0xad>
    }
    else if (base == 0) {
c0106046:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010604a:	75 07                	jne    c0106053 <strtol+0xad>
        base = 10;
c010604c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0106053:	8b 45 08             	mov    0x8(%ebp),%eax
c0106056:	0f b6 00             	movzbl (%eax),%eax
c0106059:	3c 2f                	cmp    $0x2f,%al
c010605b:	7e 1b                	jle    c0106078 <strtol+0xd2>
c010605d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106060:	0f b6 00             	movzbl (%eax),%eax
c0106063:	3c 39                	cmp    $0x39,%al
c0106065:	7f 11                	jg     c0106078 <strtol+0xd2>
            dig = *s - '0';
c0106067:	8b 45 08             	mov    0x8(%ebp),%eax
c010606a:	0f b6 00             	movzbl (%eax),%eax
c010606d:	0f be c0             	movsbl %al,%eax
c0106070:	83 e8 30             	sub    $0x30,%eax
c0106073:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106076:	eb 48                	jmp    c01060c0 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0106078:	8b 45 08             	mov    0x8(%ebp),%eax
c010607b:	0f b6 00             	movzbl (%eax),%eax
c010607e:	3c 60                	cmp    $0x60,%al
c0106080:	7e 1b                	jle    c010609d <strtol+0xf7>
c0106082:	8b 45 08             	mov    0x8(%ebp),%eax
c0106085:	0f b6 00             	movzbl (%eax),%eax
c0106088:	3c 7a                	cmp    $0x7a,%al
c010608a:	7f 11                	jg     c010609d <strtol+0xf7>
            dig = *s - 'a' + 10;
c010608c:	8b 45 08             	mov    0x8(%ebp),%eax
c010608f:	0f b6 00             	movzbl (%eax),%eax
c0106092:	0f be c0             	movsbl %al,%eax
c0106095:	83 e8 57             	sub    $0x57,%eax
c0106098:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010609b:	eb 23                	jmp    c01060c0 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010609d:	8b 45 08             	mov    0x8(%ebp),%eax
c01060a0:	0f b6 00             	movzbl (%eax),%eax
c01060a3:	3c 40                	cmp    $0x40,%al
c01060a5:	7e 3d                	jle    c01060e4 <strtol+0x13e>
c01060a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01060aa:	0f b6 00             	movzbl (%eax),%eax
c01060ad:	3c 5a                	cmp    $0x5a,%al
c01060af:	7f 33                	jg     c01060e4 <strtol+0x13e>
            dig = *s - 'A' + 10;
c01060b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01060b4:	0f b6 00             	movzbl (%eax),%eax
c01060b7:	0f be c0             	movsbl %al,%eax
c01060ba:	83 e8 37             	sub    $0x37,%eax
c01060bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01060c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060c3:	3b 45 10             	cmp    0x10(%ebp),%eax
c01060c6:	7c 02                	jl     c01060ca <strtol+0x124>
            break;
c01060c8:	eb 1a                	jmp    c01060e4 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c01060ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01060ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060d1:	0f af 45 10          	imul   0x10(%ebp),%eax
c01060d5:	89 c2                	mov    %eax,%edx
c01060d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060da:	01 d0                	add    %edx,%eax
c01060dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01060df:	e9 6f ff ff ff       	jmp    c0106053 <strtol+0xad>

    if (endptr) {
c01060e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01060e8:	74 08                	je     c01060f2 <strtol+0x14c>
        *endptr = (char *) s;
c01060ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01060f0:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01060f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01060f6:	74 07                	je     c01060ff <strtol+0x159>
c01060f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060fb:	f7 d8                	neg    %eax
c01060fd:	eb 03                	jmp    c0106102 <strtol+0x15c>
c01060ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0106102:	c9                   	leave  
c0106103:	c3                   	ret    

c0106104 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0106104:	55                   	push   %ebp
c0106105:	89 e5                	mov    %esp,%ebp
c0106107:	57                   	push   %edi
c0106108:	83 ec 24             	sub    $0x24,%esp
c010610b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010610e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0106111:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0106115:	8b 55 08             	mov    0x8(%ebp),%edx
c0106118:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010611b:	88 45 f7             	mov    %al,-0x9(%ebp)
c010611e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106121:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0106124:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0106127:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010612b:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010612e:	89 d7                	mov    %edx,%edi
c0106130:	f3 aa                	rep stos %al,%es:(%edi)
c0106132:	89 fa                	mov    %edi,%edx
c0106134:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0106137:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010613a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010613d:	83 c4 24             	add    $0x24,%esp
c0106140:	5f                   	pop    %edi
c0106141:	5d                   	pop    %ebp
c0106142:	c3                   	ret    

c0106143 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0106143:	55                   	push   %ebp
c0106144:	89 e5                	mov    %esp,%ebp
c0106146:	57                   	push   %edi
c0106147:	56                   	push   %esi
c0106148:	53                   	push   %ebx
c0106149:	83 ec 30             	sub    $0x30,%esp
c010614c:	8b 45 08             	mov    0x8(%ebp),%eax
c010614f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106152:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106155:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106158:	8b 45 10             	mov    0x10(%ebp),%eax
c010615b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010615e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106161:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106164:	73 42                	jae    c01061a8 <memmove+0x65>
c0106166:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010616c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010616f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106172:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106175:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106178:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010617b:	c1 e8 02             	shr    $0x2,%eax
c010617e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0106180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106183:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106186:	89 d7                	mov    %edx,%edi
c0106188:	89 c6                	mov    %eax,%esi
c010618a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010618c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010618f:	83 e1 03             	and    $0x3,%ecx
c0106192:	74 02                	je     c0106196 <memmove+0x53>
c0106194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106196:	89 f0                	mov    %esi,%eax
c0106198:	89 fa                	mov    %edi,%edx
c010619a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010619d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01061a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01061a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061a6:	eb 36                	jmp    c01061de <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01061a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01061ab:	8d 50 ff             	lea    -0x1(%eax),%edx
c01061ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061b1:	01 c2                	add    %eax,%edx
c01061b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01061b6:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01061b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061bc:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c01061bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01061c2:	89 c1                	mov    %eax,%ecx
c01061c4:	89 d8                	mov    %ebx,%eax
c01061c6:	89 d6                	mov    %edx,%esi
c01061c8:	89 c7                	mov    %eax,%edi
c01061ca:	fd                   	std    
c01061cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01061cd:	fc                   	cld    
c01061ce:	89 f8                	mov    %edi,%eax
c01061d0:	89 f2                	mov    %esi,%edx
c01061d2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01061d5:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01061d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01061db:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01061de:	83 c4 30             	add    $0x30,%esp
c01061e1:	5b                   	pop    %ebx
c01061e2:	5e                   	pop    %esi
c01061e3:	5f                   	pop    %edi
c01061e4:	5d                   	pop    %ebp
c01061e5:	c3                   	ret    

c01061e6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01061e6:	55                   	push   %ebp
c01061e7:	89 e5                	mov    %esp,%ebp
c01061e9:	57                   	push   %edi
c01061ea:	56                   	push   %esi
c01061eb:	83 ec 20             	sub    $0x20,%esp
c01061ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01061f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01061f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01061fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106200:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106203:	c1 e8 02             	shr    $0x2,%eax
c0106206:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0106208:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010620b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010620e:	89 d7                	mov    %edx,%edi
c0106210:	89 c6                	mov    %eax,%esi
c0106212:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106214:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0106217:	83 e1 03             	and    $0x3,%ecx
c010621a:	74 02                	je     c010621e <memcpy+0x38>
c010621c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010621e:	89 f0                	mov    %esi,%eax
c0106220:	89 fa                	mov    %edi,%edx
c0106222:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106225:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106228:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010622b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010622e:	83 c4 20             	add    $0x20,%esp
c0106231:	5e                   	pop    %esi
c0106232:	5f                   	pop    %edi
c0106233:	5d                   	pop    %ebp
c0106234:	c3                   	ret    

c0106235 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0106235:	55                   	push   %ebp
c0106236:	89 e5                	mov    %esp,%ebp
c0106238:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010623b:	8b 45 08             	mov    0x8(%ebp),%eax
c010623e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0106241:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106244:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0106247:	eb 30                	jmp    c0106279 <memcmp+0x44>
        if (*s1 != *s2) {
c0106249:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010624c:	0f b6 10             	movzbl (%eax),%edx
c010624f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106252:	0f b6 00             	movzbl (%eax),%eax
c0106255:	38 c2                	cmp    %al,%dl
c0106257:	74 18                	je     c0106271 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106259:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010625c:	0f b6 00             	movzbl (%eax),%eax
c010625f:	0f b6 d0             	movzbl %al,%edx
c0106262:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106265:	0f b6 00             	movzbl (%eax),%eax
c0106268:	0f b6 c0             	movzbl %al,%eax
c010626b:	29 c2                	sub    %eax,%edx
c010626d:	89 d0                	mov    %edx,%eax
c010626f:	eb 1a                	jmp    c010628b <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0106271:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0106275:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0106279:	8b 45 10             	mov    0x10(%ebp),%eax
c010627c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010627f:	89 55 10             	mov    %edx,0x10(%ebp)
c0106282:	85 c0                	test   %eax,%eax
c0106284:	75 c3                	jne    c0106249 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0106286:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010628b:	c9                   	leave  
c010628c:	c3                   	ret    
