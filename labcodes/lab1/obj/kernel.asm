
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 13 34 00 00       	call   10343f <memset>

    cons_init();                // init the console
  10002c:	e8 49 15 00 00       	call   10157a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 e0 35 10 00 	movl   $0x1035e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 fc 35 10 00 	movl   $0x1035fc,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 2b 2a 00 00       	call   102a85 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 5e 16 00 00       	call   1016bd <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 b0 17 00 00       	call   101814 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 04 0d 00 00       	call   100d6d <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 bd 15 00 00       	call   10162b <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 fc 0b 00 00       	call   100c8e <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 01 36 10 00 	movl   $0x103601,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 0f 36 10 00 	movl   $0x10360f,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 1d 36 10 00 	movl   $0x10361d,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 2b 36 10 00 	movl   $0x10362b,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 39 36 10 00 	movl   $0x103639,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 68 36 10 00 	movl   $0x103668,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 87 36 10 00 	movl   $0x103687,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 d6 12 00 00       	call   1015a6 <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 4b 29 00 00       	call   102c58 <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 5d 12 00 00       	call   1015a6 <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 2a 12 00 00       	call   1015cf <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 8c 36 10 00    	movl   $0x10368c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 8c 36 10 00 	movl   $0x10368c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 ec 3e 10 00 	movl   $0x103eec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 bc b6 10 00 	movl   $0x10b6bc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec bd b6 10 00 	movl   $0x10b6bd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 b4 d6 10 00 	movl   $0x10d6b4,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 f1 2b 00 00       	call   1032b3 <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 96 36 10 00 	movl   $0x103696,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 af 36 10 00 	movl   $0x1036af,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 c8 35 10 	movl   $0x1035c8,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 c7 36 10 00 	movl   $0x1036c7,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 df 36 10 00 	movl   $0x1036df,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 f7 36 10 00 	movl   $0x1036f7,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 10 37 10 00 	movl   $0x103710,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 3a 37 10 00 	movl   $0x10373a,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 56 37 10 00 	movl   $0x103756,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10099b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t valueEbp = read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t valueEip = read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i = 0 ;
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(i ; i < STACKFRAME_DEPTH; i++) {
  1009b0:	e9 92 00 00 00       	jmp    100a47 <print_stackframe+0xb7>
	    if(valueEbp != 0) {
  1009b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1009b9:	0f 84 84 00 00 00    	je     100a43 <print_stackframe+0xb3>
		cprintf("ebp:0x%08x eip:0x%08x args:", valueEbp, valueEip);
  1009bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cd:	c7 04 24 68 37 10 00 	movl   $0x103768,(%esp)
  1009d4:	e8 39 f9 ff ff       	call   100312 <cprintf>
		int j = 0;
  1009d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for(j ; j < 4; j++) {
  1009e0:	eb 2e                	jmp    100a10 <print_stackframe+0x80>
		    uint32_t args =  *((uint32_t*)valueEbp + 2 + j);
  1009e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ef:	01 d0                	add    %edx,%eax
  1009f1:	83 c0 08             	add    $0x8,%eax
  1009f4:	8b 00                	mov    (%eax),%eax
  1009f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		    cprintf("0x%08x ", args);
  1009f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a00:	c7 04 24 84 37 10 00 	movl   $0x103784,(%esp)
  100a07:	e8 06 f9 ff ff       	call   100312 <cprintf>
	int i = 0 ;
	for(i ; i < STACKFRAME_DEPTH; i++) {
	    if(valueEbp != 0) {
		cprintf("ebp:0x%08x eip:0x%08x args:", valueEbp, valueEip);
		int j = 0;
		for(j ; j < 4; j++) {
  100a0c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a10:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a14:	7e cc                	jle    1009e2 <print_stackframe+0x52>
		    uint32_t args =  *((uint32_t*)valueEbp + 2 + j);
		    cprintf("0x%08x ", args);
		}
		cprintf("\n");
  100a16:	c7 04 24 8c 37 10 00 	movl   $0x10378c,(%esp)
  100a1d:	e8 f0 f8 ff ff       	call   100312 <cprintf>
		print_debuginfo(valueEip - 1);
  100a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a25:	83 e8 01             	sub    $0x1,%eax
  100a28:	89 04 24             	mov    %eax,(%esp)
  100a2b:	e8 ac fe ff ff       	call   1008dc <print_debuginfo>
		valueEip = *((uint32_t*)valueEbp + 1);
  100a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a33:	83 c0 04             	add    $0x4,%eax
  100a36:	8b 00                	mov    (%eax),%eax
  100a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
		valueEbp = *((uint32_t*)valueEbp);
  100a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3e:	8b 00                	mov    (%eax),%eax
  100a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t valueEbp = read_ebp();
	uint32_t valueEip = read_eip();
	int i = 0 ;
	for(i ; i < STACKFRAME_DEPTH; i++) {
  100a43:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a47:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a4b:	0f 8e 64 ff ff ff    	jle    1009b5 <print_stackframe+0x25>
		print_debuginfo(valueEip - 1);
		valueEip = *((uint32_t*)valueEbp + 1);
		valueEbp = *((uint32_t*)valueEbp);
	    }
	}
}
  100a51:	c9                   	leave  
  100a52:	c3                   	ret    

00100a53 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a53:	55                   	push   %ebp
  100a54:	89 e5                	mov    %esp,%ebp
  100a56:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a60:	eb 0c                	jmp    100a6e <parse+0x1b>
            *buf ++ = '\0';
  100a62:	8b 45 08             	mov    0x8(%ebp),%eax
  100a65:	8d 50 01             	lea    0x1(%eax),%edx
  100a68:	89 55 08             	mov    %edx,0x8(%ebp)
  100a6b:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a71:	0f b6 00             	movzbl (%eax),%eax
  100a74:	84 c0                	test   %al,%al
  100a76:	74 1d                	je     100a95 <parse+0x42>
  100a78:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7b:	0f b6 00             	movzbl (%eax),%eax
  100a7e:	0f be c0             	movsbl %al,%eax
  100a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a85:	c7 04 24 10 38 10 00 	movl   $0x103810,(%esp)
  100a8c:	e8 ef 27 00 00       	call   103280 <strchr>
  100a91:	85 c0                	test   %eax,%eax
  100a93:	75 cd                	jne    100a62 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a95:	8b 45 08             	mov    0x8(%ebp),%eax
  100a98:	0f b6 00             	movzbl (%eax),%eax
  100a9b:	84 c0                	test   %al,%al
  100a9d:	75 02                	jne    100aa1 <parse+0x4e>
            break;
  100a9f:	eb 67                	jmp    100b08 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aa1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aa5:	75 14                	jne    100abb <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aa7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aae:	00 
  100aaf:	c7 04 24 15 38 10 00 	movl   $0x103815,(%esp)
  100ab6:	e8 57 f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100abe:	8d 50 01             	lea    0x1(%eax),%edx
  100ac1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ac4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ace:	01 c2                	add    %eax,%edx
  100ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad3:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad5:	eb 04                	jmp    100adb <parse+0x88>
            buf ++;
  100ad7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100adb:	8b 45 08             	mov    0x8(%ebp),%eax
  100ade:	0f b6 00             	movzbl (%eax),%eax
  100ae1:	84 c0                	test   %al,%al
  100ae3:	74 1d                	je     100b02 <parse+0xaf>
  100ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae8:	0f b6 00             	movzbl (%eax),%eax
  100aeb:	0f be c0             	movsbl %al,%eax
  100aee:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af2:	c7 04 24 10 38 10 00 	movl   $0x103810,(%esp)
  100af9:	e8 82 27 00 00       	call   103280 <strchr>
  100afe:	85 c0                	test   %eax,%eax
  100b00:	74 d5                	je     100ad7 <parse+0x84>
            buf ++;
        }
    }
  100b02:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b03:	e9 66 ff ff ff       	jmp    100a6e <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b0b:	c9                   	leave  
  100b0c:	c3                   	ret    

00100b0d <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b0d:	55                   	push   %ebp
  100b0e:	89 e5                	mov    %esp,%ebp
  100b10:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b13:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b16:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1d:	89 04 24             	mov    %eax,(%esp)
  100b20:	e8 2e ff ff ff       	call   100a53 <parse>
  100b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b2c:	75 0a                	jne    100b38 <runcmd+0x2b>
        return 0;
  100b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  100b33:	e9 85 00 00 00       	jmp    100bbd <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b3f:	eb 5c                	jmp    100b9d <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b41:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b47:	89 d0                	mov    %edx,%eax
  100b49:	01 c0                	add    %eax,%eax
  100b4b:	01 d0                	add    %edx,%eax
  100b4d:	c1 e0 02             	shl    $0x2,%eax
  100b50:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b55:	8b 00                	mov    (%eax),%eax
  100b57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b5b:	89 04 24             	mov    %eax,(%esp)
  100b5e:	e8 7e 26 00 00       	call   1031e1 <strcmp>
  100b63:	85 c0                	test   %eax,%eax
  100b65:	75 32                	jne    100b99 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6a:	89 d0                	mov    %edx,%eax
  100b6c:	01 c0                	add    %eax,%eax
  100b6e:	01 d0                	add    %edx,%eax
  100b70:	c1 e0 02             	shl    $0x2,%eax
  100b73:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b78:	8b 40 08             	mov    0x8(%eax),%eax
  100b7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b7e:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b84:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b88:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b8b:	83 c2 04             	add    $0x4,%edx
  100b8e:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b92:	89 0c 24             	mov    %ecx,(%esp)
  100b95:	ff d0                	call   *%eax
  100b97:	eb 24                	jmp    100bbd <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b99:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba0:	83 f8 02             	cmp    $0x2,%eax
  100ba3:	76 9c                	jbe    100b41 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ba5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bac:	c7 04 24 33 38 10 00 	movl   $0x103833,(%esp)
  100bb3:	e8 5a f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bbd:	c9                   	leave  
  100bbe:	c3                   	ret    

00100bbf <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bbf:	55                   	push   %ebp
  100bc0:	89 e5                	mov    %esp,%ebp
  100bc2:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bc5:	c7 04 24 4c 38 10 00 	movl   $0x10384c,(%esp)
  100bcc:	e8 41 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bd1:	c7 04 24 74 38 10 00 	movl   $0x103874,(%esp)
  100bd8:	e8 35 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bdd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100be1:	74 0b                	je     100bee <kmonitor+0x2f>
        print_trapframe(tf);
  100be3:	8b 45 08             	mov    0x8(%ebp),%eax
  100be6:	89 04 24             	mov    %eax,(%esp)
  100be9:	e8 1e 0f 00 00       	call   101b0c <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bee:	c7 04 24 99 38 10 00 	movl   $0x103899,(%esp)
  100bf5:	e8 0f f6 ff ff       	call   100209 <readline>
  100bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c01:	74 18                	je     100c1b <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c03:	8b 45 08             	mov    0x8(%ebp),%eax
  100c06:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c0d:	89 04 24             	mov    %eax,(%esp)
  100c10:	e8 f8 fe ff ff       	call   100b0d <runcmd>
  100c15:	85 c0                	test   %eax,%eax
  100c17:	79 02                	jns    100c1b <kmonitor+0x5c>
                break;
  100c19:	eb 02                	jmp    100c1d <kmonitor+0x5e>
            }
        }
    }
  100c1b:	eb d1                	jmp    100bee <kmonitor+0x2f>
}
  100c1d:	c9                   	leave  
  100c1e:	c3                   	ret    

00100c1f <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c1f:	55                   	push   %ebp
  100c20:	89 e5                	mov    %esp,%ebp
  100c22:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c2c:	eb 3f                	jmp    100c6d <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c31:	89 d0                	mov    %edx,%eax
  100c33:	01 c0                	add    %eax,%eax
  100c35:	01 d0                	add    %edx,%eax
  100c37:	c1 e0 02             	shl    $0x2,%eax
  100c3a:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c3f:	8b 48 04             	mov    0x4(%eax),%ecx
  100c42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c45:	89 d0                	mov    %edx,%eax
  100c47:	01 c0                	add    %eax,%eax
  100c49:	01 d0                	add    %edx,%eax
  100c4b:	c1 e0 02             	shl    $0x2,%eax
  100c4e:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c53:	8b 00                	mov    (%eax),%eax
  100c55:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c59:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c5d:	c7 04 24 9d 38 10 00 	movl   $0x10389d,(%esp)
  100c64:	e8 a9 f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c70:	83 f8 02             	cmp    $0x2,%eax
  100c73:	76 b9                	jbe    100c2e <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c7a:	c9                   	leave  
  100c7b:	c3                   	ret    

00100c7c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c7c:	55                   	push   %ebp
  100c7d:	89 e5                	mov    %esp,%ebp
  100c7f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c82:	e8 bf fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8c:	c9                   	leave  
  100c8d:	c3                   	ret    

00100c8e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c8e:	55                   	push   %ebp
  100c8f:	89 e5                	mov    %esp,%ebp
  100c91:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c94:	e8 f7 fc ff ff       	call   100990 <print_stackframe>
    return 0;
  100c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9e:	c9                   	leave  
  100c9f:	c3                   	ret    

00100ca0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ca0:	55                   	push   %ebp
  100ca1:	89 e5                	mov    %esp,%ebp
  100ca3:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ca6:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cab:	85 c0                	test   %eax,%eax
  100cad:	74 02                	je     100cb1 <__panic+0x11>
        goto panic_dead;
  100caf:	eb 59                	jmp    100d0a <__panic+0x6a>
    }
    is_panic = 1;
  100cb1:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cb8:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cbb:	8d 45 14             	lea    0x14(%ebp),%eax
  100cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  100ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ccf:	c7 04 24 a6 38 10 00 	movl   $0x1038a6,(%esp)
  100cd6:	e8 37 f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce2:	8b 45 10             	mov    0x10(%ebp),%eax
  100ce5:	89 04 24             	mov    %eax,(%esp)
  100ce8:	e8 f2 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100ced:	c7 04 24 c2 38 10 00 	movl   $0x1038c2,(%esp)
  100cf4:	e8 19 f6 ff ff       	call   100312 <cprintf>
    
    cprintf("stack trackback:\n");
  100cf9:	c7 04 24 c4 38 10 00 	movl   $0x1038c4,(%esp)
  100d00:	e8 0d f6 ff ff       	call   100312 <cprintf>
    print_stackframe();
  100d05:	e8 86 fc ff ff       	call   100990 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d0a:	e8 22 09 00 00       	call   101631 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d16:	e8 a4 fe ff ff       	call   100bbf <kmonitor>
    }
  100d1b:	eb f2                	jmp    100d0f <__panic+0x6f>

00100d1d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d1d:	55                   	push   %ebp
  100d1e:	89 e5                	mov    %esp,%ebp
  100d20:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d23:	8d 45 14             	lea    0x14(%ebp),%eax
  100d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d30:	8b 45 08             	mov    0x8(%ebp),%eax
  100d33:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d37:	c7 04 24 d6 38 10 00 	movl   $0x1038d6,(%esp)
  100d3e:	e8 cf f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d46:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d4d:	89 04 24             	mov    %eax,(%esp)
  100d50:	e8 8a f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d55:	c7 04 24 c2 38 10 00 	movl   $0x1038c2,(%esp)
  100d5c:	e8 b1 f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d61:	c9                   	leave  
  100d62:	c3                   	ret    

00100d63 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d63:	55                   	push   %ebp
  100d64:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d66:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d6b:	5d                   	pop    %ebp
  100d6c:	c3                   	ret    

00100d6d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d6d:	55                   	push   %ebp
  100d6e:	89 e5                	mov    %esp,%ebp
  100d70:	83 ec 28             	sub    $0x28,%esp
  100d73:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d79:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d7d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d81:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d85:	ee                   	out    %al,(%dx)
  100d86:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d8c:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d90:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d94:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d98:	ee                   	out    %al,(%dx)
  100d99:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d9f:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100da3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dab:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dac:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100db3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db6:	c7 04 24 f4 38 10 00 	movl   $0x1038f4,(%esp)
  100dbd:	e8 50 f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100dc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dc9:	e8 c1 08 00 00       	call   10168f <pic_enable>
}
  100dce:	c9                   	leave  
  100dcf:	c3                   	ret    

00100dd0 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dd0:	55                   	push   %ebp
  100dd1:	89 e5                	mov    %esp,%ebp
  100dd3:	83 ec 10             	sub    $0x10,%esp
  100dd6:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ddc:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100de0:	89 c2                	mov    %eax,%edx
  100de2:	ec                   	in     (%dx),%al
  100de3:	88 45 fd             	mov    %al,-0x3(%ebp)
  100de6:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dec:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100df0:	89 c2                	mov    %eax,%edx
  100df2:	ec                   	in     (%dx),%al
  100df3:	88 45 f9             	mov    %al,-0x7(%ebp)
  100df6:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dfc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e00:	89 c2                	mov    %eax,%edx
  100e02:	ec                   	in     (%dx),%al
  100e03:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e06:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e0c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e10:	89 c2                	mov    %eax,%edx
  100e12:	ec                   	in     (%dx),%al
  100e13:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e16:	c9                   	leave  
  100e17:	c3                   	ret    

00100e18 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e18:	55                   	push   %ebp
  100e19:	89 e5                	mov    %esp,%ebp
  100e1b:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e1e:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e28:	0f b7 00             	movzwl (%eax),%eax
  100e2b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e32:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3a:	0f b7 00             	movzwl (%eax),%eax
  100e3d:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e41:	74 12                	je     100e55 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e43:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e4a:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e51:	b4 03 
  100e53:	eb 13                	jmp    100e68 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e58:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e5c:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e5f:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e66:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e68:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e6f:	0f b7 c0             	movzwl %ax,%eax
  100e72:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e76:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e7a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e7e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e82:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e83:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8a:	83 c0 01             	add    $0x1,%eax
  100e8d:	0f b7 c0             	movzwl %ax,%eax
  100e90:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e94:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e98:	89 c2                	mov    %eax,%edx
  100e9a:	ec                   	in     (%dx),%al
  100e9b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e9e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ea2:	0f b6 c0             	movzbl %al,%eax
  100ea5:	c1 e0 08             	shl    $0x8,%eax
  100ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eab:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb2:	0f b7 c0             	movzwl %ax,%eax
  100eb5:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100eb9:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ebd:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ec1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ec5:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ec6:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ecd:	83 c0 01             	add    $0x1,%eax
  100ed0:	0f b7 c0             	movzwl %ax,%eax
  100ed3:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ed7:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100edb:	89 c2                	mov    %eax,%edx
  100edd:	ec                   	in     (%dx),%al
  100ede:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ee1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ee5:	0f b6 c0             	movzbl %al,%eax
  100ee8:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eee:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ef6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100efc:	c9                   	leave  
  100efd:	c3                   	ret    

00100efe <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100efe:	55                   	push   %ebp
  100eff:	89 e5                	mov    %esp,%ebp
  100f01:	83 ec 48             	sub    $0x48,%esp
  100f04:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f0a:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f0e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f12:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f16:	ee                   	out    %al,(%dx)
  100f17:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f1d:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f21:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f29:	ee                   	out    %al,(%dx)
  100f2a:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f30:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f34:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f38:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f3c:	ee                   	out    %al,(%dx)
  100f3d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f43:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f47:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f4b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f4f:	ee                   	out    %al,(%dx)
  100f50:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f56:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f5a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f5e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f62:	ee                   	out    %al,(%dx)
  100f63:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f69:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f6d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f71:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f75:	ee                   	out    %al,(%dx)
  100f76:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f7c:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f80:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f84:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f88:	ee                   	out    %al,(%dx)
  100f89:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f8f:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f93:	89 c2                	mov    %eax,%edx
  100f95:	ec                   	in     (%dx),%al
  100f96:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f99:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f9d:	3c ff                	cmp    $0xff,%al
  100f9f:	0f 95 c0             	setne  %al
  100fa2:	0f b6 c0             	movzbl %al,%eax
  100fa5:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100faa:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fb0:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fb4:	89 c2                	mov    %eax,%edx
  100fb6:	ec                   	in     (%dx),%al
  100fb7:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fba:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fc0:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fc4:	89 c2                	mov    %eax,%edx
  100fc6:	ec                   	in     (%dx),%al
  100fc7:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fca:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fcf:	85 c0                	test   %eax,%eax
  100fd1:	74 0c                	je     100fdf <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fd3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fda:	e8 b0 06 00 00       	call   10168f <pic_enable>
    }
}
  100fdf:	c9                   	leave  
  100fe0:	c3                   	ret    

00100fe1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fe1:	55                   	push   %ebp
  100fe2:	89 e5                	mov    %esp,%ebp
  100fe4:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fee:	eb 09                	jmp    100ff9 <lpt_putc_sub+0x18>
        delay();
  100ff0:	e8 db fd ff ff       	call   100dd0 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100ff9:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fff:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101003:	89 c2                	mov    %eax,%edx
  101005:	ec                   	in     (%dx),%al
  101006:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101009:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10100d:	84 c0                	test   %al,%al
  10100f:	78 09                	js     10101a <lpt_putc_sub+0x39>
  101011:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101018:	7e d6                	jle    100ff0 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10101a:	8b 45 08             	mov    0x8(%ebp),%eax
  10101d:	0f b6 c0             	movzbl %al,%eax
  101020:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101026:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101029:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10102d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101031:	ee                   	out    %al,(%dx)
  101032:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101038:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10103c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101040:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101044:	ee                   	out    %al,(%dx)
  101045:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10104b:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10104f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101053:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101057:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101058:	c9                   	leave  
  101059:	c3                   	ret    

0010105a <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10105a:	55                   	push   %ebp
  10105b:	89 e5                	mov    %esp,%ebp
  10105d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101060:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101064:	74 0d                	je     101073 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101066:	8b 45 08             	mov    0x8(%ebp),%eax
  101069:	89 04 24             	mov    %eax,(%esp)
  10106c:	e8 70 ff ff ff       	call   100fe1 <lpt_putc_sub>
  101071:	eb 24                	jmp    101097 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101073:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10107a:	e8 62 ff ff ff       	call   100fe1 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10107f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101086:	e8 56 ff ff ff       	call   100fe1 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10108b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101092:	e8 4a ff ff ff       	call   100fe1 <lpt_putc_sub>
    }
}
  101097:	c9                   	leave  
  101098:	c3                   	ret    

00101099 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101099:	55                   	push   %ebp
  10109a:	89 e5                	mov    %esp,%ebp
  10109c:	53                   	push   %ebx
  10109d:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a3:	b0 00                	mov    $0x0,%al
  1010a5:	85 c0                	test   %eax,%eax
  1010a7:	75 07                	jne    1010b0 <cga_putc+0x17>
        c |= 0x0700;
  1010a9:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b3:	0f b6 c0             	movzbl %al,%eax
  1010b6:	83 f8 0a             	cmp    $0xa,%eax
  1010b9:	74 4c                	je     101107 <cga_putc+0x6e>
  1010bb:	83 f8 0d             	cmp    $0xd,%eax
  1010be:	74 57                	je     101117 <cga_putc+0x7e>
  1010c0:	83 f8 08             	cmp    $0x8,%eax
  1010c3:	0f 85 88 00 00 00    	jne    101151 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010c9:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d0:	66 85 c0             	test   %ax,%ax
  1010d3:	74 30                	je     101105 <cga_putc+0x6c>
            crt_pos --;
  1010d5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010dc:	83 e8 01             	sub    $0x1,%eax
  1010df:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010e5:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010ea:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010f1:	0f b7 d2             	movzwl %dx,%edx
  1010f4:	01 d2                	add    %edx,%edx
  1010f6:	01 c2                	add    %eax,%edx
  1010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fb:	b0 00                	mov    $0x0,%al
  1010fd:	83 c8 20             	or     $0x20,%eax
  101100:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101103:	eb 72                	jmp    101177 <cga_putc+0xde>
  101105:	eb 70                	jmp    101177 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101107:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10110e:	83 c0 50             	add    $0x50,%eax
  101111:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101117:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  10111e:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101125:	0f b7 c1             	movzwl %cx,%eax
  101128:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10112e:	c1 e8 10             	shr    $0x10,%eax
  101131:	89 c2                	mov    %eax,%edx
  101133:	66 c1 ea 06          	shr    $0x6,%dx
  101137:	89 d0                	mov    %edx,%eax
  101139:	c1 e0 02             	shl    $0x2,%eax
  10113c:	01 d0                	add    %edx,%eax
  10113e:	c1 e0 04             	shl    $0x4,%eax
  101141:	29 c1                	sub    %eax,%ecx
  101143:	89 ca                	mov    %ecx,%edx
  101145:	89 d8                	mov    %ebx,%eax
  101147:	29 d0                	sub    %edx,%eax
  101149:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10114f:	eb 26                	jmp    101177 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101151:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101157:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10115e:	8d 50 01             	lea    0x1(%eax),%edx
  101161:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101168:	0f b7 c0             	movzwl %ax,%eax
  10116b:	01 c0                	add    %eax,%eax
  10116d:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101170:	8b 45 08             	mov    0x8(%ebp),%eax
  101173:	66 89 02             	mov    %ax,(%edx)
        break;
  101176:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101177:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10117e:	66 3d cf 07          	cmp    $0x7cf,%ax
  101182:	76 5b                	jbe    1011df <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101184:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101189:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10118f:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101194:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10119b:	00 
  10119c:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011a0:	89 04 24             	mov    %eax,(%esp)
  1011a3:	e8 d6 22 00 00       	call   10347e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a8:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011af:	eb 15                	jmp    1011c6 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011b1:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011b9:	01 d2                	add    %edx,%edx
  1011bb:	01 d0                	add    %edx,%eax
  1011bd:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011c6:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011cd:	7e e2                	jle    1011b1 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011cf:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d6:	83 e8 50             	sub    $0x50,%eax
  1011d9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011df:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011e6:	0f b7 c0             	movzwl %ax,%eax
  1011e9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011ed:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011f1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011f5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011f9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011fa:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101201:	66 c1 e8 08          	shr    $0x8,%ax
  101205:	0f b6 c0             	movzbl %al,%eax
  101208:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10120f:	83 c2 01             	add    $0x1,%edx
  101212:	0f b7 d2             	movzwl %dx,%edx
  101215:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101219:	88 45 ed             	mov    %al,-0x13(%ebp)
  10121c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101220:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101224:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101225:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  10122c:	0f b7 c0             	movzwl %ax,%eax
  10122f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101233:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101237:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10123b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10123f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101240:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101247:	0f b6 c0             	movzbl %al,%eax
  10124a:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101251:	83 c2 01             	add    $0x1,%edx
  101254:	0f b7 d2             	movzwl %dx,%edx
  101257:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  10125b:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10125e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101262:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101266:	ee                   	out    %al,(%dx)
}
  101267:	83 c4 34             	add    $0x34,%esp
  10126a:	5b                   	pop    %ebx
  10126b:	5d                   	pop    %ebp
  10126c:	c3                   	ret    

0010126d <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10126d:	55                   	push   %ebp
  10126e:	89 e5                	mov    %esp,%ebp
  101270:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10127a:	eb 09                	jmp    101285 <serial_putc_sub+0x18>
        delay();
  10127c:	e8 4f fb ff ff       	call   100dd0 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101281:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101285:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10128b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10128f:	89 c2                	mov    %eax,%edx
  101291:	ec                   	in     (%dx),%al
  101292:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101295:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101299:	0f b6 c0             	movzbl %al,%eax
  10129c:	83 e0 20             	and    $0x20,%eax
  10129f:	85 c0                	test   %eax,%eax
  1012a1:	75 09                	jne    1012ac <serial_putc_sub+0x3f>
  1012a3:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012aa:	7e d0                	jle    10127c <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1012af:	0f b6 c0             	movzbl %al,%eax
  1012b2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012b8:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012bb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012bf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012c3:	ee                   	out    %al,(%dx)
}
  1012c4:	c9                   	leave  
  1012c5:	c3                   	ret    

001012c6 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012c6:	55                   	push   %ebp
  1012c7:	89 e5                	mov    %esp,%ebp
  1012c9:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012cc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012d0:	74 0d                	je     1012df <serial_putc+0x19>
        serial_putc_sub(c);
  1012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d5:	89 04 24             	mov    %eax,(%esp)
  1012d8:	e8 90 ff ff ff       	call   10126d <serial_putc_sub>
  1012dd:	eb 24                	jmp    101303 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012df:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e6:	e8 82 ff ff ff       	call   10126d <serial_putc_sub>
        serial_putc_sub(' ');
  1012eb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012f2:	e8 76 ff ff ff       	call   10126d <serial_putc_sub>
        serial_putc_sub('\b');
  1012f7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012fe:	e8 6a ff ff ff       	call   10126d <serial_putc_sub>
    }
}
  101303:	c9                   	leave  
  101304:	c3                   	ret    

00101305 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101305:	55                   	push   %ebp
  101306:	89 e5                	mov    %esp,%ebp
  101308:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10130b:	eb 33                	jmp    101340 <cons_intr+0x3b>
        if (c != 0) {
  10130d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101311:	74 2d                	je     101340 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101313:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101318:	8d 50 01             	lea    0x1(%eax),%edx
  10131b:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101321:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101324:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10132a:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10132f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101334:	75 0a                	jne    101340 <cons_intr+0x3b>
                cons.wpos = 0;
  101336:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10133d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101340:	8b 45 08             	mov    0x8(%ebp),%eax
  101343:	ff d0                	call   *%eax
  101345:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101348:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10134c:	75 bf                	jne    10130d <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10134e:	c9                   	leave  
  10134f:	c3                   	ret    

00101350 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101350:	55                   	push   %ebp
  101351:	89 e5                	mov    %esp,%ebp
  101353:	83 ec 10             	sub    $0x10,%esp
  101356:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10135c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101360:	89 c2                	mov    %eax,%edx
  101362:	ec                   	in     (%dx),%al
  101363:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101366:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10136a:	0f b6 c0             	movzbl %al,%eax
  10136d:	83 e0 01             	and    $0x1,%eax
  101370:	85 c0                	test   %eax,%eax
  101372:	75 07                	jne    10137b <serial_proc_data+0x2b>
        return -1;
  101374:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101379:	eb 2a                	jmp    1013a5 <serial_proc_data+0x55>
  10137b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101381:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101385:	89 c2                	mov    %eax,%edx
  101387:	ec                   	in     (%dx),%al
  101388:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10138b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10138f:	0f b6 c0             	movzbl %al,%eax
  101392:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101395:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101399:	75 07                	jne    1013a2 <serial_proc_data+0x52>
        c = '\b';
  10139b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013a5:	c9                   	leave  
  1013a6:	c3                   	ret    

001013a7 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013a7:	55                   	push   %ebp
  1013a8:	89 e5                	mov    %esp,%ebp
  1013aa:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013ad:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013b2:	85 c0                	test   %eax,%eax
  1013b4:	74 0c                	je     1013c2 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013b6:	c7 04 24 50 13 10 00 	movl   $0x101350,(%esp)
  1013bd:	e8 43 ff ff ff       	call   101305 <cons_intr>
    }
}
  1013c2:	c9                   	leave  
  1013c3:	c3                   	ret    

001013c4 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013c4:	55                   	push   %ebp
  1013c5:	89 e5                	mov    %esp,%ebp
  1013c7:	83 ec 38             	sub    $0x38,%esp
  1013ca:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d4:	89 c2                	mov    %eax,%edx
  1013d6:	ec                   	in     (%dx),%al
  1013d7:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013de:	0f b6 c0             	movzbl %al,%eax
  1013e1:	83 e0 01             	and    $0x1,%eax
  1013e4:	85 c0                	test   %eax,%eax
  1013e6:	75 0a                	jne    1013f2 <kbd_proc_data+0x2e>
        return -1;
  1013e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013ed:	e9 59 01 00 00       	jmp    10154b <kbd_proc_data+0x187>
  1013f2:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013f8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013fc:	89 c2                	mov    %eax,%edx
  1013fe:	ec                   	in     (%dx),%al
  1013ff:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101402:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101406:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101409:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10140d:	75 17                	jne    101426 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10140f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101414:	83 c8 40             	or     $0x40,%eax
  101417:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10141c:	b8 00 00 00 00       	mov    $0x0,%eax
  101421:	e9 25 01 00 00       	jmp    10154b <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101426:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142a:	84 c0                	test   %al,%al
  10142c:	79 47                	jns    101475 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10142e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101433:	83 e0 40             	and    $0x40,%eax
  101436:	85 c0                	test   %eax,%eax
  101438:	75 09                	jne    101443 <kbd_proc_data+0x7f>
  10143a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143e:	83 e0 7f             	and    $0x7f,%eax
  101441:	eb 04                	jmp    101447 <kbd_proc_data+0x83>
  101443:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101447:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10144a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144e:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101455:	83 c8 40             	or     $0x40,%eax
  101458:	0f b6 c0             	movzbl %al,%eax
  10145b:	f7 d0                	not    %eax
  10145d:	89 c2                	mov    %eax,%edx
  10145f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101464:	21 d0                	and    %edx,%eax
  101466:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10146b:	b8 00 00 00 00       	mov    $0x0,%eax
  101470:	e9 d6 00 00 00       	jmp    10154b <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101475:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147a:	83 e0 40             	and    $0x40,%eax
  10147d:	85 c0                	test   %eax,%eax
  10147f:	74 11                	je     101492 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101481:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101485:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148a:	83 e0 bf             	and    $0xffffffbf,%eax
  10148d:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101492:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101496:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10149d:	0f b6 d0             	movzbl %al,%edx
  1014a0:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a5:	09 d0                	or     %edx,%eax
  1014a7:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014ac:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b0:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014b7:	0f b6 d0             	movzbl %al,%edx
  1014ba:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014bf:	31 d0                	xor    %edx,%eax
  1014c1:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014c6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014cb:	83 e0 03             	and    $0x3,%eax
  1014ce:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014d5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d9:	01 d0                	add    %edx,%eax
  1014db:	0f b6 00             	movzbl (%eax),%eax
  1014de:	0f b6 c0             	movzbl %al,%eax
  1014e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014e4:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e9:	83 e0 08             	and    $0x8,%eax
  1014ec:	85 c0                	test   %eax,%eax
  1014ee:	74 22                	je     101512 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014f0:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014f4:	7e 0c                	jle    101502 <kbd_proc_data+0x13e>
  1014f6:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014fa:	7f 06                	jg     101502 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014fc:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101500:	eb 10                	jmp    101512 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101502:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101506:	7e 0a                	jle    101512 <kbd_proc_data+0x14e>
  101508:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10150c:	7f 04                	jg     101512 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10150e:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101512:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101517:	f7 d0                	not    %eax
  101519:	83 e0 06             	and    $0x6,%eax
  10151c:	85 c0                	test   %eax,%eax
  10151e:	75 28                	jne    101548 <kbd_proc_data+0x184>
  101520:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101527:	75 1f                	jne    101548 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101529:	c7 04 24 0f 39 10 00 	movl   $0x10390f,(%esp)
  101530:	e8 dd ed ff ff       	call   100312 <cprintf>
  101535:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10153b:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10153f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101543:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101547:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101548:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10154b:	c9                   	leave  
  10154c:	c3                   	ret    

0010154d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10154d:	55                   	push   %ebp
  10154e:	89 e5                	mov    %esp,%ebp
  101550:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101553:	c7 04 24 c4 13 10 00 	movl   $0x1013c4,(%esp)
  10155a:	e8 a6 fd ff ff       	call   101305 <cons_intr>
}
  10155f:	c9                   	leave  
  101560:	c3                   	ret    

00101561 <kbd_init>:

static void
kbd_init(void) {
  101561:	55                   	push   %ebp
  101562:	89 e5                	mov    %esp,%ebp
  101564:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101567:	e8 e1 ff ff ff       	call   10154d <kbd_intr>
    pic_enable(IRQ_KBD);
  10156c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101573:	e8 17 01 00 00       	call   10168f <pic_enable>
}
  101578:	c9                   	leave  
  101579:	c3                   	ret    

0010157a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10157a:	55                   	push   %ebp
  10157b:	89 e5                	mov    %esp,%ebp
  10157d:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101580:	e8 93 f8 ff ff       	call   100e18 <cga_init>
    serial_init();
  101585:	e8 74 f9 ff ff       	call   100efe <serial_init>
    kbd_init();
  10158a:	e8 d2 ff ff ff       	call   101561 <kbd_init>
    if (!serial_exists) {
  10158f:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101594:	85 c0                	test   %eax,%eax
  101596:	75 0c                	jne    1015a4 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101598:	c7 04 24 1b 39 10 00 	movl   $0x10391b,(%esp)
  10159f:	e8 6e ed ff ff       	call   100312 <cprintf>
    }
}
  1015a4:	c9                   	leave  
  1015a5:	c3                   	ret    

001015a6 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015a6:	55                   	push   %ebp
  1015a7:	89 e5                	mov    %esp,%ebp
  1015a9:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1015af:	89 04 24             	mov    %eax,(%esp)
  1015b2:	e8 a3 fa ff ff       	call   10105a <lpt_putc>
    cga_putc(c);
  1015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ba:	89 04 24             	mov    %eax,(%esp)
  1015bd:	e8 d7 fa ff ff       	call   101099 <cga_putc>
    serial_putc(c);
  1015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c5:	89 04 24             	mov    %eax,(%esp)
  1015c8:	e8 f9 fc ff ff       	call   1012c6 <serial_putc>
}
  1015cd:	c9                   	leave  
  1015ce:	c3                   	ret    

001015cf <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015cf:	55                   	push   %ebp
  1015d0:	89 e5                	mov    %esp,%ebp
  1015d2:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015d5:	e8 cd fd ff ff       	call   1013a7 <serial_intr>
    kbd_intr();
  1015da:	e8 6e ff ff ff       	call   10154d <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015df:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015e5:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015ea:	39 c2                	cmp    %eax,%edx
  1015ec:	74 36                	je     101624 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015ee:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f3:	8d 50 01             	lea    0x1(%eax),%edx
  1015f6:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015fc:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101603:	0f b6 c0             	movzbl %al,%eax
  101606:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101609:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10160e:	3d 00 02 00 00       	cmp    $0x200,%eax
  101613:	75 0a                	jne    10161f <cons_getc+0x50>
            cons.rpos = 0;
  101615:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10161c:	00 00 00 
        }
        return c;
  10161f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101622:	eb 05                	jmp    101629 <cons_getc+0x5a>
    }
    return 0;
  101624:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101629:	c9                   	leave  
  10162a:	c3                   	ret    

0010162b <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10162b:	55                   	push   %ebp
  10162c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10162e:	fb                   	sti    
    sti();
}
  10162f:	5d                   	pop    %ebp
  101630:	c3                   	ret    

00101631 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101631:	55                   	push   %ebp
  101632:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101634:	fa                   	cli    
    cli();
}
  101635:	5d                   	pop    %ebp
  101636:	c3                   	ret    

00101637 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101637:	55                   	push   %ebp
  101638:	89 e5                	mov    %esp,%ebp
  10163a:	83 ec 14             	sub    $0x14,%esp
  10163d:	8b 45 08             	mov    0x8(%ebp),%eax
  101640:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101644:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101648:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10164e:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101653:	85 c0                	test   %eax,%eax
  101655:	74 36                	je     10168d <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101657:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10165b:	0f b6 c0             	movzbl %al,%eax
  10165e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101664:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101667:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10166b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10166f:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101670:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101674:	66 c1 e8 08          	shr    $0x8,%ax
  101678:	0f b6 c0             	movzbl %al,%eax
  10167b:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101681:	88 45 f9             	mov    %al,-0x7(%ebp)
  101684:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101688:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10168c:	ee                   	out    %al,(%dx)
    }
}
  10168d:	c9                   	leave  
  10168e:	c3                   	ret    

0010168f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10168f:	55                   	push   %ebp
  101690:	89 e5                	mov    %esp,%ebp
  101692:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101695:	8b 45 08             	mov    0x8(%ebp),%eax
  101698:	ba 01 00 00 00       	mov    $0x1,%edx
  10169d:	89 c1                	mov    %eax,%ecx
  10169f:	d3 e2                	shl    %cl,%edx
  1016a1:	89 d0                	mov    %edx,%eax
  1016a3:	f7 d0                	not    %eax
  1016a5:	89 c2                	mov    %eax,%edx
  1016a7:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016ae:	21 d0                	and    %edx,%eax
  1016b0:	0f b7 c0             	movzwl %ax,%eax
  1016b3:	89 04 24             	mov    %eax,(%esp)
  1016b6:	e8 7c ff ff ff       	call   101637 <pic_setmask>
}
  1016bb:	c9                   	leave  
  1016bc:	c3                   	ret    

001016bd <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016bd:	55                   	push   %ebp
  1016be:	89 e5                	mov    %esp,%ebp
  1016c0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016c3:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016ca:	00 00 00 
  1016cd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016d3:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016d7:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016db:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016df:	ee                   	out    %al,(%dx)
  1016e0:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016e6:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016ea:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016ee:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f2:	ee                   	out    %al,(%dx)
  1016f3:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016f9:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016fd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101701:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101705:	ee                   	out    %al,(%dx)
  101706:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10170c:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101710:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101714:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101718:	ee                   	out    %al,(%dx)
  101719:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10171f:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101723:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101727:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10172b:	ee                   	out    %al,(%dx)
  10172c:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101732:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101736:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10173a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10173e:	ee                   	out    %al,(%dx)
  10173f:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101745:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101749:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10174d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101751:	ee                   	out    %al,(%dx)
  101752:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101758:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10175c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101760:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101764:	ee                   	out    %al,(%dx)
  101765:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10176b:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10176f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101773:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101777:	ee                   	out    %al,(%dx)
  101778:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10177e:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101782:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101786:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10178a:	ee                   	out    %al,(%dx)
  10178b:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101791:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101795:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101799:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10179d:	ee                   	out    %al,(%dx)
  10179e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017a4:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017a8:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017ac:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017b0:	ee                   	out    %al,(%dx)
  1017b1:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017b7:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017bb:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017bf:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017c3:	ee                   	out    %al,(%dx)
  1017c4:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017ca:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017ce:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017d2:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017d6:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017d7:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017de:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017e2:	74 12                	je     1017f6 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017e4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017eb:	0f b7 c0             	movzwl %ax,%eax
  1017ee:	89 04 24             	mov    %eax,(%esp)
  1017f1:	e8 41 fe ff ff       	call   101637 <pic_setmask>
    }
}
  1017f6:	c9                   	leave  
  1017f7:	c3                   	ret    

001017f8 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017f8:	55                   	push   %ebp
  1017f9:	89 e5                	mov    %esp,%ebp
  1017fb:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017fe:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101805:	00 
  101806:	c7 04 24 40 39 10 00 	movl   $0x103940,(%esp)
  10180d:	e8 00 eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101812:	c9                   	leave  
  101813:	c3                   	ret    

00101814 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101814:	55                   	push   %ebp
  101815:	89 e5                	mov    %esp,%ebp
  101817:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
  10181a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i; i < 256 ; i++) {
  101821:	e9 83 02 00 00       	jmp    101aa9 <idt_init+0x295>
	    if(i != T_SYSCALL && i != T_SWITCH_TOK && i >= IRQ_OFFSET) {
  101826:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  10182d:	0f 84 d8 00 00 00    	je     10190b <idt_init+0xf7>
  101833:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
  101837:	0f 84 ce 00 00 00    	je     10190b <idt_init+0xf7>
  10183d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  101841:	0f 8e c4 00 00 00    	jle    10190b <idt_init+0xf7>
	       SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101847:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184a:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101851:	89 c2                	mov    %eax,%edx
  101853:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101856:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10185d:	00 
  10185e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101861:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101868:	00 08 00 
  10186b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186e:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101875:	00 
  101876:	83 e2 e0             	and    $0xffffffe0,%edx
  101879:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101880:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101883:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10188a:	00 
  10188b:	83 e2 1f             	and    $0x1f,%edx
  10188e:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101895:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101898:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10189f:	00 
  1018a0:	83 e2 f0             	and    $0xfffffff0,%edx
  1018a3:	83 ca 0e             	or     $0xe,%edx
  1018a6:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b0:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018b7:	00 
  1018b8:	83 e2 ef             	and    $0xffffffef,%edx
  1018bb:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c5:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018cc:	00 
  1018cd:	83 e2 9f             	and    $0xffffff9f,%edx
  1018d0:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018da:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018e1:	00 
  1018e2:	83 ca 80             	or     $0xffffff80,%edx
  1018e5:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ef:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018f6:	c1 e8 10             	shr    $0x10,%eax
  1018f9:	89 c2                	mov    %eax,%edx
  1018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fe:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101905:	00 
  101906:	e9 9a 01 00 00       	jmp    101aa5 <idt_init+0x291>
	    } else {
	    	if(i == T_SYSCALL || i == T_SWITCH_TOK) {
  10190b:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  101912:	74 0a                	je     10191e <idt_init+0x10a>
  101914:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
  101918:	0f 85 c1 00 00 00    	jne    1019df <idt_init+0x1cb>
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);		
  10191e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101921:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101928:	89 c2                	mov    %eax,%edx
  10192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192d:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101934:	00 
  101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101938:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10193f:	00 08 00 
  101942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101945:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10194c:	00 
  10194d:	83 e2 e0             	and    $0xffffffe0,%edx
  101950:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101957:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195a:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101961:	00 
  101962:	83 e2 1f             	and    $0x1f,%edx
  101965:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196f:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101976:	00 
  101977:	83 ca 0f             	or     $0xf,%edx
  10197a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101981:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101984:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10198b:	00 
  10198c:	83 e2 ef             	and    $0xffffffef,%edx
  10198f:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101999:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1019a0:	00 
  1019a1:	83 ca 60             	or     $0x60,%edx
  1019a4:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1019ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ae:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1019b5:	00 
  1019b6:	83 ca 80             	or     $0xffffff80,%edx
  1019b9:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1019c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c3:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1019ca:	c1 e8 10             	shr    $0x10,%eax
  1019cd:	89 c2                	mov    %eax,%edx
  1019cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d2:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1019d9:	00 
  1019da:	e9 c6 00 00 00       	jmp    101aa5 <idt_init+0x291>
		} else if(i < IRQ_OFFSET) {
  1019df:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  1019e3:	0f 8f bc 00 00 00    	jg     101aa5 <idt_init+0x291>
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);		
  1019e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ec:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1019f3:	89 c2                	mov    %eax,%edx
  1019f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f8:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  1019ff:	00 
  101a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a03:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101a0a:	00 08 00 
  101a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a10:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101a17:	00 
  101a18:	83 e2 e0             	and    $0xffffffe0,%edx
  101a1b:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a25:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101a2c:	00 
  101a2d:	83 e2 1f             	and    $0x1f,%edx
  101a30:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a3a:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101a41:	00 
  101a42:	83 ca 0f             	or     $0xf,%edx
  101a45:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101a4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a4f:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101a56:	00 
  101a57:	83 e2 ef             	and    $0xffffffef,%edx
  101a5a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101a61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a64:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101a6b:	00 
  101a6c:	83 e2 9f             	and    $0xffffff9f,%edx
  101a6f:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a79:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101a80:	00 
  101a81:	83 ca 80             	or     $0xffffff80,%edx
  101a84:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101a8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a8e:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101a95:	c1 e8 10             	shr    $0x10,%eax
  101a98:	89 c2                	mov    %eax,%edx
  101a9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a9d:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101aa4:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
	for(i; i < 256 ; i++) {
  101aa5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101aa9:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101ab0:	0f 8e 70 fd ff ff    	jle    101826 <idt_init+0x12>
  101ab6:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101abd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ac0:	0f 01 18             	lidtl  (%eax)
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);		
		}
	    }
	}
	lidt(&idt_pd);
}
  101ac3:	c9                   	leave  
  101ac4:	c3                   	ret    

00101ac5 <trapname>:

static const char *
trapname(int trapno) {
  101ac5:	55                   	push   %ebp
  101ac6:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  101acb:	83 f8 13             	cmp    $0x13,%eax
  101ace:	77 0c                	ja     101adc <trapname+0x17>
        return excnames[trapno];
  101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad3:	8b 04 85 a0 3c 10 00 	mov    0x103ca0(,%eax,4),%eax
  101ada:	eb 18                	jmp    101af4 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101adc:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ae0:	7e 0d                	jle    101aef <trapname+0x2a>
  101ae2:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ae6:	7f 07                	jg     101aef <trapname+0x2a>
        return "Hardware Interrupt";
  101ae8:	b8 4a 39 10 00       	mov    $0x10394a,%eax
  101aed:	eb 05                	jmp    101af4 <trapname+0x2f>
    }
    return "(unknown trap)";
  101aef:	b8 5d 39 10 00       	mov    $0x10395d,%eax
}
  101af4:	5d                   	pop    %ebp
  101af5:	c3                   	ret    

00101af6 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101af6:	55                   	push   %ebp
  101af7:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101af9:	8b 45 08             	mov    0x8(%ebp),%eax
  101afc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b00:	66 83 f8 08          	cmp    $0x8,%ax
  101b04:	0f 94 c0             	sete   %al
  101b07:	0f b6 c0             	movzbl %al,%eax
}
  101b0a:	5d                   	pop    %ebp
  101b0b:	c3                   	ret    

00101b0c <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b0c:	55                   	push   %ebp
  101b0d:	89 e5                	mov    %esp,%ebp
  101b0f:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b12:	8b 45 08             	mov    0x8(%ebp),%eax
  101b15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b19:	c7 04 24 9e 39 10 00 	movl   $0x10399e,(%esp)
  101b20:	e8 ed e7 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  101b25:	8b 45 08             	mov    0x8(%ebp),%eax
  101b28:	89 04 24             	mov    %eax,(%esp)
  101b2b:	e8 a1 01 00 00       	call   101cd1 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b30:	8b 45 08             	mov    0x8(%ebp),%eax
  101b33:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b37:	0f b7 c0             	movzwl %ax,%eax
  101b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3e:	c7 04 24 af 39 10 00 	movl   $0x1039af,(%esp)
  101b45:	e8 c8 e7 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b51:	0f b7 c0             	movzwl %ax,%eax
  101b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b58:	c7 04 24 c2 39 10 00 	movl   $0x1039c2,(%esp)
  101b5f:	e8 ae e7 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b64:	8b 45 08             	mov    0x8(%ebp),%eax
  101b67:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b6b:	0f b7 c0             	movzwl %ax,%eax
  101b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b72:	c7 04 24 d5 39 10 00 	movl   $0x1039d5,(%esp)
  101b79:	e8 94 e7 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b81:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b85:	0f b7 c0             	movzwl %ax,%eax
  101b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8c:	c7 04 24 e8 39 10 00 	movl   $0x1039e8,(%esp)
  101b93:	e8 7a e7 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b98:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9b:	8b 40 30             	mov    0x30(%eax),%eax
  101b9e:	89 04 24             	mov    %eax,(%esp)
  101ba1:	e8 1f ff ff ff       	call   101ac5 <trapname>
  101ba6:	8b 55 08             	mov    0x8(%ebp),%edx
  101ba9:	8b 52 30             	mov    0x30(%edx),%edx
  101bac:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bb0:	89 54 24 04          	mov    %edx,0x4(%esp)
  101bb4:	c7 04 24 fb 39 10 00 	movl   $0x1039fb,(%esp)
  101bbb:	e8 52 e7 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc3:	8b 40 34             	mov    0x34(%eax),%eax
  101bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bca:	c7 04 24 0d 3a 10 00 	movl   $0x103a0d,(%esp)
  101bd1:	e8 3c e7 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd9:	8b 40 38             	mov    0x38(%eax),%eax
  101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be0:	c7 04 24 1c 3a 10 00 	movl   $0x103a1c,(%esp)
  101be7:	e8 26 e7 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bec:	8b 45 08             	mov    0x8(%ebp),%eax
  101bef:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bf3:	0f b7 c0             	movzwl %ax,%eax
  101bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfa:	c7 04 24 2b 3a 10 00 	movl   $0x103a2b,(%esp)
  101c01:	e8 0c e7 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	8b 40 40             	mov    0x40(%eax),%eax
  101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c10:	c7 04 24 3e 3a 10 00 	movl   $0x103a3e,(%esp)
  101c17:	e8 f6 e6 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c23:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c2a:	eb 3e                	jmp    101c6a <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2f:	8b 50 40             	mov    0x40(%eax),%edx
  101c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c35:	21 d0                	and    %edx,%eax
  101c37:	85 c0                	test   %eax,%eax
  101c39:	74 28                	je     101c63 <print_trapframe+0x157>
  101c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c3e:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101c45:	85 c0                	test   %eax,%eax
  101c47:	74 1a                	je     101c63 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c4c:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101c53:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c57:	c7 04 24 4d 3a 10 00 	movl   $0x103a4d,(%esp)
  101c5e:	e8 af e6 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c63:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c67:	d1 65 f0             	shll   -0x10(%ebp)
  101c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c6d:	83 f8 17             	cmp    $0x17,%eax
  101c70:	76 ba                	jbe    101c2c <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c72:	8b 45 08             	mov    0x8(%ebp),%eax
  101c75:	8b 40 40             	mov    0x40(%eax),%eax
  101c78:	25 00 30 00 00       	and    $0x3000,%eax
  101c7d:	c1 e8 0c             	shr    $0xc,%eax
  101c80:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c84:	c7 04 24 51 3a 10 00 	movl   $0x103a51,(%esp)
  101c8b:	e8 82 e6 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c90:	8b 45 08             	mov    0x8(%ebp),%eax
  101c93:	89 04 24             	mov    %eax,(%esp)
  101c96:	e8 5b fe ff ff       	call   101af6 <trap_in_kernel>
  101c9b:	85 c0                	test   %eax,%eax
  101c9d:	75 30                	jne    101ccf <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca2:	8b 40 44             	mov    0x44(%eax),%eax
  101ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca9:	c7 04 24 5a 3a 10 00 	movl   $0x103a5a,(%esp)
  101cb0:	e8 5d e6 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb8:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cbc:	0f b7 c0             	movzwl %ax,%eax
  101cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc3:	c7 04 24 69 3a 10 00 	movl   $0x103a69,(%esp)
  101cca:	e8 43 e6 ff ff       	call   100312 <cprintf>
    }
}
  101ccf:	c9                   	leave  
  101cd0:	c3                   	ret    

00101cd1 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cd1:	55                   	push   %ebp
  101cd2:	89 e5                	mov    %esp,%ebp
  101cd4:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101cda:	8b 00                	mov    (%eax),%eax
  101cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce0:	c7 04 24 7c 3a 10 00 	movl   $0x103a7c,(%esp)
  101ce7:	e8 26 e6 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cec:	8b 45 08             	mov    0x8(%ebp),%eax
  101cef:	8b 40 04             	mov    0x4(%eax),%eax
  101cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf6:	c7 04 24 8b 3a 10 00 	movl   $0x103a8b,(%esp)
  101cfd:	e8 10 e6 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d02:	8b 45 08             	mov    0x8(%ebp),%eax
  101d05:	8b 40 08             	mov    0x8(%eax),%eax
  101d08:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0c:	c7 04 24 9a 3a 10 00 	movl   $0x103a9a,(%esp)
  101d13:	e8 fa e5 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d18:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1b:	8b 40 0c             	mov    0xc(%eax),%eax
  101d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d22:	c7 04 24 a9 3a 10 00 	movl   $0x103aa9,(%esp)
  101d29:	e8 e4 e5 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d31:	8b 40 10             	mov    0x10(%eax),%eax
  101d34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d38:	c7 04 24 b8 3a 10 00 	movl   $0x103ab8,(%esp)
  101d3f:	e8 ce e5 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d44:	8b 45 08             	mov    0x8(%ebp),%eax
  101d47:	8b 40 14             	mov    0x14(%eax),%eax
  101d4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d4e:	c7 04 24 c7 3a 10 00 	movl   $0x103ac7,(%esp)
  101d55:	e8 b8 e5 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5d:	8b 40 18             	mov    0x18(%eax),%eax
  101d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d64:	c7 04 24 d6 3a 10 00 	movl   $0x103ad6,(%esp)
  101d6b:	e8 a2 e5 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d70:	8b 45 08             	mov    0x8(%ebp),%eax
  101d73:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d76:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7a:	c7 04 24 e5 3a 10 00 	movl   $0x103ae5,(%esp)
  101d81:	e8 8c e5 ff ff       	call   100312 <cprintf>
}
  101d86:	c9                   	leave  
  101d87:	c3                   	ret    

00101d88 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d88:	55                   	push   %ebp
  101d89:	89 e5                	mov    %esp,%ebp
  101d8b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d91:	8b 40 30             	mov    0x30(%eax),%eax
  101d94:	83 f8 2f             	cmp    $0x2f,%eax
  101d97:	77 21                	ja     101dba <trap_dispatch+0x32>
  101d99:	83 f8 2e             	cmp    $0x2e,%eax
  101d9c:	0f 83 04 01 00 00    	jae    101ea6 <trap_dispatch+0x11e>
  101da2:	83 f8 21             	cmp    $0x21,%eax
  101da5:	0f 84 81 00 00 00    	je     101e2c <trap_dispatch+0xa4>
  101dab:	83 f8 24             	cmp    $0x24,%eax
  101dae:	74 56                	je     101e06 <trap_dispatch+0x7e>
  101db0:	83 f8 20             	cmp    $0x20,%eax
  101db3:	74 16                	je     101dcb <trap_dispatch+0x43>
  101db5:	e9 b4 00 00 00       	jmp    101e6e <trap_dispatch+0xe6>
  101dba:	83 e8 78             	sub    $0x78,%eax
  101dbd:	83 f8 01             	cmp    $0x1,%eax
  101dc0:	0f 87 a8 00 00 00    	ja     101e6e <trap_dispatch+0xe6>
  101dc6:	e9 87 00 00 00       	jmp    101e52 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks = ticks + 1;
  101dcb:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101dd0:	83 c0 01             	add    $0x1,%eax
  101dd3:	a3 08 f9 10 00       	mov    %eax,0x10f908
	if(ticks % 100 == 0) {
  101dd8:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101dde:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101de3:	89 c8                	mov    %ecx,%eax
  101de5:	f7 e2                	mul    %edx
  101de7:	89 d0                	mov    %edx,%eax
  101de9:	c1 e8 05             	shr    $0x5,%eax
  101dec:	6b c0 64             	imul   $0x64,%eax,%eax
  101def:	29 c1                	sub    %eax,%ecx
  101df1:	89 c8                	mov    %ecx,%eax
  101df3:	85 c0                	test   %eax,%eax
  101df5:	75 0a                	jne    101e01 <trap_dispatch+0x79>
	   print_ticks();	
  101df7:	e8 fc f9 ff ff       	call   1017f8 <print_ticks>
	}
        break;
  101dfc:	e9 a6 00 00 00       	jmp    101ea7 <trap_dispatch+0x11f>
  101e01:	e9 a1 00 00 00       	jmp    101ea7 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e06:	e8 c4 f7 ff ff       	call   1015cf <cons_getc>
  101e0b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e0e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e12:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e16:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e1e:	c7 04 24 f4 3a 10 00 	movl   $0x103af4,(%esp)
  101e25:	e8 e8 e4 ff ff       	call   100312 <cprintf>
        break;
  101e2a:	eb 7b                	jmp    101ea7 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e2c:	e8 9e f7 ff ff       	call   1015cf <cons_getc>
  101e31:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e34:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e38:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e3c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e44:	c7 04 24 06 3b 10 00 	movl   $0x103b06,(%esp)
  101e4b:	e8 c2 e4 ff ff       	call   100312 <cprintf>
        break;
  101e50:	eb 55                	jmp    101ea7 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e52:	c7 44 24 08 15 3b 10 	movl   $0x103b15,0x8(%esp)
  101e59:	00 
  101e5a:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  101e61:	00 
  101e62:	c7 04 24 25 3b 10 00 	movl   $0x103b25,(%esp)
  101e69:	e8 32 ee ff ff       	call   100ca0 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e71:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e75:	0f b7 c0             	movzwl %ax,%eax
  101e78:	83 e0 03             	and    $0x3,%eax
  101e7b:	85 c0                	test   %eax,%eax
  101e7d:	75 28                	jne    101ea7 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e82:	89 04 24             	mov    %eax,(%esp)
  101e85:	e8 82 fc ff ff       	call   101b0c <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e8a:	c7 44 24 08 36 3b 10 	movl   $0x103b36,0x8(%esp)
  101e91:	00 
  101e92:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  101e99:	00 
  101e9a:	c7 04 24 25 3b 10 00 	movl   $0x103b25,(%esp)
  101ea1:	e8 fa ed ff ff       	call   100ca0 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ea6:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ea7:	c9                   	leave  
  101ea8:	c3                   	ret    

00101ea9 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ea9:	55                   	push   %ebp
  101eaa:	89 e5                	mov    %esp,%ebp
  101eac:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb2:	89 04 24             	mov    %eax,(%esp)
  101eb5:	e8 ce fe ff ff       	call   101d88 <trap_dispatch>
}
  101eba:	c9                   	leave  
  101ebb:	c3                   	ret    

00101ebc <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101ebc:	1e                   	push   %ds
    pushl %es
  101ebd:	06                   	push   %es
    pushl %fs
  101ebe:	0f a0                	push   %fs
    pushl %gs
  101ec0:	0f a8                	push   %gs
    pushal
  101ec2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ec3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101ec8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101eca:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101ecc:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101ecd:	e8 d7 ff ff ff       	call   101ea9 <trap>

    # pop the pushed stack pointer
    popl %esp
  101ed2:	5c                   	pop    %esp

00101ed3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101ed3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ed4:	0f a9                	pop    %gs
    popl %fs
  101ed6:	0f a1                	pop    %fs
    popl %es
  101ed8:	07                   	pop    %es
    popl %ds
  101ed9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101eda:	83 c4 08             	add    $0x8,%esp
    iret
  101edd:	cf                   	iret   

00101ede <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $0
  101ee0:	6a 00                	push   $0x0
  jmp __alltraps
  101ee2:	e9 d5 ff ff ff       	jmp    101ebc <__alltraps>

00101ee7 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $1
  101ee9:	6a 01                	push   $0x1
  jmp __alltraps
  101eeb:	e9 cc ff ff ff       	jmp    101ebc <__alltraps>

00101ef0 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $2
  101ef2:	6a 02                	push   $0x2
  jmp __alltraps
  101ef4:	e9 c3 ff ff ff       	jmp    101ebc <__alltraps>

00101ef9 <vector3>:
.globl vector3
vector3:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $3
  101efb:	6a 03                	push   $0x3
  jmp __alltraps
  101efd:	e9 ba ff ff ff       	jmp    101ebc <__alltraps>

00101f02 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $4
  101f04:	6a 04                	push   $0x4
  jmp __alltraps
  101f06:	e9 b1 ff ff ff       	jmp    101ebc <__alltraps>

00101f0b <vector5>:
.globl vector5
vector5:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $5
  101f0d:	6a 05                	push   $0x5
  jmp __alltraps
  101f0f:	e9 a8 ff ff ff       	jmp    101ebc <__alltraps>

00101f14 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $6
  101f16:	6a 06                	push   $0x6
  jmp __alltraps
  101f18:	e9 9f ff ff ff       	jmp    101ebc <__alltraps>

00101f1d <vector7>:
.globl vector7
vector7:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $7
  101f1f:	6a 07                	push   $0x7
  jmp __alltraps
  101f21:	e9 96 ff ff ff       	jmp    101ebc <__alltraps>

00101f26 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f26:	6a 08                	push   $0x8
  jmp __alltraps
  101f28:	e9 8f ff ff ff       	jmp    101ebc <__alltraps>

00101f2d <vector9>:
.globl vector9
vector9:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $9
  101f2f:	6a 09                	push   $0x9
  jmp __alltraps
  101f31:	e9 86 ff ff ff       	jmp    101ebc <__alltraps>

00101f36 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f36:	6a 0a                	push   $0xa
  jmp __alltraps
  101f38:	e9 7f ff ff ff       	jmp    101ebc <__alltraps>

00101f3d <vector11>:
.globl vector11
vector11:
  pushl $11
  101f3d:	6a 0b                	push   $0xb
  jmp __alltraps
  101f3f:	e9 78 ff ff ff       	jmp    101ebc <__alltraps>

00101f44 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f44:	6a 0c                	push   $0xc
  jmp __alltraps
  101f46:	e9 71 ff ff ff       	jmp    101ebc <__alltraps>

00101f4b <vector13>:
.globl vector13
vector13:
  pushl $13
  101f4b:	6a 0d                	push   $0xd
  jmp __alltraps
  101f4d:	e9 6a ff ff ff       	jmp    101ebc <__alltraps>

00101f52 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f52:	6a 0e                	push   $0xe
  jmp __alltraps
  101f54:	e9 63 ff ff ff       	jmp    101ebc <__alltraps>

00101f59 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $15
  101f5b:	6a 0f                	push   $0xf
  jmp __alltraps
  101f5d:	e9 5a ff ff ff       	jmp    101ebc <__alltraps>

00101f62 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $16
  101f64:	6a 10                	push   $0x10
  jmp __alltraps
  101f66:	e9 51 ff ff ff       	jmp    101ebc <__alltraps>

00101f6b <vector17>:
.globl vector17
vector17:
  pushl $17
  101f6b:	6a 11                	push   $0x11
  jmp __alltraps
  101f6d:	e9 4a ff ff ff       	jmp    101ebc <__alltraps>

00101f72 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f72:	6a 00                	push   $0x0
  pushl $18
  101f74:	6a 12                	push   $0x12
  jmp __alltraps
  101f76:	e9 41 ff ff ff       	jmp    101ebc <__alltraps>

00101f7b <vector19>:
.globl vector19
vector19:
  pushl $0
  101f7b:	6a 00                	push   $0x0
  pushl $19
  101f7d:	6a 13                	push   $0x13
  jmp __alltraps
  101f7f:	e9 38 ff ff ff       	jmp    101ebc <__alltraps>

00101f84 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f84:	6a 00                	push   $0x0
  pushl $20
  101f86:	6a 14                	push   $0x14
  jmp __alltraps
  101f88:	e9 2f ff ff ff       	jmp    101ebc <__alltraps>

00101f8d <vector21>:
.globl vector21
vector21:
  pushl $0
  101f8d:	6a 00                	push   $0x0
  pushl $21
  101f8f:	6a 15                	push   $0x15
  jmp __alltraps
  101f91:	e9 26 ff ff ff       	jmp    101ebc <__alltraps>

00101f96 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f96:	6a 00                	push   $0x0
  pushl $22
  101f98:	6a 16                	push   $0x16
  jmp __alltraps
  101f9a:	e9 1d ff ff ff       	jmp    101ebc <__alltraps>

00101f9f <vector23>:
.globl vector23
vector23:
  pushl $0
  101f9f:	6a 00                	push   $0x0
  pushl $23
  101fa1:	6a 17                	push   $0x17
  jmp __alltraps
  101fa3:	e9 14 ff ff ff       	jmp    101ebc <__alltraps>

00101fa8 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fa8:	6a 00                	push   $0x0
  pushl $24
  101faa:	6a 18                	push   $0x18
  jmp __alltraps
  101fac:	e9 0b ff ff ff       	jmp    101ebc <__alltraps>

00101fb1 <vector25>:
.globl vector25
vector25:
  pushl $0
  101fb1:	6a 00                	push   $0x0
  pushl $25
  101fb3:	6a 19                	push   $0x19
  jmp __alltraps
  101fb5:	e9 02 ff ff ff       	jmp    101ebc <__alltraps>

00101fba <vector26>:
.globl vector26
vector26:
  pushl $0
  101fba:	6a 00                	push   $0x0
  pushl $26
  101fbc:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fbe:	e9 f9 fe ff ff       	jmp    101ebc <__alltraps>

00101fc3 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fc3:	6a 00                	push   $0x0
  pushl $27
  101fc5:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fc7:	e9 f0 fe ff ff       	jmp    101ebc <__alltraps>

00101fcc <vector28>:
.globl vector28
vector28:
  pushl $0
  101fcc:	6a 00                	push   $0x0
  pushl $28
  101fce:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fd0:	e9 e7 fe ff ff       	jmp    101ebc <__alltraps>

00101fd5 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fd5:	6a 00                	push   $0x0
  pushl $29
  101fd7:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fd9:	e9 de fe ff ff       	jmp    101ebc <__alltraps>

00101fde <vector30>:
.globl vector30
vector30:
  pushl $0
  101fde:	6a 00                	push   $0x0
  pushl $30
  101fe0:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fe2:	e9 d5 fe ff ff       	jmp    101ebc <__alltraps>

00101fe7 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fe7:	6a 00                	push   $0x0
  pushl $31
  101fe9:	6a 1f                	push   $0x1f
  jmp __alltraps
  101feb:	e9 cc fe ff ff       	jmp    101ebc <__alltraps>

00101ff0 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ff0:	6a 00                	push   $0x0
  pushl $32
  101ff2:	6a 20                	push   $0x20
  jmp __alltraps
  101ff4:	e9 c3 fe ff ff       	jmp    101ebc <__alltraps>

00101ff9 <vector33>:
.globl vector33
vector33:
  pushl $0
  101ff9:	6a 00                	push   $0x0
  pushl $33
  101ffb:	6a 21                	push   $0x21
  jmp __alltraps
  101ffd:	e9 ba fe ff ff       	jmp    101ebc <__alltraps>

00102002 <vector34>:
.globl vector34
vector34:
  pushl $0
  102002:	6a 00                	push   $0x0
  pushl $34
  102004:	6a 22                	push   $0x22
  jmp __alltraps
  102006:	e9 b1 fe ff ff       	jmp    101ebc <__alltraps>

0010200b <vector35>:
.globl vector35
vector35:
  pushl $0
  10200b:	6a 00                	push   $0x0
  pushl $35
  10200d:	6a 23                	push   $0x23
  jmp __alltraps
  10200f:	e9 a8 fe ff ff       	jmp    101ebc <__alltraps>

00102014 <vector36>:
.globl vector36
vector36:
  pushl $0
  102014:	6a 00                	push   $0x0
  pushl $36
  102016:	6a 24                	push   $0x24
  jmp __alltraps
  102018:	e9 9f fe ff ff       	jmp    101ebc <__alltraps>

0010201d <vector37>:
.globl vector37
vector37:
  pushl $0
  10201d:	6a 00                	push   $0x0
  pushl $37
  10201f:	6a 25                	push   $0x25
  jmp __alltraps
  102021:	e9 96 fe ff ff       	jmp    101ebc <__alltraps>

00102026 <vector38>:
.globl vector38
vector38:
  pushl $0
  102026:	6a 00                	push   $0x0
  pushl $38
  102028:	6a 26                	push   $0x26
  jmp __alltraps
  10202a:	e9 8d fe ff ff       	jmp    101ebc <__alltraps>

0010202f <vector39>:
.globl vector39
vector39:
  pushl $0
  10202f:	6a 00                	push   $0x0
  pushl $39
  102031:	6a 27                	push   $0x27
  jmp __alltraps
  102033:	e9 84 fe ff ff       	jmp    101ebc <__alltraps>

00102038 <vector40>:
.globl vector40
vector40:
  pushl $0
  102038:	6a 00                	push   $0x0
  pushl $40
  10203a:	6a 28                	push   $0x28
  jmp __alltraps
  10203c:	e9 7b fe ff ff       	jmp    101ebc <__alltraps>

00102041 <vector41>:
.globl vector41
vector41:
  pushl $0
  102041:	6a 00                	push   $0x0
  pushl $41
  102043:	6a 29                	push   $0x29
  jmp __alltraps
  102045:	e9 72 fe ff ff       	jmp    101ebc <__alltraps>

0010204a <vector42>:
.globl vector42
vector42:
  pushl $0
  10204a:	6a 00                	push   $0x0
  pushl $42
  10204c:	6a 2a                	push   $0x2a
  jmp __alltraps
  10204e:	e9 69 fe ff ff       	jmp    101ebc <__alltraps>

00102053 <vector43>:
.globl vector43
vector43:
  pushl $0
  102053:	6a 00                	push   $0x0
  pushl $43
  102055:	6a 2b                	push   $0x2b
  jmp __alltraps
  102057:	e9 60 fe ff ff       	jmp    101ebc <__alltraps>

0010205c <vector44>:
.globl vector44
vector44:
  pushl $0
  10205c:	6a 00                	push   $0x0
  pushl $44
  10205e:	6a 2c                	push   $0x2c
  jmp __alltraps
  102060:	e9 57 fe ff ff       	jmp    101ebc <__alltraps>

00102065 <vector45>:
.globl vector45
vector45:
  pushl $0
  102065:	6a 00                	push   $0x0
  pushl $45
  102067:	6a 2d                	push   $0x2d
  jmp __alltraps
  102069:	e9 4e fe ff ff       	jmp    101ebc <__alltraps>

0010206e <vector46>:
.globl vector46
vector46:
  pushl $0
  10206e:	6a 00                	push   $0x0
  pushl $46
  102070:	6a 2e                	push   $0x2e
  jmp __alltraps
  102072:	e9 45 fe ff ff       	jmp    101ebc <__alltraps>

00102077 <vector47>:
.globl vector47
vector47:
  pushl $0
  102077:	6a 00                	push   $0x0
  pushl $47
  102079:	6a 2f                	push   $0x2f
  jmp __alltraps
  10207b:	e9 3c fe ff ff       	jmp    101ebc <__alltraps>

00102080 <vector48>:
.globl vector48
vector48:
  pushl $0
  102080:	6a 00                	push   $0x0
  pushl $48
  102082:	6a 30                	push   $0x30
  jmp __alltraps
  102084:	e9 33 fe ff ff       	jmp    101ebc <__alltraps>

00102089 <vector49>:
.globl vector49
vector49:
  pushl $0
  102089:	6a 00                	push   $0x0
  pushl $49
  10208b:	6a 31                	push   $0x31
  jmp __alltraps
  10208d:	e9 2a fe ff ff       	jmp    101ebc <__alltraps>

00102092 <vector50>:
.globl vector50
vector50:
  pushl $0
  102092:	6a 00                	push   $0x0
  pushl $50
  102094:	6a 32                	push   $0x32
  jmp __alltraps
  102096:	e9 21 fe ff ff       	jmp    101ebc <__alltraps>

0010209b <vector51>:
.globl vector51
vector51:
  pushl $0
  10209b:	6a 00                	push   $0x0
  pushl $51
  10209d:	6a 33                	push   $0x33
  jmp __alltraps
  10209f:	e9 18 fe ff ff       	jmp    101ebc <__alltraps>

001020a4 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020a4:	6a 00                	push   $0x0
  pushl $52
  1020a6:	6a 34                	push   $0x34
  jmp __alltraps
  1020a8:	e9 0f fe ff ff       	jmp    101ebc <__alltraps>

001020ad <vector53>:
.globl vector53
vector53:
  pushl $0
  1020ad:	6a 00                	push   $0x0
  pushl $53
  1020af:	6a 35                	push   $0x35
  jmp __alltraps
  1020b1:	e9 06 fe ff ff       	jmp    101ebc <__alltraps>

001020b6 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020b6:	6a 00                	push   $0x0
  pushl $54
  1020b8:	6a 36                	push   $0x36
  jmp __alltraps
  1020ba:	e9 fd fd ff ff       	jmp    101ebc <__alltraps>

001020bf <vector55>:
.globl vector55
vector55:
  pushl $0
  1020bf:	6a 00                	push   $0x0
  pushl $55
  1020c1:	6a 37                	push   $0x37
  jmp __alltraps
  1020c3:	e9 f4 fd ff ff       	jmp    101ebc <__alltraps>

001020c8 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $56
  1020ca:	6a 38                	push   $0x38
  jmp __alltraps
  1020cc:	e9 eb fd ff ff       	jmp    101ebc <__alltraps>

001020d1 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020d1:	6a 00                	push   $0x0
  pushl $57
  1020d3:	6a 39                	push   $0x39
  jmp __alltraps
  1020d5:	e9 e2 fd ff ff       	jmp    101ebc <__alltraps>

001020da <vector58>:
.globl vector58
vector58:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $58
  1020dc:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020de:	e9 d9 fd ff ff       	jmp    101ebc <__alltraps>

001020e3 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $59
  1020e5:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020e7:	e9 d0 fd ff ff       	jmp    101ebc <__alltraps>

001020ec <vector60>:
.globl vector60
vector60:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $60
  1020ee:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020f0:	e9 c7 fd ff ff       	jmp    101ebc <__alltraps>

001020f5 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020f5:	6a 00                	push   $0x0
  pushl $61
  1020f7:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020f9:	e9 be fd ff ff       	jmp    101ebc <__alltraps>

001020fe <vector62>:
.globl vector62
vector62:
  pushl $0
  1020fe:	6a 00                	push   $0x0
  pushl $62
  102100:	6a 3e                	push   $0x3e
  jmp __alltraps
  102102:	e9 b5 fd ff ff       	jmp    101ebc <__alltraps>

00102107 <vector63>:
.globl vector63
vector63:
  pushl $0
  102107:	6a 00                	push   $0x0
  pushl $63
  102109:	6a 3f                	push   $0x3f
  jmp __alltraps
  10210b:	e9 ac fd ff ff       	jmp    101ebc <__alltraps>

00102110 <vector64>:
.globl vector64
vector64:
  pushl $0
  102110:	6a 00                	push   $0x0
  pushl $64
  102112:	6a 40                	push   $0x40
  jmp __alltraps
  102114:	e9 a3 fd ff ff       	jmp    101ebc <__alltraps>

00102119 <vector65>:
.globl vector65
vector65:
  pushl $0
  102119:	6a 00                	push   $0x0
  pushl $65
  10211b:	6a 41                	push   $0x41
  jmp __alltraps
  10211d:	e9 9a fd ff ff       	jmp    101ebc <__alltraps>

00102122 <vector66>:
.globl vector66
vector66:
  pushl $0
  102122:	6a 00                	push   $0x0
  pushl $66
  102124:	6a 42                	push   $0x42
  jmp __alltraps
  102126:	e9 91 fd ff ff       	jmp    101ebc <__alltraps>

0010212b <vector67>:
.globl vector67
vector67:
  pushl $0
  10212b:	6a 00                	push   $0x0
  pushl $67
  10212d:	6a 43                	push   $0x43
  jmp __alltraps
  10212f:	e9 88 fd ff ff       	jmp    101ebc <__alltraps>

00102134 <vector68>:
.globl vector68
vector68:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $68
  102136:	6a 44                	push   $0x44
  jmp __alltraps
  102138:	e9 7f fd ff ff       	jmp    101ebc <__alltraps>

0010213d <vector69>:
.globl vector69
vector69:
  pushl $0
  10213d:	6a 00                	push   $0x0
  pushl $69
  10213f:	6a 45                	push   $0x45
  jmp __alltraps
  102141:	e9 76 fd ff ff       	jmp    101ebc <__alltraps>

00102146 <vector70>:
.globl vector70
vector70:
  pushl $0
  102146:	6a 00                	push   $0x0
  pushl $70
  102148:	6a 46                	push   $0x46
  jmp __alltraps
  10214a:	e9 6d fd ff ff       	jmp    101ebc <__alltraps>

0010214f <vector71>:
.globl vector71
vector71:
  pushl $0
  10214f:	6a 00                	push   $0x0
  pushl $71
  102151:	6a 47                	push   $0x47
  jmp __alltraps
  102153:	e9 64 fd ff ff       	jmp    101ebc <__alltraps>

00102158 <vector72>:
.globl vector72
vector72:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $72
  10215a:	6a 48                	push   $0x48
  jmp __alltraps
  10215c:	e9 5b fd ff ff       	jmp    101ebc <__alltraps>

00102161 <vector73>:
.globl vector73
vector73:
  pushl $0
  102161:	6a 00                	push   $0x0
  pushl $73
  102163:	6a 49                	push   $0x49
  jmp __alltraps
  102165:	e9 52 fd ff ff       	jmp    101ebc <__alltraps>

0010216a <vector74>:
.globl vector74
vector74:
  pushl $0
  10216a:	6a 00                	push   $0x0
  pushl $74
  10216c:	6a 4a                	push   $0x4a
  jmp __alltraps
  10216e:	e9 49 fd ff ff       	jmp    101ebc <__alltraps>

00102173 <vector75>:
.globl vector75
vector75:
  pushl $0
  102173:	6a 00                	push   $0x0
  pushl $75
  102175:	6a 4b                	push   $0x4b
  jmp __alltraps
  102177:	e9 40 fd ff ff       	jmp    101ebc <__alltraps>

0010217c <vector76>:
.globl vector76
vector76:
  pushl $0
  10217c:	6a 00                	push   $0x0
  pushl $76
  10217e:	6a 4c                	push   $0x4c
  jmp __alltraps
  102180:	e9 37 fd ff ff       	jmp    101ebc <__alltraps>

00102185 <vector77>:
.globl vector77
vector77:
  pushl $0
  102185:	6a 00                	push   $0x0
  pushl $77
  102187:	6a 4d                	push   $0x4d
  jmp __alltraps
  102189:	e9 2e fd ff ff       	jmp    101ebc <__alltraps>

0010218e <vector78>:
.globl vector78
vector78:
  pushl $0
  10218e:	6a 00                	push   $0x0
  pushl $78
  102190:	6a 4e                	push   $0x4e
  jmp __alltraps
  102192:	e9 25 fd ff ff       	jmp    101ebc <__alltraps>

00102197 <vector79>:
.globl vector79
vector79:
  pushl $0
  102197:	6a 00                	push   $0x0
  pushl $79
  102199:	6a 4f                	push   $0x4f
  jmp __alltraps
  10219b:	e9 1c fd ff ff       	jmp    101ebc <__alltraps>

001021a0 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021a0:	6a 00                	push   $0x0
  pushl $80
  1021a2:	6a 50                	push   $0x50
  jmp __alltraps
  1021a4:	e9 13 fd ff ff       	jmp    101ebc <__alltraps>

001021a9 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021a9:	6a 00                	push   $0x0
  pushl $81
  1021ab:	6a 51                	push   $0x51
  jmp __alltraps
  1021ad:	e9 0a fd ff ff       	jmp    101ebc <__alltraps>

001021b2 <vector82>:
.globl vector82
vector82:
  pushl $0
  1021b2:	6a 00                	push   $0x0
  pushl $82
  1021b4:	6a 52                	push   $0x52
  jmp __alltraps
  1021b6:	e9 01 fd ff ff       	jmp    101ebc <__alltraps>

001021bb <vector83>:
.globl vector83
vector83:
  pushl $0
  1021bb:	6a 00                	push   $0x0
  pushl $83
  1021bd:	6a 53                	push   $0x53
  jmp __alltraps
  1021bf:	e9 f8 fc ff ff       	jmp    101ebc <__alltraps>

001021c4 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021c4:	6a 00                	push   $0x0
  pushl $84
  1021c6:	6a 54                	push   $0x54
  jmp __alltraps
  1021c8:	e9 ef fc ff ff       	jmp    101ebc <__alltraps>

001021cd <vector85>:
.globl vector85
vector85:
  pushl $0
  1021cd:	6a 00                	push   $0x0
  pushl $85
  1021cf:	6a 55                	push   $0x55
  jmp __alltraps
  1021d1:	e9 e6 fc ff ff       	jmp    101ebc <__alltraps>

001021d6 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021d6:	6a 00                	push   $0x0
  pushl $86
  1021d8:	6a 56                	push   $0x56
  jmp __alltraps
  1021da:	e9 dd fc ff ff       	jmp    101ebc <__alltraps>

001021df <vector87>:
.globl vector87
vector87:
  pushl $0
  1021df:	6a 00                	push   $0x0
  pushl $87
  1021e1:	6a 57                	push   $0x57
  jmp __alltraps
  1021e3:	e9 d4 fc ff ff       	jmp    101ebc <__alltraps>

001021e8 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021e8:	6a 00                	push   $0x0
  pushl $88
  1021ea:	6a 58                	push   $0x58
  jmp __alltraps
  1021ec:	e9 cb fc ff ff       	jmp    101ebc <__alltraps>

001021f1 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021f1:	6a 00                	push   $0x0
  pushl $89
  1021f3:	6a 59                	push   $0x59
  jmp __alltraps
  1021f5:	e9 c2 fc ff ff       	jmp    101ebc <__alltraps>

001021fa <vector90>:
.globl vector90
vector90:
  pushl $0
  1021fa:	6a 00                	push   $0x0
  pushl $90
  1021fc:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021fe:	e9 b9 fc ff ff       	jmp    101ebc <__alltraps>

00102203 <vector91>:
.globl vector91
vector91:
  pushl $0
  102203:	6a 00                	push   $0x0
  pushl $91
  102205:	6a 5b                	push   $0x5b
  jmp __alltraps
  102207:	e9 b0 fc ff ff       	jmp    101ebc <__alltraps>

0010220c <vector92>:
.globl vector92
vector92:
  pushl $0
  10220c:	6a 00                	push   $0x0
  pushl $92
  10220e:	6a 5c                	push   $0x5c
  jmp __alltraps
  102210:	e9 a7 fc ff ff       	jmp    101ebc <__alltraps>

00102215 <vector93>:
.globl vector93
vector93:
  pushl $0
  102215:	6a 00                	push   $0x0
  pushl $93
  102217:	6a 5d                	push   $0x5d
  jmp __alltraps
  102219:	e9 9e fc ff ff       	jmp    101ebc <__alltraps>

0010221e <vector94>:
.globl vector94
vector94:
  pushl $0
  10221e:	6a 00                	push   $0x0
  pushl $94
  102220:	6a 5e                	push   $0x5e
  jmp __alltraps
  102222:	e9 95 fc ff ff       	jmp    101ebc <__alltraps>

00102227 <vector95>:
.globl vector95
vector95:
  pushl $0
  102227:	6a 00                	push   $0x0
  pushl $95
  102229:	6a 5f                	push   $0x5f
  jmp __alltraps
  10222b:	e9 8c fc ff ff       	jmp    101ebc <__alltraps>

00102230 <vector96>:
.globl vector96
vector96:
  pushl $0
  102230:	6a 00                	push   $0x0
  pushl $96
  102232:	6a 60                	push   $0x60
  jmp __alltraps
  102234:	e9 83 fc ff ff       	jmp    101ebc <__alltraps>

00102239 <vector97>:
.globl vector97
vector97:
  pushl $0
  102239:	6a 00                	push   $0x0
  pushl $97
  10223b:	6a 61                	push   $0x61
  jmp __alltraps
  10223d:	e9 7a fc ff ff       	jmp    101ebc <__alltraps>

00102242 <vector98>:
.globl vector98
vector98:
  pushl $0
  102242:	6a 00                	push   $0x0
  pushl $98
  102244:	6a 62                	push   $0x62
  jmp __alltraps
  102246:	e9 71 fc ff ff       	jmp    101ebc <__alltraps>

0010224b <vector99>:
.globl vector99
vector99:
  pushl $0
  10224b:	6a 00                	push   $0x0
  pushl $99
  10224d:	6a 63                	push   $0x63
  jmp __alltraps
  10224f:	e9 68 fc ff ff       	jmp    101ebc <__alltraps>

00102254 <vector100>:
.globl vector100
vector100:
  pushl $0
  102254:	6a 00                	push   $0x0
  pushl $100
  102256:	6a 64                	push   $0x64
  jmp __alltraps
  102258:	e9 5f fc ff ff       	jmp    101ebc <__alltraps>

0010225d <vector101>:
.globl vector101
vector101:
  pushl $0
  10225d:	6a 00                	push   $0x0
  pushl $101
  10225f:	6a 65                	push   $0x65
  jmp __alltraps
  102261:	e9 56 fc ff ff       	jmp    101ebc <__alltraps>

00102266 <vector102>:
.globl vector102
vector102:
  pushl $0
  102266:	6a 00                	push   $0x0
  pushl $102
  102268:	6a 66                	push   $0x66
  jmp __alltraps
  10226a:	e9 4d fc ff ff       	jmp    101ebc <__alltraps>

0010226f <vector103>:
.globl vector103
vector103:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $103
  102271:	6a 67                	push   $0x67
  jmp __alltraps
  102273:	e9 44 fc ff ff       	jmp    101ebc <__alltraps>

00102278 <vector104>:
.globl vector104
vector104:
  pushl $0
  102278:	6a 00                	push   $0x0
  pushl $104
  10227a:	6a 68                	push   $0x68
  jmp __alltraps
  10227c:	e9 3b fc ff ff       	jmp    101ebc <__alltraps>

00102281 <vector105>:
.globl vector105
vector105:
  pushl $0
  102281:	6a 00                	push   $0x0
  pushl $105
  102283:	6a 69                	push   $0x69
  jmp __alltraps
  102285:	e9 32 fc ff ff       	jmp    101ebc <__alltraps>

0010228a <vector106>:
.globl vector106
vector106:
  pushl $0
  10228a:	6a 00                	push   $0x0
  pushl $106
  10228c:	6a 6a                	push   $0x6a
  jmp __alltraps
  10228e:	e9 29 fc ff ff       	jmp    101ebc <__alltraps>

00102293 <vector107>:
.globl vector107
vector107:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $107
  102295:	6a 6b                	push   $0x6b
  jmp __alltraps
  102297:	e9 20 fc ff ff       	jmp    101ebc <__alltraps>

0010229c <vector108>:
.globl vector108
vector108:
  pushl $0
  10229c:	6a 00                	push   $0x0
  pushl $108
  10229e:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022a0:	e9 17 fc ff ff       	jmp    101ebc <__alltraps>

001022a5 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022a5:	6a 00                	push   $0x0
  pushl $109
  1022a7:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022a9:	e9 0e fc ff ff       	jmp    101ebc <__alltraps>

001022ae <vector110>:
.globl vector110
vector110:
  pushl $0
  1022ae:	6a 00                	push   $0x0
  pushl $110
  1022b0:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022b2:	e9 05 fc ff ff       	jmp    101ebc <__alltraps>

001022b7 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $111
  1022b9:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022bb:	e9 fc fb ff ff       	jmp    101ebc <__alltraps>

001022c0 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022c0:	6a 00                	push   $0x0
  pushl $112
  1022c2:	6a 70                	push   $0x70
  jmp __alltraps
  1022c4:	e9 f3 fb ff ff       	jmp    101ebc <__alltraps>

001022c9 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022c9:	6a 00                	push   $0x0
  pushl $113
  1022cb:	6a 71                	push   $0x71
  jmp __alltraps
  1022cd:	e9 ea fb ff ff       	jmp    101ebc <__alltraps>

001022d2 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022d2:	6a 00                	push   $0x0
  pushl $114
  1022d4:	6a 72                	push   $0x72
  jmp __alltraps
  1022d6:	e9 e1 fb ff ff       	jmp    101ebc <__alltraps>

001022db <vector115>:
.globl vector115
vector115:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $115
  1022dd:	6a 73                	push   $0x73
  jmp __alltraps
  1022df:	e9 d8 fb ff ff       	jmp    101ebc <__alltraps>

001022e4 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022e4:	6a 00                	push   $0x0
  pushl $116
  1022e6:	6a 74                	push   $0x74
  jmp __alltraps
  1022e8:	e9 cf fb ff ff       	jmp    101ebc <__alltraps>

001022ed <vector117>:
.globl vector117
vector117:
  pushl $0
  1022ed:	6a 00                	push   $0x0
  pushl $117
  1022ef:	6a 75                	push   $0x75
  jmp __alltraps
  1022f1:	e9 c6 fb ff ff       	jmp    101ebc <__alltraps>

001022f6 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022f6:	6a 00                	push   $0x0
  pushl $118
  1022f8:	6a 76                	push   $0x76
  jmp __alltraps
  1022fa:	e9 bd fb ff ff       	jmp    101ebc <__alltraps>

001022ff <vector119>:
.globl vector119
vector119:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $119
  102301:	6a 77                	push   $0x77
  jmp __alltraps
  102303:	e9 b4 fb ff ff       	jmp    101ebc <__alltraps>

00102308 <vector120>:
.globl vector120
vector120:
  pushl $0
  102308:	6a 00                	push   $0x0
  pushl $120
  10230a:	6a 78                	push   $0x78
  jmp __alltraps
  10230c:	e9 ab fb ff ff       	jmp    101ebc <__alltraps>

00102311 <vector121>:
.globl vector121
vector121:
  pushl $0
  102311:	6a 00                	push   $0x0
  pushl $121
  102313:	6a 79                	push   $0x79
  jmp __alltraps
  102315:	e9 a2 fb ff ff       	jmp    101ebc <__alltraps>

0010231a <vector122>:
.globl vector122
vector122:
  pushl $0
  10231a:	6a 00                	push   $0x0
  pushl $122
  10231c:	6a 7a                	push   $0x7a
  jmp __alltraps
  10231e:	e9 99 fb ff ff       	jmp    101ebc <__alltraps>

00102323 <vector123>:
.globl vector123
vector123:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $123
  102325:	6a 7b                	push   $0x7b
  jmp __alltraps
  102327:	e9 90 fb ff ff       	jmp    101ebc <__alltraps>

0010232c <vector124>:
.globl vector124
vector124:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $124
  10232e:	6a 7c                	push   $0x7c
  jmp __alltraps
  102330:	e9 87 fb ff ff       	jmp    101ebc <__alltraps>

00102335 <vector125>:
.globl vector125
vector125:
  pushl $0
  102335:	6a 00                	push   $0x0
  pushl $125
  102337:	6a 7d                	push   $0x7d
  jmp __alltraps
  102339:	e9 7e fb ff ff       	jmp    101ebc <__alltraps>

0010233e <vector126>:
.globl vector126
vector126:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $126
  102340:	6a 7e                	push   $0x7e
  jmp __alltraps
  102342:	e9 75 fb ff ff       	jmp    101ebc <__alltraps>

00102347 <vector127>:
.globl vector127
vector127:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $127
  102349:	6a 7f                	push   $0x7f
  jmp __alltraps
  10234b:	e9 6c fb ff ff       	jmp    101ebc <__alltraps>

00102350 <vector128>:
.globl vector128
vector128:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $128
  102352:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102357:	e9 60 fb ff ff       	jmp    101ebc <__alltraps>

0010235c <vector129>:
.globl vector129
vector129:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $129
  10235e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102363:	e9 54 fb ff ff       	jmp    101ebc <__alltraps>

00102368 <vector130>:
.globl vector130
vector130:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $130
  10236a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10236f:	e9 48 fb ff ff       	jmp    101ebc <__alltraps>

00102374 <vector131>:
.globl vector131
vector131:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $131
  102376:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10237b:	e9 3c fb ff ff       	jmp    101ebc <__alltraps>

00102380 <vector132>:
.globl vector132
vector132:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $132
  102382:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102387:	e9 30 fb ff ff       	jmp    101ebc <__alltraps>

0010238c <vector133>:
.globl vector133
vector133:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $133
  10238e:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102393:	e9 24 fb ff ff       	jmp    101ebc <__alltraps>

00102398 <vector134>:
.globl vector134
vector134:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $134
  10239a:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10239f:	e9 18 fb ff ff       	jmp    101ebc <__alltraps>

001023a4 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $135
  1023a6:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023ab:	e9 0c fb ff ff       	jmp    101ebc <__alltraps>

001023b0 <vector136>:
.globl vector136
vector136:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $136
  1023b2:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023b7:	e9 00 fb ff ff       	jmp    101ebc <__alltraps>

001023bc <vector137>:
.globl vector137
vector137:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $137
  1023be:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023c3:	e9 f4 fa ff ff       	jmp    101ebc <__alltraps>

001023c8 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $138
  1023ca:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023cf:	e9 e8 fa ff ff       	jmp    101ebc <__alltraps>

001023d4 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $139
  1023d6:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023db:	e9 dc fa ff ff       	jmp    101ebc <__alltraps>

001023e0 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $140
  1023e2:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023e7:	e9 d0 fa ff ff       	jmp    101ebc <__alltraps>

001023ec <vector141>:
.globl vector141
vector141:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $141
  1023ee:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023f3:	e9 c4 fa ff ff       	jmp    101ebc <__alltraps>

001023f8 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $142
  1023fa:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023ff:	e9 b8 fa ff ff       	jmp    101ebc <__alltraps>

00102404 <vector143>:
.globl vector143
vector143:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $143
  102406:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10240b:	e9 ac fa ff ff       	jmp    101ebc <__alltraps>

00102410 <vector144>:
.globl vector144
vector144:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $144
  102412:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102417:	e9 a0 fa ff ff       	jmp    101ebc <__alltraps>

0010241c <vector145>:
.globl vector145
vector145:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $145
  10241e:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102423:	e9 94 fa ff ff       	jmp    101ebc <__alltraps>

00102428 <vector146>:
.globl vector146
vector146:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $146
  10242a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10242f:	e9 88 fa ff ff       	jmp    101ebc <__alltraps>

00102434 <vector147>:
.globl vector147
vector147:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $147
  102436:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10243b:	e9 7c fa ff ff       	jmp    101ebc <__alltraps>

00102440 <vector148>:
.globl vector148
vector148:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $148
  102442:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102447:	e9 70 fa ff ff       	jmp    101ebc <__alltraps>

0010244c <vector149>:
.globl vector149
vector149:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $149
  10244e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102453:	e9 64 fa ff ff       	jmp    101ebc <__alltraps>

00102458 <vector150>:
.globl vector150
vector150:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $150
  10245a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10245f:	e9 58 fa ff ff       	jmp    101ebc <__alltraps>

00102464 <vector151>:
.globl vector151
vector151:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $151
  102466:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10246b:	e9 4c fa ff ff       	jmp    101ebc <__alltraps>

00102470 <vector152>:
.globl vector152
vector152:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $152
  102472:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102477:	e9 40 fa ff ff       	jmp    101ebc <__alltraps>

0010247c <vector153>:
.globl vector153
vector153:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $153
  10247e:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102483:	e9 34 fa ff ff       	jmp    101ebc <__alltraps>

00102488 <vector154>:
.globl vector154
vector154:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $154
  10248a:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10248f:	e9 28 fa ff ff       	jmp    101ebc <__alltraps>

00102494 <vector155>:
.globl vector155
vector155:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $155
  102496:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10249b:	e9 1c fa ff ff       	jmp    101ebc <__alltraps>

001024a0 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $156
  1024a2:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024a7:	e9 10 fa ff ff       	jmp    101ebc <__alltraps>

001024ac <vector157>:
.globl vector157
vector157:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $157
  1024ae:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024b3:	e9 04 fa ff ff       	jmp    101ebc <__alltraps>

001024b8 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $158
  1024ba:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024bf:	e9 f8 f9 ff ff       	jmp    101ebc <__alltraps>

001024c4 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $159
  1024c6:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024cb:	e9 ec f9 ff ff       	jmp    101ebc <__alltraps>

001024d0 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $160
  1024d2:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024d7:	e9 e0 f9 ff ff       	jmp    101ebc <__alltraps>

001024dc <vector161>:
.globl vector161
vector161:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $161
  1024de:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024e3:	e9 d4 f9 ff ff       	jmp    101ebc <__alltraps>

001024e8 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $162
  1024ea:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024ef:	e9 c8 f9 ff ff       	jmp    101ebc <__alltraps>

001024f4 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $163
  1024f6:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024fb:	e9 bc f9 ff ff       	jmp    101ebc <__alltraps>

00102500 <vector164>:
.globl vector164
vector164:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $164
  102502:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102507:	e9 b0 f9 ff ff       	jmp    101ebc <__alltraps>

0010250c <vector165>:
.globl vector165
vector165:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $165
  10250e:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102513:	e9 a4 f9 ff ff       	jmp    101ebc <__alltraps>

00102518 <vector166>:
.globl vector166
vector166:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $166
  10251a:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10251f:	e9 98 f9 ff ff       	jmp    101ebc <__alltraps>

00102524 <vector167>:
.globl vector167
vector167:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $167
  102526:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10252b:	e9 8c f9 ff ff       	jmp    101ebc <__alltraps>

00102530 <vector168>:
.globl vector168
vector168:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $168
  102532:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102537:	e9 80 f9 ff ff       	jmp    101ebc <__alltraps>

0010253c <vector169>:
.globl vector169
vector169:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $169
  10253e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102543:	e9 74 f9 ff ff       	jmp    101ebc <__alltraps>

00102548 <vector170>:
.globl vector170
vector170:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $170
  10254a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10254f:	e9 68 f9 ff ff       	jmp    101ebc <__alltraps>

00102554 <vector171>:
.globl vector171
vector171:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $171
  102556:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10255b:	e9 5c f9 ff ff       	jmp    101ebc <__alltraps>

00102560 <vector172>:
.globl vector172
vector172:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $172
  102562:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102567:	e9 50 f9 ff ff       	jmp    101ebc <__alltraps>

0010256c <vector173>:
.globl vector173
vector173:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $173
  10256e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102573:	e9 44 f9 ff ff       	jmp    101ebc <__alltraps>

00102578 <vector174>:
.globl vector174
vector174:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $174
  10257a:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10257f:	e9 38 f9 ff ff       	jmp    101ebc <__alltraps>

00102584 <vector175>:
.globl vector175
vector175:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $175
  102586:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10258b:	e9 2c f9 ff ff       	jmp    101ebc <__alltraps>

00102590 <vector176>:
.globl vector176
vector176:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $176
  102592:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102597:	e9 20 f9 ff ff       	jmp    101ebc <__alltraps>

0010259c <vector177>:
.globl vector177
vector177:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $177
  10259e:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025a3:	e9 14 f9 ff ff       	jmp    101ebc <__alltraps>

001025a8 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $178
  1025aa:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025af:	e9 08 f9 ff ff       	jmp    101ebc <__alltraps>

001025b4 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $179
  1025b6:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025bb:	e9 fc f8 ff ff       	jmp    101ebc <__alltraps>

001025c0 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $180
  1025c2:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025c7:	e9 f0 f8 ff ff       	jmp    101ebc <__alltraps>

001025cc <vector181>:
.globl vector181
vector181:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $181
  1025ce:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025d3:	e9 e4 f8 ff ff       	jmp    101ebc <__alltraps>

001025d8 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $182
  1025da:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025df:	e9 d8 f8 ff ff       	jmp    101ebc <__alltraps>

001025e4 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $183
  1025e6:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025eb:	e9 cc f8 ff ff       	jmp    101ebc <__alltraps>

001025f0 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $184
  1025f2:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025f7:	e9 c0 f8 ff ff       	jmp    101ebc <__alltraps>

001025fc <vector185>:
.globl vector185
vector185:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $185
  1025fe:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102603:	e9 b4 f8 ff ff       	jmp    101ebc <__alltraps>

00102608 <vector186>:
.globl vector186
vector186:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $186
  10260a:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10260f:	e9 a8 f8 ff ff       	jmp    101ebc <__alltraps>

00102614 <vector187>:
.globl vector187
vector187:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $187
  102616:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10261b:	e9 9c f8 ff ff       	jmp    101ebc <__alltraps>

00102620 <vector188>:
.globl vector188
vector188:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $188
  102622:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102627:	e9 90 f8 ff ff       	jmp    101ebc <__alltraps>

0010262c <vector189>:
.globl vector189
vector189:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $189
  10262e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102633:	e9 84 f8 ff ff       	jmp    101ebc <__alltraps>

00102638 <vector190>:
.globl vector190
vector190:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $190
  10263a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10263f:	e9 78 f8 ff ff       	jmp    101ebc <__alltraps>

00102644 <vector191>:
.globl vector191
vector191:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $191
  102646:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10264b:	e9 6c f8 ff ff       	jmp    101ebc <__alltraps>

00102650 <vector192>:
.globl vector192
vector192:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $192
  102652:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102657:	e9 60 f8 ff ff       	jmp    101ebc <__alltraps>

0010265c <vector193>:
.globl vector193
vector193:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $193
  10265e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102663:	e9 54 f8 ff ff       	jmp    101ebc <__alltraps>

00102668 <vector194>:
.globl vector194
vector194:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $194
  10266a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10266f:	e9 48 f8 ff ff       	jmp    101ebc <__alltraps>

00102674 <vector195>:
.globl vector195
vector195:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $195
  102676:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10267b:	e9 3c f8 ff ff       	jmp    101ebc <__alltraps>

00102680 <vector196>:
.globl vector196
vector196:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $196
  102682:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102687:	e9 30 f8 ff ff       	jmp    101ebc <__alltraps>

0010268c <vector197>:
.globl vector197
vector197:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $197
  10268e:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102693:	e9 24 f8 ff ff       	jmp    101ebc <__alltraps>

00102698 <vector198>:
.globl vector198
vector198:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $198
  10269a:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10269f:	e9 18 f8 ff ff       	jmp    101ebc <__alltraps>

001026a4 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $199
  1026a6:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026ab:	e9 0c f8 ff ff       	jmp    101ebc <__alltraps>

001026b0 <vector200>:
.globl vector200
vector200:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $200
  1026b2:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026b7:	e9 00 f8 ff ff       	jmp    101ebc <__alltraps>

001026bc <vector201>:
.globl vector201
vector201:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $201
  1026be:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026c3:	e9 f4 f7 ff ff       	jmp    101ebc <__alltraps>

001026c8 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $202
  1026ca:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026cf:	e9 e8 f7 ff ff       	jmp    101ebc <__alltraps>

001026d4 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $203
  1026d6:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026db:	e9 dc f7 ff ff       	jmp    101ebc <__alltraps>

001026e0 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $204
  1026e2:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026e7:	e9 d0 f7 ff ff       	jmp    101ebc <__alltraps>

001026ec <vector205>:
.globl vector205
vector205:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $205
  1026ee:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026f3:	e9 c4 f7 ff ff       	jmp    101ebc <__alltraps>

001026f8 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $206
  1026fa:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026ff:	e9 b8 f7 ff ff       	jmp    101ebc <__alltraps>

00102704 <vector207>:
.globl vector207
vector207:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $207
  102706:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10270b:	e9 ac f7 ff ff       	jmp    101ebc <__alltraps>

00102710 <vector208>:
.globl vector208
vector208:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $208
  102712:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102717:	e9 a0 f7 ff ff       	jmp    101ebc <__alltraps>

0010271c <vector209>:
.globl vector209
vector209:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $209
  10271e:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102723:	e9 94 f7 ff ff       	jmp    101ebc <__alltraps>

00102728 <vector210>:
.globl vector210
vector210:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $210
  10272a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10272f:	e9 88 f7 ff ff       	jmp    101ebc <__alltraps>

00102734 <vector211>:
.globl vector211
vector211:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $211
  102736:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10273b:	e9 7c f7 ff ff       	jmp    101ebc <__alltraps>

00102740 <vector212>:
.globl vector212
vector212:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $212
  102742:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102747:	e9 70 f7 ff ff       	jmp    101ebc <__alltraps>

0010274c <vector213>:
.globl vector213
vector213:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $213
  10274e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102753:	e9 64 f7 ff ff       	jmp    101ebc <__alltraps>

00102758 <vector214>:
.globl vector214
vector214:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $214
  10275a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10275f:	e9 58 f7 ff ff       	jmp    101ebc <__alltraps>

00102764 <vector215>:
.globl vector215
vector215:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $215
  102766:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10276b:	e9 4c f7 ff ff       	jmp    101ebc <__alltraps>

00102770 <vector216>:
.globl vector216
vector216:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $216
  102772:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102777:	e9 40 f7 ff ff       	jmp    101ebc <__alltraps>

0010277c <vector217>:
.globl vector217
vector217:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $217
  10277e:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102783:	e9 34 f7 ff ff       	jmp    101ebc <__alltraps>

00102788 <vector218>:
.globl vector218
vector218:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $218
  10278a:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10278f:	e9 28 f7 ff ff       	jmp    101ebc <__alltraps>

00102794 <vector219>:
.globl vector219
vector219:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $219
  102796:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10279b:	e9 1c f7 ff ff       	jmp    101ebc <__alltraps>

001027a0 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $220
  1027a2:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027a7:	e9 10 f7 ff ff       	jmp    101ebc <__alltraps>

001027ac <vector221>:
.globl vector221
vector221:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $221
  1027ae:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027b3:	e9 04 f7 ff ff       	jmp    101ebc <__alltraps>

001027b8 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $222
  1027ba:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027bf:	e9 f8 f6 ff ff       	jmp    101ebc <__alltraps>

001027c4 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $223
  1027c6:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027cb:	e9 ec f6 ff ff       	jmp    101ebc <__alltraps>

001027d0 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $224
  1027d2:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027d7:	e9 e0 f6 ff ff       	jmp    101ebc <__alltraps>

001027dc <vector225>:
.globl vector225
vector225:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $225
  1027de:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027e3:	e9 d4 f6 ff ff       	jmp    101ebc <__alltraps>

001027e8 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $226
  1027ea:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027ef:	e9 c8 f6 ff ff       	jmp    101ebc <__alltraps>

001027f4 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $227
  1027f6:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027fb:	e9 bc f6 ff ff       	jmp    101ebc <__alltraps>

00102800 <vector228>:
.globl vector228
vector228:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $228
  102802:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102807:	e9 b0 f6 ff ff       	jmp    101ebc <__alltraps>

0010280c <vector229>:
.globl vector229
vector229:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $229
  10280e:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102813:	e9 a4 f6 ff ff       	jmp    101ebc <__alltraps>

00102818 <vector230>:
.globl vector230
vector230:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $230
  10281a:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10281f:	e9 98 f6 ff ff       	jmp    101ebc <__alltraps>

00102824 <vector231>:
.globl vector231
vector231:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $231
  102826:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10282b:	e9 8c f6 ff ff       	jmp    101ebc <__alltraps>

00102830 <vector232>:
.globl vector232
vector232:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $232
  102832:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102837:	e9 80 f6 ff ff       	jmp    101ebc <__alltraps>

0010283c <vector233>:
.globl vector233
vector233:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $233
  10283e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102843:	e9 74 f6 ff ff       	jmp    101ebc <__alltraps>

00102848 <vector234>:
.globl vector234
vector234:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $234
  10284a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10284f:	e9 68 f6 ff ff       	jmp    101ebc <__alltraps>

00102854 <vector235>:
.globl vector235
vector235:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $235
  102856:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10285b:	e9 5c f6 ff ff       	jmp    101ebc <__alltraps>

00102860 <vector236>:
.globl vector236
vector236:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $236
  102862:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102867:	e9 50 f6 ff ff       	jmp    101ebc <__alltraps>

0010286c <vector237>:
.globl vector237
vector237:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $237
  10286e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102873:	e9 44 f6 ff ff       	jmp    101ebc <__alltraps>

00102878 <vector238>:
.globl vector238
vector238:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $238
  10287a:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10287f:	e9 38 f6 ff ff       	jmp    101ebc <__alltraps>

00102884 <vector239>:
.globl vector239
vector239:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $239
  102886:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10288b:	e9 2c f6 ff ff       	jmp    101ebc <__alltraps>

00102890 <vector240>:
.globl vector240
vector240:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $240
  102892:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102897:	e9 20 f6 ff ff       	jmp    101ebc <__alltraps>

0010289c <vector241>:
.globl vector241
vector241:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $241
  10289e:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028a3:	e9 14 f6 ff ff       	jmp    101ebc <__alltraps>

001028a8 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $242
  1028aa:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028af:	e9 08 f6 ff ff       	jmp    101ebc <__alltraps>

001028b4 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $243
  1028b6:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028bb:	e9 fc f5 ff ff       	jmp    101ebc <__alltraps>

001028c0 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $244
  1028c2:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028c7:	e9 f0 f5 ff ff       	jmp    101ebc <__alltraps>

001028cc <vector245>:
.globl vector245
vector245:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $245
  1028ce:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028d3:	e9 e4 f5 ff ff       	jmp    101ebc <__alltraps>

001028d8 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $246
  1028da:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028df:	e9 d8 f5 ff ff       	jmp    101ebc <__alltraps>

001028e4 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028e4:	6a 00                	push   $0x0
  pushl $247
  1028e6:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028eb:	e9 cc f5 ff ff       	jmp    101ebc <__alltraps>

001028f0 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028f0:	6a 00                	push   $0x0
  pushl $248
  1028f2:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028f7:	e9 c0 f5 ff ff       	jmp    101ebc <__alltraps>

001028fc <vector249>:
.globl vector249
vector249:
  pushl $0
  1028fc:	6a 00                	push   $0x0
  pushl $249
  1028fe:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102903:	e9 b4 f5 ff ff       	jmp    101ebc <__alltraps>

00102908 <vector250>:
.globl vector250
vector250:
  pushl $0
  102908:	6a 00                	push   $0x0
  pushl $250
  10290a:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10290f:	e9 a8 f5 ff ff       	jmp    101ebc <__alltraps>

00102914 <vector251>:
.globl vector251
vector251:
  pushl $0
  102914:	6a 00                	push   $0x0
  pushl $251
  102916:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10291b:	e9 9c f5 ff ff       	jmp    101ebc <__alltraps>

00102920 <vector252>:
.globl vector252
vector252:
  pushl $0
  102920:	6a 00                	push   $0x0
  pushl $252
  102922:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102927:	e9 90 f5 ff ff       	jmp    101ebc <__alltraps>

0010292c <vector253>:
.globl vector253
vector253:
  pushl $0
  10292c:	6a 00                	push   $0x0
  pushl $253
  10292e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102933:	e9 84 f5 ff ff       	jmp    101ebc <__alltraps>

00102938 <vector254>:
.globl vector254
vector254:
  pushl $0
  102938:	6a 00                	push   $0x0
  pushl $254
  10293a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10293f:	e9 78 f5 ff ff       	jmp    101ebc <__alltraps>

00102944 <vector255>:
.globl vector255
vector255:
  pushl $0
  102944:	6a 00                	push   $0x0
  pushl $255
  102946:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10294b:	e9 6c f5 ff ff       	jmp    101ebc <__alltraps>

00102950 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102950:	55                   	push   %ebp
  102951:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102953:	8b 45 08             	mov    0x8(%ebp),%eax
  102956:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102959:	b8 23 00 00 00       	mov    $0x23,%eax
  10295e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102960:	b8 23 00 00 00       	mov    $0x23,%eax
  102965:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102967:	b8 10 00 00 00       	mov    $0x10,%eax
  10296c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10296e:	b8 10 00 00 00       	mov    $0x10,%eax
  102973:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102975:	b8 10 00 00 00       	mov    $0x10,%eax
  10297a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10297c:	ea 83 29 10 00 08 00 	ljmp   $0x8,$0x102983
}
  102983:	5d                   	pop    %ebp
  102984:	c3                   	ret    

00102985 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102985:	55                   	push   %ebp
  102986:	89 e5                	mov    %esp,%ebp
  102988:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10298b:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102990:	05 00 04 00 00       	add    $0x400,%eax
  102995:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10299a:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1029a1:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029a3:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1029aa:	68 00 
  1029ac:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029b1:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1029b7:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029bc:	c1 e8 10             	shr    $0x10,%eax
  1029bf:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029c4:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029cb:	83 e0 f0             	and    $0xfffffff0,%eax
  1029ce:	83 c8 09             	or     $0x9,%eax
  1029d1:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029d6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029dd:	83 c8 10             	or     $0x10,%eax
  1029e0:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029e5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ec:	83 e0 9f             	and    $0xffffff9f,%eax
  1029ef:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029f4:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029fb:	83 c8 80             	or     $0xffffff80,%eax
  1029fe:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a03:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a0a:	83 e0 f0             	and    $0xfffffff0,%eax
  102a0d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a12:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a19:	83 e0 ef             	and    $0xffffffef,%eax
  102a1c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a21:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a28:	83 e0 df             	and    $0xffffffdf,%eax
  102a2b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a30:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a37:	83 c8 40             	or     $0x40,%eax
  102a3a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a3f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a46:	83 e0 7f             	and    $0x7f,%eax
  102a49:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a4e:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a53:	c1 e8 18             	shr    $0x18,%eax
  102a56:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a5b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a62:	83 e0 ef             	and    $0xffffffef,%eax
  102a65:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a6a:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102a71:	e8 da fe ff ff       	call   102950 <lgdt>
  102a76:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a7c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a80:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a83:	c9                   	leave  
  102a84:	c3                   	ret    

00102a85 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a85:	55                   	push   %ebp
  102a86:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a88:	e8 f8 fe ff ff       	call   102985 <gdt_init>
}
  102a8d:	5d                   	pop    %ebp
  102a8e:	c3                   	ret    

00102a8f <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102a8f:	55                   	push   %ebp
  102a90:	89 e5                	mov    %esp,%ebp
  102a92:	83 ec 58             	sub    $0x58,%esp
  102a95:	8b 45 10             	mov    0x10(%ebp),%eax
  102a98:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  102a9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102aa1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102aa4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102aa7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102aaa:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102aad:	8b 45 18             	mov    0x18(%ebp),%eax
  102ab0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ab3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ab6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ab9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102abc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ac5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ac9:	74 1c                	je     102ae7 <printnum+0x58>
  102acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ace:	ba 00 00 00 00       	mov    $0x0,%edx
  102ad3:	f7 75 e4             	divl   -0x1c(%ebp)
  102ad6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102adc:	ba 00 00 00 00       	mov    $0x0,%edx
  102ae1:	f7 75 e4             	divl   -0x1c(%ebp)
  102ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102aea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102aed:	f7 75 e4             	divl   -0x1c(%ebp)
  102af0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102af3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102af9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102afc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102aff:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b02:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b05:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b08:	8b 45 18             	mov    0x18(%ebp),%eax
  102b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  102b10:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b13:	77 56                	ja     102b6b <printnum+0xdc>
  102b15:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b18:	72 05                	jb     102b1f <printnum+0x90>
  102b1a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102b1d:	77 4c                	ja     102b6b <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102b1f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102b22:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b25:	8b 45 20             	mov    0x20(%ebp),%eax
  102b28:	89 44 24 18          	mov    %eax,0x18(%esp)
  102b2c:	89 54 24 14          	mov    %edx,0x14(%esp)
  102b30:	8b 45 18             	mov    0x18(%ebp),%eax
  102b33:	89 44 24 10          	mov    %eax,0x10(%esp)
  102b37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b41:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4f:	89 04 24             	mov    %eax,(%esp)
  102b52:	e8 38 ff ff ff       	call   102a8f <printnum>
  102b57:	eb 1c                	jmp    102b75 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b60:	8b 45 20             	mov    0x20(%ebp),%eax
  102b63:	89 04 24             	mov    %eax,(%esp)
  102b66:	8b 45 08             	mov    0x8(%ebp),%eax
  102b69:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102b6b:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102b6f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102b73:	7f e4                	jg     102b59 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102b75:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b78:	05 70 3d 10 00       	add    $0x103d70,%eax
  102b7d:	0f b6 00             	movzbl (%eax),%eax
  102b80:	0f be c0             	movsbl %al,%eax
  102b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b86:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b8a:	89 04 24             	mov    %eax,(%esp)
  102b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b90:	ff d0                	call   *%eax
}
  102b92:	c9                   	leave  
  102b93:	c3                   	ret    

00102b94 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102b94:	55                   	push   %ebp
  102b95:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102b97:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102b9b:	7e 14                	jle    102bb1 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba0:	8b 00                	mov    (%eax),%eax
  102ba2:	8d 48 08             	lea    0x8(%eax),%ecx
  102ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  102ba8:	89 0a                	mov    %ecx,(%edx)
  102baa:	8b 50 04             	mov    0x4(%eax),%edx
  102bad:	8b 00                	mov    (%eax),%eax
  102baf:	eb 30                	jmp    102be1 <getuint+0x4d>
    }
    else if (lflag) {
  102bb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bb5:	74 16                	je     102bcd <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  102bba:	8b 00                	mov    (%eax),%eax
  102bbc:	8d 48 04             	lea    0x4(%eax),%ecx
  102bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  102bc2:	89 0a                	mov    %ecx,(%edx)
  102bc4:	8b 00                	mov    (%eax),%eax
  102bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  102bcb:	eb 14                	jmp    102be1 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd0:	8b 00                	mov    (%eax),%eax
  102bd2:	8d 48 04             	lea    0x4(%eax),%ecx
  102bd5:	8b 55 08             	mov    0x8(%ebp),%edx
  102bd8:	89 0a                	mov    %ecx,(%edx)
  102bda:	8b 00                	mov    (%eax),%eax
  102bdc:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102be1:	5d                   	pop    %ebp
  102be2:	c3                   	ret    

00102be3 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102be3:	55                   	push   %ebp
  102be4:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102be6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102bea:	7e 14                	jle    102c00 <getint+0x1d>
        return va_arg(*ap, long long);
  102bec:	8b 45 08             	mov    0x8(%ebp),%eax
  102bef:	8b 00                	mov    (%eax),%eax
  102bf1:	8d 48 08             	lea    0x8(%eax),%ecx
  102bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  102bf7:	89 0a                	mov    %ecx,(%edx)
  102bf9:	8b 50 04             	mov    0x4(%eax),%edx
  102bfc:	8b 00                	mov    (%eax),%eax
  102bfe:	eb 28                	jmp    102c28 <getint+0x45>
    }
    else if (lflag) {
  102c00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c04:	74 12                	je     102c18 <getint+0x35>
        return va_arg(*ap, long);
  102c06:	8b 45 08             	mov    0x8(%ebp),%eax
  102c09:	8b 00                	mov    (%eax),%eax
  102c0b:	8d 48 04             	lea    0x4(%eax),%ecx
  102c0e:	8b 55 08             	mov    0x8(%ebp),%edx
  102c11:	89 0a                	mov    %ecx,(%edx)
  102c13:	8b 00                	mov    (%eax),%eax
  102c15:	99                   	cltd   
  102c16:	eb 10                	jmp    102c28 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102c18:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1b:	8b 00                	mov    (%eax),%eax
  102c1d:	8d 48 04             	lea    0x4(%eax),%ecx
  102c20:	8b 55 08             	mov    0x8(%ebp),%edx
  102c23:	89 0a                	mov    %ecx,(%edx)
  102c25:	8b 00                	mov    (%eax),%eax
  102c27:	99                   	cltd   
    }
}
  102c28:	5d                   	pop    %ebp
  102c29:	c3                   	ret    

00102c2a <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102c2a:	55                   	push   %ebp
  102c2b:	89 e5                	mov    %esp,%ebp
  102c2d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102c30:	8d 45 14             	lea    0x14(%ebp),%eax
  102c33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c39:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  102c40:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4e:	89 04 24             	mov    %eax,(%esp)
  102c51:	e8 02 00 00 00       	call   102c58 <vprintfmt>
    va_end(ap);
}
  102c56:	c9                   	leave  
  102c57:	c3                   	ret    

00102c58 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c58:	55                   	push   %ebp
  102c59:	89 e5                	mov    %esp,%ebp
  102c5b:	56                   	push   %esi
  102c5c:	53                   	push   %ebx
  102c5d:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c60:	eb 18                	jmp    102c7a <vprintfmt+0x22>
            if (ch == '\0') {
  102c62:	85 db                	test   %ebx,%ebx
  102c64:	75 05                	jne    102c6b <vprintfmt+0x13>
                return;
  102c66:	e9 d1 03 00 00       	jmp    10303c <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c72:	89 1c 24             	mov    %ebx,(%esp)
  102c75:	8b 45 08             	mov    0x8(%ebp),%eax
  102c78:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c7a:	8b 45 10             	mov    0x10(%ebp),%eax
  102c7d:	8d 50 01             	lea    0x1(%eax),%edx
  102c80:	89 55 10             	mov    %edx,0x10(%ebp)
  102c83:	0f b6 00             	movzbl (%eax),%eax
  102c86:	0f b6 d8             	movzbl %al,%ebx
  102c89:	83 fb 25             	cmp    $0x25,%ebx
  102c8c:	75 d4                	jne    102c62 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102c8e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102c92:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102c9f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ca6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102cac:	8b 45 10             	mov    0x10(%ebp),%eax
  102caf:	8d 50 01             	lea    0x1(%eax),%edx
  102cb2:	89 55 10             	mov    %edx,0x10(%ebp)
  102cb5:	0f b6 00             	movzbl (%eax),%eax
  102cb8:	0f b6 d8             	movzbl %al,%ebx
  102cbb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102cbe:	83 f8 55             	cmp    $0x55,%eax
  102cc1:	0f 87 44 03 00 00    	ja     10300b <vprintfmt+0x3b3>
  102cc7:	8b 04 85 94 3d 10 00 	mov    0x103d94(,%eax,4),%eax
  102cce:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102cd0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102cd4:	eb d6                	jmp    102cac <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102cd6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102cda:	eb d0                	jmp    102cac <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102cdc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102ce3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ce6:	89 d0                	mov    %edx,%eax
  102ce8:	c1 e0 02             	shl    $0x2,%eax
  102ceb:	01 d0                	add    %edx,%eax
  102ced:	01 c0                	add    %eax,%eax
  102cef:	01 d8                	add    %ebx,%eax
  102cf1:	83 e8 30             	sub    $0x30,%eax
  102cf4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  102cfa:	0f b6 00             	movzbl (%eax),%eax
  102cfd:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d00:	83 fb 2f             	cmp    $0x2f,%ebx
  102d03:	7e 0b                	jle    102d10 <vprintfmt+0xb8>
  102d05:	83 fb 39             	cmp    $0x39,%ebx
  102d08:	7f 06                	jg     102d10 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d0a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102d0e:	eb d3                	jmp    102ce3 <vprintfmt+0x8b>
            goto process_precision;
  102d10:	eb 33                	jmp    102d45 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102d12:	8b 45 14             	mov    0x14(%ebp),%eax
  102d15:	8d 50 04             	lea    0x4(%eax),%edx
  102d18:	89 55 14             	mov    %edx,0x14(%ebp)
  102d1b:	8b 00                	mov    (%eax),%eax
  102d1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102d20:	eb 23                	jmp    102d45 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102d22:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d26:	79 0c                	jns    102d34 <vprintfmt+0xdc>
                width = 0;
  102d28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102d2f:	e9 78 ff ff ff       	jmp    102cac <vprintfmt+0x54>
  102d34:	e9 73 ff ff ff       	jmp    102cac <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102d39:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102d40:	e9 67 ff ff ff       	jmp    102cac <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102d45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d49:	79 12                	jns    102d5d <vprintfmt+0x105>
                width = precision, precision = -1;
  102d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d51:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d58:	e9 4f ff ff ff       	jmp    102cac <vprintfmt+0x54>
  102d5d:	e9 4a ff ff ff       	jmp    102cac <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d62:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102d66:	e9 41 ff ff ff       	jmp    102cac <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d6b:	8b 45 14             	mov    0x14(%ebp),%eax
  102d6e:	8d 50 04             	lea    0x4(%eax),%edx
  102d71:	89 55 14             	mov    %edx,0x14(%ebp)
  102d74:	8b 00                	mov    (%eax),%eax
  102d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d79:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d7d:	89 04 24             	mov    %eax,(%esp)
  102d80:	8b 45 08             	mov    0x8(%ebp),%eax
  102d83:	ff d0                	call   *%eax
            break;
  102d85:	e9 ac 02 00 00       	jmp    103036 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102d8a:	8b 45 14             	mov    0x14(%ebp),%eax
  102d8d:	8d 50 04             	lea    0x4(%eax),%edx
  102d90:	89 55 14             	mov    %edx,0x14(%ebp)
  102d93:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102d95:	85 db                	test   %ebx,%ebx
  102d97:	79 02                	jns    102d9b <vprintfmt+0x143>
                err = -err;
  102d99:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102d9b:	83 fb 06             	cmp    $0x6,%ebx
  102d9e:	7f 0b                	jg     102dab <vprintfmt+0x153>
  102da0:	8b 34 9d 54 3d 10 00 	mov    0x103d54(,%ebx,4),%esi
  102da7:	85 f6                	test   %esi,%esi
  102da9:	75 23                	jne    102dce <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102dab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102daf:	c7 44 24 08 81 3d 10 	movl   $0x103d81,0x8(%esp)
  102db6:	00 
  102db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dba:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc1:	89 04 24             	mov    %eax,(%esp)
  102dc4:	e8 61 fe ff ff       	call   102c2a <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102dc9:	e9 68 02 00 00       	jmp    103036 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102dce:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102dd2:	c7 44 24 08 8a 3d 10 	movl   $0x103d8a,0x8(%esp)
  102dd9:	00 
  102dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102de1:	8b 45 08             	mov    0x8(%ebp),%eax
  102de4:	89 04 24             	mov    %eax,(%esp)
  102de7:	e8 3e fe ff ff       	call   102c2a <printfmt>
            }
            break;
  102dec:	e9 45 02 00 00       	jmp    103036 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102df1:	8b 45 14             	mov    0x14(%ebp),%eax
  102df4:	8d 50 04             	lea    0x4(%eax),%edx
  102df7:	89 55 14             	mov    %edx,0x14(%ebp)
  102dfa:	8b 30                	mov    (%eax),%esi
  102dfc:	85 f6                	test   %esi,%esi
  102dfe:	75 05                	jne    102e05 <vprintfmt+0x1ad>
                p = "(null)";
  102e00:	be 8d 3d 10 00       	mov    $0x103d8d,%esi
            }
            if (width > 0 && padc != '-') {
  102e05:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e09:	7e 3e                	jle    102e49 <vprintfmt+0x1f1>
  102e0b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102e0f:	74 38                	je     102e49 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e11:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e17:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e1b:	89 34 24             	mov    %esi,(%esp)
  102e1e:	e8 15 03 00 00       	call   103138 <strnlen>
  102e23:	29 c3                	sub    %eax,%ebx
  102e25:	89 d8                	mov    %ebx,%eax
  102e27:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e2a:	eb 17                	jmp    102e43 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102e2c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102e30:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e33:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e37:	89 04 24             	mov    %eax,(%esp)
  102e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3d:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e3f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e43:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e47:	7f e3                	jg     102e2c <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e49:	eb 38                	jmp    102e83 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102e4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102e4f:	74 1f                	je     102e70 <vprintfmt+0x218>
  102e51:	83 fb 1f             	cmp    $0x1f,%ebx
  102e54:	7e 05                	jle    102e5b <vprintfmt+0x203>
  102e56:	83 fb 7e             	cmp    $0x7e,%ebx
  102e59:	7e 15                	jle    102e70 <vprintfmt+0x218>
                    putch('?', putdat);
  102e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e62:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102e69:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6c:	ff d0                	call   *%eax
  102e6e:	eb 0f                	jmp    102e7f <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e73:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e77:	89 1c 24             	mov    %ebx,(%esp)
  102e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7d:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e7f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e83:	89 f0                	mov    %esi,%eax
  102e85:	8d 70 01             	lea    0x1(%eax),%esi
  102e88:	0f b6 00             	movzbl (%eax),%eax
  102e8b:	0f be d8             	movsbl %al,%ebx
  102e8e:	85 db                	test   %ebx,%ebx
  102e90:	74 10                	je     102ea2 <vprintfmt+0x24a>
  102e92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e96:	78 b3                	js     102e4b <vprintfmt+0x1f3>
  102e98:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102e9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ea0:	79 a9                	jns    102e4b <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102ea2:	eb 17                	jmp    102ebb <vprintfmt+0x263>
                putch(' ', putdat);
  102ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eab:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb5:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102eb7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ebb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ebf:	7f e3                	jg     102ea4 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102ec1:	e9 70 01 00 00       	jmp    103036 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ecd:	8d 45 14             	lea    0x14(%ebp),%eax
  102ed0:	89 04 24             	mov    %eax,(%esp)
  102ed3:	e8 0b fd ff ff       	call   102be3 <getint>
  102ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102edb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ee4:	85 d2                	test   %edx,%edx
  102ee6:	79 26                	jns    102f0e <vprintfmt+0x2b6>
                putch('-', putdat);
  102ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eef:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef9:	ff d0                	call   *%eax
                num = -(long long)num;
  102efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f01:	f7 d8                	neg    %eax
  102f03:	83 d2 00             	adc    $0x0,%edx
  102f06:	f7 da                	neg    %edx
  102f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102f0e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f15:	e9 a8 00 00 00       	jmp    102fc2 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102f1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f21:	8d 45 14             	lea    0x14(%ebp),%eax
  102f24:	89 04 24             	mov    %eax,(%esp)
  102f27:	e8 68 fc ff ff       	call   102b94 <getuint>
  102f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102f32:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f39:	e9 84 00 00 00       	jmp    102fc2 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f41:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f45:	8d 45 14             	lea    0x14(%ebp),%eax
  102f48:	89 04 24             	mov    %eax,(%esp)
  102f4b:	e8 44 fc ff ff       	call   102b94 <getuint>
  102f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f53:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f56:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f5d:	eb 63                	jmp    102fc2 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f62:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f66:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f70:	ff d0                	call   *%eax
            putch('x', putdat);
  102f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f75:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f79:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102f80:	8b 45 08             	mov    0x8(%ebp),%eax
  102f83:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102f85:	8b 45 14             	mov    0x14(%ebp),%eax
  102f88:	8d 50 04             	lea    0x4(%eax),%edx
  102f8b:	89 55 14             	mov    %edx,0x14(%ebp)
  102f8e:	8b 00                	mov    (%eax),%eax
  102f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102f9a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102fa1:	eb 1f                	jmp    102fc2 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102fa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102faa:	8d 45 14             	lea    0x14(%ebp),%eax
  102fad:	89 04 24             	mov    %eax,(%esp)
  102fb0:	e8 df fb ff ff       	call   102b94 <getuint>
  102fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fb8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102fbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102fc2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc9:	89 54 24 18          	mov    %edx,0x18(%esp)
  102fcd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102fd0:	89 54 24 14          	mov    %edx,0x14(%esp)
  102fd4:	89 44 24 10          	mov    %eax,0x10(%esp)
  102fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fde:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fe2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fed:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff0:	89 04 24             	mov    %eax,(%esp)
  102ff3:	e8 97 fa ff ff       	call   102a8f <printnum>
            break;
  102ff8:	eb 3c                	jmp    103036 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ffd:	89 44 24 04          	mov    %eax,0x4(%esp)
  103001:	89 1c 24             	mov    %ebx,(%esp)
  103004:	8b 45 08             	mov    0x8(%ebp),%eax
  103007:	ff d0                	call   *%eax
            break;
  103009:	eb 2b                	jmp    103036 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10300b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10300e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103012:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103019:	8b 45 08             	mov    0x8(%ebp),%eax
  10301c:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10301e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103022:	eb 04                	jmp    103028 <vprintfmt+0x3d0>
  103024:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103028:	8b 45 10             	mov    0x10(%ebp),%eax
  10302b:	83 e8 01             	sub    $0x1,%eax
  10302e:	0f b6 00             	movzbl (%eax),%eax
  103031:	3c 25                	cmp    $0x25,%al
  103033:	75 ef                	jne    103024 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  103035:	90                   	nop
        }
    }
  103036:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103037:	e9 3e fc ff ff       	jmp    102c7a <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10303c:	83 c4 40             	add    $0x40,%esp
  10303f:	5b                   	pop    %ebx
  103040:	5e                   	pop    %esi
  103041:	5d                   	pop    %ebp
  103042:	c3                   	ret    

00103043 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103043:	55                   	push   %ebp
  103044:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103046:	8b 45 0c             	mov    0xc(%ebp),%eax
  103049:	8b 40 08             	mov    0x8(%eax),%eax
  10304c:	8d 50 01             	lea    0x1(%eax),%edx
  10304f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103052:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103055:	8b 45 0c             	mov    0xc(%ebp),%eax
  103058:	8b 10                	mov    (%eax),%edx
  10305a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10305d:	8b 40 04             	mov    0x4(%eax),%eax
  103060:	39 c2                	cmp    %eax,%edx
  103062:	73 12                	jae    103076 <sprintputch+0x33>
        *b->buf ++ = ch;
  103064:	8b 45 0c             	mov    0xc(%ebp),%eax
  103067:	8b 00                	mov    (%eax),%eax
  103069:	8d 48 01             	lea    0x1(%eax),%ecx
  10306c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10306f:	89 0a                	mov    %ecx,(%edx)
  103071:	8b 55 08             	mov    0x8(%ebp),%edx
  103074:	88 10                	mov    %dl,(%eax)
    }
}
  103076:	5d                   	pop    %ebp
  103077:	c3                   	ret    

00103078 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103078:	55                   	push   %ebp
  103079:	89 e5                	mov    %esp,%ebp
  10307b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10307e:	8d 45 14             	lea    0x14(%ebp),%eax
  103081:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103087:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10308b:	8b 45 10             	mov    0x10(%ebp),%eax
  10308e:	89 44 24 08          	mov    %eax,0x8(%esp)
  103092:	8b 45 0c             	mov    0xc(%ebp),%eax
  103095:	89 44 24 04          	mov    %eax,0x4(%esp)
  103099:	8b 45 08             	mov    0x8(%ebp),%eax
  10309c:	89 04 24             	mov    %eax,(%esp)
  10309f:	e8 08 00 00 00       	call   1030ac <vsnprintf>
  1030a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030aa:	c9                   	leave  
  1030ab:	c3                   	ret    

001030ac <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1030ac:	55                   	push   %ebp
  1030ad:	89 e5                	mov    %esp,%ebp
  1030af:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030be:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c1:	01 d0                	add    %edx,%eax
  1030c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1030cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1030d1:	74 0a                	je     1030dd <vsnprintf+0x31>
  1030d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1030d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030d9:	39 c2                	cmp    %eax,%edx
  1030db:	76 07                	jbe    1030e4 <vsnprintf+0x38>
        return -E_INVAL;
  1030dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1030e2:	eb 2a                	jmp    10310e <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1030e4:	8b 45 14             	mov    0x14(%ebp),%eax
  1030e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1030ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030f2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1030f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030f9:	c7 04 24 43 30 10 00 	movl   $0x103043,(%esp)
  103100:	e8 53 fb ff ff       	call   102c58 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103105:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103108:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10310e:	c9                   	leave  
  10310f:	c3                   	ret    

00103110 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  103110:	55                   	push   %ebp
  103111:	89 e5                	mov    %esp,%ebp
  103113:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103116:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10311d:	eb 04                	jmp    103123 <strlen+0x13>
        cnt ++;
  10311f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  103123:	8b 45 08             	mov    0x8(%ebp),%eax
  103126:	8d 50 01             	lea    0x1(%eax),%edx
  103129:	89 55 08             	mov    %edx,0x8(%ebp)
  10312c:	0f b6 00             	movzbl (%eax),%eax
  10312f:	84 c0                	test   %al,%al
  103131:	75 ec                	jne    10311f <strlen+0xf>
        cnt ++;
    }
    return cnt;
  103133:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103136:	c9                   	leave  
  103137:	c3                   	ret    

00103138 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103138:	55                   	push   %ebp
  103139:	89 e5                	mov    %esp,%ebp
  10313b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10313e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103145:	eb 04                	jmp    10314b <strnlen+0x13>
        cnt ++;
  103147:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10314b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10314e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103151:	73 10                	jae    103163 <strnlen+0x2b>
  103153:	8b 45 08             	mov    0x8(%ebp),%eax
  103156:	8d 50 01             	lea    0x1(%eax),%edx
  103159:	89 55 08             	mov    %edx,0x8(%ebp)
  10315c:	0f b6 00             	movzbl (%eax),%eax
  10315f:	84 c0                	test   %al,%al
  103161:	75 e4                	jne    103147 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  103163:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103166:	c9                   	leave  
  103167:	c3                   	ret    

00103168 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103168:	55                   	push   %ebp
  103169:	89 e5                	mov    %esp,%ebp
  10316b:	57                   	push   %edi
  10316c:	56                   	push   %esi
  10316d:	83 ec 20             	sub    $0x20,%esp
  103170:	8b 45 08             	mov    0x8(%ebp),%eax
  103173:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103176:	8b 45 0c             	mov    0xc(%ebp),%eax
  103179:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10317c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10317f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103182:	89 d1                	mov    %edx,%ecx
  103184:	89 c2                	mov    %eax,%edx
  103186:	89 ce                	mov    %ecx,%esi
  103188:	89 d7                	mov    %edx,%edi
  10318a:	ac                   	lods   %ds:(%esi),%al
  10318b:	aa                   	stos   %al,%es:(%edi)
  10318c:	84 c0                	test   %al,%al
  10318e:	75 fa                	jne    10318a <strcpy+0x22>
  103190:	89 fa                	mov    %edi,%edx
  103192:	89 f1                	mov    %esi,%ecx
  103194:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103197:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10319a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10319d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1031a0:	83 c4 20             	add    $0x20,%esp
  1031a3:	5e                   	pop    %esi
  1031a4:	5f                   	pop    %edi
  1031a5:	5d                   	pop    %ebp
  1031a6:	c3                   	ret    

001031a7 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1031a7:	55                   	push   %ebp
  1031a8:	89 e5                	mov    %esp,%ebp
  1031aa:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1031b3:	eb 21                	jmp    1031d6 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1031b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b8:	0f b6 10             	movzbl (%eax),%edx
  1031bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031be:	88 10                	mov    %dl,(%eax)
  1031c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031c3:	0f b6 00             	movzbl (%eax),%eax
  1031c6:	84 c0                	test   %al,%al
  1031c8:	74 04                	je     1031ce <strncpy+0x27>
            src ++;
  1031ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1031ce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1031d2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1031d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031da:	75 d9                	jne    1031b5 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1031dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031df:	c9                   	leave  
  1031e0:	c3                   	ret    

001031e1 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1031e1:	55                   	push   %ebp
  1031e2:	89 e5                	mov    %esp,%ebp
  1031e4:	57                   	push   %edi
  1031e5:	56                   	push   %esi
  1031e6:	83 ec 20             	sub    $0x20,%esp
  1031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1031f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031fb:	89 d1                	mov    %edx,%ecx
  1031fd:	89 c2                	mov    %eax,%edx
  1031ff:	89 ce                	mov    %ecx,%esi
  103201:	89 d7                	mov    %edx,%edi
  103203:	ac                   	lods   %ds:(%esi),%al
  103204:	ae                   	scas   %es:(%edi),%al
  103205:	75 08                	jne    10320f <strcmp+0x2e>
  103207:	84 c0                	test   %al,%al
  103209:	75 f8                	jne    103203 <strcmp+0x22>
  10320b:	31 c0                	xor    %eax,%eax
  10320d:	eb 04                	jmp    103213 <strcmp+0x32>
  10320f:	19 c0                	sbb    %eax,%eax
  103211:	0c 01                	or     $0x1,%al
  103213:	89 fa                	mov    %edi,%edx
  103215:	89 f1                	mov    %esi,%ecx
  103217:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10321a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10321d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  103220:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103223:	83 c4 20             	add    $0x20,%esp
  103226:	5e                   	pop    %esi
  103227:	5f                   	pop    %edi
  103228:	5d                   	pop    %ebp
  103229:	c3                   	ret    

0010322a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10322a:	55                   	push   %ebp
  10322b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10322d:	eb 0c                	jmp    10323b <strncmp+0x11>
        n --, s1 ++, s2 ++;
  10322f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103233:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103237:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10323b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10323f:	74 1a                	je     10325b <strncmp+0x31>
  103241:	8b 45 08             	mov    0x8(%ebp),%eax
  103244:	0f b6 00             	movzbl (%eax),%eax
  103247:	84 c0                	test   %al,%al
  103249:	74 10                	je     10325b <strncmp+0x31>
  10324b:	8b 45 08             	mov    0x8(%ebp),%eax
  10324e:	0f b6 10             	movzbl (%eax),%edx
  103251:	8b 45 0c             	mov    0xc(%ebp),%eax
  103254:	0f b6 00             	movzbl (%eax),%eax
  103257:	38 c2                	cmp    %al,%dl
  103259:	74 d4                	je     10322f <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10325b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10325f:	74 18                	je     103279 <strncmp+0x4f>
  103261:	8b 45 08             	mov    0x8(%ebp),%eax
  103264:	0f b6 00             	movzbl (%eax),%eax
  103267:	0f b6 d0             	movzbl %al,%edx
  10326a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10326d:	0f b6 00             	movzbl (%eax),%eax
  103270:	0f b6 c0             	movzbl %al,%eax
  103273:	29 c2                	sub    %eax,%edx
  103275:	89 d0                	mov    %edx,%eax
  103277:	eb 05                	jmp    10327e <strncmp+0x54>
  103279:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10327e:	5d                   	pop    %ebp
  10327f:	c3                   	ret    

00103280 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103280:	55                   	push   %ebp
  103281:	89 e5                	mov    %esp,%ebp
  103283:	83 ec 04             	sub    $0x4,%esp
  103286:	8b 45 0c             	mov    0xc(%ebp),%eax
  103289:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10328c:	eb 14                	jmp    1032a2 <strchr+0x22>
        if (*s == c) {
  10328e:	8b 45 08             	mov    0x8(%ebp),%eax
  103291:	0f b6 00             	movzbl (%eax),%eax
  103294:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103297:	75 05                	jne    10329e <strchr+0x1e>
            return (char *)s;
  103299:	8b 45 08             	mov    0x8(%ebp),%eax
  10329c:	eb 13                	jmp    1032b1 <strchr+0x31>
        }
        s ++;
  10329e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1032a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a5:	0f b6 00             	movzbl (%eax),%eax
  1032a8:	84 c0                	test   %al,%al
  1032aa:	75 e2                	jne    10328e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  1032ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032b1:	c9                   	leave  
  1032b2:	c3                   	ret    

001032b3 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1032b3:	55                   	push   %ebp
  1032b4:	89 e5                	mov    %esp,%ebp
  1032b6:	83 ec 04             	sub    $0x4,%esp
  1032b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032bc:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1032bf:	eb 11                	jmp    1032d2 <strfind+0x1f>
        if (*s == c) {
  1032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c4:	0f b6 00             	movzbl (%eax),%eax
  1032c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1032ca:	75 02                	jne    1032ce <strfind+0x1b>
            break;
  1032cc:	eb 0e                	jmp    1032dc <strfind+0x29>
        }
        s ++;
  1032ce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d5:	0f b6 00             	movzbl (%eax),%eax
  1032d8:	84 c0                	test   %al,%al
  1032da:	75 e5                	jne    1032c1 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1032dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1032df:	c9                   	leave  
  1032e0:	c3                   	ret    

001032e1 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1032e1:	55                   	push   %ebp
  1032e2:	89 e5                	mov    %esp,%ebp
  1032e4:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1032e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1032ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032f5:	eb 04                	jmp    1032fb <strtol+0x1a>
        s ++;
  1032f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1032fe:	0f b6 00             	movzbl (%eax),%eax
  103301:	3c 20                	cmp    $0x20,%al
  103303:	74 f2                	je     1032f7 <strtol+0x16>
  103305:	8b 45 08             	mov    0x8(%ebp),%eax
  103308:	0f b6 00             	movzbl (%eax),%eax
  10330b:	3c 09                	cmp    $0x9,%al
  10330d:	74 e8                	je     1032f7 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  10330f:	8b 45 08             	mov    0x8(%ebp),%eax
  103312:	0f b6 00             	movzbl (%eax),%eax
  103315:	3c 2b                	cmp    $0x2b,%al
  103317:	75 06                	jne    10331f <strtol+0x3e>
        s ++;
  103319:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10331d:	eb 15                	jmp    103334 <strtol+0x53>
    }
    else if (*s == '-') {
  10331f:	8b 45 08             	mov    0x8(%ebp),%eax
  103322:	0f b6 00             	movzbl (%eax),%eax
  103325:	3c 2d                	cmp    $0x2d,%al
  103327:	75 0b                	jne    103334 <strtol+0x53>
        s ++, neg = 1;
  103329:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10332d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103334:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103338:	74 06                	je     103340 <strtol+0x5f>
  10333a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10333e:	75 24                	jne    103364 <strtol+0x83>
  103340:	8b 45 08             	mov    0x8(%ebp),%eax
  103343:	0f b6 00             	movzbl (%eax),%eax
  103346:	3c 30                	cmp    $0x30,%al
  103348:	75 1a                	jne    103364 <strtol+0x83>
  10334a:	8b 45 08             	mov    0x8(%ebp),%eax
  10334d:	83 c0 01             	add    $0x1,%eax
  103350:	0f b6 00             	movzbl (%eax),%eax
  103353:	3c 78                	cmp    $0x78,%al
  103355:	75 0d                	jne    103364 <strtol+0x83>
        s += 2, base = 16;
  103357:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10335b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103362:	eb 2a                	jmp    10338e <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103364:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103368:	75 17                	jne    103381 <strtol+0xa0>
  10336a:	8b 45 08             	mov    0x8(%ebp),%eax
  10336d:	0f b6 00             	movzbl (%eax),%eax
  103370:	3c 30                	cmp    $0x30,%al
  103372:	75 0d                	jne    103381 <strtol+0xa0>
        s ++, base = 8;
  103374:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103378:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10337f:	eb 0d                	jmp    10338e <strtol+0xad>
    }
    else if (base == 0) {
  103381:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103385:	75 07                	jne    10338e <strtol+0xad>
        base = 10;
  103387:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10338e:	8b 45 08             	mov    0x8(%ebp),%eax
  103391:	0f b6 00             	movzbl (%eax),%eax
  103394:	3c 2f                	cmp    $0x2f,%al
  103396:	7e 1b                	jle    1033b3 <strtol+0xd2>
  103398:	8b 45 08             	mov    0x8(%ebp),%eax
  10339b:	0f b6 00             	movzbl (%eax),%eax
  10339e:	3c 39                	cmp    $0x39,%al
  1033a0:	7f 11                	jg     1033b3 <strtol+0xd2>
            dig = *s - '0';
  1033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a5:	0f b6 00             	movzbl (%eax),%eax
  1033a8:	0f be c0             	movsbl %al,%eax
  1033ab:	83 e8 30             	sub    $0x30,%eax
  1033ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033b1:	eb 48                	jmp    1033fb <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b6:	0f b6 00             	movzbl (%eax),%eax
  1033b9:	3c 60                	cmp    $0x60,%al
  1033bb:	7e 1b                	jle    1033d8 <strtol+0xf7>
  1033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c0:	0f b6 00             	movzbl (%eax),%eax
  1033c3:	3c 7a                	cmp    $0x7a,%al
  1033c5:	7f 11                	jg     1033d8 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1033ca:	0f b6 00             	movzbl (%eax),%eax
  1033cd:	0f be c0             	movsbl %al,%eax
  1033d0:	83 e8 57             	sub    $0x57,%eax
  1033d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033d6:	eb 23                	jmp    1033fb <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1033d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1033db:	0f b6 00             	movzbl (%eax),%eax
  1033de:	3c 40                	cmp    $0x40,%al
  1033e0:	7e 3d                	jle    10341f <strtol+0x13e>
  1033e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e5:	0f b6 00             	movzbl (%eax),%eax
  1033e8:	3c 5a                	cmp    $0x5a,%al
  1033ea:	7f 33                	jg     10341f <strtol+0x13e>
            dig = *s - 'A' + 10;
  1033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1033ef:	0f b6 00             	movzbl (%eax),%eax
  1033f2:	0f be c0             	movsbl %al,%eax
  1033f5:	83 e8 37             	sub    $0x37,%eax
  1033f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1033fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033fe:	3b 45 10             	cmp    0x10(%ebp),%eax
  103401:	7c 02                	jl     103405 <strtol+0x124>
            break;
  103403:	eb 1a                	jmp    10341f <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103405:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103409:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10340c:	0f af 45 10          	imul   0x10(%ebp),%eax
  103410:	89 c2                	mov    %eax,%edx
  103412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103415:	01 d0                	add    %edx,%eax
  103417:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10341a:	e9 6f ff ff ff       	jmp    10338e <strtol+0xad>

    if (endptr) {
  10341f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103423:	74 08                	je     10342d <strtol+0x14c>
        *endptr = (char *) s;
  103425:	8b 45 0c             	mov    0xc(%ebp),%eax
  103428:	8b 55 08             	mov    0x8(%ebp),%edx
  10342b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10342d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103431:	74 07                	je     10343a <strtol+0x159>
  103433:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103436:	f7 d8                	neg    %eax
  103438:	eb 03                	jmp    10343d <strtol+0x15c>
  10343a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10343d:	c9                   	leave  
  10343e:	c3                   	ret    

0010343f <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10343f:	55                   	push   %ebp
  103440:	89 e5                	mov    %esp,%ebp
  103442:	57                   	push   %edi
  103443:	83 ec 24             	sub    $0x24,%esp
  103446:	8b 45 0c             	mov    0xc(%ebp),%eax
  103449:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10344c:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103450:	8b 55 08             	mov    0x8(%ebp),%edx
  103453:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103456:	88 45 f7             	mov    %al,-0x9(%ebp)
  103459:	8b 45 10             	mov    0x10(%ebp),%eax
  10345c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10345f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103462:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103466:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103469:	89 d7                	mov    %edx,%edi
  10346b:	f3 aa                	rep stos %al,%es:(%edi)
  10346d:	89 fa                	mov    %edi,%edx
  10346f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103472:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103475:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103478:	83 c4 24             	add    $0x24,%esp
  10347b:	5f                   	pop    %edi
  10347c:	5d                   	pop    %ebp
  10347d:	c3                   	ret    

0010347e <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10347e:	55                   	push   %ebp
  10347f:	89 e5                	mov    %esp,%ebp
  103481:	57                   	push   %edi
  103482:	56                   	push   %esi
  103483:	53                   	push   %ebx
  103484:	83 ec 30             	sub    $0x30,%esp
  103487:	8b 45 08             	mov    0x8(%ebp),%eax
  10348a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10348d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103490:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103493:	8b 45 10             	mov    0x10(%ebp),%eax
  103496:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10349c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10349f:	73 42                	jae    1034e3 <memmove+0x65>
  1034a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1034ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1034b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1034b6:	c1 e8 02             	shr    $0x2,%eax
  1034b9:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1034bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1034be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034c1:	89 d7                	mov    %edx,%edi
  1034c3:	89 c6                	mov    %eax,%esi
  1034c5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1034c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1034ca:	83 e1 03             	and    $0x3,%ecx
  1034cd:	74 02                	je     1034d1 <memmove+0x53>
  1034cf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034d1:	89 f0                	mov    %esi,%eax
  1034d3:	89 fa                	mov    %edi,%edx
  1034d5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1034d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1034db:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1034de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034e1:	eb 36                	jmp    103519 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1034e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034ec:	01 c2                	add    %eax,%edx
  1034ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034f1:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1034f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034f7:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1034fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034fd:	89 c1                	mov    %eax,%ecx
  1034ff:	89 d8                	mov    %ebx,%eax
  103501:	89 d6                	mov    %edx,%esi
  103503:	89 c7                	mov    %eax,%edi
  103505:	fd                   	std    
  103506:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103508:	fc                   	cld    
  103509:	89 f8                	mov    %edi,%eax
  10350b:	89 f2                	mov    %esi,%edx
  10350d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103510:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103513:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  103516:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103519:	83 c4 30             	add    $0x30,%esp
  10351c:	5b                   	pop    %ebx
  10351d:	5e                   	pop    %esi
  10351e:	5f                   	pop    %edi
  10351f:	5d                   	pop    %ebp
  103520:	c3                   	ret    

00103521 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103521:	55                   	push   %ebp
  103522:	89 e5                	mov    %esp,%ebp
  103524:	57                   	push   %edi
  103525:	56                   	push   %esi
  103526:	83 ec 20             	sub    $0x20,%esp
  103529:	8b 45 08             	mov    0x8(%ebp),%eax
  10352c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10352f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103532:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103535:	8b 45 10             	mov    0x10(%ebp),%eax
  103538:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10353b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10353e:	c1 e8 02             	shr    $0x2,%eax
  103541:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103549:	89 d7                	mov    %edx,%edi
  10354b:	89 c6                	mov    %eax,%esi
  10354d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10354f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103552:	83 e1 03             	and    $0x3,%ecx
  103555:	74 02                	je     103559 <memcpy+0x38>
  103557:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103559:	89 f0                	mov    %esi,%eax
  10355b:	89 fa                	mov    %edi,%edx
  10355d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103560:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103563:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103566:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103569:	83 c4 20             	add    $0x20,%esp
  10356c:	5e                   	pop    %esi
  10356d:	5f                   	pop    %edi
  10356e:	5d                   	pop    %ebp
  10356f:	c3                   	ret    

00103570 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103570:	55                   	push   %ebp
  103571:	89 e5                	mov    %esp,%ebp
  103573:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103576:	8b 45 08             	mov    0x8(%ebp),%eax
  103579:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10357c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10357f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103582:	eb 30                	jmp    1035b4 <memcmp+0x44>
        if (*s1 != *s2) {
  103584:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103587:	0f b6 10             	movzbl (%eax),%edx
  10358a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10358d:	0f b6 00             	movzbl (%eax),%eax
  103590:	38 c2                	cmp    %al,%dl
  103592:	74 18                	je     1035ac <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103594:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103597:	0f b6 00             	movzbl (%eax),%eax
  10359a:	0f b6 d0             	movzbl %al,%edx
  10359d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035a0:	0f b6 00             	movzbl (%eax),%eax
  1035a3:	0f b6 c0             	movzbl %al,%eax
  1035a6:	29 c2                	sub    %eax,%edx
  1035a8:	89 d0                	mov    %edx,%eax
  1035aa:	eb 1a                	jmp    1035c6 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1035ac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1035b0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1035b4:	8b 45 10             	mov    0x10(%ebp),%eax
  1035b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1035ba:	89 55 10             	mov    %edx,0x10(%ebp)
  1035bd:	85 c0                	test   %eax,%eax
  1035bf:	75 c3                	jne    103584 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1035c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035c6:	c9                   	leave  
  1035c7:	c3                   	ret    
