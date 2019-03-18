
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
  100027:	e8 3e 34 00 00       	call   10346a <memset>

    cons_init();                // init the console
  10002c:	e8 4e 15 00 00       	call   10157f <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 00 36 10 00 	movl   $0x103600,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 1c 36 10 00 	movl   $0x10361c,(%esp)
  100046:	e8 cc 02 00 00       	call   100317 <cprintf>

    print_kerninfo();
  10004b:	e8 fb 07 00 00       	call   10084b <print_kerninfo>

    grade_backtrace();
  100050:	e8 8b 00 00 00       	call   1000e0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 56 2a 00 00       	call   102ab0 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 63 16 00 00       	call   1016c2 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 db 17 00 00       	call   10183f <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 09 0d 00 00       	call   100d72 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 c2 15 00 00       	call   101630 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 62 01 00 00       	call   1001d5 <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 fc 0b 00 00       	call   100c93 <mon_backtrace>
}
  100097:	c9                   	leave  
  100098:	c3                   	ret    

00100099 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100099:	55                   	push   %ebp
  10009a:	89 e5                	mov    %esp,%ebp
  10009c:	53                   	push   %ebx
  10009d:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a6:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b8:	89 04 24             	mov    %eax,(%esp)
  1000bb:	e8 b5 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c0:	83 c4 14             	add    $0x14,%esp
  1000c3:	5b                   	pop    %ebx
  1000c4:	5d                   	pop    %ebp
  1000c5:	c3                   	ret    

001000c6 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c6:	55                   	push   %ebp
  1000c7:	89 e5                	mov    %esp,%ebp
  1000c9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d6:	89 04 24             	mov    %eax,(%esp)
  1000d9:	e8 bb ff ff ff       	call   100099 <grade_backtrace1>
}
  1000de:	c9                   	leave  
  1000df:	c3                   	ret    

001000e0 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e0:	55                   	push   %ebp
  1000e1:	89 e5                	mov    %esp,%ebp
  1000e3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e6:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000eb:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f2:	ff 
  1000f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000fe:	e8 c3 ff ff ff       	call   1000c6 <grade_backtrace0>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100111:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100114:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100117:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011b:	0f b7 c0             	movzwl %ax,%eax
  10011e:	83 e0 03             	and    $0x3,%eax
  100121:	89 c2                	mov    %eax,%edx
  100123:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100128:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100130:	c7 04 24 21 36 10 00 	movl   $0x103621,(%esp)
  100137:	e8 db 01 00 00       	call   100317 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 d0             	movzwl %ax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 2f 36 10 00 	movl   $0x10362f,(%esp)
  100157:	e8 bb 01 00 00       	call   100317 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	0f b7 d0             	movzwl %ax,%edx
  100163:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100168:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100170:	c7 04 24 3d 36 10 00 	movl   $0x10363d,(%esp)
  100177:	e8 9b 01 00 00       	call   100317 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100180:	0f b7 d0             	movzwl %ax,%edx
  100183:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100188:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100190:	c7 04 24 4b 36 10 00 	movl   $0x10364b,(%esp)
  100197:	e8 7b 01 00 00       	call   100317 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a0:	0f b7 d0             	movzwl %ax,%edx
  1001a3:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b0:	c7 04 24 59 36 10 00 	movl   $0x103659,(%esp)
  1001b7:	e8 5b 01 00 00       	call   100317 <cprintf>
    round ++;
  1001bc:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c9:	c9                   	leave  
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001d3:	5d                   	pop    %ebp
  1001d4:	c3                   	ret    

001001d5 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d5:	55                   	push   %ebp
  1001d6:	89 e5                	mov    %esp,%ebp
  1001d8:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001db:	e8 25 ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e0:	c7 04 24 68 36 10 00 	movl   $0x103668,(%esp)
  1001e7:	e8 2b 01 00 00       	call   100317 <cprintf>
    lab1_switch_to_user();
  1001ec:	e8 da ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f1:	e8 0f ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f6:	c7 04 24 88 36 10 00 	movl   $0x103688,(%esp)
  1001fd:	e8 15 01 00 00       	call   100317 <cprintf>
    lab1_switch_to_kernel();
  100202:	e8 c9 ff ff ff       	call   1001d0 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100207:	e8 f9 fe ff ff       	call   100105 <lab1_print_cur_status>
}
  10020c:	c9                   	leave  
  10020d:	c3                   	ret    

0010020e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10020e:	55                   	push   %ebp
  10020f:	89 e5                	mov    %esp,%ebp
  100211:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100214:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100218:	74 13                	je     10022d <readline+0x1f>
        cprintf("%s", prompt);
  10021a:	8b 45 08             	mov    0x8(%ebp),%eax
  10021d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100221:	c7 04 24 a7 36 10 00 	movl   $0x1036a7,(%esp)
  100228:	e8 ea 00 00 00       	call   100317 <cprintf>
    }
    int i = 0, c;
  10022d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100234:	e8 66 01 00 00       	call   10039f <getchar>
  100239:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10023c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100240:	79 07                	jns    100249 <readline+0x3b>
            return NULL;
  100242:	b8 00 00 00 00       	mov    $0x0,%eax
  100247:	eb 79                	jmp    1002c2 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100249:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10024d:	7e 28                	jle    100277 <readline+0x69>
  10024f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100256:	7f 1f                	jg     100277 <readline+0x69>
            cputchar(c);
  100258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025b:	89 04 24             	mov    %eax,(%esp)
  10025e:	e8 da 00 00 00       	call   10033d <cputchar>
            buf[i ++] = c;
  100263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100266:	8d 50 01             	lea    0x1(%eax),%edx
  100269:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10026c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026f:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100275:	eb 46                	jmp    1002bd <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100277:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10027b:	75 17                	jne    100294 <readline+0x86>
  10027d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100281:	7e 11                	jle    100294 <readline+0x86>
            cputchar(c);
  100283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100286:	89 04 24             	mov    %eax,(%esp)
  100289:	e8 af 00 00 00       	call   10033d <cputchar>
            i --;
  10028e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100292:	eb 29                	jmp    1002bd <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  100294:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100298:	74 06                	je     1002a0 <readline+0x92>
  10029a:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10029e:	75 1d                	jne    1002bd <readline+0xaf>
            cputchar(c);
  1002a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a3:	89 04 24             	mov    %eax,(%esp)
  1002a6:	e8 92 00 00 00       	call   10033d <cputchar>
            buf[i] = '\0';
  1002ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002ae:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002b3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b6:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002bb:	eb 05                	jmp    1002c2 <readline+0xb4>
        }
    }
  1002bd:	e9 72 ff ff ff       	jmp    100234 <readline+0x26>
}
  1002c2:	c9                   	leave  
  1002c3:	c3                   	ret    

001002c4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002c4:	55                   	push   %ebp
  1002c5:	89 e5                	mov    %esp,%ebp
  1002c7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cd:	89 04 24             	mov    %eax,(%esp)
  1002d0:	e8 d6 12 00 00       	call   1015ab <cons_putc>
    (*cnt) ++;
  1002d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d8:	8b 00                	mov    (%eax),%eax
  1002da:	8d 50 01             	lea    0x1(%eax),%edx
  1002dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e0:	89 10                	mov    %edx,(%eax)
}
  1002e2:	c9                   	leave  
  1002e3:	c3                   	ret    

001002e4 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002e4:	55                   	push   %ebp
  1002e5:	89 e5                	mov    %esp,%ebp
  1002e7:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100302:	89 44 24 04          	mov    %eax,0x4(%esp)
  100306:	c7 04 24 c4 02 10 00 	movl   $0x1002c4,(%esp)
  10030d:	e8 71 29 00 00       	call   102c83 <vprintfmt>
    return cnt;
  100312:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100315:	c9                   	leave  
  100316:	c3                   	ret    

00100317 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100317:	55                   	push   %ebp
  100318:	89 e5                	mov    %esp,%ebp
  10031a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10031d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100320:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100326:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032a:	8b 45 08             	mov    0x8(%ebp),%eax
  10032d:	89 04 24             	mov    %eax,(%esp)
  100330:	e8 af ff ff ff       	call   1002e4 <vcprintf>
  100335:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100338:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033b:	c9                   	leave  
  10033c:	c3                   	ret    

0010033d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10033d:	55                   	push   %ebp
  10033e:	89 e5                	mov    %esp,%ebp
  100340:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100343:	8b 45 08             	mov    0x8(%ebp),%eax
  100346:	89 04 24             	mov    %eax,(%esp)
  100349:	e8 5d 12 00 00       	call   1015ab <cons_putc>
}
  10034e:	c9                   	leave  
  10034f:	c3                   	ret    

00100350 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100350:	55                   	push   %ebp
  100351:	89 e5                	mov    %esp,%ebp
  100353:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100356:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10035d:	eb 13                	jmp    100372 <cputs+0x22>
        cputch(c, &cnt);
  10035f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100363:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100366:	89 54 24 04          	mov    %edx,0x4(%esp)
  10036a:	89 04 24             	mov    %eax,(%esp)
  10036d:	e8 52 ff ff ff       	call   1002c4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100372:	8b 45 08             	mov    0x8(%ebp),%eax
  100375:	8d 50 01             	lea    0x1(%eax),%edx
  100378:	89 55 08             	mov    %edx,0x8(%ebp)
  10037b:	0f b6 00             	movzbl (%eax),%eax
  10037e:	88 45 f7             	mov    %al,-0x9(%ebp)
  100381:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100385:	75 d8                	jne    10035f <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100387:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10038a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10038e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100395:	e8 2a ff ff ff       	call   1002c4 <cputch>
    return cnt;
  10039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10039d:	c9                   	leave  
  10039e:	c3                   	ret    

0010039f <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039f:	55                   	push   %ebp
  1003a0:	89 e5                	mov    %esp,%ebp
  1003a2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a5:	e8 2a 12 00 00       	call   1015d4 <cons_getc>
  1003aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003b1:	74 f2                	je     1003a5 <getchar+0x6>
        /* do nothing */;
    return c;
  1003b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b6:	c9                   	leave  
  1003b7:	c3                   	ret    

001003b8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b8:	55                   	push   %ebp
  1003b9:	89 e5                	mov    %esp,%ebp
  1003bb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003c1:	8b 00                	mov    (%eax),%eax
  1003c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c9:	8b 00                	mov    (%eax),%eax
  1003cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d5:	e9 d2 00 00 00       	jmp    1004ac <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003e0:	01 d0                	add    %edx,%eax
  1003e2:	89 c2                	mov    %eax,%edx
  1003e4:	c1 ea 1f             	shr    $0x1f,%edx
  1003e7:	01 d0                	add    %edx,%eax
  1003e9:	d1 f8                	sar    %eax
  1003eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003f1:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f4:	eb 04                	jmp    1003fa <stab_binsearch+0x42>
            m --;
  1003f6:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100400:	7c 1f                	jl     100421 <stab_binsearch+0x69>
  100402:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100405:	89 d0                	mov    %edx,%eax
  100407:	01 c0                	add    %eax,%eax
  100409:	01 d0                	add    %edx,%eax
  10040b:	c1 e0 02             	shl    $0x2,%eax
  10040e:	89 c2                	mov    %eax,%edx
  100410:	8b 45 08             	mov    0x8(%ebp),%eax
  100413:	01 d0                	add    %edx,%eax
  100415:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100419:	0f b6 c0             	movzbl %al,%eax
  10041c:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041f:	75 d5                	jne    1003f6 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100424:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100427:	7d 0b                	jge    100434 <stab_binsearch+0x7c>
            l = true_m + 1;
  100429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10042c:	83 c0 01             	add    $0x1,%eax
  10042f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100432:	eb 78                	jmp    1004ac <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100434:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10043b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10043e:	89 d0                	mov    %edx,%eax
  100440:	01 c0                	add    %eax,%eax
  100442:	01 d0                	add    %edx,%eax
  100444:	c1 e0 02             	shl    $0x2,%eax
  100447:	89 c2                	mov    %eax,%edx
  100449:	8b 45 08             	mov    0x8(%ebp),%eax
  10044c:	01 d0                	add    %edx,%eax
  10044e:	8b 40 08             	mov    0x8(%eax),%eax
  100451:	3b 45 18             	cmp    0x18(%ebp),%eax
  100454:	73 13                	jae    100469 <stab_binsearch+0xb1>
            *region_left = m;
  100456:	8b 45 0c             	mov    0xc(%ebp),%eax
  100459:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10045c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10045e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100461:	83 c0 01             	add    $0x1,%eax
  100464:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100467:	eb 43                	jmp    1004ac <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100469:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046c:	89 d0                	mov    %edx,%eax
  10046e:	01 c0                	add    %eax,%eax
  100470:	01 d0                	add    %edx,%eax
  100472:	c1 e0 02             	shl    $0x2,%eax
  100475:	89 c2                	mov    %eax,%edx
  100477:	8b 45 08             	mov    0x8(%ebp),%eax
  10047a:	01 d0                	add    %edx,%eax
  10047c:	8b 40 08             	mov    0x8(%eax),%eax
  10047f:	3b 45 18             	cmp    0x18(%ebp),%eax
  100482:	76 16                	jbe    10049a <stab_binsearch+0xe2>
            *region_right = m - 1;
  100484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100487:	8d 50 ff             	lea    -0x1(%eax),%edx
  10048a:	8b 45 10             	mov    0x10(%ebp),%eax
  10048d:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100492:	83 e8 01             	sub    $0x1,%eax
  100495:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100498:	eb 12                	jmp    1004ac <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10049a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004a0:	89 10                	mov    %edx,(%eax)
            l = m;
  1004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004b2:	0f 8e 22 ff ff ff    	jle    1003da <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004bc:	75 0f                	jne    1004cd <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c1:	8b 00                	mov    (%eax),%eax
  1004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c9:	89 10                	mov    %edx,(%eax)
  1004cb:	eb 3f                	jmp    10050c <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d0:	8b 00                	mov    (%eax),%eax
  1004d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d5:	eb 04                	jmp    1004db <stab_binsearch+0x123>
  1004d7:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004de:	8b 00                	mov    (%eax),%eax
  1004e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e3:	7d 1f                	jge    100504 <stab_binsearch+0x14c>
  1004e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e8:	89 d0                	mov    %edx,%eax
  1004ea:	01 c0                	add    %eax,%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	c1 e0 02             	shl    $0x2,%eax
  1004f1:	89 c2                	mov    %eax,%edx
  1004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f6:	01 d0                	add    %edx,%eax
  1004f8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004fc:	0f b6 c0             	movzbl %al,%eax
  1004ff:	3b 45 14             	cmp    0x14(%ebp),%eax
  100502:	75 d3                	jne    1004d7 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100504:	8b 45 0c             	mov    0xc(%ebp),%eax
  100507:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050a:	89 10                	mov    %edx,(%eax)
    }
}
  10050c:	c9                   	leave  
  10050d:	c3                   	ret    

0010050e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10050e:	55                   	push   %ebp
  10050f:	89 e5                	mov    %esp,%ebp
  100511:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100514:	8b 45 0c             	mov    0xc(%ebp),%eax
  100517:	c7 00 ac 36 10 00    	movl   $0x1036ac,(%eax)
    info->eip_line = 0;
  10051d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100520:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100527:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052a:	c7 40 08 ac 36 10 00 	movl   $0x1036ac,0x8(%eax)
    info->eip_fn_namelen = 9;
  100531:	8b 45 0c             	mov    0xc(%ebp),%eax
  100534:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053e:	8b 55 08             	mov    0x8(%ebp),%edx
  100541:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10054e:	c7 45 f4 2c 3f 10 00 	movl   $0x103f2c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100555:	c7 45 f0 14 b7 10 00 	movl   $0x10b714,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10055c:	c7 45 ec 15 b7 10 00 	movl   $0x10b715,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100563:	c7 45 e8 0c d7 10 00 	movl   $0x10d70c,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10056a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10056d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100570:	76 0d                	jbe    10057f <debuginfo_eip+0x71>
  100572:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100575:	83 e8 01             	sub    $0x1,%eax
  100578:	0f b6 00             	movzbl (%eax),%eax
  10057b:	84 c0                	test   %al,%al
  10057d:	74 0a                	je     100589 <debuginfo_eip+0x7b>
        return -1;
  10057f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100584:	e9 c0 02 00 00       	jmp    100849 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100589:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100590:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100596:	29 c2                	sub    %eax,%edx
  100598:	89 d0                	mov    %edx,%eax
  10059a:	c1 f8 02             	sar    $0x2,%eax
  10059d:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005a3:	83 e8 01             	sub    $0x1,%eax
  1005a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005b0:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b7:	00 
  1005b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c9:	89 04 24             	mov    %eax,(%esp)
  1005cc:	e8 e7 fd ff ff       	call   1003b8 <stab_binsearch>
    if (lfile == 0)
  1005d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005d4:	85 c0                	test   %eax,%eax
  1005d6:	75 0a                	jne    1005e2 <debuginfo_eip+0xd4>
        return -1;
  1005d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005dd:	e9 67 02 00 00       	jmp    100849 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f5:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005fc:	00 
  1005fd:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100600:	89 44 24 08          	mov    %eax,0x8(%esp)
  100604:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100607:	89 44 24 04          	mov    %eax,0x4(%esp)
  10060b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10060e:	89 04 24             	mov    %eax,(%esp)
  100611:	e8 a2 fd ff ff       	call   1003b8 <stab_binsearch>

    if (lfun <= rfun) {
  100616:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100619:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10061c:	39 c2                	cmp    %eax,%edx
  10061e:	7f 7c                	jg     10069c <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100620:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100623:	89 c2                	mov    %eax,%edx
  100625:	89 d0                	mov    %edx,%eax
  100627:	01 c0                	add    %eax,%eax
  100629:	01 d0                	add    %edx,%eax
  10062b:	c1 e0 02             	shl    $0x2,%eax
  10062e:	89 c2                	mov    %eax,%edx
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	01 d0                	add    %edx,%eax
  100635:	8b 10                	mov    (%eax),%edx
  100637:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10063a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10063d:	29 c1                	sub    %eax,%ecx
  10063f:	89 c8                	mov    %ecx,%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	73 22                	jae    100667 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065f:	01 c2                	add    %eax,%edx
  100661:	8b 45 0c             	mov    0xc(%ebp),%eax
  100664:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100667:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066a:	89 c2                	mov    %eax,%edx
  10066c:	89 d0                	mov    %edx,%eax
  10066e:	01 c0                	add    %eax,%eax
  100670:	01 d0                	add    %edx,%eax
  100672:	c1 e0 02             	shl    $0x2,%eax
  100675:	89 c2                	mov    %eax,%edx
  100677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067a:	01 d0                	add    %edx,%eax
  10067c:	8b 50 08             	mov    0x8(%eax),%edx
  10067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100682:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100685:	8b 45 0c             	mov    0xc(%ebp),%eax
  100688:	8b 40 10             	mov    0x10(%eax),%eax
  10068b:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10068e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100691:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100694:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100697:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10069a:	eb 15                	jmp    1006b1 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10069c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069f:	8b 55 08             	mov    0x8(%ebp),%edx
  1006a2:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b4:	8b 40 08             	mov    0x8(%eax),%eax
  1006b7:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006be:	00 
  1006bf:	89 04 24             	mov    %eax,(%esp)
  1006c2:	e8 17 2c 00 00       	call   1032de <strfind>
  1006c7:	89 c2                	mov    %eax,%edx
  1006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cc:	8b 40 08             	mov    0x8(%eax),%eax
  1006cf:	29 c2                	sub    %eax,%edx
  1006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d4:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1006da:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006de:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e5:	00 
  1006e6:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ed:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f7:	89 04 24             	mov    %eax,(%esp)
  1006fa:	e8 b9 fc ff ff       	call   1003b8 <stab_binsearch>
    if (lline <= rline) {
  1006ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100702:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100705:	39 c2                	cmp    %eax,%edx
  100707:	7f 24                	jg     10072d <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100709:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10070c:	89 c2                	mov    %eax,%edx
  10070e:	89 d0                	mov    %edx,%eax
  100710:	01 c0                	add    %eax,%eax
  100712:	01 d0                	add    %edx,%eax
  100714:	c1 e0 02             	shl    $0x2,%eax
  100717:	89 c2                	mov    %eax,%edx
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	01 d0                	add    %edx,%eax
  10071e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100722:	0f b7 d0             	movzwl %ax,%edx
  100725:	8b 45 0c             	mov    0xc(%ebp),%eax
  100728:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10072b:	eb 13                	jmp    100740 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10072d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100732:	e9 12 01 00 00       	jmp    100849 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100737:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10073a:	83 e8 01             	sub    $0x1,%eax
  10073d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100740:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100746:	39 c2                	cmp    %eax,%edx
  100748:	7c 56                	jl     1007a0 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10074a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10074d:	89 c2                	mov    %eax,%edx
  10074f:	89 d0                	mov    %edx,%eax
  100751:	01 c0                	add    %eax,%eax
  100753:	01 d0                	add    %edx,%eax
  100755:	c1 e0 02             	shl    $0x2,%eax
  100758:	89 c2                	mov    %eax,%edx
  10075a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075d:	01 d0                	add    %edx,%eax
  10075f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100763:	3c 84                	cmp    $0x84,%al
  100765:	74 39                	je     1007a0 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	89 d0                	mov    %edx,%eax
  10076e:	01 c0                	add    %eax,%eax
  100770:	01 d0                	add    %edx,%eax
  100772:	c1 e0 02             	shl    $0x2,%eax
  100775:	89 c2                	mov    %eax,%edx
  100777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10077a:	01 d0                	add    %edx,%eax
  10077c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100780:	3c 64                	cmp    $0x64,%al
  100782:	75 b3                	jne    100737 <debuginfo_eip+0x229>
  100784:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100787:	89 c2                	mov    %eax,%edx
  100789:	89 d0                	mov    %edx,%eax
  10078b:	01 c0                	add    %eax,%eax
  10078d:	01 d0                	add    %edx,%eax
  10078f:	c1 e0 02             	shl    $0x2,%eax
  100792:	89 c2                	mov    %eax,%edx
  100794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100797:	01 d0                	add    %edx,%eax
  100799:	8b 40 08             	mov    0x8(%eax),%eax
  10079c:	85 c0                	test   %eax,%eax
  10079e:	74 97                	je     100737 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a6:	39 c2                	cmp    %eax,%edx
  1007a8:	7c 46                	jl     1007f0 <debuginfo_eip+0x2e2>
  1007aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ad:	89 c2                	mov    %eax,%edx
  1007af:	89 d0                	mov    %edx,%eax
  1007b1:	01 c0                	add    %eax,%eax
  1007b3:	01 d0                	add    %edx,%eax
  1007b5:	c1 e0 02             	shl    $0x2,%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bd:	01 d0                	add    %edx,%eax
  1007bf:	8b 10                	mov    (%eax),%edx
  1007c1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c7:	29 c1                	sub    %eax,%ecx
  1007c9:	89 c8                	mov    %ecx,%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	73 21                	jae    1007f0 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e9:	01 c2                	add    %eax,%edx
  1007eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ee:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f6:	39 c2                	cmp    %eax,%edx
  1007f8:	7d 4a                	jge    100844 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007fd:	83 c0 01             	add    $0x1,%eax
  100800:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100803:	eb 18                	jmp    10081d <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100805:	8b 45 0c             	mov    0xc(%ebp),%eax
  100808:	8b 40 14             	mov    0x14(%eax),%eax
  10080b:	8d 50 01             	lea    0x1(%eax),%edx
  10080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100811:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100814:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100817:	83 c0 01             	add    $0x1,%eax
  10081a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10081d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100820:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100823:	39 c2                	cmp    %eax,%edx
  100825:	7d 1d                	jge    100844 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100827:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082a:	89 c2                	mov    %eax,%edx
  10082c:	89 d0                	mov    %edx,%eax
  10082e:	01 c0                	add    %eax,%eax
  100830:	01 d0                	add    %edx,%eax
  100832:	c1 e0 02             	shl    $0x2,%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083a:	01 d0                	add    %edx,%eax
  10083c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100840:	3c a0                	cmp    $0xa0,%al
  100842:	74 c1                	je     100805 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100844:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100849:	c9                   	leave  
  10084a:	c3                   	ret    

0010084b <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10084b:	55                   	push   %ebp
  10084c:	89 e5                	mov    %esp,%ebp
  10084e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100851:	c7 04 24 b6 36 10 00 	movl   $0x1036b6,(%esp)
  100858:	e8 ba fa ff ff       	call   100317 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10085d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100864:	00 
  100865:	c7 04 24 cf 36 10 00 	movl   $0x1036cf,(%esp)
  10086c:	e8 a6 fa ff ff       	call   100317 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100871:	c7 44 24 04 f3 35 10 	movl   $0x1035f3,0x4(%esp)
  100878:	00 
  100879:	c7 04 24 e7 36 10 00 	movl   $0x1036e7,(%esp)
  100880:	e8 92 fa ff ff       	call   100317 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100885:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  10088c:	00 
  10088d:	c7 04 24 ff 36 10 00 	movl   $0x1036ff,(%esp)
  100894:	e8 7e fa ff ff       	call   100317 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100899:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  1008a0:	00 
  1008a1:	c7 04 24 17 37 10 00 	movl   $0x103717,(%esp)
  1008a8:	e8 6a fa ff ff       	call   100317 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008ad:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008b2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b8:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008bd:	29 c2                	sub    %eax,%edx
  1008bf:	89 d0                	mov    %edx,%eax
  1008c1:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c7:	85 c0                	test   %eax,%eax
  1008c9:	0f 48 c2             	cmovs  %edx,%eax
  1008cc:	c1 f8 0a             	sar    $0xa,%eax
  1008cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008d3:	c7 04 24 30 37 10 00 	movl   $0x103730,(%esp)
  1008da:	e8 38 fa ff ff       	call   100317 <cprintf>
}
  1008df:	c9                   	leave  
  1008e0:	c3                   	ret    

001008e1 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008e1:	55                   	push   %ebp
  1008e2:	89 e5                	mov    %esp,%ebp
  1008e4:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1008f4:	89 04 24             	mov    %eax,(%esp)
  1008f7:	e8 12 fc ff ff       	call   10050e <debuginfo_eip>
  1008fc:	85 c0                	test   %eax,%eax
  1008fe:	74 15                	je     100915 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100900:	8b 45 08             	mov    0x8(%ebp),%eax
  100903:	89 44 24 04          	mov    %eax,0x4(%esp)
  100907:	c7 04 24 5a 37 10 00 	movl   $0x10375a,(%esp)
  10090e:	e8 04 fa ff ff       	call   100317 <cprintf>
  100913:	eb 6d                	jmp    100982 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100915:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10091c:	eb 1c                	jmp    10093a <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  10091e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100924:	01 d0                	add    %edx,%eax
  100926:	0f b6 00             	movzbl (%eax),%eax
  100929:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100932:	01 ca                	add    %ecx,%edx
  100934:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100936:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10093a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10093d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100940:	7f dc                	jg     10091e <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100942:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10094b:	01 d0                	add    %edx,%eax
  10094d:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100950:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100953:	8b 55 08             	mov    0x8(%ebp),%edx
  100956:	89 d1                	mov    %edx,%ecx
  100958:	29 c1                	sub    %eax,%ecx
  10095a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10095d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100960:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100964:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10096a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10096e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100972:	89 44 24 04          	mov    %eax,0x4(%esp)
  100976:	c7 04 24 76 37 10 00 	movl   $0x103776,(%esp)
  10097d:	e8 95 f9 ff ff       	call   100317 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  100982:	c9                   	leave  
  100983:	c3                   	ret    

00100984 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100984:	55                   	push   %ebp
  100985:	89 e5                	mov    %esp,%ebp
  100987:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  10098a:	8b 45 04             	mov    0x4(%ebp),%eax
  10098d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100990:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100993:	c9                   	leave  
  100994:	c3                   	ret    

00100995 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100995:	55                   	push   %ebp
  100996:	89 e5                	mov    %esp,%ebp
  100998:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  10099b:	89 e8                	mov    %ebp,%eax
  10099d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t valueEbp = read_ebp();
  1009a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t valueEip = read_eip();
  1009a6:	e8 d9 ff ff ff       	call   100984 <read_eip>
  1009ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i = 0 ;
  1009ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(i ; i < STACKFRAME_DEPTH; i++) {
  1009b5:	e9 92 00 00 00       	jmp    100a4c <print_stackframe+0xb7>
	    if(valueEbp != 0) {
  1009ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1009be:	0f 84 84 00 00 00    	je     100a48 <print_stackframe+0xb3>
		cprintf("ebp:0x%08x eip:0x%08x args:", valueEbp, valueEip);
  1009c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d2:	c7 04 24 88 37 10 00 	movl   $0x103788,(%esp)
  1009d9:	e8 39 f9 ff ff       	call   100317 <cprintf>
		int j = 0;
  1009de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for(j ; j < 4; j++) {
  1009e5:	eb 2e                	jmp    100a15 <print_stackframe+0x80>
		    uint32_t args =  *((uint32_t*)valueEbp + 2 + j);
  1009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f4:	01 d0                	add    %edx,%eax
  1009f6:	83 c0 08             	add    $0x8,%eax
  1009f9:	8b 00                	mov    (%eax),%eax
  1009fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		    cprintf("0x%08x ", args);
  1009fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a05:	c7 04 24 a4 37 10 00 	movl   $0x1037a4,(%esp)
  100a0c:	e8 06 f9 ff ff       	call   100317 <cprintf>
	int i = 0 ;
	for(i ; i < STACKFRAME_DEPTH; i++) {
	    if(valueEbp != 0) {
		cprintf("ebp:0x%08x eip:0x%08x args:", valueEbp, valueEip);
		int j = 0;
		for(j ; j < 4; j++) {
  100a11:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a15:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a19:	7e cc                	jle    1009e7 <print_stackframe+0x52>
		    uint32_t args =  *((uint32_t*)valueEbp + 2 + j);
		    cprintf("0x%08x ", args);
		}
		cprintf("\n");
  100a1b:	c7 04 24 ac 37 10 00 	movl   $0x1037ac,(%esp)
  100a22:	e8 f0 f8 ff ff       	call   100317 <cprintf>
		print_debuginfo(valueEip - 1);
  100a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a2a:	83 e8 01             	sub    $0x1,%eax
  100a2d:	89 04 24             	mov    %eax,(%esp)
  100a30:	e8 ac fe ff ff       	call   1008e1 <print_debuginfo>
		valueEip = *((uint32_t*)valueEbp + 1);
  100a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a38:	83 c0 04             	add    $0x4,%eax
  100a3b:	8b 00                	mov    (%eax),%eax
  100a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		valueEbp = *((uint32_t*)valueEbp);
  100a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a43:	8b 00                	mov    (%eax),%eax
  100a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t valueEbp = read_ebp();
	uint32_t valueEip = read_eip();
	int i = 0 ;
	for(i ; i < STACKFRAME_DEPTH; i++) {
  100a48:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a4c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a50:	0f 8e 64 ff ff ff    	jle    1009ba <print_stackframe+0x25>
		print_debuginfo(valueEip - 1);
		valueEip = *((uint32_t*)valueEbp + 1);
		valueEbp = *((uint32_t*)valueEbp);
	    }
	}
}
  100a56:	c9                   	leave  
  100a57:	c3                   	ret    

00100a58 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a58:	55                   	push   %ebp
  100a59:	89 e5                	mov    %esp,%ebp
  100a5b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a65:	eb 0c                	jmp    100a73 <parse+0x1b>
            *buf ++ = '\0';
  100a67:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6a:	8d 50 01             	lea    0x1(%eax),%edx
  100a6d:	89 55 08             	mov    %edx,0x8(%ebp)
  100a70:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a73:	8b 45 08             	mov    0x8(%ebp),%eax
  100a76:	0f b6 00             	movzbl (%eax),%eax
  100a79:	84 c0                	test   %al,%al
  100a7b:	74 1d                	je     100a9a <parse+0x42>
  100a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  100a80:	0f b6 00             	movzbl (%eax),%eax
  100a83:	0f be c0             	movsbl %al,%eax
  100a86:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a8a:	c7 04 24 30 38 10 00 	movl   $0x103830,(%esp)
  100a91:	e8 15 28 00 00       	call   1032ab <strchr>
  100a96:	85 c0                	test   %eax,%eax
  100a98:	75 cd                	jne    100a67 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9d:	0f b6 00             	movzbl (%eax),%eax
  100aa0:	84 c0                	test   %al,%al
  100aa2:	75 02                	jne    100aa6 <parse+0x4e>
            break;
  100aa4:	eb 67                	jmp    100b0d <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aa6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aaa:	75 14                	jne    100ac0 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aac:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ab3:	00 
  100ab4:	c7 04 24 35 38 10 00 	movl   $0x103835,(%esp)
  100abb:	e8 57 f8 ff ff       	call   100317 <cprintf>
        }
        argv[argc ++] = buf;
  100ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac3:	8d 50 01             	lea    0x1(%eax),%edx
  100ac6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ac9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ad3:	01 c2                	add    %eax,%edx
  100ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad8:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ada:	eb 04                	jmp    100ae0 <parse+0x88>
            buf ++;
  100adc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae3:	0f b6 00             	movzbl (%eax),%eax
  100ae6:	84 c0                	test   %al,%al
  100ae8:	74 1d                	je     100b07 <parse+0xaf>
  100aea:	8b 45 08             	mov    0x8(%ebp),%eax
  100aed:	0f b6 00             	movzbl (%eax),%eax
  100af0:	0f be c0             	movsbl %al,%eax
  100af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af7:	c7 04 24 30 38 10 00 	movl   $0x103830,(%esp)
  100afe:	e8 a8 27 00 00       	call   1032ab <strchr>
  100b03:	85 c0                	test   %eax,%eax
  100b05:	74 d5                	je     100adc <parse+0x84>
            buf ++;
        }
    }
  100b07:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b08:	e9 66 ff ff ff       	jmp    100a73 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b10:	c9                   	leave  
  100b11:	c3                   	ret    

00100b12 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b12:	55                   	push   %ebp
  100b13:	89 e5                	mov    %esp,%ebp
  100b15:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b18:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b22:	89 04 24             	mov    %eax,(%esp)
  100b25:	e8 2e ff ff ff       	call   100a58 <parse>
  100b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b31:	75 0a                	jne    100b3d <runcmd+0x2b>
        return 0;
  100b33:	b8 00 00 00 00       	mov    $0x0,%eax
  100b38:	e9 85 00 00 00       	jmp    100bc2 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b44:	eb 5c                	jmp    100ba2 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b46:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b4c:	89 d0                	mov    %edx,%eax
  100b4e:	01 c0                	add    %eax,%eax
  100b50:	01 d0                	add    %edx,%eax
  100b52:	c1 e0 02             	shl    $0x2,%eax
  100b55:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b5a:	8b 00                	mov    (%eax),%eax
  100b5c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b60:	89 04 24             	mov    %eax,(%esp)
  100b63:	e8 a4 26 00 00       	call   10320c <strcmp>
  100b68:	85 c0                	test   %eax,%eax
  100b6a:	75 32                	jne    100b9e <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6f:	89 d0                	mov    %edx,%eax
  100b71:	01 c0                	add    %eax,%eax
  100b73:	01 d0                	add    %edx,%eax
  100b75:	c1 e0 02             	shl    $0x2,%eax
  100b78:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b7d:	8b 40 08             	mov    0x8(%eax),%eax
  100b80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b83:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b89:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b8d:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b90:	83 c2 04             	add    $0x4,%edx
  100b93:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b97:	89 0c 24             	mov    %ecx,(%esp)
  100b9a:	ff d0                	call   *%eax
  100b9c:	eb 24                	jmp    100bc2 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba5:	83 f8 02             	cmp    $0x2,%eax
  100ba8:	76 9c                	jbe    100b46 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100baa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bad:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb1:	c7 04 24 53 38 10 00 	movl   $0x103853,(%esp)
  100bb8:	e8 5a f7 ff ff       	call   100317 <cprintf>
    return 0;
  100bbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bc2:	c9                   	leave  
  100bc3:	c3                   	ret    

00100bc4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bc4:	55                   	push   %ebp
  100bc5:	89 e5                	mov    %esp,%ebp
  100bc7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bca:	c7 04 24 6c 38 10 00 	movl   $0x10386c,(%esp)
  100bd1:	e8 41 f7 ff ff       	call   100317 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bd6:	c7 04 24 94 38 10 00 	movl   $0x103894,(%esp)
  100bdd:	e8 35 f7 ff ff       	call   100317 <cprintf>

    if (tf != NULL) {
  100be2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100be6:	74 0b                	je     100bf3 <kmonitor+0x2f>
        print_trapframe(tf);
  100be8:	8b 45 08             	mov    0x8(%ebp),%eax
  100beb:	89 04 24             	mov    %eax,(%esp)
  100bee:	e8 44 0f 00 00       	call   101b37 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bf3:	c7 04 24 b9 38 10 00 	movl   $0x1038b9,(%esp)
  100bfa:	e8 0f f6 ff ff       	call   10020e <readline>
  100bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c06:	74 18                	je     100c20 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c08:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c12:	89 04 24             	mov    %eax,(%esp)
  100c15:	e8 f8 fe ff ff       	call   100b12 <runcmd>
  100c1a:	85 c0                	test   %eax,%eax
  100c1c:	79 02                	jns    100c20 <kmonitor+0x5c>
                break;
  100c1e:	eb 02                	jmp    100c22 <kmonitor+0x5e>
            }
        }
    }
  100c20:	eb d1                	jmp    100bf3 <kmonitor+0x2f>
}
  100c22:	c9                   	leave  
  100c23:	c3                   	ret    

00100c24 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c24:	55                   	push   %ebp
  100c25:	89 e5                	mov    %esp,%ebp
  100c27:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c31:	eb 3f                	jmp    100c72 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c36:	89 d0                	mov    %edx,%eax
  100c38:	01 c0                	add    %eax,%eax
  100c3a:	01 d0                	add    %edx,%eax
  100c3c:	c1 e0 02             	shl    $0x2,%eax
  100c3f:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c44:	8b 48 04             	mov    0x4(%eax),%ecx
  100c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4a:	89 d0                	mov    %edx,%eax
  100c4c:	01 c0                	add    %eax,%eax
  100c4e:	01 d0                	add    %edx,%eax
  100c50:	c1 e0 02             	shl    $0x2,%eax
  100c53:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c58:	8b 00                	mov    (%eax),%eax
  100c5a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c62:	c7 04 24 bd 38 10 00 	movl   $0x1038bd,(%esp)
  100c69:	e8 a9 f6 ff ff       	call   100317 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c75:	83 f8 02             	cmp    $0x2,%eax
  100c78:	76 b9                	jbe    100c33 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c7f:	c9                   	leave  
  100c80:	c3                   	ret    

00100c81 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c81:	55                   	push   %ebp
  100c82:	89 e5                	mov    %esp,%ebp
  100c84:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c87:	e8 bf fb ff ff       	call   10084b <print_kerninfo>
    return 0;
  100c8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c91:	c9                   	leave  
  100c92:	c3                   	ret    

00100c93 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c93:	55                   	push   %ebp
  100c94:	89 e5                	mov    %esp,%ebp
  100c96:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c99:	e8 f7 fc ff ff       	call   100995 <print_stackframe>
    return 0;
  100c9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca3:	c9                   	leave  
  100ca4:	c3                   	ret    

00100ca5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ca5:	55                   	push   %ebp
  100ca6:	89 e5                	mov    %esp,%ebp
  100ca8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cab:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cb0:	85 c0                	test   %eax,%eax
  100cb2:	74 02                	je     100cb6 <__panic+0x11>
        goto panic_dead;
  100cb4:	eb 59                	jmp    100d0f <__panic+0x6a>
    }
    is_panic = 1;
  100cb6:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cbd:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cc0:	8d 45 14             	lea    0x14(%ebp),%eax
  100cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cc9:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd4:	c7 04 24 c6 38 10 00 	movl   $0x1038c6,(%esp)
  100cdb:	e8 37 f6 ff ff       	call   100317 <cprintf>
    vcprintf(fmt, ap);
  100ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce7:	8b 45 10             	mov    0x10(%ebp),%eax
  100cea:	89 04 24             	mov    %eax,(%esp)
  100ced:	e8 f2 f5 ff ff       	call   1002e4 <vcprintf>
    cprintf("\n");
  100cf2:	c7 04 24 e2 38 10 00 	movl   $0x1038e2,(%esp)
  100cf9:	e8 19 f6 ff ff       	call   100317 <cprintf>
    
    cprintf("stack trackback:\n");
  100cfe:	c7 04 24 e4 38 10 00 	movl   $0x1038e4,(%esp)
  100d05:	e8 0d f6 ff ff       	call   100317 <cprintf>
    print_stackframe();
  100d0a:	e8 86 fc ff ff       	call   100995 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d0f:	e8 22 09 00 00       	call   101636 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d1b:	e8 a4 fe ff ff       	call   100bc4 <kmonitor>
    }
  100d20:	eb f2                	jmp    100d14 <__panic+0x6f>

00100d22 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d22:	55                   	push   %ebp
  100d23:	89 e5                	mov    %esp,%ebp
  100d25:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d28:	8d 45 14             	lea    0x14(%ebp),%eax
  100d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d31:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d35:	8b 45 08             	mov    0x8(%ebp),%eax
  100d38:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d3c:	c7 04 24 f6 38 10 00 	movl   $0x1038f6,(%esp)
  100d43:	e8 cf f5 ff ff       	call   100317 <cprintf>
    vcprintf(fmt, ap);
  100d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d52:	89 04 24             	mov    %eax,(%esp)
  100d55:	e8 8a f5 ff ff       	call   1002e4 <vcprintf>
    cprintf("\n");
  100d5a:	c7 04 24 e2 38 10 00 	movl   $0x1038e2,(%esp)
  100d61:	e8 b1 f5 ff ff       	call   100317 <cprintf>
    va_end(ap);
}
  100d66:	c9                   	leave  
  100d67:	c3                   	ret    

00100d68 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d68:	55                   	push   %ebp
  100d69:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d6b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d70:	5d                   	pop    %ebp
  100d71:	c3                   	ret    

00100d72 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d72:	55                   	push   %ebp
  100d73:	89 e5                	mov    %esp,%ebp
  100d75:	83 ec 28             	sub    $0x28,%esp
  100d78:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d7e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d82:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d86:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d8a:	ee                   	out    %al,(%dx)
  100d8b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d91:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d95:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d99:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d9d:	ee                   	out    %al,(%dx)
  100d9e:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100da4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100da8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100db0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100db1:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100db8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dbb:	c7 04 24 14 39 10 00 	movl   $0x103914,(%esp)
  100dc2:	e8 50 f5 ff ff       	call   100317 <cprintf>
    pic_enable(IRQ_TIMER);
  100dc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dce:	e8 c1 08 00 00       	call   101694 <pic_enable>
}
  100dd3:	c9                   	leave  
  100dd4:	c3                   	ret    

00100dd5 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dd5:	55                   	push   %ebp
  100dd6:	89 e5                	mov    %esp,%ebp
  100dd8:	83 ec 10             	sub    $0x10,%esp
  100ddb:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100de1:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100de5:	89 c2                	mov    %eax,%edx
  100de7:	ec                   	in     (%dx),%al
  100de8:	88 45 fd             	mov    %al,-0x3(%ebp)
  100deb:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100df1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100df5:	89 c2                	mov    %eax,%edx
  100df7:	ec                   	in     (%dx),%al
  100df8:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dfb:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e01:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e05:	89 c2                	mov    %eax,%edx
  100e07:	ec                   	in     (%dx),%al
  100e08:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e0b:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e11:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e15:	89 c2                	mov    %eax,%edx
  100e17:	ec                   	in     (%dx),%al
  100e18:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e1b:	c9                   	leave  
  100e1c:	c3                   	ret    

00100e1d <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e1d:	55                   	push   %ebp
  100e1e:	89 e5                	mov    %esp,%ebp
  100e20:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e23:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2d:	0f b7 00             	movzwl (%eax),%eax
  100e30:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e37:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3f:	0f b7 00             	movzwl (%eax),%eax
  100e42:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e46:	74 12                	je     100e5a <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e48:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e4f:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e56:	b4 03 
  100e58:	eb 13                	jmp    100e6d <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e5d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e61:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e64:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e6b:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e6d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e74:	0f b7 c0             	movzwl %ax,%eax
  100e77:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e7b:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e7f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e83:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e87:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e88:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8f:	83 c0 01             	add    $0x1,%eax
  100e92:	0f b7 c0             	movzwl %ax,%eax
  100e95:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e99:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e9d:	89 c2                	mov    %eax,%edx
  100e9f:	ec                   	in     (%dx),%al
  100ea0:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ea3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ea7:	0f b6 c0             	movzbl %al,%eax
  100eaa:	c1 e0 08             	shl    $0x8,%eax
  100ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eb0:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb7:	0f b7 c0             	movzwl %ax,%eax
  100eba:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ebe:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ec2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ec6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100eca:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ecb:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ed2:	83 c0 01             	add    $0x1,%eax
  100ed5:	0f b7 c0             	movzwl %ax,%eax
  100ed8:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100edc:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ee0:	89 c2                	mov    %eax,%edx
  100ee2:	ec                   	in     (%dx),%al
  100ee3:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ee6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eea:	0f b6 c0             	movzbl %al,%eax
  100eed:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ef3:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100efb:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f01:	c9                   	leave  
  100f02:	c3                   	ret    

00100f03 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f03:	55                   	push   %ebp
  100f04:	89 e5                	mov    %esp,%ebp
  100f06:	83 ec 48             	sub    $0x48,%esp
  100f09:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f0f:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f13:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f17:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f1b:	ee                   	out    %al,(%dx)
  100f1c:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f22:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f26:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f2a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f2e:	ee                   	out    %al,(%dx)
  100f2f:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f35:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f39:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f3d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f41:	ee                   	out    %al,(%dx)
  100f42:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f48:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f4c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f50:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f54:	ee                   	out    %al,(%dx)
  100f55:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f5b:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f5f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f63:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f67:	ee                   	out    %al,(%dx)
  100f68:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f6e:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f72:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f76:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f7a:	ee                   	out    %al,(%dx)
  100f7b:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f81:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f85:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f89:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f8d:	ee                   	out    %al,(%dx)
  100f8e:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f94:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f98:	89 c2                	mov    %eax,%edx
  100f9a:	ec                   	in     (%dx),%al
  100f9b:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f9e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fa2:	3c ff                	cmp    $0xff,%al
  100fa4:	0f 95 c0             	setne  %al
  100fa7:	0f b6 c0             	movzbl %al,%eax
  100faa:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100faf:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fb5:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fb9:	89 c2                	mov    %eax,%edx
  100fbb:	ec                   	in     (%dx),%al
  100fbc:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fbf:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fc5:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fc9:	89 c2                	mov    %eax,%edx
  100fcb:	ec                   	in     (%dx),%al
  100fcc:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fcf:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fd4:	85 c0                	test   %eax,%eax
  100fd6:	74 0c                	je     100fe4 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fd8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fdf:	e8 b0 06 00 00       	call   101694 <pic_enable>
    }
}
  100fe4:	c9                   	leave  
  100fe5:	c3                   	ret    

00100fe6 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fe6:	55                   	push   %ebp
  100fe7:	89 e5                	mov    %esp,%ebp
  100fe9:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ff3:	eb 09                	jmp    100ffe <lpt_putc_sub+0x18>
        delay();
  100ff5:	e8 db fd ff ff       	call   100dd5 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ffa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100ffe:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101004:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101008:	89 c2                	mov    %eax,%edx
  10100a:	ec                   	in     (%dx),%al
  10100b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10100e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101012:	84 c0                	test   %al,%al
  101014:	78 09                	js     10101f <lpt_putc_sub+0x39>
  101016:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10101d:	7e d6                	jle    100ff5 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10101f:	8b 45 08             	mov    0x8(%ebp),%eax
  101022:	0f b6 c0             	movzbl %al,%eax
  101025:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10102b:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10102e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101032:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101036:	ee                   	out    %al,(%dx)
  101037:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10103d:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101041:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101045:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101049:	ee                   	out    %al,(%dx)
  10104a:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101050:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101054:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101058:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10105c:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10105d:	c9                   	leave  
  10105e:	c3                   	ret    

0010105f <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10105f:	55                   	push   %ebp
  101060:	89 e5                	mov    %esp,%ebp
  101062:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101065:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101069:	74 0d                	je     101078 <lpt_putc+0x19>
        lpt_putc_sub(c);
  10106b:	8b 45 08             	mov    0x8(%ebp),%eax
  10106e:	89 04 24             	mov    %eax,(%esp)
  101071:	e8 70 ff ff ff       	call   100fe6 <lpt_putc_sub>
  101076:	eb 24                	jmp    10109c <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101078:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10107f:	e8 62 ff ff ff       	call   100fe6 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101084:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10108b:	e8 56 ff ff ff       	call   100fe6 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101090:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101097:	e8 4a ff ff ff       	call   100fe6 <lpt_putc_sub>
    }
}
  10109c:	c9                   	leave  
  10109d:	c3                   	ret    

0010109e <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10109e:	55                   	push   %ebp
  10109f:	89 e5                	mov    %esp,%ebp
  1010a1:	53                   	push   %ebx
  1010a2:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a8:	b0 00                	mov    $0x0,%al
  1010aa:	85 c0                	test   %eax,%eax
  1010ac:	75 07                	jne    1010b5 <cga_putc+0x17>
        c |= 0x0700;
  1010ae:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b8:	0f b6 c0             	movzbl %al,%eax
  1010bb:	83 f8 0a             	cmp    $0xa,%eax
  1010be:	74 4c                	je     10110c <cga_putc+0x6e>
  1010c0:	83 f8 0d             	cmp    $0xd,%eax
  1010c3:	74 57                	je     10111c <cga_putc+0x7e>
  1010c5:	83 f8 08             	cmp    $0x8,%eax
  1010c8:	0f 85 88 00 00 00    	jne    101156 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010ce:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d5:	66 85 c0             	test   %ax,%ax
  1010d8:	74 30                	je     10110a <cga_putc+0x6c>
            crt_pos --;
  1010da:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e1:	83 e8 01             	sub    $0x1,%eax
  1010e4:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010ea:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010ef:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010f6:	0f b7 d2             	movzwl %dx,%edx
  1010f9:	01 d2                	add    %edx,%edx
  1010fb:	01 c2                	add    %eax,%edx
  1010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101100:	b0 00                	mov    $0x0,%al
  101102:	83 c8 20             	or     $0x20,%eax
  101105:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101108:	eb 72                	jmp    10117c <cga_putc+0xde>
  10110a:	eb 70                	jmp    10117c <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10110c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101113:	83 c0 50             	add    $0x50,%eax
  101116:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10111c:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101123:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10112a:	0f b7 c1             	movzwl %cx,%eax
  10112d:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101133:	c1 e8 10             	shr    $0x10,%eax
  101136:	89 c2                	mov    %eax,%edx
  101138:	66 c1 ea 06          	shr    $0x6,%dx
  10113c:	89 d0                	mov    %edx,%eax
  10113e:	c1 e0 02             	shl    $0x2,%eax
  101141:	01 d0                	add    %edx,%eax
  101143:	c1 e0 04             	shl    $0x4,%eax
  101146:	29 c1                	sub    %eax,%ecx
  101148:	89 ca                	mov    %ecx,%edx
  10114a:	89 d8                	mov    %ebx,%eax
  10114c:	29 d0                	sub    %edx,%eax
  10114e:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101154:	eb 26                	jmp    10117c <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101156:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10115c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101163:	8d 50 01             	lea    0x1(%eax),%edx
  101166:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10116d:	0f b7 c0             	movzwl %ax,%eax
  101170:	01 c0                	add    %eax,%eax
  101172:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101175:	8b 45 08             	mov    0x8(%ebp),%eax
  101178:	66 89 02             	mov    %ax,(%edx)
        break;
  10117b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10117c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101183:	66 3d cf 07          	cmp    $0x7cf,%ax
  101187:	76 5b                	jbe    1011e4 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101189:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10118e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101194:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101199:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011a0:	00 
  1011a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011a5:	89 04 24             	mov    %eax,(%esp)
  1011a8:	e8 fc 22 00 00       	call   1034a9 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ad:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011b4:	eb 15                	jmp    1011cb <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011b6:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011be:	01 d2                	add    %edx,%edx
  1011c0:	01 d0                	add    %edx,%eax
  1011c2:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011cb:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011d2:	7e e2                	jle    1011b6 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011d4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011db:	83 e8 50             	sub    $0x50,%eax
  1011de:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011e4:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011eb:	0f b7 c0             	movzwl %ax,%eax
  1011ee:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011f2:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011f6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011fa:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011fe:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011ff:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101206:	66 c1 e8 08          	shr    $0x8,%ax
  10120a:	0f b6 c0             	movzbl %al,%eax
  10120d:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101214:	83 c2 01             	add    $0x1,%edx
  101217:	0f b7 d2             	movzwl %dx,%edx
  10121a:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10121e:	88 45 ed             	mov    %al,-0x13(%ebp)
  101221:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101225:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101229:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10122a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101231:	0f b7 c0             	movzwl %ax,%eax
  101234:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101238:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10123c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101240:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101244:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101245:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10124c:	0f b6 c0             	movzbl %al,%eax
  10124f:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101256:	83 c2 01             	add    $0x1,%edx
  101259:	0f b7 d2             	movzwl %dx,%edx
  10125c:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101260:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101263:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101267:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10126b:	ee                   	out    %al,(%dx)
}
  10126c:	83 c4 34             	add    $0x34,%esp
  10126f:	5b                   	pop    %ebx
  101270:	5d                   	pop    %ebp
  101271:	c3                   	ret    

00101272 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101272:	55                   	push   %ebp
  101273:	89 e5                	mov    %esp,%ebp
  101275:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101278:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10127f:	eb 09                	jmp    10128a <serial_putc_sub+0x18>
        delay();
  101281:	e8 4f fb ff ff       	call   100dd5 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101286:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10128a:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101290:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101294:	89 c2                	mov    %eax,%edx
  101296:	ec                   	in     (%dx),%al
  101297:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10129a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10129e:	0f b6 c0             	movzbl %al,%eax
  1012a1:	83 e0 20             	and    $0x20,%eax
  1012a4:	85 c0                	test   %eax,%eax
  1012a6:	75 09                	jne    1012b1 <serial_putc_sub+0x3f>
  1012a8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012af:	7e d0                	jle    101281 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1012b4:	0f b6 c0             	movzbl %al,%eax
  1012b7:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012bd:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012c4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012c8:	ee                   	out    %al,(%dx)
}
  1012c9:	c9                   	leave  
  1012ca:	c3                   	ret    

001012cb <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012cb:	55                   	push   %ebp
  1012cc:	89 e5                	mov    %esp,%ebp
  1012ce:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012d1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012d5:	74 0d                	je     1012e4 <serial_putc+0x19>
        serial_putc_sub(c);
  1012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1012da:	89 04 24             	mov    %eax,(%esp)
  1012dd:	e8 90 ff ff ff       	call   101272 <serial_putc_sub>
  1012e2:	eb 24                	jmp    101308 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012eb:	e8 82 ff ff ff       	call   101272 <serial_putc_sub>
        serial_putc_sub(' ');
  1012f0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012f7:	e8 76 ff ff ff       	call   101272 <serial_putc_sub>
        serial_putc_sub('\b');
  1012fc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101303:	e8 6a ff ff ff       	call   101272 <serial_putc_sub>
    }
}
  101308:	c9                   	leave  
  101309:	c3                   	ret    

0010130a <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10130a:	55                   	push   %ebp
  10130b:	89 e5                	mov    %esp,%ebp
  10130d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101310:	eb 33                	jmp    101345 <cons_intr+0x3b>
        if (c != 0) {
  101312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101316:	74 2d                	je     101345 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101318:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10131d:	8d 50 01             	lea    0x1(%eax),%edx
  101320:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101326:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101329:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10132f:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101334:	3d 00 02 00 00       	cmp    $0x200,%eax
  101339:	75 0a                	jne    101345 <cons_intr+0x3b>
                cons.wpos = 0;
  10133b:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101342:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101345:	8b 45 08             	mov    0x8(%ebp),%eax
  101348:	ff d0                	call   *%eax
  10134a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10134d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101351:	75 bf                	jne    101312 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101353:	c9                   	leave  
  101354:	c3                   	ret    

00101355 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101355:	55                   	push   %ebp
  101356:	89 e5                	mov    %esp,%ebp
  101358:	83 ec 10             	sub    $0x10,%esp
  10135b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101361:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101365:	89 c2                	mov    %eax,%edx
  101367:	ec                   	in     (%dx),%al
  101368:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10136b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10136f:	0f b6 c0             	movzbl %al,%eax
  101372:	83 e0 01             	and    $0x1,%eax
  101375:	85 c0                	test   %eax,%eax
  101377:	75 07                	jne    101380 <serial_proc_data+0x2b>
        return -1;
  101379:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10137e:	eb 2a                	jmp    1013aa <serial_proc_data+0x55>
  101380:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101386:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10138a:	89 c2                	mov    %eax,%edx
  10138c:	ec                   	in     (%dx),%al
  10138d:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101390:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101394:	0f b6 c0             	movzbl %al,%eax
  101397:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10139a:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10139e:	75 07                	jne    1013a7 <serial_proc_data+0x52>
        c = '\b';
  1013a0:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013aa:	c9                   	leave  
  1013ab:	c3                   	ret    

001013ac <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013ac:	55                   	push   %ebp
  1013ad:	89 e5                	mov    %esp,%ebp
  1013af:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013b2:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013b7:	85 c0                	test   %eax,%eax
  1013b9:	74 0c                	je     1013c7 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013bb:	c7 04 24 55 13 10 00 	movl   $0x101355,(%esp)
  1013c2:	e8 43 ff ff ff       	call   10130a <cons_intr>
    }
}
  1013c7:	c9                   	leave  
  1013c8:	c3                   	ret    

001013c9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013c9:	55                   	push   %ebp
  1013ca:	89 e5                	mov    %esp,%ebp
  1013cc:	83 ec 38             	sub    $0x38,%esp
  1013cf:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d9:	89 c2                	mov    %eax,%edx
  1013db:	ec                   	in     (%dx),%al
  1013dc:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013df:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013e3:	0f b6 c0             	movzbl %al,%eax
  1013e6:	83 e0 01             	and    $0x1,%eax
  1013e9:	85 c0                	test   %eax,%eax
  1013eb:	75 0a                	jne    1013f7 <kbd_proc_data+0x2e>
        return -1;
  1013ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f2:	e9 59 01 00 00       	jmp    101550 <kbd_proc_data+0x187>
  1013f7:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013fd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101401:	89 c2                	mov    %eax,%edx
  101403:	ec                   	in     (%dx),%al
  101404:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101407:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10140b:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10140e:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101412:	75 17                	jne    10142b <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101414:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101419:	83 c8 40             	or     $0x40,%eax
  10141c:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101421:	b8 00 00 00 00       	mov    $0x0,%eax
  101426:	e9 25 01 00 00       	jmp    101550 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10142b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142f:	84 c0                	test   %al,%al
  101431:	79 47                	jns    10147a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101433:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101438:	83 e0 40             	and    $0x40,%eax
  10143b:	85 c0                	test   %eax,%eax
  10143d:	75 09                	jne    101448 <kbd_proc_data+0x7f>
  10143f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101443:	83 e0 7f             	and    $0x7f,%eax
  101446:	eb 04                	jmp    10144c <kbd_proc_data+0x83>
  101448:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144c:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10144f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101453:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10145a:	83 c8 40             	or     $0x40,%eax
  10145d:	0f b6 c0             	movzbl %al,%eax
  101460:	f7 d0                	not    %eax
  101462:	89 c2                	mov    %eax,%edx
  101464:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101469:	21 d0                	and    %edx,%eax
  10146b:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101470:	b8 00 00 00 00       	mov    $0x0,%eax
  101475:	e9 d6 00 00 00       	jmp    101550 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10147a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147f:	83 e0 40             	and    $0x40,%eax
  101482:	85 c0                	test   %eax,%eax
  101484:	74 11                	je     101497 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101486:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10148a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148f:	83 e0 bf             	and    $0xffffffbf,%eax
  101492:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101497:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014a2:	0f b6 d0             	movzbl %al,%edx
  1014a5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014aa:	09 d0                	or     %edx,%eax
  1014ac:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014b1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b5:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014bc:	0f b6 d0             	movzbl %al,%edx
  1014bf:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c4:	31 d0                	xor    %edx,%eax
  1014c6:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014cb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d0:	83 e0 03             	and    $0x3,%eax
  1014d3:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014de:	01 d0                	add    %edx,%eax
  1014e0:	0f b6 00             	movzbl (%eax),%eax
  1014e3:	0f b6 c0             	movzbl %al,%eax
  1014e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014e9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ee:	83 e0 08             	and    $0x8,%eax
  1014f1:	85 c0                	test   %eax,%eax
  1014f3:	74 22                	je     101517 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014f5:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014f9:	7e 0c                	jle    101507 <kbd_proc_data+0x13e>
  1014fb:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014ff:	7f 06                	jg     101507 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101501:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101505:	eb 10                	jmp    101517 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101507:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10150b:	7e 0a                	jle    101517 <kbd_proc_data+0x14e>
  10150d:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101511:	7f 04                	jg     101517 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101513:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101517:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10151c:	f7 d0                	not    %eax
  10151e:	83 e0 06             	and    $0x6,%eax
  101521:	85 c0                	test   %eax,%eax
  101523:	75 28                	jne    10154d <kbd_proc_data+0x184>
  101525:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10152c:	75 1f                	jne    10154d <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10152e:	c7 04 24 2f 39 10 00 	movl   $0x10392f,(%esp)
  101535:	e8 dd ed ff ff       	call   100317 <cprintf>
  10153a:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101540:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101544:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101548:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10154c:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10154d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101550:	c9                   	leave  
  101551:	c3                   	ret    

00101552 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101552:	55                   	push   %ebp
  101553:	89 e5                	mov    %esp,%ebp
  101555:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101558:	c7 04 24 c9 13 10 00 	movl   $0x1013c9,(%esp)
  10155f:	e8 a6 fd ff ff       	call   10130a <cons_intr>
}
  101564:	c9                   	leave  
  101565:	c3                   	ret    

00101566 <kbd_init>:

static void
kbd_init(void) {
  101566:	55                   	push   %ebp
  101567:	89 e5                	mov    %esp,%ebp
  101569:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10156c:	e8 e1 ff ff ff       	call   101552 <kbd_intr>
    pic_enable(IRQ_KBD);
  101571:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101578:	e8 17 01 00 00       	call   101694 <pic_enable>
}
  10157d:	c9                   	leave  
  10157e:	c3                   	ret    

0010157f <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10157f:	55                   	push   %ebp
  101580:	89 e5                	mov    %esp,%ebp
  101582:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101585:	e8 93 f8 ff ff       	call   100e1d <cga_init>
    serial_init();
  10158a:	e8 74 f9 ff ff       	call   100f03 <serial_init>
    kbd_init();
  10158f:	e8 d2 ff ff ff       	call   101566 <kbd_init>
    if (!serial_exists) {
  101594:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101599:	85 c0                	test   %eax,%eax
  10159b:	75 0c                	jne    1015a9 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10159d:	c7 04 24 3b 39 10 00 	movl   $0x10393b,(%esp)
  1015a4:	e8 6e ed ff ff       	call   100317 <cprintf>
    }
}
  1015a9:	c9                   	leave  
  1015aa:	c3                   	ret    

001015ab <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015ab:	55                   	push   %ebp
  1015ac:	89 e5                	mov    %esp,%ebp
  1015ae:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b4:	89 04 24             	mov    %eax,(%esp)
  1015b7:	e8 a3 fa ff ff       	call   10105f <lpt_putc>
    cga_putc(c);
  1015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1015bf:	89 04 24             	mov    %eax,(%esp)
  1015c2:	e8 d7 fa ff ff       	call   10109e <cga_putc>
    serial_putc(c);
  1015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ca:	89 04 24             	mov    %eax,(%esp)
  1015cd:	e8 f9 fc ff ff       	call   1012cb <serial_putc>
}
  1015d2:	c9                   	leave  
  1015d3:	c3                   	ret    

001015d4 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015d4:	55                   	push   %ebp
  1015d5:	89 e5                	mov    %esp,%ebp
  1015d7:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015da:	e8 cd fd ff ff       	call   1013ac <serial_intr>
    kbd_intr();
  1015df:	e8 6e ff ff ff       	call   101552 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015e4:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015ea:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015ef:	39 c2                	cmp    %eax,%edx
  1015f1:	74 36                	je     101629 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015f3:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f8:	8d 50 01             	lea    0x1(%eax),%edx
  1015fb:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101601:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101608:	0f b6 c0             	movzbl %al,%eax
  10160b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  10160e:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101613:	3d 00 02 00 00       	cmp    $0x200,%eax
  101618:	75 0a                	jne    101624 <cons_getc+0x50>
            cons.rpos = 0;
  10161a:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101621:	00 00 00 
        }
        return c;
  101624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101627:	eb 05                	jmp    10162e <cons_getc+0x5a>
    }
    return 0;
  101629:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10162e:	c9                   	leave  
  10162f:	c3                   	ret    

00101630 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101630:	55                   	push   %ebp
  101631:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101633:	fb                   	sti    
    sti();
}
  101634:	5d                   	pop    %ebp
  101635:	c3                   	ret    

00101636 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101636:	55                   	push   %ebp
  101637:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101639:	fa                   	cli    
    cli();
}
  10163a:	5d                   	pop    %ebp
  10163b:	c3                   	ret    

0010163c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10163c:	55                   	push   %ebp
  10163d:	89 e5                	mov    %esp,%ebp
  10163f:	83 ec 14             	sub    $0x14,%esp
  101642:	8b 45 08             	mov    0x8(%ebp),%eax
  101645:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101649:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10164d:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101653:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101658:	85 c0                	test   %eax,%eax
  10165a:	74 36                	je     101692 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10165c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101660:	0f b6 c0             	movzbl %al,%eax
  101663:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101669:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10166c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101670:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101674:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101675:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101679:	66 c1 e8 08          	shr    $0x8,%ax
  10167d:	0f b6 c0             	movzbl %al,%eax
  101680:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101686:	88 45 f9             	mov    %al,-0x7(%ebp)
  101689:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10168d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101691:	ee                   	out    %al,(%dx)
    }
}
  101692:	c9                   	leave  
  101693:	c3                   	ret    

00101694 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101694:	55                   	push   %ebp
  101695:	89 e5                	mov    %esp,%ebp
  101697:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10169a:	8b 45 08             	mov    0x8(%ebp),%eax
  10169d:	ba 01 00 00 00       	mov    $0x1,%edx
  1016a2:	89 c1                	mov    %eax,%ecx
  1016a4:	d3 e2                	shl    %cl,%edx
  1016a6:	89 d0                	mov    %edx,%eax
  1016a8:	f7 d0                	not    %eax
  1016aa:	89 c2                	mov    %eax,%edx
  1016ac:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016b3:	21 d0                	and    %edx,%eax
  1016b5:	0f b7 c0             	movzwl %ax,%eax
  1016b8:	89 04 24             	mov    %eax,(%esp)
  1016bb:	e8 7c ff ff ff       	call   10163c <pic_setmask>
}
  1016c0:	c9                   	leave  
  1016c1:	c3                   	ret    

001016c2 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016c2:	55                   	push   %ebp
  1016c3:	89 e5                	mov    %esp,%ebp
  1016c5:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016c8:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016cf:	00 00 00 
  1016d2:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016d8:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016dc:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e4:	ee                   	out    %al,(%dx)
  1016e5:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016eb:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016ef:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016f3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f7:	ee                   	out    %al,(%dx)
  1016f8:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016fe:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101702:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101706:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10170a:	ee                   	out    %al,(%dx)
  10170b:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101711:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101715:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101719:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10171d:	ee                   	out    %al,(%dx)
  10171e:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101724:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101728:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10172c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101730:	ee                   	out    %al,(%dx)
  101731:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101737:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10173b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10173f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101743:	ee                   	out    %al,(%dx)
  101744:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10174a:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10174e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101752:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101756:	ee                   	out    %al,(%dx)
  101757:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10175d:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101761:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101765:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101769:	ee                   	out    %al,(%dx)
  10176a:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101770:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101774:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101778:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10177c:	ee                   	out    %al,(%dx)
  10177d:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101783:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101787:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10178b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10178f:	ee                   	out    %al,(%dx)
  101790:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101796:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10179a:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10179e:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017a2:	ee                   	out    %al,(%dx)
  1017a3:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017a9:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017ad:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017b1:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017b5:	ee                   	out    %al,(%dx)
  1017b6:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017bc:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017c0:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017c4:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017c8:	ee                   	out    %al,(%dx)
  1017c9:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017cf:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017d3:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017d7:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017db:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017dc:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e3:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017e7:	74 12                	je     1017fb <pic_init+0x139>
        pic_setmask(irq_mask);
  1017e9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017f0:	0f b7 c0             	movzwl %ax,%eax
  1017f3:	89 04 24             	mov    %eax,(%esp)
  1017f6:	e8 41 fe ff ff       	call   10163c <pic_setmask>
    }
}
  1017fb:	c9                   	leave  
  1017fc:	c3                   	ret    

001017fd <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017fd:	55                   	push   %ebp
  1017fe:	89 e5                	mov    %esp,%ebp
  101800:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101803:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10180a:	00 
  10180b:	c7 04 24 60 39 10 00 	movl   $0x103960,(%esp)
  101812:	e8 00 eb ff ff       	call   100317 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101817:	c7 04 24 6a 39 10 00 	movl   $0x10396a,(%esp)
  10181e:	e8 f4 ea ff ff       	call   100317 <cprintf>
    panic("EOT: kernel seems ok.");
  101823:	c7 44 24 08 78 39 10 	movl   $0x103978,0x8(%esp)
  10182a:	00 
  10182b:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101832:	00 
  101833:	c7 04 24 8e 39 10 00 	movl   $0x10398e,(%esp)
  10183a:	e8 66 f4 ff ff       	call   100ca5 <__panic>

0010183f <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10183f:	55                   	push   %ebp
  101840:	89 e5                	mov    %esp,%ebp
  101842:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
  101845:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i; i < 256 ; i++) {
  10184c:	e9 83 02 00 00       	jmp    101ad4 <idt_init+0x295>
	    if(i != T_SYSCALL && i != T_SWITCH_TOK && i >= IRQ_OFFSET) {
  101851:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  101858:	0f 84 d8 00 00 00    	je     101936 <idt_init+0xf7>
  10185e:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
  101862:	0f 84 ce 00 00 00    	je     101936 <idt_init+0xf7>
  101868:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  10186c:	0f 8e c4 00 00 00    	jle    101936 <idt_init+0xf7>
	       SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101875:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10187c:	89 c2                	mov    %eax,%edx
  10187e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101881:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101888:	00 
  101889:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188c:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101893:	00 08 00 
  101896:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101899:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  1018a0:	00 
  1018a1:	83 e2 e0             	and    $0xffffffe0,%edx
  1018a4:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1018ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ae:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  1018b5:	00 
  1018b6:	83 e2 1f             	and    $0x1f,%edx
  1018b9:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1018c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c3:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018ca:	00 
  1018cb:	83 e2 f0             	and    $0xfffffff0,%edx
  1018ce:	83 ca 0e             	or     $0xe,%edx
  1018d1:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018db:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018e2:	00 
  1018e3:	83 e2 ef             	and    $0xffffffef,%edx
  1018e6:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f0:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018f7:	00 
  1018f8:	83 e2 9f             	and    $0xffffff9f,%edx
  1018fb:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101902:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101905:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10190c:	00 
  10190d:	83 ca 80             	or     $0xffffff80,%edx
  101910:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101917:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191a:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101921:	c1 e8 10             	shr    $0x10,%eax
  101924:	89 c2                	mov    %eax,%edx
  101926:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101929:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101930:	00 
  101931:	e9 9a 01 00 00       	jmp    101ad0 <idt_init+0x291>
	    } else {
	    	if(i == T_SYSCALL || i == T_SWITCH_TOK) {
  101936:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  10193d:	74 0a                	je     101949 <idt_init+0x10a>
  10193f:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
  101943:	0f 85 c1 00 00 00    	jne    101a0a <idt_init+0x1cb>
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);		
  101949:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194c:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101953:	89 c2                	mov    %eax,%edx
  101955:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101958:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10195f:	00 
  101960:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101963:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10196a:	00 08 00 
  10196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101970:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101977:	00 
  101978:	83 e2 e0             	and    $0xffffffe0,%edx
  10197b:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101982:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101985:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10198c:	00 
  10198d:	83 e2 1f             	and    $0x1f,%edx
  101990:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101997:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199a:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1019a1:	00 
  1019a2:	83 ca 0f             	or     $0xf,%edx
  1019a5:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1019ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019af:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1019b6:	00 
  1019b7:	83 e2 ef             	and    $0xffffffef,%edx
  1019ba:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1019c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c4:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1019cb:	00 
  1019cc:	83 ca 60             	or     $0x60,%edx
  1019cf:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1019d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d9:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1019e0:	00 
  1019e1:	83 ca 80             	or     $0xffffff80,%edx
  1019e4:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1019eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ee:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1019f5:	c1 e8 10             	shr    $0x10,%eax
  1019f8:	89 c2                	mov    %eax,%edx
  1019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fd:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101a04:	00 
  101a05:	e9 c6 00 00 00       	jmp    101ad0 <idt_init+0x291>
		} else if(i < IRQ_OFFSET) {
  101a0a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  101a0e:	0f 8f bc 00 00 00    	jg     101ad0 <idt_init+0x291>
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);		
  101a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a17:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101a1e:	89 c2                	mov    %eax,%edx
  101a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a23:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101a2a:	00 
  101a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a2e:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101a35:	00 08 00 
  101a38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a3b:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101a42:	00 
  101a43:	83 e2 e0             	and    $0xffffffe0,%edx
  101a46:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a50:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101a57:	00 
  101a58:	83 e2 1f             	and    $0x1f,%edx
  101a5b:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101a62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a65:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101a6c:	00 
  101a6d:	83 ca 0f             	or     $0xf,%edx
  101a70:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101a77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a7a:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101a81:	00 
  101a82:	83 e2 ef             	and    $0xffffffef,%edx
  101a85:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a8f:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101a96:	00 
  101a97:	83 e2 9f             	and    $0xffffff9f,%edx
  101a9a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101aa4:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101aab:	00 
  101aac:	83 ca 80             	or     $0xffffff80,%edx
  101aaf:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101ab6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ab9:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101ac0:	c1 e8 10             	shr    $0x10,%eax
  101ac3:	89 c2                	mov    %eax,%edx
  101ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ac8:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101acf:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
	for(i; i < 256 ; i++) {
  101ad0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101ad4:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101adb:	0f 8e 70 fd ff ff    	jle    101851 <idt_init+0x12>
  101ae1:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101ae8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101aeb:	0f 01 18             	lidtl  (%eax)
		   SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);		
		}
	    }
	}
	lidt(&idt_pd);
}
  101aee:	c9                   	leave  
  101aef:	c3                   	ret    

00101af0 <trapname>:

static const char *
trapname(int trapno) {
  101af0:	55                   	push   %ebp
  101af1:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101af3:	8b 45 08             	mov    0x8(%ebp),%eax
  101af6:	83 f8 13             	cmp    $0x13,%eax
  101af9:	77 0c                	ja     101b07 <trapname+0x17>
        return excnames[trapno];
  101afb:	8b 45 08             	mov    0x8(%ebp),%eax
  101afe:	8b 04 85 e0 3c 10 00 	mov    0x103ce0(,%eax,4),%eax
  101b05:	eb 18                	jmp    101b1f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b07:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b0b:	7e 0d                	jle    101b1a <trapname+0x2a>
  101b0d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b11:	7f 07                	jg     101b1a <trapname+0x2a>
        return "Hardware Interrupt";
  101b13:	b8 9f 39 10 00       	mov    $0x10399f,%eax
  101b18:	eb 05                	jmp    101b1f <trapname+0x2f>
    }
    return "(unknown trap)";
  101b1a:	b8 b2 39 10 00       	mov    $0x1039b2,%eax
}
  101b1f:	5d                   	pop    %ebp
  101b20:	c3                   	ret    

00101b21 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b21:	55                   	push   %ebp
  101b22:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b24:	8b 45 08             	mov    0x8(%ebp),%eax
  101b27:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b2b:	66 83 f8 08          	cmp    $0x8,%ax
  101b2f:	0f 94 c0             	sete   %al
  101b32:	0f b6 c0             	movzbl %al,%eax
}
  101b35:	5d                   	pop    %ebp
  101b36:	c3                   	ret    

00101b37 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b37:	55                   	push   %ebp
  101b38:	89 e5                	mov    %esp,%ebp
  101b3a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b44:	c7 04 24 f3 39 10 00 	movl   $0x1039f3,(%esp)
  101b4b:	e8 c7 e7 ff ff       	call   100317 <cprintf>
    print_regs(&tf->tf_regs);
  101b50:	8b 45 08             	mov    0x8(%ebp),%eax
  101b53:	89 04 24             	mov    %eax,(%esp)
  101b56:	e8 a1 01 00 00       	call   101cfc <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b62:	0f b7 c0             	movzwl %ax,%eax
  101b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b69:	c7 04 24 04 3a 10 00 	movl   $0x103a04,(%esp)
  101b70:	e8 a2 e7 ff ff       	call   100317 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b75:	8b 45 08             	mov    0x8(%ebp),%eax
  101b78:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b7c:	0f b7 c0             	movzwl %ax,%eax
  101b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b83:	c7 04 24 17 3a 10 00 	movl   $0x103a17,(%esp)
  101b8a:	e8 88 e7 ff ff       	call   100317 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b92:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b96:	0f b7 c0             	movzwl %ax,%eax
  101b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9d:	c7 04 24 2a 3a 10 00 	movl   $0x103a2a,(%esp)
  101ba4:	e8 6e e7 ff ff       	call   100317 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bac:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101bb0:	0f b7 c0             	movzwl %ax,%eax
  101bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb7:	c7 04 24 3d 3a 10 00 	movl   $0x103a3d,(%esp)
  101bbe:	e8 54 e7 ff ff       	call   100317 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc6:	8b 40 30             	mov    0x30(%eax),%eax
  101bc9:	89 04 24             	mov    %eax,(%esp)
  101bcc:	e8 1f ff ff ff       	call   101af0 <trapname>
  101bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  101bd4:	8b 52 30             	mov    0x30(%edx),%edx
  101bd7:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bdb:	89 54 24 04          	mov    %edx,0x4(%esp)
  101bdf:	c7 04 24 50 3a 10 00 	movl   $0x103a50,(%esp)
  101be6:	e8 2c e7 ff ff       	call   100317 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101beb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bee:	8b 40 34             	mov    0x34(%eax),%eax
  101bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf5:	c7 04 24 62 3a 10 00 	movl   $0x103a62,(%esp)
  101bfc:	e8 16 e7 ff ff       	call   100317 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c01:	8b 45 08             	mov    0x8(%ebp),%eax
  101c04:	8b 40 38             	mov    0x38(%eax),%eax
  101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0b:	c7 04 24 71 3a 10 00 	movl   $0x103a71,(%esp)
  101c12:	e8 00 e7 ff ff       	call   100317 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c17:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c1e:	0f b7 c0             	movzwl %ax,%eax
  101c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c25:	c7 04 24 80 3a 10 00 	movl   $0x103a80,(%esp)
  101c2c:	e8 e6 e6 ff ff       	call   100317 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c31:	8b 45 08             	mov    0x8(%ebp),%eax
  101c34:	8b 40 40             	mov    0x40(%eax),%eax
  101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3b:	c7 04 24 93 3a 10 00 	movl   $0x103a93,(%esp)
  101c42:	e8 d0 e6 ff ff       	call   100317 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c4e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c55:	eb 3e                	jmp    101c95 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c57:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5a:	8b 50 40             	mov    0x40(%eax),%edx
  101c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c60:	21 d0                	and    %edx,%eax
  101c62:	85 c0                	test   %eax,%eax
  101c64:	74 28                	je     101c8e <print_trapframe+0x157>
  101c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c69:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101c70:	85 c0                	test   %eax,%eax
  101c72:	74 1a                	je     101c8e <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c77:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c82:	c7 04 24 a2 3a 10 00 	movl   $0x103aa2,(%esp)
  101c89:	e8 89 e6 ff ff       	call   100317 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c8e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c92:	d1 65 f0             	shll   -0x10(%ebp)
  101c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c98:	83 f8 17             	cmp    $0x17,%eax
  101c9b:	76 ba                	jbe    101c57 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca0:	8b 40 40             	mov    0x40(%eax),%eax
  101ca3:	25 00 30 00 00       	and    $0x3000,%eax
  101ca8:	c1 e8 0c             	shr    $0xc,%eax
  101cab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101caf:	c7 04 24 a6 3a 10 00 	movl   $0x103aa6,(%esp)
  101cb6:	e8 5c e6 ff ff       	call   100317 <cprintf>

    if (!trap_in_kernel(tf)) {
  101cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbe:	89 04 24             	mov    %eax,(%esp)
  101cc1:	e8 5b fe ff ff       	call   101b21 <trap_in_kernel>
  101cc6:	85 c0                	test   %eax,%eax
  101cc8:	75 30                	jne    101cfa <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101cca:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccd:	8b 40 44             	mov    0x44(%eax),%eax
  101cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd4:	c7 04 24 af 3a 10 00 	movl   $0x103aaf,(%esp)
  101cdb:	e8 37 e6 ff ff       	call   100317 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce3:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ce7:	0f b7 c0             	movzwl %ax,%eax
  101cea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cee:	c7 04 24 be 3a 10 00 	movl   $0x103abe,(%esp)
  101cf5:	e8 1d e6 ff ff       	call   100317 <cprintf>
    }
}
  101cfa:	c9                   	leave  
  101cfb:	c3                   	ret    

00101cfc <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cfc:	55                   	push   %ebp
  101cfd:	89 e5                	mov    %esp,%ebp
  101cff:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d02:	8b 45 08             	mov    0x8(%ebp),%eax
  101d05:	8b 00                	mov    (%eax),%eax
  101d07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0b:	c7 04 24 d1 3a 10 00 	movl   $0x103ad1,(%esp)
  101d12:	e8 00 e6 ff ff       	call   100317 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d17:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1a:	8b 40 04             	mov    0x4(%eax),%eax
  101d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d21:	c7 04 24 e0 3a 10 00 	movl   $0x103ae0,(%esp)
  101d28:	e8 ea e5 ff ff       	call   100317 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d30:	8b 40 08             	mov    0x8(%eax),%eax
  101d33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d37:	c7 04 24 ef 3a 10 00 	movl   $0x103aef,(%esp)
  101d3e:	e8 d4 e5 ff ff       	call   100317 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d43:	8b 45 08             	mov    0x8(%ebp),%eax
  101d46:	8b 40 0c             	mov    0xc(%eax),%eax
  101d49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d4d:	c7 04 24 fe 3a 10 00 	movl   $0x103afe,(%esp)
  101d54:	e8 be e5 ff ff       	call   100317 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d59:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5c:	8b 40 10             	mov    0x10(%eax),%eax
  101d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d63:	c7 04 24 0d 3b 10 00 	movl   $0x103b0d,(%esp)
  101d6a:	e8 a8 e5 ff ff       	call   100317 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d72:	8b 40 14             	mov    0x14(%eax),%eax
  101d75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d79:	c7 04 24 1c 3b 10 00 	movl   $0x103b1c,(%esp)
  101d80:	e8 92 e5 ff ff       	call   100317 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d85:	8b 45 08             	mov    0x8(%ebp),%eax
  101d88:	8b 40 18             	mov    0x18(%eax),%eax
  101d8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8f:	c7 04 24 2b 3b 10 00 	movl   $0x103b2b,(%esp)
  101d96:	e8 7c e5 ff ff       	call   100317 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9e:	8b 40 1c             	mov    0x1c(%eax),%eax
  101da1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da5:	c7 04 24 3a 3b 10 00 	movl   $0x103b3a,(%esp)
  101dac:	e8 66 e5 ff ff       	call   100317 <cprintf>
}
  101db1:	c9                   	leave  
  101db2:	c3                   	ret    

00101db3 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101db3:	55                   	push   %ebp
  101db4:	89 e5                	mov    %esp,%ebp
  101db6:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101db9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbc:	8b 40 30             	mov    0x30(%eax),%eax
  101dbf:	83 f8 2f             	cmp    $0x2f,%eax
  101dc2:	77 21                	ja     101de5 <trap_dispatch+0x32>
  101dc4:	83 f8 2e             	cmp    $0x2e,%eax
  101dc7:	0f 83 04 01 00 00    	jae    101ed1 <trap_dispatch+0x11e>
  101dcd:	83 f8 21             	cmp    $0x21,%eax
  101dd0:	0f 84 81 00 00 00    	je     101e57 <trap_dispatch+0xa4>
  101dd6:	83 f8 24             	cmp    $0x24,%eax
  101dd9:	74 56                	je     101e31 <trap_dispatch+0x7e>
  101ddb:	83 f8 20             	cmp    $0x20,%eax
  101dde:	74 16                	je     101df6 <trap_dispatch+0x43>
  101de0:	e9 b4 00 00 00       	jmp    101e99 <trap_dispatch+0xe6>
  101de5:	83 e8 78             	sub    $0x78,%eax
  101de8:	83 f8 01             	cmp    $0x1,%eax
  101deb:	0f 87 a8 00 00 00    	ja     101e99 <trap_dispatch+0xe6>
  101df1:	e9 87 00 00 00       	jmp    101e7d <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks = ticks + 1;
  101df6:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101dfb:	83 c0 01             	add    $0x1,%eax
  101dfe:	a3 08 f9 10 00       	mov    %eax,0x10f908
	if(ticks % 100 == 0) {
  101e03:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101e09:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e0e:	89 c8                	mov    %ecx,%eax
  101e10:	f7 e2                	mul    %edx
  101e12:	89 d0                	mov    %edx,%eax
  101e14:	c1 e8 05             	shr    $0x5,%eax
  101e17:	6b c0 64             	imul   $0x64,%eax,%eax
  101e1a:	29 c1                	sub    %eax,%ecx
  101e1c:	89 c8                	mov    %ecx,%eax
  101e1e:	85 c0                	test   %eax,%eax
  101e20:	75 0a                	jne    101e2c <trap_dispatch+0x79>
	   print_ticks();	
  101e22:	e8 d6 f9 ff ff       	call   1017fd <print_ticks>
	}
        break;
  101e27:	e9 a6 00 00 00       	jmp    101ed2 <trap_dispatch+0x11f>
  101e2c:	e9 a1 00 00 00       	jmp    101ed2 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e31:	e8 9e f7 ff ff       	call   1015d4 <cons_getc>
  101e36:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e39:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e3d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e41:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e49:	c7 04 24 49 3b 10 00 	movl   $0x103b49,(%esp)
  101e50:	e8 c2 e4 ff ff       	call   100317 <cprintf>
        break;
  101e55:	eb 7b                	jmp    101ed2 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e57:	e8 78 f7 ff ff       	call   1015d4 <cons_getc>
  101e5c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e5f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e63:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e67:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e6f:	c7 04 24 5b 3b 10 00 	movl   $0x103b5b,(%esp)
  101e76:	e8 9c e4 ff ff       	call   100317 <cprintf>
        break;
  101e7b:	eb 55                	jmp    101ed2 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e7d:	c7 44 24 08 6a 3b 10 	movl   $0x103b6a,0x8(%esp)
  101e84:	00 
  101e85:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  101e8c:	00 
  101e8d:	c7 04 24 8e 39 10 00 	movl   $0x10398e,(%esp)
  101e94:	e8 0c ee ff ff       	call   100ca5 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e99:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ea0:	0f b7 c0             	movzwl %ax,%eax
  101ea3:	83 e0 03             	and    $0x3,%eax
  101ea6:	85 c0                	test   %eax,%eax
  101ea8:	75 28                	jne    101ed2 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  101ead:	89 04 24             	mov    %eax,(%esp)
  101eb0:	e8 82 fc ff ff       	call   101b37 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101eb5:	c7 44 24 08 7a 3b 10 	movl   $0x103b7a,0x8(%esp)
  101ebc:	00 
  101ebd:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  101ec4:	00 
  101ec5:	c7 04 24 8e 39 10 00 	movl   $0x10398e,(%esp)
  101ecc:	e8 d4 ed ff ff       	call   100ca5 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ed1:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ed2:	c9                   	leave  
  101ed3:	c3                   	ret    

00101ed4 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ed4:	55                   	push   %ebp
  101ed5:	89 e5                	mov    %esp,%ebp
  101ed7:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101eda:	8b 45 08             	mov    0x8(%ebp),%eax
  101edd:	89 04 24             	mov    %eax,(%esp)
  101ee0:	e8 ce fe ff ff       	call   101db3 <trap_dispatch>
}
  101ee5:	c9                   	leave  
  101ee6:	c3                   	ret    

00101ee7 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101ee7:	1e                   	push   %ds
    pushl %es
  101ee8:	06                   	push   %es
    pushl %fs
  101ee9:	0f a0                	push   %fs
    pushl %gs
  101eeb:	0f a8                	push   %gs
    pushal
  101eed:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101eee:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101ef3:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101ef5:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101ef7:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101ef8:	e8 d7 ff ff ff       	call   101ed4 <trap>

    # pop the pushed stack pointer
    popl %esp
  101efd:	5c                   	pop    %esp

00101efe <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101efe:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101eff:	0f a9                	pop    %gs
    popl %fs
  101f01:	0f a1                	pop    %fs
    popl %es
  101f03:	07                   	pop    %es
    popl %ds
  101f04:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f05:	83 c4 08             	add    $0x8,%esp
    iret
  101f08:	cf                   	iret   

00101f09 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f09:	6a 00                	push   $0x0
  pushl $0
  101f0b:	6a 00                	push   $0x0
  jmp __alltraps
  101f0d:	e9 d5 ff ff ff       	jmp    101ee7 <__alltraps>

00101f12 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f12:	6a 00                	push   $0x0
  pushl $1
  101f14:	6a 01                	push   $0x1
  jmp __alltraps
  101f16:	e9 cc ff ff ff       	jmp    101ee7 <__alltraps>

00101f1b <vector2>:
.globl vector2
vector2:
  pushl $0
  101f1b:	6a 00                	push   $0x0
  pushl $2
  101f1d:	6a 02                	push   $0x2
  jmp __alltraps
  101f1f:	e9 c3 ff ff ff       	jmp    101ee7 <__alltraps>

00101f24 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f24:	6a 00                	push   $0x0
  pushl $3
  101f26:	6a 03                	push   $0x3
  jmp __alltraps
  101f28:	e9 ba ff ff ff       	jmp    101ee7 <__alltraps>

00101f2d <vector4>:
.globl vector4
vector4:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $4
  101f2f:	6a 04                	push   $0x4
  jmp __alltraps
  101f31:	e9 b1 ff ff ff       	jmp    101ee7 <__alltraps>

00101f36 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $5
  101f38:	6a 05                	push   $0x5
  jmp __alltraps
  101f3a:	e9 a8 ff ff ff       	jmp    101ee7 <__alltraps>

00101f3f <vector6>:
.globl vector6
vector6:
  pushl $0
  101f3f:	6a 00                	push   $0x0
  pushl $6
  101f41:	6a 06                	push   $0x6
  jmp __alltraps
  101f43:	e9 9f ff ff ff       	jmp    101ee7 <__alltraps>

00101f48 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f48:	6a 00                	push   $0x0
  pushl $7
  101f4a:	6a 07                	push   $0x7
  jmp __alltraps
  101f4c:	e9 96 ff ff ff       	jmp    101ee7 <__alltraps>

00101f51 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f51:	6a 08                	push   $0x8
  jmp __alltraps
  101f53:	e9 8f ff ff ff       	jmp    101ee7 <__alltraps>

00101f58 <vector9>:
.globl vector9
vector9:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $9
  101f5a:	6a 09                	push   $0x9
  jmp __alltraps
  101f5c:	e9 86 ff ff ff       	jmp    101ee7 <__alltraps>

00101f61 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f61:	6a 0a                	push   $0xa
  jmp __alltraps
  101f63:	e9 7f ff ff ff       	jmp    101ee7 <__alltraps>

00101f68 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f68:	6a 0b                	push   $0xb
  jmp __alltraps
  101f6a:	e9 78 ff ff ff       	jmp    101ee7 <__alltraps>

00101f6f <vector12>:
.globl vector12
vector12:
  pushl $12
  101f6f:	6a 0c                	push   $0xc
  jmp __alltraps
  101f71:	e9 71 ff ff ff       	jmp    101ee7 <__alltraps>

00101f76 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f76:	6a 0d                	push   $0xd
  jmp __alltraps
  101f78:	e9 6a ff ff ff       	jmp    101ee7 <__alltraps>

00101f7d <vector14>:
.globl vector14
vector14:
  pushl $14
  101f7d:	6a 0e                	push   $0xe
  jmp __alltraps
  101f7f:	e9 63 ff ff ff       	jmp    101ee7 <__alltraps>

00101f84 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f84:	6a 00                	push   $0x0
  pushl $15
  101f86:	6a 0f                	push   $0xf
  jmp __alltraps
  101f88:	e9 5a ff ff ff       	jmp    101ee7 <__alltraps>

00101f8d <vector16>:
.globl vector16
vector16:
  pushl $0
  101f8d:	6a 00                	push   $0x0
  pushl $16
  101f8f:	6a 10                	push   $0x10
  jmp __alltraps
  101f91:	e9 51 ff ff ff       	jmp    101ee7 <__alltraps>

00101f96 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f96:	6a 11                	push   $0x11
  jmp __alltraps
  101f98:	e9 4a ff ff ff       	jmp    101ee7 <__alltraps>

00101f9d <vector18>:
.globl vector18
vector18:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $18
  101f9f:	6a 12                	push   $0x12
  jmp __alltraps
  101fa1:	e9 41 ff ff ff       	jmp    101ee7 <__alltraps>

00101fa6 <vector19>:
.globl vector19
vector19:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $19
  101fa8:	6a 13                	push   $0x13
  jmp __alltraps
  101faa:	e9 38 ff ff ff       	jmp    101ee7 <__alltraps>

00101faf <vector20>:
.globl vector20
vector20:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $20
  101fb1:	6a 14                	push   $0x14
  jmp __alltraps
  101fb3:	e9 2f ff ff ff       	jmp    101ee7 <__alltraps>

00101fb8 <vector21>:
.globl vector21
vector21:
  pushl $0
  101fb8:	6a 00                	push   $0x0
  pushl $21
  101fba:	6a 15                	push   $0x15
  jmp __alltraps
  101fbc:	e9 26 ff ff ff       	jmp    101ee7 <__alltraps>

00101fc1 <vector22>:
.globl vector22
vector22:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $22
  101fc3:	6a 16                	push   $0x16
  jmp __alltraps
  101fc5:	e9 1d ff ff ff       	jmp    101ee7 <__alltraps>

00101fca <vector23>:
.globl vector23
vector23:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $23
  101fcc:	6a 17                	push   $0x17
  jmp __alltraps
  101fce:	e9 14 ff ff ff       	jmp    101ee7 <__alltraps>

00101fd3 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $24
  101fd5:	6a 18                	push   $0x18
  jmp __alltraps
  101fd7:	e9 0b ff ff ff       	jmp    101ee7 <__alltraps>

00101fdc <vector25>:
.globl vector25
vector25:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $25
  101fde:	6a 19                	push   $0x19
  jmp __alltraps
  101fe0:	e9 02 ff ff ff       	jmp    101ee7 <__alltraps>

00101fe5 <vector26>:
.globl vector26
vector26:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $26
  101fe7:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fe9:	e9 f9 fe ff ff       	jmp    101ee7 <__alltraps>

00101fee <vector27>:
.globl vector27
vector27:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $27
  101ff0:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ff2:	e9 f0 fe ff ff       	jmp    101ee7 <__alltraps>

00101ff7 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $28
  101ff9:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ffb:	e9 e7 fe ff ff       	jmp    101ee7 <__alltraps>

00102000 <vector29>:
.globl vector29
vector29:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $29
  102002:	6a 1d                	push   $0x1d
  jmp __alltraps
  102004:	e9 de fe ff ff       	jmp    101ee7 <__alltraps>

00102009 <vector30>:
.globl vector30
vector30:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $30
  10200b:	6a 1e                	push   $0x1e
  jmp __alltraps
  10200d:	e9 d5 fe ff ff       	jmp    101ee7 <__alltraps>

00102012 <vector31>:
.globl vector31
vector31:
  pushl $0
  102012:	6a 00                	push   $0x0
  pushl $31
  102014:	6a 1f                	push   $0x1f
  jmp __alltraps
  102016:	e9 cc fe ff ff       	jmp    101ee7 <__alltraps>

0010201b <vector32>:
.globl vector32
vector32:
  pushl $0
  10201b:	6a 00                	push   $0x0
  pushl $32
  10201d:	6a 20                	push   $0x20
  jmp __alltraps
  10201f:	e9 c3 fe ff ff       	jmp    101ee7 <__alltraps>

00102024 <vector33>:
.globl vector33
vector33:
  pushl $0
  102024:	6a 00                	push   $0x0
  pushl $33
  102026:	6a 21                	push   $0x21
  jmp __alltraps
  102028:	e9 ba fe ff ff       	jmp    101ee7 <__alltraps>

0010202d <vector34>:
.globl vector34
vector34:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $34
  10202f:	6a 22                	push   $0x22
  jmp __alltraps
  102031:	e9 b1 fe ff ff       	jmp    101ee7 <__alltraps>

00102036 <vector35>:
.globl vector35
vector35:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $35
  102038:	6a 23                	push   $0x23
  jmp __alltraps
  10203a:	e9 a8 fe ff ff       	jmp    101ee7 <__alltraps>

0010203f <vector36>:
.globl vector36
vector36:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $36
  102041:	6a 24                	push   $0x24
  jmp __alltraps
  102043:	e9 9f fe ff ff       	jmp    101ee7 <__alltraps>

00102048 <vector37>:
.globl vector37
vector37:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $37
  10204a:	6a 25                	push   $0x25
  jmp __alltraps
  10204c:	e9 96 fe ff ff       	jmp    101ee7 <__alltraps>

00102051 <vector38>:
.globl vector38
vector38:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $38
  102053:	6a 26                	push   $0x26
  jmp __alltraps
  102055:	e9 8d fe ff ff       	jmp    101ee7 <__alltraps>

0010205a <vector39>:
.globl vector39
vector39:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $39
  10205c:	6a 27                	push   $0x27
  jmp __alltraps
  10205e:	e9 84 fe ff ff       	jmp    101ee7 <__alltraps>

00102063 <vector40>:
.globl vector40
vector40:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $40
  102065:	6a 28                	push   $0x28
  jmp __alltraps
  102067:	e9 7b fe ff ff       	jmp    101ee7 <__alltraps>

0010206c <vector41>:
.globl vector41
vector41:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $41
  10206e:	6a 29                	push   $0x29
  jmp __alltraps
  102070:	e9 72 fe ff ff       	jmp    101ee7 <__alltraps>

00102075 <vector42>:
.globl vector42
vector42:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $42
  102077:	6a 2a                	push   $0x2a
  jmp __alltraps
  102079:	e9 69 fe ff ff       	jmp    101ee7 <__alltraps>

0010207e <vector43>:
.globl vector43
vector43:
  pushl $0
  10207e:	6a 00                	push   $0x0
  pushl $43
  102080:	6a 2b                	push   $0x2b
  jmp __alltraps
  102082:	e9 60 fe ff ff       	jmp    101ee7 <__alltraps>

00102087 <vector44>:
.globl vector44
vector44:
  pushl $0
  102087:	6a 00                	push   $0x0
  pushl $44
  102089:	6a 2c                	push   $0x2c
  jmp __alltraps
  10208b:	e9 57 fe ff ff       	jmp    101ee7 <__alltraps>

00102090 <vector45>:
.globl vector45
vector45:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $45
  102092:	6a 2d                	push   $0x2d
  jmp __alltraps
  102094:	e9 4e fe ff ff       	jmp    101ee7 <__alltraps>

00102099 <vector46>:
.globl vector46
vector46:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $46
  10209b:	6a 2e                	push   $0x2e
  jmp __alltraps
  10209d:	e9 45 fe ff ff       	jmp    101ee7 <__alltraps>

001020a2 <vector47>:
.globl vector47
vector47:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $47
  1020a4:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020a6:	e9 3c fe ff ff       	jmp    101ee7 <__alltraps>

001020ab <vector48>:
.globl vector48
vector48:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $48
  1020ad:	6a 30                	push   $0x30
  jmp __alltraps
  1020af:	e9 33 fe ff ff       	jmp    101ee7 <__alltraps>

001020b4 <vector49>:
.globl vector49
vector49:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $49
  1020b6:	6a 31                	push   $0x31
  jmp __alltraps
  1020b8:	e9 2a fe ff ff       	jmp    101ee7 <__alltraps>

001020bd <vector50>:
.globl vector50
vector50:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $50
  1020bf:	6a 32                	push   $0x32
  jmp __alltraps
  1020c1:	e9 21 fe ff ff       	jmp    101ee7 <__alltraps>

001020c6 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $51
  1020c8:	6a 33                	push   $0x33
  jmp __alltraps
  1020ca:	e9 18 fe ff ff       	jmp    101ee7 <__alltraps>

001020cf <vector52>:
.globl vector52
vector52:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $52
  1020d1:	6a 34                	push   $0x34
  jmp __alltraps
  1020d3:	e9 0f fe ff ff       	jmp    101ee7 <__alltraps>

001020d8 <vector53>:
.globl vector53
vector53:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $53
  1020da:	6a 35                	push   $0x35
  jmp __alltraps
  1020dc:	e9 06 fe ff ff       	jmp    101ee7 <__alltraps>

001020e1 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $54
  1020e3:	6a 36                	push   $0x36
  jmp __alltraps
  1020e5:	e9 fd fd ff ff       	jmp    101ee7 <__alltraps>

001020ea <vector55>:
.globl vector55
vector55:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $55
  1020ec:	6a 37                	push   $0x37
  jmp __alltraps
  1020ee:	e9 f4 fd ff ff       	jmp    101ee7 <__alltraps>

001020f3 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $56
  1020f5:	6a 38                	push   $0x38
  jmp __alltraps
  1020f7:	e9 eb fd ff ff       	jmp    101ee7 <__alltraps>

001020fc <vector57>:
.globl vector57
vector57:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $57
  1020fe:	6a 39                	push   $0x39
  jmp __alltraps
  102100:	e9 e2 fd ff ff       	jmp    101ee7 <__alltraps>

00102105 <vector58>:
.globl vector58
vector58:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $58
  102107:	6a 3a                	push   $0x3a
  jmp __alltraps
  102109:	e9 d9 fd ff ff       	jmp    101ee7 <__alltraps>

0010210e <vector59>:
.globl vector59
vector59:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $59
  102110:	6a 3b                	push   $0x3b
  jmp __alltraps
  102112:	e9 d0 fd ff ff       	jmp    101ee7 <__alltraps>

00102117 <vector60>:
.globl vector60
vector60:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $60
  102119:	6a 3c                	push   $0x3c
  jmp __alltraps
  10211b:	e9 c7 fd ff ff       	jmp    101ee7 <__alltraps>

00102120 <vector61>:
.globl vector61
vector61:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $61
  102122:	6a 3d                	push   $0x3d
  jmp __alltraps
  102124:	e9 be fd ff ff       	jmp    101ee7 <__alltraps>

00102129 <vector62>:
.globl vector62
vector62:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $62
  10212b:	6a 3e                	push   $0x3e
  jmp __alltraps
  10212d:	e9 b5 fd ff ff       	jmp    101ee7 <__alltraps>

00102132 <vector63>:
.globl vector63
vector63:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $63
  102134:	6a 3f                	push   $0x3f
  jmp __alltraps
  102136:	e9 ac fd ff ff       	jmp    101ee7 <__alltraps>

0010213b <vector64>:
.globl vector64
vector64:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $64
  10213d:	6a 40                	push   $0x40
  jmp __alltraps
  10213f:	e9 a3 fd ff ff       	jmp    101ee7 <__alltraps>

00102144 <vector65>:
.globl vector65
vector65:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $65
  102146:	6a 41                	push   $0x41
  jmp __alltraps
  102148:	e9 9a fd ff ff       	jmp    101ee7 <__alltraps>

0010214d <vector66>:
.globl vector66
vector66:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $66
  10214f:	6a 42                	push   $0x42
  jmp __alltraps
  102151:	e9 91 fd ff ff       	jmp    101ee7 <__alltraps>

00102156 <vector67>:
.globl vector67
vector67:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $67
  102158:	6a 43                	push   $0x43
  jmp __alltraps
  10215a:	e9 88 fd ff ff       	jmp    101ee7 <__alltraps>

0010215f <vector68>:
.globl vector68
vector68:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $68
  102161:	6a 44                	push   $0x44
  jmp __alltraps
  102163:	e9 7f fd ff ff       	jmp    101ee7 <__alltraps>

00102168 <vector69>:
.globl vector69
vector69:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $69
  10216a:	6a 45                	push   $0x45
  jmp __alltraps
  10216c:	e9 76 fd ff ff       	jmp    101ee7 <__alltraps>

00102171 <vector70>:
.globl vector70
vector70:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $70
  102173:	6a 46                	push   $0x46
  jmp __alltraps
  102175:	e9 6d fd ff ff       	jmp    101ee7 <__alltraps>

0010217a <vector71>:
.globl vector71
vector71:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $71
  10217c:	6a 47                	push   $0x47
  jmp __alltraps
  10217e:	e9 64 fd ff ff       	jmp    101ee7 <__alltraps>

00102183 <vector72>:
.globl vector72
vector72:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $72
  102185:	6a 48                	push   $0x48
  jmp __alltraps
  102187:	e9 5b fd ff ff       	jmp    101ee7 <__alltraps>

0010218c <vector73>:
.globl vector73
vector73:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $73
  10218e:	6a 49                	push   $0x49
  jmp __alltraps
  102190:	e9 52 fd ff ff       	jmp    101ee7 <__alltraps>

00102195 <vector74>:
.globl vector74
vector74:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $74
  102197:	6a 4a                	push   $0x4a
  jmp __alltraps
  102199:	e9 49 fd ff ff       	jmp    101ee7 <__alltraps>

0010219e <vector75>:
.globl vector75
vector75:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $75
  1021a0:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021a2:	e9 40 fd ff ff       	jmp    101ee7 <__alltraps>

001021a7 <vector76>:
.globl vector76
vector76:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $76
  1021a9:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021ab:	e9 37 fd ff ff       	jmp    101ee7 <__alltraps>

001021b0 <vector77>:
.globl vector77
vector77:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $77
  1021b2:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021b4:	e9 2e fd ff ff       	jmp    101ee7 <__alltraps>

001021b9 <vector78>:
.globl vector78
vector78:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $78
  1021bb:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021bd:	e9 25 fd ff ff       	jmp    101ee7 <__alltraps>

001021c2 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $79
  1021c4:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021c6:	e9 1c fd ff ff       	jmp    101ee7 <__alltraps>

001021cb <vector80>:
.globl vector80
vector80:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $80
  1021cd:	6a 50                	push   $0x50
  jmp __alltraps
  1021cf:	e9 13 fd ff ff       	jmp    101ee7 <__alltraps>

001021d4 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $81
  1021d6:	6a 51                	push   $0x51
  jmp __alltraps
  1021d8:	e9 0a fd ff ff       	jmp    101ee7 <__alltraps>

001021dd <vector82>:
.globl vector82
vector82:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $82
  1021df:	6a 52                	push   $0x52
  jmp __alltraps
  1021e1:	e9 01 fd ff ff       	jmp    101ee7 <__alltraps>

001021e6 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $83
  1021e8:	6a 53                	push   $0x53
  jmp __alltraps
  1021ea:	e9 f8 fc ff ff       	jmp    101ee7 <__alltraps>

001021ef <vector84>:
.globl vector84
vector84:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $84
  1021f1:	6a 54                	push   $0x54
  jmp __alltraps
  1021f3:	e9 ef fc ff ff       	jmp    101ee7 <__alltraps>

001021f8 <vector85>:
.globl vector85
vector85:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $85
  1021fa:	6a 55                	push   $0x55
  jmp __alltraps
  1021fc:	e9 e6 fc ff ff       	jmp    101ee7 <__alltraps>

00102201 <vector86>:
.globl vector86
vector86:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $86
  102203:	6a 56                	push   $0x56
  jmp __alltraps
  102205:	e9 dd fc ff ff       	jmp    101ee7 <__alltraps>

0010220a <vector87>:
.globl vector87
vector87:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $87
  10220c:	6a 57                	push   $0x57
  jmp __alltraps
  10220e:	e9 d4 fc ff ff       	jmp    101ee7 <__alltraps>

00102213 <vector88>:
.globl vector88
vector88:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $88
  102215:	6a 58                	push   $0x58
  jmp __alltraps
  102217:	e9 cb fc ff ff       	jmp    101ee7 <__alltraps>

0010221c <vector89>:
.globl vector89
vector89:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $89
  10221e:	6a 59                	push   $0x59
  jmp __alltraps
  102220:	e9 c2 fc ff ff       	jmp    101ee7 <__alltraps>

00102225 <vector90>:
.globl vector90
vector90:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $90
  102227:	6a 5a                	push   $0x5a
  jmp __alltraps
  102229:	e9 b9 fc ff ff       	jmp    101ee7 <__alltraps>

0010222e <vector91>:
.globl vector91
vector91:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $91
  102230:	6a 5b                	push   $0x5b
  jmp __alltraps
  102232:	e9 b0 fc ff ff       	jmp    101ee7 <__alltraps>

00102237 <vector92>:
.globl vector92
vector92:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $92
  102239:	6a 5c                	push   $0x5c
  jmp __alltraps
  10223b:	e9 a7 fc ff ff       	jmp    101ee7 <__alltraps>

00102240 <vector93>:
.globl vector93
vector93:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $93
  102242:	6a 5d                	push   $0x5d
  jmp __alltraps
  102244:	e9 9e fc ff ff       	jmp    101ee7 <__alltraps>

00102249 <vector94>:
.globl vector94
vector94:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $94
  10224b:	6a 5e                	push   $0x5e
  jmp __alltraps
  10224d:	e9 95 fc ff ff       	jmp    101ee7 <__alltraps>

00102252 <vector95>:
.globl vector95
vector95:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $95
  102254:	6a 5f                	push   $0x5f
  jmp __alltraps
  102256:	e9 8c fc ff ff       	jmp    101ee7 <__alltraps>

0010225b <vector96>:
.globl vector96
vector96:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $96
  10225d:	6a 60                	push   $0x60
  jmp __alltraps
  10225f:	e9 83 fc ff ff       	jmp    101ee7 <__alltraps>

00102264 <vector97>:
.globl vector97
vector97:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $97
  102266:	6a 61                	push   $0x61
  jmp __alltraps
  102268:	e9 7a fc ff ff       	jmp    101ee7 <__alltraps>

0010226d <vector98>:
.globl vector98
vector98:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $98
  10226f:	6a 62                	push   $0x62
  jmp __alltraps
  102271:	e9 71 fc ff ff       	jmp    101ee7 <__alltraps>

00102276 <vector99>:
.globl vector99
vector99:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $99
  102278:	6a 63                	push   $0x63
  jmp __alltraps
  10227a:	e9 68 fc ff ff       	jmp    101ee7 <__alltraps>

0010227f <vector100>:
.globl vector100
vector100:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $100
  102281:	6a 64                	push   $0x64
  jmp __alltraps
  102283:	e9 5f fc ff ff       	jmp    101ee7 <__alltraps>

00102288 <vector101>:
.globl vector101
vector101:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $101
  10228a:	6a 65                	push   $0x65
  jmp __alltraps
  10228c:	e9 56 fc ff ff       	jmp    101ee7 <__alltraps>

00102291 <vector102>:
.globl vector102
vector102:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $102
  102293:	6a 66                	push   $0x66
  jmp __alltraps
  102295:	e9 4d fc ff ff       	jmp    101ee7 <__alltraps>

0010229a <vector103>:
.globl vector103
vector103:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $103
  10229c:	6a 67                	push   $0x67
  jmp __alltraps
  10229e:	e9 44 fc ff ff       	jmp    101ee7 <__alltraps>

001022a3 <vector104>:
.globl vector104
vector104:
  pushl $0
  1022a3:	6a 00                	push   $0x0
  pushl $104
  1022a5:	6a 68                	push   $0x68
  jmp __alltraps
  1022a7:	e9 3b fc ff ff       	jmp    101ee7 <__alltraps>

001022ac <vector105>:
.globl vector105
vector105:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $105
  1022ae:	6a 69                	push   $0x69
  jmp __alltraps
  1022b0:	e9 32 fc ff ff       	jmp    101ee7 <__alltraps>

001022b5 <vector106>:
.globl vector106
vector106:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $106
  1022b7:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022b9:	e9 29 fc ff ff       	jmp    101ee7 <__alltraps>

001022be <vector107>:
.globl vector107
vector107:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $107
  1022c0:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022c2:	e9 20 fc ff ff       	jmp    101ee7 <__alltraps>

001022c7 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $108
  1022c9:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022cb:	e9 17 fc ff ff       	jmp    101ee7 <__alltraps>

001022d0 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $109
  1022d2:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022d4:	e9 0e fc ff ff       	jmp    101ee7 <__alltraps>

001022d9 <vector110>:
.globl vector110
vector110:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $110
  1022db:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022dd:	e9 05 fc ff ff       	jmp    101ee7 <__alltraps>

001022e2 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $111
  1022e4:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022e6:	e9 fc fb ff ff       	jmp    101ee7 <__alltraps>

001022eb <vector112>:
.globl vector112
vector112:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $112
  1022ed:	6a 70                	push   $0x70
  jmp __alltraps
  1022ef:	e9 f3 fb ff ff       	jmp    101ee7 <__alltraps>

001022f4 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $113
  1022f6:	6a 71                	push   $0x71
  jmp __alltraps
  1022f8:	e9 ea fb ff ff       	jmp    101ee7 <__alltraps>

001022fd <vector114>:
.globl vector114
vector114:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $114
  1022ff:	6a 72                	push   $0x72
  jmp __alltraps
  102301:	e9 e1 fb ff ff       	jmp    101ee7 <__alltraps>

00102306 <vector115>:
.globl vector115
vector115:
  pushl $0
  102306:	6a 00                	push   $0x0
  pushl $115
  102308:	6a 73                	push   $0x73
  jmp __alltraps
  10230a:	e9 d8 fb ff ff       	jmp    101ee7 <__alltraps>

0010230f <vector116>:
.globl vector116
vector116:
  pushl $0
  10230f:	6a 00                	push   $0x0
  pushl $116
  102311:	6a 74                	push   $0x74
  jmp __alltraps
  102313:	e9 cf fb ff ff       	jmp    101ee7 <__alltraps>

00102318 <vector117>:
.globl vector117
vector117:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $117
  10231a:	6a 75                	push   $0x75
  jmp __alltraps
  10231c:	e9 c6 fb ff ff       	jmp    101ee7 <__alltraps>

00102321 <vector118>:
.globl vector118
vector118:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $118
  102323:	6a 76                	push   $0x76
  jmp __alltraps
  102325:	e9 bd fb ff ff       	jmp    101ee7 <__alltraps>

0010232a <vector119>:
.globl vector119
vector119:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $119
  10232c:	6a 77                	push   $0x77
  jmp __alltraps
  10232e:	e9 b4 fb ff ff       	jmp    101ee7 <__alltraps>

00102333 <vector120>:
.globl vector120
vector120:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $120
  102335:	6a 78                	push   $0x78
  jmp __alltraps
  102337:	e9 ab fb ff ff       	jmp    101ee7 <__alltraps>

0010233c <vector121>:
.globl vector121
vector121:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $121
  10233e:	6a 79                	push   $0x79
  jmp __alltraps
  102340:	e9 a2 fb ff ff       	jmp    101ee7 <__alltraps>

00102345 <vector122>:
.globl vector122
vector122:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $122
  102347:	6a 7a                	push   $0x7a
  jmp __alltraps
  102349:	e9 99 fb ff ff       	jmp    101ee7 <__alltraps>

0010234e <vector123>:
.globl vector123
vector123:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $123
  102350:	6a 7b                	push   $0x7b
  jmp __alltraps
  102352:	e9 90 fb ff ff       	jmp    101ee7 <__alltraps>

00102357 <vector124>:
.globl vector124
vector124:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $124
  102359:	6a 7c                	push   $0x7c
  jmp __alltraps
  10235b:	e9 87 fb ff ff       	jmp    101ee7 <__alltraps>

00102360 <vector125>:
.globl vector125
vector125:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $125
  102362:	6a 7d                	push   $0x7d
  jmp __alltraps
  102364:	e9 7e fb ff ff       	jmp    101ee7 <__alltraps>

00102369 <vector126>:
.globl vector126
vector126:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $126
  10236b:	6a 7e                	push   $0x7e
  jmp __alltraps
  10236d:	e9 75 fb ff ff       	jmp    101ee7 <__alltraps>

00102372 <vector127>:
.globl vector127
vector127:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $127
  102374:	6a 7f                	push   $0x7f
  jmp __alltraps
  102376:	e9 6c fb ff ff       	jmp    101ee7 <__alltraps>

0010237b <vector128>:
.globl vector128
vector128:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $128
  10237d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102382:	e9 60 fb ff ff       	jmp    101ee7 <__alltraps>

00102387 <vector129>:
.globl vector129
vector129:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $129
  102389:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10238e:	e9 54 fb ff ff       	jmp    101ee7 <__alltraps>

00102393 <vector130>:
.globl vector130
vector130:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $130
  102395:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10239a:	e9 48 fb ff ff       	jmp    101ee7 <__alltraps>

0010239f <vector131>:
.globl vector131
vector131:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $131
  1023a1:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023a6:	e9 3c fb ff ff       	jmp    101ee7 <__alltraps>

001023ab <vector132>:
.globl vector132
vector132:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $132
  1023ad:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023b2:	e9 30 fb ff ff       	jmp    101ee7 <__alltraps>

001023b7 <vector133>:
.globl vector133
vector133:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $133
  1023b9:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023be:	e9 24 fb ff ff       	jmp    101ee7 <__alltraps>

001023c3 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $134
  1023c5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023ca:	e9 18 fb ff ff       	jmp    101ee7 <__alltraps>

001023cf <vector135>:
.globl vector135
vector135:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $135
  1023d1:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023d6:	e9 0c fb ff ff       	jmp    101ee7 <__alltraps>

001023db <vector136>:
.globl vector136
vector136:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $136
  1023dd:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023e2:	e9 00 fb ff ff       	jmp    101ee7 <__alltraps>

001023e7 <vector137>:
.globl vector137
vector137:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $137
  1023e9:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023ee:	e9 f4 fa ff ff       	jmp    101ee7 <__alltraps>

001023f3 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $138
  1023f5:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023fa:	e9 e8 fa ff ff       	jmp    101ee7 <__alltraps>

001023ff <vector139>:
.globl vector139
vector139:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $139
  102401:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102406:	e9 dc fa ff ff       	jmp    101ee7 <__alltraps>

0010240b <vector140>:
.globl vector140
vector140:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $140
  10240d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102412:	e9 d0 fa ff ff       	jmp    101ee7 <__alltraps>

00102417 <vector141>:
.globl vector141
vector141:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $141
  102419:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10241e:	e9 c4 fa ff ff       	jmp    101ee7 <__alltraps>

00102423 <vector142>:
.globl vector142
vector142:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $142
  102425:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10242a:	e9 b8 fa ff ff       	jmp    101ee7 <__alltraps>

0010242f <vector143>:
.globl vector143
vector143:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $143
  102431:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102436:	e9 ac fa ff ff       	jmp    101ee7 <__alltraps>

0010243b <vector144>:
.globl vector144
vector144:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $144
  10243d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102442:	e9 a0 fa ff ff       	jmp    101ee7 <__alltraps>

00102447 <vector145>:
.globl vector145
vector145:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $145
  102449:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10244e:	e9 94 fa ff ff       	jmp    101ee7 <__alltraps>

00102453 <vector146>:
.globl vector146
vector146:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $146
  102455:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10245a:	e9 88 fa ff ff       	jmp    101ee7 <__alltraps>

0010245f <vector147>:
.globl vector147
vector147:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $147
  102461:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102466:	e9 7c fa ff ff       	jmp    101ee7 <__alltraps>

0010246b <vector148>:
.globl vector148
vector148:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $148
  10246d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102472:	e9 70 fa ff ff       	jmp    101ee7 <__alltraps>

00102477 <vector149>:
.globl vector149
vector149:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $149
  102479:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10247e:	e9 64 fa ff ff       	jmp    101ee7 <__alltraps>

00102483 <vector150>:
.globl vector150
vector150:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $150
  102485:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10248a:	e9 58 fa ff ff       	jmp    101ee7 <__alltraps>

0010248f <vector151>:
.globl vector151
vector151:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $151
  102491:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102496:	e9 4c fa ff ff       	jmp    101ee7 <__alltraps>

0010249b <vector152>:
.globl vector152
vector152:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $152
  10249d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024a2:	e9 40 fa ff ff       	jmp    101ee7 <__alltraps>

001024a7 <vector153>:
.globl vector153
vector153:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $153
  1024a9:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024ae:	e9 34 fa ff ff       	jmp    101ee7 <__alltraps>

001024b3 <vector154>:
.globl vector154
vector154:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $154
  1024b5:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024ba:	e9 28 fa ff ff       	jmp    101ee7 <__alltraps>

001024bf <vector155>:
.globl vector155
vector155:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $155
  1024c1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024c6:	e9 1c fa ff ff       	jmp    101ee7 <__alltraps>

001024cb <vector156>:
.globl vector156
vector156:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $156
  1024cd:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024d2:	e9 10 fa ff ff       	jmp    101ee7 <__alltraps>

001024d7 <vector157>:
.globl vector157
vector157:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $157
  1024d9:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024de:	e9 04 fa ff ff       	jmp    101ee7 <__alltraps>

001024e3 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $158
  1024e5:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024ea:	e9 f8 f9 ff ff       	jmp    101ee7 <__alltraps>

001024ef <vector159>:
.globl vector159
vector159:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $159
  1024f1:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024f6:	e9 ec f9 ff ff       	jmp    101ee7 <__alltraps>

001024fb <vector160>:
.globl vector160
vector160:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $160
  1024fd:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102502:	e9 e0 f9 ff ff       	jmp    101ee7 <__alltraps>

00102507 <vector161>:
.globl vector161
vector161:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $161
  102509:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10250e:	e9 d4 f9 ff ff       	jmp    101ee7 <__alltraps>

00102513 <vector162>:
.globl vector162
vector162:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $162
  102515:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10251a:	e9 c8 f9 ff ff       	jmp    101ee7 <__alltraps>

0010251f <vector163>:
.globl vector163
vector163:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $163
  102521:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102526:	e9 bc f9 ff ff       	jmp    101ee7 <__alltraps>

0010252b <vector164>:
.globl vector164
vector164:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $164
  10252d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102532:	e9 b0 f9 ff ff       	jmp    101ee7 <__alltraps>

00102537 <vector165>:
.globl vector165
vector165:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $165
  102539:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10253e:	e9 a4 f9 ff ff       	jmp    101ee7 <__alltraps>

00102543 <vector166>:
.globl vector166
vector166:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $166
  102545:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10254a:	e9 98 f9 ff ff       	jmp    101ee7 <__alltraps>

0010254f <vector167>:
.globl vector167
vector167:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $167
  102551:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102556:	e9 8c f9 ff ff       	jmp    101ee7 <__alltraps>

0010255b <vector168>:
.globl vector168
vector168:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $168
  10255d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102562:	e9 80 f9 ff ff       	jmp    101ee7 <__alltraps>

00102567 <vector169>:
.globl vector169
vector169:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $169
  102569:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10256e:	e9 74 f9 ff ff       	jmp    101ee7 <__alltraps>

00102573 <vector170>:
.globl vector170
vector170:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $170
  102575:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10257a:	e9 68 f9 ff ff       	jmp    101ee7 <__alltraps>

0010257f <vector171>:
.globl vector171
vector171:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $171
  102581:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102586:	e9 5c f9 ff ff       	jmp    101ee7 <__alltraps>

0010258b <vector172>:
.globl vector172
vector172:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $172
  10258d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102592:	e9 50 f9 ff ff       	jmp    101ee7 <__alltraps>

00102597 <vector173>:
.globl vector173
vector173:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $173
  102599:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10259e:	e9 44 f9 ff ff       	jmp    101ee7 <__alltraps>

001025a3 <vector174>:
.globl vector174
vector174:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $174
  1025a5:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025aa:	e9 38 f9 ff ff       	jmp    101ee7 <__alltraps>

001025af <vector175>:
.globl vector175
vector175:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $175
  1025b1:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025b6:	e9 2c f9 ff ff       	jmp    101ee7 <__alltraps>

001025bb <vector176>:
.globl vector176
vector176:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $176
  1025bd:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025c2:	e9 20 f9 ff ff       	jmp    101ee7 <__alltraps>

001025c7 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $177
  1025c9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025ce:	e9 14 f9 ff ff       	jmp    101ee7 <__alltraps>

001025d3 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $178
  1025d5:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025da:	e9 08 f9 ff ff       	jmp    101ee7 <__alltraps>

001025df <vector179>:
.globl vector179
vector179:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $179
  1025e1:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025e6:	e9 fc f8 ff ff       	jmp    101ee7 <__alltraps>

001025eb <vector180>:
.globl vector180
vector180:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $180
  1025ed:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025f2:	e9 f0 f8 ff ff       	jmp    101ee7 <__alltraps>

001025f7 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $181
  1025f9:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025fe:	e9 e4 f8 ff ff       	jmp    101ee7 <__alltraps>

00102603 <vector182>:
.globl vector182
vector182:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $182
  102605:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10260a:	e9 d8 f8 ff ff       	jmp    101ee7 <__alltraps>

0010260f <vector183>:
.globl vector183
vector183:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $183
  102611:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102616:	e9 cc f8 ff ff       	jmp    101ee7 <__alltraps>

0010261b <vector184>:
.globl vector184
vector184:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $184
  10261d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102622:	e9 c0 f8 ff ff       	jmp    101ee7 <__alltraps>

00102627 <vector185>:
.globl vector185
vector185:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $185
  102629:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10262e:	e9 b4 f8 ff ff       	jmp    101ee7 <__alltraps>

00102633 <vector186>:
.globl vector186
vector186:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $186
  102635:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10263a:	e9 a8 f8 ff ff       	jmp    101ee7 <__alltraps>

0010263f <vector187>:
.globl vector187
vector187:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $187
  102641:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102646:	e9 9c f8 ff ff       	jmp    101ee7 <__alltraps>

0010264b <vector188>:
.globl vector188
vector188:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $188
  10264d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102652:	e9 90 f8 ff ff       	jmp    101ee7 <__alltraps>

00102657 <vector189>:
.globl vector189
vector189:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $189
  102659:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10265e:	e9 84 f8 ff ff       	jmp    101ee7 <__alltraps>

00102663 <vector190>:
.globl vector190
vector190:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $190
  102665:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10266a:	e9 78 f8 ff ff       	jmp    101ee7 <__alltraps>

0010266f <vector191>:
.globl vector191
vector191:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $191
  102671:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102676:	e9 6c f8 ff ff       	jmp    101ee7 <__alltraps>

0010267b <vector192>:
.globl vector192
vector192:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $192
  10267d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102682:	e9 60 f8 ff ff       	jmp    101ee7 <__alltraps>

00102687 <vector193>:
.globl vector193
vector193:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $193
  102689:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10268e:	e9 54 f8 ff ff       	jmp    101ee7 <__alltraps>

00102693 <vector194>:
.globl vector194
vector194:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $194
  102695:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10269a:	e9 48 f8 ff ff       	jmp    101ee7 <__alltraps>

0010269f <vector195>:
.globl vector195
vector195:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $195
  1026a1:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026a6:	e9 3c f8 ff ff       	jmp    101ee7 <__alltraps>

001026ab <vector196>:
.globl vector196
vector196:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $196
  1026ad:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026b2:	e9 30 f8 ff ff       	jmp    101ee7 <__alltraps>

001026b7 <vector197>:
.globl vector197
vector197:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $197
  1026b9:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026be:	e9 24 f8 ff ff       	jmp    101ee7 <__alltraps>

001026c3 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $198
  1026c5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026ca:	e9 18 f8 ff ff       	jmp    101ee7 <__alltraps>

001026cf <vector199>:
.globl vector199
vector199:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $199
  1026d1:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026d6:	e9 0c f8 ff ff       	jmp    101ee7 <__alltraps>

001026db <vector200>:
.globl vector200
vector200:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $200
  1026dd:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026e2:	e9 00 f8 ff ff       	jmp    101ee7 <__alltraps>

001026e7 <vector201>:
.globl vector201
vector201:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $201
  1026e9:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026ee:	e9 f4 f7 ff ff       	jmp    101ee7 <__alltraps>

001026f3 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $202
  1026f5:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026fa:	e9 e8 f7 ff ff       	jmp    101ee7 <__alltraps>

001026ff <vector203>:
.globl vector203
vector203:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $203
  102701:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102706:	e9 dc f7 ff ff       	jmp    101ee7 <__alltraps>

0010270b <vector204>:
.globl vector204
vector204:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $204
  10270d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102712:	e9 d0 f7 ff ff       	jmp    101ee7 <__alltraps>

00102717 <vector205>:
.globl vector205
vector205:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $205
  102719:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10271e:	e9 c4 f7 ff ff       	jmp    101ee7 <__alltraps>

00102723 <vector206>:
.globl vector206
vector206:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $206
  102725:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10272a:	e9 b8 f7 ff ff       	jmp    101ee7 <__alltraps>

0010272f <vector207>:
.globl vector207
vector207:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $207
  102731:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102736:	e9 ac f7 ff ff       	jmp    101ee7 <__alltraps>

0010273b <vector208>:
.globl vector208
vector208:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $208
  10273d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102742:	e9 a0 f7 ff ff       	jmp    101ee7 <__alltraps>

00102747 <vector209>:
.globl vector209
vector209:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $209
  102749:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10274e:	e9 94 f7 ff ff       	jmp    101ee7 <__alltraps>

00102753 <vector210>:
.globl vector210
vector210:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $210
  102755:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10275a:	e9 88 f7 ff ff       	jmp    101ee7 <__alltraps>

0010275f <vector211>:
.globl vector211
vector211:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $211
  102761:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102766:	e9 7c f7 ff ff       	jmp    101ee7 <__alltraps>

0010276b <vector212>:
.globl vector212
vector212:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $212
  10276d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102772:	e9 70 f7 ff ff       	jmp    101ee7 <__alltraps>

00102777 <vector213>:
.globl vector213
vector213:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $213
  102779:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10277e:	e9 64 f7 ff ff       	jmp    101ee7 <__alltraps>

00102783 <vector214>:
.globl vector214
vector214:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $214
  102785:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10278a:	e9 58 f7 ff ff       	jmp    101ee7 <__alltraps>

0010278f <vector215>:
.globl vector215
vector215:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $215
  102791:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102796:	e9 4c f7 ff ff       	jmp    101ee7 <__alltraps>

0010279b <vector216>:
.globl vector216
vector216:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $216
  10279d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027a2:	e9 40 f7 ff ff       	jmp    101ee7 <__alltraps>

001027a7 <vector217>:
.globl vector217
vector217:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $217
  1027a9:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027ae:	e9 34 f7 ff ff       	jmp    101ee7 <__alltraps>

001027b3 <vector218>:
.globl vector218
vector218:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $218
  1027b5:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027ba:	e9 28 f7 ff ff       	jmp    101ee7 <__alltraps>

001027bf <vector219>:
.globl vector219
vector219:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $219
  1027c1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027c6:	e9 1c f7 ff ff       	jmp    101ee7 <__alltraps>

001027cb <vector220>:
.globl vector220
vector220:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $220
  1027cd:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027d2:	e9 10 f7 ff ff       	jmp    101ee7 <__alltraps>

001027d7 <vector221>:
.globl vector221
vector221:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $221
  1027d9:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027de:	e9 04 f7 ff ff       	jmp    101ee7 <__alltraps>

001027e3 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $222
  1027e5:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027ea:	e9 f8 f6 ff ff       	jmp    101ee7 <__alltraps>

001027ef <vector223>:
.globl vector223
vector223:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $223
  1027f1:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027f6:	e9 ec f6 ff ff       	jmp    101ee7 <__alltraps>

001027fb <vector224>:
.globl vector224
vector224:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $224
  1027fd:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102802:	e9 e0 f6 ff ff       	jmp    101ee7 <__alltraps>

00102807 <vector225>:
.globl vector225
vector225:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $225
  102809:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10280e:	e9 d4 f6 ff ff       	jmp    101ee7 <__alltraps>

00102813 <vector226>:
.globl vector226
vector226:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $226
  102815:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10281a:	e9 c8 f6 ff ff       	jmp    101ee7 <__alltraps>

0010281f <vector227>:
.globl vector227
vector227:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $227
  102821:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102826:	e9 bc f6 ff ff       	jmp    101ee7 <__alltraps>

0010282b <vector228>:
.globl vector228
vector228:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $228
  10282d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102832:	e9 b0 f6 ff ff       	jmp    101ee7 <__alltraps>

00102837 <vector229>:
.globl vector229
vector229:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $229
  102839:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10283e:	e9 a4 f6 ff ff       	jmp    101ee7 <__alltraps>

00102843 <vector230>:
.globl vector230
vector230:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $230
  102845:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10284a:	e9 98 f6 ff ff       	jmp    101ee7 <__alltraps>

0010284f <vector231>:
.globl vector231
vector231:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $231
  102851:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102856:	e9 8c f6 ff ff       	jmp    101ee7 <__alltraps>

0010285b <vector232>:
.globl vector232
vector232:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $232
  10285d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102862:	e9 80 f6 ff ff       	jmp    101ee7 <__alltraps>

00102867 <vector233>:
.globl vector233
vector233:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $233
  102869:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10286e:	e9 74 f6 ff ff       	jmp    101ee7 <__alltraps>

00102873 <vector234>:
.globl vector234
vector234:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $234
  102875:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10287a:	e9 68 f6 ff ff       	jmp    101ee7 <__alltraps>

0010287f <vector235>:
.globl vector235
vector235:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $235
  102881:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102886:	e9 5c f6 ff ff       	jmp    101ee7 <__alltraps>

0010288b <vector236>:
.globl vector236
vector236:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $236
  10288d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102892:	e9 50 f6 ff ff       	jmp    101ee7 <__alltraps>

00102897 <vector237>:
.globl vector237
vector237:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $237
  102899:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10289e:	e9 44 f6 ff ff       	jmp    101ee7 <__alltraps>

001028a3 <vector238>:
.globl vector238
vector238:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $238
  1028a5:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028aa:	e9 38 f6 ff ff       	jmp    101ee7 <__alltraps>

001028af <vector239>:
.globl vector239
vector239:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $239
  1028b1:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028b6:	e9 2c f6 ff ff       	jmp    101ee7 <__alltraps>

001028bb <vector240>:
.globl vector240
vector240:
  pushl $0
  1028bb:	6a 00                	push   $0x0
  pushl $240
  1028bd:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028c2:	e9 20 f6 ff ff       	jmp    101ee7 <__alltraps>

001028c7 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028c7:	6a 00                	push   $0x0
  pushl $241
  1028c9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028ce:	e9 14 f6 ff ff       	jmp    101ee7 <__alltraps>

001028d3 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028d3:	6a 00                	push   $0x0
  pushl $242
  1028d5:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028da:	e9 08 f6 ff ff       	jmp    101ee7 <__alltraps>

001028df <vector243>:
.globl vector243
vector243:
  pushl $0
  1028df:	6a 00                	push   $0x0
  pushl $243
  1028e1:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028e6:	e9 fc f5 ff ff       	jmp    101ee7 <__alltraps>

001028eb <vector244>:
.globl vector244
vector244:
  pushl $0
  1028eb:	6a 00                	push   $0x0
  pushl $244
  1028ed:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028f2:	e9 f0 f5 ff ff       	jmp    101ee7 <__alltraps>

001028f7 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028f7:	6a 00                	push   $0x0
  pushl $245
  1028f9:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028fe:	e9 e4 f5 ff ff       	jmp    101ee7 <__alltraps>

00102903 <vector246>:
.globl vector246
vector246:
  pushl $0
  102903:	6a 00                	push   $0x0
  pushl $246
  102905:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10290a:	e9 d8 f5 ff ff       	jmp    101ee7 <__alltraps>

0010290f <vector247>:
.globl vector247
vector247:
  pushl $0
  10290f:	6a 00                	push   $0x0
  pushl $247
  102911:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102916:	e9 cc f5 ff ff       	jmp    101ee7 <__alltraps>

0010291b <vector248>:
.globl vector248
vector248:
  pushl $0
  10291b:	6a 00                	push   $0x0
  pushl $248
  10291d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102922:	e9 c0 f5 ff ff       	jmp    101ee7 <__alltraps>

00102927 <vector249>:
.globl vector249
vector249:
  pushl $0
  102927:	6a 00                	push   $0x0
  pushl $249
  102929:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10292e:	e9 b4 f5 ff ff       	jmp    101ee7 <__alltraps>

00102933 <vector250>:
.globl vector250
vector250:
  pushl $0
  102933:	6a 00                	push   $0x0
  pushl $250
  102935:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10293a:	e9 a8 f5 ff ff       	jmp    101ee7 <__alltraps>

0010293f <vector251>:
.globl vector251
vector251:
  pushl $0
  10293f:	6a 00                	push   $0x0
  pushl $251
  102941:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102946:	e9 9c f5 ff ff       	jmp    101ee7 <__alltraps>

0010294b <vector252>:
.globl vector252
vector252:
  pushl $0
  10294b:	6a 00                	push   $0x0
  pushl $252
  10294d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102952:	e9 90 f5 ff ff       	jmp    101ee7 <__alltraps>

00102957 <vector253>:
.globl vector253
vector253:
  pushl $0
  102957:	6a 00                	push   $0x0
  pushl $253
  102959:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10295e:	e9 84 f5 ff ff       	jmp    101ee7 <__alltraps>

00102963 <vector254>:
.globl vector254
vector254:
  pushl $0
  102963:	6a 00                	push   $0x0
  pushl $254
  102965:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10296a:	e9 78 f5 ff ff       	jmp    101ee7 <__alltraps>

0010296f <vector255>:
.globl vector255
vector255:
  pushl $0
  10296f:	6a 00                	push   $0x0
  pushl $255
  102971:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102976:	e9 6c f5 ff ff       	jmp    101ee7 <__alltraps>

0010297b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10297b:	55                   	push   %ebp
  10297c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10297e:	8b 45 08             	mov    0x8(%ebp),%eax
  102981:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102984:	b8 23 00 00 00       	mov    $0x23,%eax
  102989:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10298b:	b8 23 00 00 00       	mov    $0x23,%eax
  102990:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102992:	b8 10 00 00 00       	mov    $0x10,%eax
  102997:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102999:	b8 10 00 00 00       	mov    $0x10,%eax
  10299e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1029a0:	b8 10 00 00 00       	mov    $0x10,%eax
  1029a5:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1029a7:	ea ae 29 10 00 08 00 	ljmp   $0x8,$0x1029ae
}
  1029ae:	5d                   	pop    %ebp
  1029af:	c3                   	ret    

001029b0 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1029b0:	55                   	push   %ebp
  1029b1:	89 e5                	mov    %esp,%ebp
  1029b3:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1029b6:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1029bb:	05 00 04 00 00       	add    $0x400,%eax
  1029c0:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1029c5:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1029cc:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029ce:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1029d5:	68 00 
  1029d7:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029dc:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1029e2:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029e7:	c1 e8 10             	shr    $0x10,%eax
  1029ea:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029ef:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029f6:	83 e0 f0             	and    $0xfffffff0,%eax
  1029f9:	83 c8 09             	or     $0x9,%eax
  1029fc:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a01:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a08:	83 c8 10             	or     $0x10,%eax
  102a0b:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a10:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a17:	83 e0 9f             	and    $0xffffff9f,%eax
  102a1a:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a1f:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a26:	83 c8 80             	or     $0xffffff80,%eax
  102a29:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a2e:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a35:	83 e0 f0             	and    $0xfffffff0,%eax
  102a38:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a3d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a44:	83 e0 ef             	and    $0xffffffef,%eax
  102a47:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a4c:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a53:	83 e0 df             	and    $0xffffffdf,%eax
  102a56:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a5b:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a62:	83 c8 40             	or     $0x40,%eax
  102a65:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a6a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a71:	83 e0 7f             	and    $0x7f,%eax
  102a74:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a79:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a7e:	c1 e8 18             	shr    $0x18,%eax
  102a81:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a86:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a8d:	83 e0 ef             	and    $0xffffffef,%eax
  102a90:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a95:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102a9c:	e8 da fe ff ff       	call   10297b <lgdt>
  102aa1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102aa7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102aab:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102aae:	c9                   	leave  
  102aaf:	c3                   	ret    

00102ab0 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102ab0:	55                   	push   %ebp
  102ab1:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102ab3:	e8 f8 fe ff ff       	call   1029b0 <gdt_init>
}
  102ab8:	5d                   	pop    %ebp
  102ab9:	c3                   	ret    

00102aba <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102aba:	55                   	push   %ebp
  102abb:	89 e5                	mov    %esp,%ebp
  102abd:	83 ec 58             	sub    $0x58,%esp
  102ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  102ac3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  102ac9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102acc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102acf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ad2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ad5:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102ad8:	8b 45 18             	mov    0x18(%ebp),%eax
  102adb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ae1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ae4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ae7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102af0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102af4:	74 1c                	je     102b12 <printnum+0x58>
  102af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102af9:	ba 00 00 00 00       	mov    $0x0,%edx
  102afe:	f7 75 e4             	divl   -0x1c(%ebp)
  102b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b07:	ba 00 00 00 00       	mov    $0x0,%edx
  102b0c:	f7 75 e4             	divl   -0x1c(%ebp)
  102b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b18:	f7 75 e4             	divl   -0x1c(%ebp)
  102b1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b1e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b27:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b2a:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b30:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b33:	8b 45 18             	mov    0x18(%ebp),%eax
  102b36:	ba 00 00 00 00       	mov    $0x0,%edx
  102b3b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b3e:	77 56                	ja     102b96 <printnum+0xdc>
  102b40:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b43:	72 05                	jb     102b4a <printnum+0x90>
  102b45:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102b48:	77 4c                	ja     102b96 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102b4a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102b4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b50:	8b 45 20             	mov    0x20(%ebp),%eax
  102b53:	89 44 24 18          	mov    %eax,0x18(%esp)
  102b57:	89 54 24 14          	mov    %edx,0x14(%esp)
  102b5b:	8b 45 18             	mov    0x18(%ebp),%eax
  102b5e:	89 44 24 10          	mov    %eax,0x10(%esp)
  102b62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b65:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b68:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b6c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b73:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b77:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7a:	89 04 24             	mov    %eax,(%esp)
  102b7d:	e8 38 ff ff ff       	call   102aba <printnum>
  102b82:	eb 1c                	jmp    102ba0 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b8b:	8b 45 20             	mov    0x20(%ebp),%eax
  102b8e:	89 04 24             	mov    %eax,(%esp)
  102b91:	8b 45 08             	mov    0x8(%ebp),%eax
  102b94:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102b96:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102b9a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102b9e:	7f e4                	jg     102b84 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102ba0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102ba3:	05 b0 3d 10 00       	add    $0x103db0,%eax
  102ba8:	0f b6 00             	movzbl (%eax),%eax
  102bab:	0f be c0             	movsbl %al,%eax
  102bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  102bb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  102bb5:	89 04 24             	mov    %eax,(%esp)
  102bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbb:	ff d0                	call   *%eax
}
  102bbd:	c9                   	leave  
  102bbe:	c3                   	ret    

00102bbf <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102bbf:	55                   	push   %ebp
  102bc0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102bc2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102bc6:	7e 14                	jle    102bdc <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcb:	8b 00                	mov    (%eax),%eax
  102bcd:	8d 48 08             	lea    0x8(%eax),%ecx
  102bd0:	8b 55 08             	mov    0x8(%ebp),%edx
  102bd3:	89 0a                	mov    %ecx,(%edx)
  102bd5:	8b 50 04             	mov    0x4(%eax),%edx
  102bd8:	8b 00                	mov    (%eax),%eax
  102bda:	eb 30                	jmp    102c0c <getuint+0x4d>
    }
    else if (lflag) {
  102bdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102be0:	74 16                	je     102bf8 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102be2:	8b 45 08             	mov    0x8(%ebp),%eax
  102be5:	8b 00                	mov    (%eax),%eax
  102be7:	8d 48 04             	lea    0x4(%eax),%ecx
  102bea:	8b 55 08             	mov    0x8(%ebp),%edx
  102bed:	89 0a                	mov    %ecx,(%edx)
  102bef:	8b 00                	mov    (%eax),%eax
  102bf1:	ba 00 00 00 00       	mov    $0x0,%edx
  102bf6:	eb 14                	jmp    102c0c <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfb:	8b 00                	mov    (%eax),%eax
  102bfd:	8d 48 04             	lea    0x4(%eax),%ecx
  102c00:	8b 55 08             	mov    0x8(%ebp),%edx
  102c03:	89 0a                	mov    %ecx,(%edx)
  102c05:	8b 00                	mov    (%eax),%eax
  102c07:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102c0c:	5d                   	pop    %ebp
  102c0d:	c3                   	ret    

00102c0e <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102c0e:	55                   	push   %ebp
  102c0f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c11:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c15:	7e 14                	jle    102c2b <getint+0x1d>
        return va_arg(*ap, long long);
  102c17:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1a:	8b 00                	mov    (%eax),%eax
  102c1c:	8d 48 08             	lea    0x8(%eax),%ecx
  102c1f:	8b 55 08             	mov    0x8(%ebp),%edx
  102c22:	89 0a                	mov    %ecx,(%edx)
  102c24:	8b 50 04             	mov    0x4(%eax),%edx
  102c27:	8b 00                	mov    (%eax),%eax
  102c29:	eb 28                	jmp    102c53 <getint+0x45>
    }
    else if (lflag) {
  102c2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c2f:	74 12                	je     102c43 <getint+0x35>
        return va_arg(*ap, long);
  102c31:	8b 45 08             	mov    0x8(%ebp),%eax
  102c34:	8b 00                	mov    (%eax),%eax
  102c36:	8d 48 04             	lea    0x4(%eax),%ecx
  102c39:	8b 55 08             	mov    0x8(%ebp),%edx
  102c3c:	89 0a                	mov    %ecx,(%edx)
  102c3e:	8b 00                	mov    (%eax),%eax
  102c40:	99                   	cltd   
  102c41:	eb 10                	jmp    102c53 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102c43:	8b 45 08             	mov    0x8(%ebp),%eax
  102c46:	8b 00                	mov    (%eax),%eax
  102c48:	8d 48 04             	lea    0x4(%eax),%ecx
  102c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  102c4e:	89 0a                	mov    %ecx,(%edx)
  102c50:	8b 00                	mov    (%eax),%eax
  102c52:	99                   	cltd   
    }
}
  102c53:	5d                   	pop    %ebp
  102c54:	c3                   	ret    

00102c55 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102c55:	55                   	push   %ebp
  102c56:	89 e5                	mov    %esp,%ebp
  102c58:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102c5b:	8d 45 14             	lea    0x14(%ebp),%eax
  102c5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c64:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c68:	8b 45 10             	mov    0x10(%ebp),%eax
  102c6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c72:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c76:	8b 45 08             	mov    0x8(%ebp),%eax
  102c79:	89 04 24             	mov    %eax,(%esp)
  102c7c:	e8 02 00 00 00       	call   102c83 <vprintfmt>
    va_end(ap);
}
  102c81:	c9                   	leave  
  102c82:	c3                   	ret    

00102c83 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c83:	55                   	push   %ebp
  102c84:	89 e5                	mov    %esp,%ebp
  102c86:	56                   	push   %esi
  102c87:	53                   	push   %ebx
  102c88:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c8b:	eb 18                	jmp    102ca5 <vprintfmt+0x22>
            if (ch == '\0') {
  102c8d:	85 db                	test   %ebx,%ebx
  102c8f:	75 05                	jne    102c96 <vprintfmt+0x13>
                return;
  102c91:	e9 d1 03 00 00       	jmp    103067 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c9d:	89 1c 24             	mov    %ebx,(%esp)
  102ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca3:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  102ca8:	8d 50 01             	lea    0x1(%eax),%edx
  102cab:	89 55 10             	mov    %edx,0x10(%ebp)
  102cae:	0f b6 00             	movzbl (%eax),%eax
  102cb1:	0f b6 d8             	movzbl %al,%ebx
  102cb4:	83 fb 25             	cmp    $0x25,%ebx
  102cb7:	75 d4                	jne    102c8d <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102cb9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102cbd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102cc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102cca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102cd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cd4:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102cd7:	8b 45 10             	mov    0x10(%ebp),%eax
  102cda:	8d 50 01             	lea    0x1(%eax),%edx
  102cdd:	89 55 10             	mov    %edx,0x10(%ebp)
  102ce0:	0f b6 00             	movzbl (%eax),%eax
  102ce3:	0f b6 d8             	movzbl %al,%ebx
  102ce6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102ce9:	83 f8 55             	cmp    $0x55,%eax
  102cec:	0f 87 44 03 00 00    	ja     103036 <vprintfmt+0x3b3>
  102cf2:	8b 04 85 d4 3d 10 00 	mov    0x103dd4(,%eax,4),%eax
  102cf9:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102cfb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102cff:	eb d6                	jmp    102cd7 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102d01:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102d05:	eb d0                	jmp    102cd7 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d07:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102d0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d11:	89 d0                	mov    %edx,%eax
  102d13:	c1 e0 02             	shl    $0x2,%eax
  102d16:	01 d0                	add    %edx,%eax
  102d18:	01 c0                	add    %eax,%eax
  102d1a:	01 d8                	add    %ebx,%eax
  102d1c:	83 e8 30             	sub    $0x30,%eax
  102d1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102d22:	8b 45 10             	mov    0x10(%ebp),%eax
  102d25:	0f b6 00             	movzbl (%eax),%eax
  102d28:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d2b:	83 fb 2f             	cmp    $0x2f,%ebx
  102d2e:	7e 0b                	jle    102d3b <vprintfmt+0xb8>
  102d30:	83 fb 39             	cmp    $0x39,%ebx
  102d33:	7f 06                	jg     102d3b <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d35:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102d39:	eb d3                	jmp    102d0e <vprintfmt+0x8b>
            goto process_precision;
  102d3b:	eb 33                	jmp    102d70 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102d3d:	8b 45 14             	mov    0x14(%ebp),%eax
  102d40:	8d 50 04             	lea    0x4(%eax),%edx
  102d43:	89 55 14             	mov    %edx,0x14(%ebp)
  102d46:	8b 00                	mov    (%eax),%eax
  102d48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102d4b:	eb 23                	jmp    102d70 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102d4d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d51:	79 0c                	jns    102d5f <vprintfmt+0xdc>
                width = 0;
  102d53:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102d5a:	e9 78 ff ff ff       	jmp    102cd7 <vprintfmt+0x54>
  102d5f:	e9 73 ff ff ff       	jmp    102cd7 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102d64:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102d6b:	e9 67 ff ff ff       	jmp    102cd7 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102d70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d74:	79 12                	jns    102d88 <vprintfmt+0x105>
                width = precision, precision = -1;
  102d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d79:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d7c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d83:	e9 4f ff ff ff       	jmp    102cd7 <vprintfmt+0x54>
  102d88:	e9 4a ff ff ff       	jmp    102cd7 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d8d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102d91:	e9 41 ff ff ff       	jmp    102cd7 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d96:	8b 45 14             	mov    0x14(%ebp),%eax
  102d99:	8d 50 04             	lea    0x4(%eax),%edx
  102d9c:	89 55 14             	mov    %edx,0x14(%ebp)
  102d9f:	8b 00                	mov    (%eax),%eax
  102da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  102da4:	89 54 24 04          	mov    %edx,0x4(%esp)
  102da8:	89 04 24             	mov    %eax,(%esp)
  102dab:	8b 45 08             	mov    0x8(%ebp),%eax
  102dae:	ff d0                	call   *%eax
            break;
  102db0:	e9 ac 02 00 00       	jmp    103061 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102db5:	8b 45 14             	mov    0x14(%ebp),%eax
  102db8:	8d 50 04             	lea    0x4(%eax),%edx
  102dbb:	89 55 14             	mov    %edx,0x14(%ebp)
  102dbe:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102dc0:	85 db                	test   %ebx,%ebx
  102dc2:	79 02                	jns    102dc6 <vprintfmt+0x143>
                err = -err;
  102dc4:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102dc6:	83 fb 06             	cmp    $0x6,%ebx
  102dc9:	7f 0b                	jg     102dd6 <vprintfmt+0x153>
  102dcb:	8b 34 9d 94 3d 10 00 	mov    0x103d94(,%ebx,4),%esi
  102dd2:	85 f6                	test   %esi,%esi
  102dd4:	75 23                	jne    102df9 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102dd6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102dda:	c7 44 24 08 c1 3d 10 	movl   $0x103dc1,0x8(%esp)
  102de1:	00 
  102de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102de5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102de9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dec:	89 04 24             	mov    %eax,(%esp)
  102def:	e8 61 fe ff ff       	call   102c55 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102df4:	e9 68 02 00 00       	jmp    103061 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102df9:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102dfd:	c7 44 24 08 ca 3d 10 	movl   $0x103dca,0x8(%esp)
  102e04:	00 
  102e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e08:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0f:	89 04 24             	mov    %eax,(%esp)
  102e12:	e8 3e fe ff ff       	call   102c55 <printfmt>
            }
            break;
  102e17:	e9 45 02 00 00       	jmp    103061 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  102e1f:	8d 50 04             	lea    0x4(%eax),%edx
  102e22:	89 55 14             	mov    %edx,0x14(%ebp)
  102e25:	8b 30                	mov    (%eax),%esi
  102e27:	85 f6                	test   %esi,%esi
  102e29:	75 05                	jne    102e30 <vprintfmt+0x1ad>
                p = "(null)";
  102e2b:	be cd 3d 10 00       	mov    $0x103dcd,%esi
            }
            if (width > 0 && padc != '-') {
  102e30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e34:	7e 3e                	jle    102e74 <vprintfmt+0x1f1>
  102e36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102e3a:	74 38                	je     102e74 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e3c:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102e3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e42:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e46:	89 34 24             	mov    %esi,(%esp)
  102e49:	e8 15 03 00 00       	call   103163 <strnlen>
  102e4e:	29 c3                	sub    %eax,%ebx
  102e50:	89 d8                	mov    %ebx,%eax
  102e52:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e55:	eb 17                	jmp    102e6e <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102e57:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e5e:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e62:	89 04 24             	mov    %eax,(%esp)
  102e65:	8b 45 08             	mov    0x8(%ebp),%eax
  102e68:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e6a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e6e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e72:	7f e3                	jg     102e57 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e74:	eb 38                	jmp    102eae <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102e76:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102e7a:	74 1f                	je     102e9b <vprintfmt+0x218>
  102e7c:	83 fb 1f             	cmp    $0x1f,%ebx
  102e7f:	7e 05                	jle    102e86 <vprintfmt+0x203>
  102e81:	83 fb 7e             	cmp    $0x7e,%ebx
  102e84:	7e 15                	jle    102e9b <vprintfmt+0x218>
                    putch('?', putdat);
  102e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e89:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e8d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102e94:	8b 45 08             	mov    0x8(%ebp),%eax
  102e97:	ff d0                	call   *%eax
  102e99:	eb 0f                	jmp    102eaa <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ea2:	89 1c 24             	mov    %ebx,(%esp)
  102ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea8:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102eaa:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102eae:	89 f0                	mov    %esi,%eax
  102eb0:	8d 70 01             	lea    0x1(%eax),%esi
  102eb3:	0f b6 00             	movzbl (%eax),%eax
  102eb6:	0f be d8             	movsbl %al,%ebx
  102eb9:	85 db                	test   %ebx,%ebx
  102ebb:	74 10                	je     102ecd <vprintfmt+0x24a>
  102ebd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ec1:	78 b3                	js     102e76 <vprintfmt+0x1f3>
  102ec3:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102ec7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ecb:	79 a9                	jns    102e76 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102ecd:	eb 17                	jmp    102ee6 <vprintfmt+0x263>
                putch(' ', putdat);
  102ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ed6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102edd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee0:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102ee2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ee6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102eea:	7f e3                	jg     102ecf <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102eec:	e9 70 01 00 00       	jmp    103061 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102ef1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ef8:	8d 45 14             	lea    0x14(%ebp),%eax
  102efb:	89 04 24             	mov    %eax,(%esp)
  102efe:	e8 0b fd ff ff       	call   102c0e <getint>
  102f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f0f:	85 d2                	test   %edx,%edx
  102f11:	79 26                	jns    102f39 <vprintfmt+0x2b6>
                putch('-', putdat);
  102f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f16:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f1a:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102f21:	8b 45 08             	mov    0x8(%ebp),%eax
  102f24:	ff d0                	call   *%eax
                num = -(long long)num;
  102f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f2c:	f7 d8                	neg    %eax
  102f2e:	83 d2 00             	adc    $0x0,%edx
  102f31:	f7 da                	neg    %edx
  102f33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f36:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102f39:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f40:	e9 a8 00 00 00       	jmp    102fed <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102f45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f48:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f4c:	8d 45 14             	lea    0x14(%ebp),%eax
  102f4f:	89 04 24             	mov    %eax,(%esp)
  102f52:	e8 68 fc ff ff       	call   102bbf <getuint>
  102f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102f5d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f64:	e9 84 00 00 00       	jmp    102fed <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102f69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f70:	8d 45 14             	lea    0x14(%ebp),%eax
  102f73:	89 04 24             	mov    %eax,(%esp)
  102f76:	e8 44 fc ff ff       	call   102bbf <getuint>
  102f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f7e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f81:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f88:	eb 63                	jmp    102fed <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f91:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102f98:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9b:	ff d0                	call   *%eax
            putch('x', putdat);
  102f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fa4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102fab:	8b 45 08             	mov    0x8(%ebp),%eax
  102fae:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  102fb3:	8d 50 04             	lea    0x4(%eax),%edx
  102fb6:	89 55 14             	mov    %edx,0x14(%ebp)
  102fb9:	8b 00                	mov    (%eax),%eax
  102fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102fc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102fcc:	eb 1f                	jmp    102fed <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102fce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fd5:	8d 45 14             	lea    0x14(%ebp),%eax
  102fd8:	89 04 24             	mov    %eax,(%esp)
  102fdb:	e8 df fb ff ff       	call   102bbf <getuint>
  102fe0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fe3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102fe6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102fed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff4:	89 54 24 18          	mov    %edx,0x18(%esp)
  102ff8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102ffb:	89 54 24 14          	mov    %edx,0x14(%esp)
  102fff:	89 44 24 10          	mov    %eax,0x10(%esp)
  103003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103006:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103009:	89 44 24 08          	mov    %eax,0x8(%esp)
  10300d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103011:	8b 45 0c             	mov    0xc(%ebp),%eax
  103014:	89 44 24 04          	mov    %eax,0x4(%esp)
  103018:	8b 45 08             	mov    0x8(%ebp),%eax
  10301b:	89 04 24             	mov    %eax,(%esp)
  10301e:	e8 97 fa ff ff       	call   102aba <printnum>
            break;
  103023:	eb 3c                	jmp    103061 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103025:	8b 45 0c             	mov    0xc(%ebp),%eax
  103028:	89 44 24 04          	mov    %eax,0x4(%esp)
  10302c:	89 1c 24             	mov    %ebx,(%esp)
  10302f:	8b 45 08             	mov    0x8(%ebp),%eax
  103032:	ff d0                	call   *%eax
            break;
  103034:	eb 2b                	jmp    103061 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103036:	8b 45 0c             	mov    0xc(%ebp),%eax
  103039:	89 44 24 04          	mov    %eax,0x4(%esp)
  10303d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103044:	8b 45 08             	mov    0x8(%ebp),%eax
  103047:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103049:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10304d:	eb 04                	jmp    103053 <vprintfmt+0x3d0>
  10304f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103053:	8b 45 10             	mov    0x10(%ebp),%eax
  103056:	83 e8 01             	sub    $0x1,%eax
  103059:	0f b6 00             	movzbl (%eax),%eax
  10305c:	3c 25                	cmp    $0x25,%al
  10305e:	75 ef                	jne    10304f <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  103060:	90                   	nop
        }
    }
  103061:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103062:	e9 3e fc ff ff       	jmp    102ca5 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  103067:	83 c4 40             	add    $0x40,%esp
  10306a:	5b                   	pop    %ebx
  10306b:	5e                   	pop    %esi
  10306c:	5d                   	pop    %ebp
  10306d:	c3                   	ret    

0010306e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10306e:	55                   	push   %ebp
  10306f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103071:	8b 45 0c             	mov    0xc(%ebp),%eax
  103074:	8b 40 08             	mov    0x8(%eax),%eax
  103077:	8d 50 01             	lea    0x1(%eax),%edx
  10307a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103080:	8b 45 0c             	mov    0xc(%ebp),%eax
  103083:	8b 10                	mov    (%eax),%edx
  103085:	8b 45 0c             	mov    0xc(%ebp),%eax
  103088:	8b 40 04             	mov    0x4(%eax),%eax
  10308b:	39 c2                	cmp    %eax,%edx
  10308d:	73 12                	jae    1030a1 <sprintputch+0x33>
        *b->buf ++ = ch;
  10308f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103092:	8b 00                	mov    (%eax),%eax
  103094:	8d 48 01             	lea    0x1(%eax),%ecx
  103097:	8b 55 0c             	mov    0xc(%ebp),%edx
  10309a:	89 0a                	mov    %ecx,(%edx)
  10309c:	8b 55 08             	mov    0x8(%ebp),%edx
  10309f:	88 10                	mov    %dl,(%eax)
    }
}
  1030a1:	5d                   	pop    %ebp
  1030a2:	c3                   	ret    

001030a3 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1030a3:	55                   	push   %ebp
  1030a4:	89 e5                	mov    %esp,%ebp
  1030a6:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1030a9:	8d 45 14             	lea    0x14(%ebp),%eax
  1030ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1030af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1030b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c7:	89 04 24             	mov    %eax,(%esp)
  1030ca:	e8 08 00 00 00       	call   1030d7 <vsnprintf>
  1030cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030d5:	c9                   	leave  
  1030d6:	c3                   	ret    

001030d7 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1030d7:	55                   	push   %ebp
  1030d8:	89 e5                	mov    %esp,%ebp
  1030da:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ec:	01 d0                	add    %edx,%eax
  1030ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1030f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1030fc:	74 0a                	je     103108 <vsnprintf+0x31>
  1030fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103104:	39 c2                	cmp    %eax,%edx
  103106:	76 07                	jbe    10310f <vsnprintf+0x38>
        return -E_INVAL;
  103108:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10310d:	eb 2a                	jmp    103139 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10310f:	8b 45 14             	mov    0x14(%ebp),%eax
  103112:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103116:	8b 45 10             	mov    0x10(%ebp),%eax
  103119:	89 44 24 08          	mov    %eax,0x8(%esp)
  10311d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103120:	89 44 24 04          	mov    %eax,0x4(%esp)
  103124:	c7 04 24 6e 30 10 00 	movl   $0x10306e,(%esp)
  10312b:	e8 53 fb ff ff       	call   102c83 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103130:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103133:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103136:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103139:	c9                   	leave  
  10313a:	c3                   	ret    

0010313b <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10313b:	55                   	push   %ebp
  10313c:	89 e5                	mov    %esp,%ebp
  10313e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103141:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  103148:	eb 04                	jmp    10314e <strlen+0x13>
        cnt ++;
  10314a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  10314e:	8b 45 08             	mov    0x8(%ebp),%eax
  103151:	8d 50 01             	lea    0x1(%eax),%edx
  103154:	89 55 08             	mov    %edx,0x8(%ebp)
  103157:	0f b6 00             	movzbl (%eax),%eax
  10315a:	84 c0                	test   %al,%al
  10315c:	75 ec                	jne    10314a <strlen+0xf>
        cnt ++;
    }
    return cnt;
  10315e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103161:	c9                   	leave  
  103162:	c3                   	ret    

00103163 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103163:	55                   	push   %ebp
  103164:	89 e5                	mov    %esp,%ebp
  103166:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103169:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103170:	eb 04                	jmp    103176 <strnlen+0x13>
        cnt ++;
  103172:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  103176:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103179:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10317c:	73 10                	jae    10318e <strnlen+0x2b>
  10317e:	8b 45 08             	mov    0x8(%ebp),%eax
  103181:	8d 50 01             	lea    0x1(%eax),%edx
  103184:	89 55 08             	mov    %edx,0x8(%ebp)
  103187:	0f b6 00             	movzbl (%eax),%eax
  10318a:	84 c0                	test   %al,%al
  10318c:	75 e4                	jne    103172 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10318e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103191:	c9                   	leave  
  103192:	c3                   	ret    

00103193 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103193:	55                   	push   %ebp
  103194:	89 e5                	mov    %esp,%ebp
  103196:	57                   	push   %edi
  103197:	56                   	push   %esi
  103198:	83 ec 20             	sub    $0x20,%esp
  10319b:	8b 45 08             	mov    0x8(%ebp),%eax
  10319e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1031a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031ad:	89 d1                	mov    %edx,%ecx
  1031af:	89 c2                	mov    %eax,%edx
  1031b1:	89 ce                	mov    %ecx,%esi
  1031b3:	89 d7                	mov    %edx,%edi
  1031b5:	ac                   	lods   %ds:(%esi),%al
  1031b6:	aa                   	stos   %al,%es:(%edi)
  1031b7:	84 c0                	test   %al,%al
  1031b9:	75 fa                	jne    1031b5 <strcpy+0x22>
  1031bb:	89 fa                	mov    %edi,%edx
  1031bd:	89 f1                	mov    %esi,%ecx
  1031bf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1031c2:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1031c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  1031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1031cb:	83 c4 20             	add    $0x20,%esp
  1031ce:	5e                   	pop    %esi
  1031cf:	5f                   	pop    %edi
  1031d0:	5d                   	pop    %ebp
  1031d1:	c3                   	ret    

001031d2 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1031d2:	55                   	push   %ebp
  1031d3:	89 e5                	mov    %esp,%ebp
  1031d5:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1031db:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1031de:	eb 21                	jmp    103201 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1031e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031e3:	0f b6 10             	movzbl (%eax),%edx
  1031e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031e9:	88 10                	mov    %dl,(%eax)
  1031eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031ee:	0f b6 00             	movzbl (%eax),%eax
  1031f1:	84 c0                	test   %al,%al
  1031f3:	74 04                	je     1031f9 <strncpy+0x27>
            src ++;
  1031f5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1031f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1031fd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  103201:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103205:	75 d9                	jne    1031e0 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103207:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10320a:	c9                   	leave  
  10320b:	c3                   	ret    

0010320c <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10320c:	55                   	push   %ebp
  10320d:	89 e5                	mov    %esp,%ebp
  10320f:	57                   	push   %edi
  103210:	56                   	push   %esi
  103211:	83 ec 20             	sub    $0x20,%esp
  103214:	8b 45 08             	mov    0x8(%ebp),%eax
  103217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10321a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10321d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  103220:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103226:	89 d1                	mov    %edx,%ecx
  103228:	89 c2                	mov    %eax,%edx
  10322a:	89 ce                	mov    %ecx,%esi
  10322c:	89 d7                	mov    %edx,%edi
  10322e:	ac                   	lods   %ds:(%esi),%al
  10322f:	ae                   	scas   %es:(%edi),%al
  103230:	75 08                	jne    10323a <strcmp+0x2e>
  103232:	84 c0                	test   %al,%al
  103234:	75 f8                	jne    10322e <strcmp+0x22>
  103236:	31 c0                	xor    %eax,%eax
  103238:	eb 04                	jmp    10323e <strcmp+0x32>
  10323a:	19 c0                	sbb    %eax,%eax
  10323c:	0c 01                	or     $0x1,%al
  10323e:	89 fa                	mov    %edi,%edx
  103240:	89 f1                	mov    %esi,%ecx
  103242:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103245:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103248:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  10324b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10324e:	83 c4 20             	add    $0x20,%esp
  103251:	5e                   	pop    %esi
  103252:	5f                   	pop    %edi
  103253:	5d                   	pop    %ebp
  103254:	c3                   	ret    

00103255 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  103255:	55                   	push   %ebp
  103256:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103258:	eb 0c                	jmp    103266 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  10325a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10325e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103262:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103266:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10326a:	74 1a                	je     103286 <strncmp+0x31>
  10326c:	8b 45 08             	mov    0x8(%ebp),%eax
  10326f:	0f b6 00             	movzbl (%eax),%eax
  103272:	84 c0                	test   %al,%al
  103274:	74 10                	je     103286 <strncmp+0x31>
  103276:	8b 45 08             	mov    0x8(%ebp),%eax
  103279:	0f b6 10             	movzbl (%eax),%edx
  10327c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10327f:	0f b6 00             	movzbl (%eax),%eax
  103282:	38 c2                	cmp    %al,%dl
  103284:	74 d4                	je     10325a <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103286:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10328a:	74 18                	je     1032a4 <strncmp+0x4f>
  10328c:	8b 45 08             	mov    0x8(%ebp),%eax
  10328f:	0f b6 00             	movzbl (%eax),%eax
  103292:	0f b6 d0             	movzbl %al,%edx
  103295:	8b 45 0c             	mov    0xc(%ebp),%eax
  103298:	0f b6 00             	movzbl (%eax),%eax
  10329b:	0f b6 c0             	movzbl %al,%eax
  10329e:	29 c2                	sub    %eax,%edx
  1032a0:	89 d0                	mov    %edx,%eax
  1032a2:	eb 05                	jmp    1032a9 <strncmp+0x54>
  1032a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032a9:	5d                   	pop    %ebp
  1032aa:	c3                   	ret    

001032ab <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1032ab:	55                   	push   %ebp
  1032ac:	89 e5                	mov    %esp,%ebp
  1032ae:	83 ec 04             	sub    $0x4,%esp
  1032b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032b4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1032b7:	eb 14                	jmp    1032cd <strchr+0x22>
        if (*s == c) {
  1032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032bc:	0f b6 00             	movzbl (%eax),%eax
  1032bf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1032c2:	75 05                	jne    1032c9 <strchr+0x1e>
            return (char *)s;
  1032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c7:	eb 13                	jmp    1032dc <strchr+0x31>
        }
        s ++;
  1032c9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d0:	0f b6 00             	movzbl (%eax),%eax
  1032d3:	84 c0                	test   %al,%al
  1032d5:	75 e2                	jne    1032b9 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  1032d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032dc:	c9                   	leave  
  1032dd:	c3                   	ret    

001032de <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1032de:	55                   	push   %ebp
  1032df:	89 e5                	mov    %esp,%ebp
  1032e1:	83 ec 04             	sub    $0x4,%esp
  1032e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1032ea:	eb 11                	jmp    1032fd <strfind+0x1f>
        if (*s == c) {
  1032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ef:	0f b6 00             	movzbl (%eax),%eax
  1032f2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1032f5:	75 02                	jne    1032f9 <strfind+0x1b>
            break;
  1032f7:	eb 0e                	jmp    103307 <strfind+0x29>
        }
        s ++;
  1032f9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103300:	0f b6 00             	movzbl (%eax),%eax
  103303:	84 c0                	test   %al,%al
  103305:	75 e5                	jne    1032ec <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103307:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10330a:	c9                   	leave  
  10330b:	c3                   	ret    

0010330c <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10330c:	55                   	push   %ebp
  10330d:	89 e5                	mov    %esp,%ebp
  10330f:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  103312:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103319:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103320:	eb 04                	jmp    103326 <strtol+0x1a>
        s ++;
  103322:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103326:	8b 45 08             	mov    0x8(%ebp),%eax
  103329:	0f b6 00             	movzbl (%eax),%eax
  10332c:	3c 20                	cmp    $0x20,%al
  10332e:	74 f2                	je     103322 <strtol+0x16>
  103330:	8b 45 08             	mov    0x8(%ebp),%eax
  103333:	0f b6 00             	movzbl (%eax),%eax
  103336:	3c 09                	cmp    $0x9,%al
  103338:	74 e8                	je     103322 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  10333a:	8b 45 08             	mov    0x8(%ebp),%eax
  10333d:	0f b6 00             	movzbl (%eax),%eax
  103340:	3c 2b                	cmp    $0x2b,%al
  103342:	75 06                	jne    10334a <strtol+0x3e>
        s ++;
  103344:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103348:	eb 15                	jmp    10335f <strtol+0x53>
    }
    else if (*s == '-') {
  10334a:	8b 45 08             	mov    0x8(%ebp),%eax
  10334d:	0f b6 00             	movzbl (%eax),%eax
  103350:	3c 2d                	cmp    $0x2d,%al
  103352:	75 0b                	jne    10335f <strtol+0x53>
        s ++, neg = 1;
  103354:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103358:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10335f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103363:	74 06                	je     10336b <strtol+0x5f>
  103365:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103369:	75 24                	jne    10338f <strtol+0x83>
  10336b:	8b 45 08             	mov    0x8(%ebp),%eax
  10336e:	0f b6 00             	movzbl (%eax),%eax
  103371:	3c 30                	cmp    $0x30,%al
  103373:	75 1a                	jne    10338f <strtol+0x83>
  103375:	8b 45 08             	mov    0x8(%ebp),%eax
  103378:	83 c0 01             	add    $0x1,%eax
  10337b:	0f b6 00             	movzbl (%eax),%eax
  10337e:	3c 78                	cmp    $0x78,%al
  103380:	75 0d                	jne    10338f <strtol+0x83>
        s += 2, base = 16;
  103382:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103386:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10338d:	eb 2a                	jmp    1033b9 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10338f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103393:	75 17                	jne    1033ac <strtol+0xa0>
  103395:	8b 45 08             	mov    0x8(%ebp),%eax
  103398:	0f b6 00             	movzbl (%eax),%eax
  10339b:	3c 30                	cmp    $0x30,%al
  10339d:	75 0d                	jne    1033ac <strtol+0xa0>
        s ++, base = 8;
  10339f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1033a3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1033aa:	eb 0d                	jmp    1033b9 <strtol+0xad>
    }
    else if (base == 0) {
  1033ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033b0:	75 07                	jne    1033b9 <strtol+0xad>
        base = 10;
  1033b2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033bc:	0f b6 00             	movzbl (%eax),%eax
  1033bf:	3c 2f                	cmp    $0x2f,%al
  1033c1:	7e 1b                	jle    1033de <strtol+0xd2>
  1033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c6:	0f b6 00             	movzbl (%eax),%eax
  1033c9:	3c 39                	cmp    $0x39,%al
  1033cb:	7f 11                	jg     1033de <strtol+0xd2>
            dig = *s - '0';
  1033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d0:	0f b6 00             	movzbl (%eax),%eax
  1033d3:	0f be c0             	movsbl %al,%eax
  1033d6:	83 e8 30             	sub    $0x30,%eax
  1033d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033dc:	eb 48                	jmp    103426 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1033de:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e1:	0f b6 00             	movzbl (%eax),%eax
  1033e4:	3c 60                	cmp    $0x60,%al
  1033e6:	7e 1b                	jle    103403 <strtol+0xf7>
  1033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1033eb:	0f b6 00             	movzbl (%eax),%eax
  1033ee:	3c 7a                	cmp    $0x7a,%al
  1033f0:	7f 11                	jg     103403 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f5:	0f b6 00             	movzbl (%eax),%eax
  1033f8:	0f be c0             	movsbl %al,%eax
  1033fb:	83 e8 57             	sub    $0x57,%eax
  1033fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103401:	eb 23                	jmp    103426 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103403:	8b 45 08             	mov    0x8(%ebp),%eax
  103406:	0f b6 00             	movzbl (%eax),%eax
  103409:	3c 40                	cmp    $0x40,%al
  10340b:	7e 3d                	jle    10344a <strtol+0x13e>
  10340d:	8b 45 08             	mov    0x8(%ebp),%eax
  103410:	0f b6 00             	movzbl (%eax),%eax
  103413:	3c 5a                	cmp    $0x5a,%al
  103415:	7f 33                	jg     10344a <strtol+0x13e>
            dig = *s - 'A' + 10;
  103417:	8b 45 08             	mov    0x8(%ebp),%eax
  10341a:	0f b6 00             	movzbl (%eax),%eax
  10341d:	0f be c0             	movsbl %al,%eax
  103420:	83 e8 37             	sub    $0x37,%eax
  103423:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103429:	3b 45 10             	cmp    0x10(%ebp),%eax
  10342c:	7c 02                	jl     103430 <strtol+0x124>
            break;
  10342e:	eb 1a                	jmp    10344a <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103430:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103437:	0f af 45 10          	imul   0x10(%ebp),%eax
  10343b:	89 c2                	mov    %eax,%edx
  10343d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103440:	01 d0                	add    %edx,%eax
  103442:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  103445:	e9 6f ff ff ff       	jmp    1033b9 <strtol+0xad>

    if (endptr) {
  10344a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10344e:	74 08                	je     103458 <strtol+0x14c>
        *endptr = (char *) s;
  103450:	8b 45 0c             	mov    0xc(%ebp),%eax
  103453:	8b 55 08             	mov    0x8(%ebp),%edx
  103456:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103458:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10345c:	74 07                	je     103465 <strtol+0x159>
  10345e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103461:	f7 d8                	neg    %eax
  103463:	eb 03                	jmp    103468 <strtol+0x15c>
  103465:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103468:	c9                   	leave  
  103469:	c3                   	ret    

0010346a <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10346a:	55                   	push   %ebp
  10346b:	89 e5                	mov    %esp,%ebp
  10346d:	57                   	push   %edi
  10346e:	83 ec 24             	sub    $0x24,%esp
  103471:	8b 45 0c             	mov    0xc(%ebp),%eax
  103474:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103477:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10347b:	8b 55 08             	mov    0x8(%ebp),%edx
  10347e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103481:	88 45 f7             	mov    %al,-0x9(%ebp)
  103484:	8b 45 10             	mov    0x10(%ebp),%eax
  103487:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10348a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10348d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103491:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103494:	89 d7                	mov    %edx,%edi
  103496:	f3 aa                	rep stos %al,%es:(%edi)
  103498:	89 fa                	mov    %edi,%edx
  10349a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10349d:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1034a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1034a3:	83 c4 24             	add    $0x24,%esp
  1034a6:	5f                   	pop    %edi
  1034a7:	5d                   	pop    %ebp
  1034a8:	c3                   	ret    

001034a9 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1034a9:	55                   	push   %ebp
  1034aa:	89 e5                	mov    %esp,%ebp
  1034ac:	57                   	push   %edi
  1034ad:	56                   	push   %esi
  1034ae:	53                   	push   %ebx
  1034af:	83 ec 30             	sub    $0x30,%esp
  1034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034be:	8b 45 10             	mov    0x10(%ebp),%eax
  1034c1:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1034c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034c7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1034ca:	73 42                	jae    10350e <memmove+0x65>
  1034cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1034d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034db:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1034de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1034e1:	c1 e8 02             	shr    $0x2,%eax
  1034e4:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1034e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1034e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034ec:	89 d7                	mov    %edx,%edi
  1034ee:	89 c6                	mov    %eax,%esi
  1034f0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1034f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1034f5:	83 e1 03             	and    $0x3,%ecx
  1034f8:	74 02                	je     1034fc <memmove+0x53>
  1034fa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034fc:	89 f0                	mov    %esi,%eax
  1034fe:	89 fa                	mov    %edi,%edx
  103500:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103503:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103506:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10350c:	eb 36                	jmp    103544 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10350e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103511:	8d 50 ff             	lea    -0x1(%eax),%edx
  103514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103517:	01 c2                	add    %eax,%edx
  103519:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10351c:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10351f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103522:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  103525:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103528:	89 c1                	mov    %eax,%ecx
  10352a:	89 d8                	mov    %ebx,%eax
  10352c:	89 d6                	mov    %edx,%esi
  10352e:	89 c7                	mov    %eax,%edi
  103530:	fd                   	std    
  103531:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103533:	fc                   	cld    
  103534:	89 f8                	mov    %edi,%eax
  103536:	89 f2                	mov    %esi,%edx
  103538:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10353b:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10353e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  103541:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103544:	83 c4 30             	add    $0x30,%esp
  103547:	5b                   	pop    %ebx
  103548:	5e                   	pop    %esi
  103549:	5f                   	pop    %edi
  10354a:	5d                   	pop    %ebp
  10354b:	c3                   	ret    

0010354c <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10354c:	55                   	push   %ebp
  10354d:	89 e5                	mov    %esp,%ebp
  10354f:	57                   	push   %edi
  103550:	56                   	push   %esi
  103551:	83 ec 20             	sub    $0x20,%esp
  103554:	8b 45 08             	mov    0x8(%ebp),%eax
  103557:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10355a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10355d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103560:	8b 45 10             	mov    0x10(%ebp),%eax
  103563:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103566:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103569:	c1 e8 02             	shr    $0x2,%eax
  10356c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10356e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103574:	89 d7                	mov    %edx,%edi
  103576:	89 c6                	mov    %eax,%esi
  103578:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10357a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10357d:	83 e1 03             	and    $0x3,%ecx
  103580:	74 02                	je     103584 <memcpy+0x38>
  103582:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103584:	89 f0                	mov    %esi,%eax
  103586:	89 fa                	mov    %edi,%edx
  103588:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10358b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10358e:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103591:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103594:	83 c4 20             	add    $0x20,%esp
  103597:	5e                   	pop    %esi
  103598:	5f                   	pop    %edi
  103599:	5d                   	pop    %ebp
  10359a:	c3                   	ret    

0010359b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10359b:	55                   	push   %ebp
  10359c:	89 e5                	mov    %esp,%ebp
  10359e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1035a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1035a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1035ad:	eb 30                	jmp    1035df <memcmp+0x44>
        if (*s1 != *s2) {
  1035af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1035b2:	0f b6 10             	movzbl (%eax),%edx
  1035b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035b8:	0f b6 00             	movzbl (%eax),%eax
  1035bb:	38 c2                	cmp    %al,%dl
  1035bd:	74 18                	je     1035d7 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1035bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1035c2:	0f b6 00             	movzbl (%eax),%eax
  1035c5:	0f b6 d0             	movzbl %al,%edx
  1035c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035cb:	0f b6 00             	movzbl (%eax),%eax
  1035ce:	0f b6 c0             	movzbl %al,%eax
  1035d1:	29 c2                	sub    %eax,%edx
  1035d3:	89 d0                	mov    %edx,%eax
  1035d5:	eb 1a                	jmp    1035f1 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1035d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1035db:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1035df:	8b 45 10             	mov    0x10(%ebp),%eax
  1035e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1035e5:	89 55 10             	mov    %edx,0x10(%ebp)
  1035e8:	85 c0                	test   %eax,%eax
  1035ea:	75 c3                	jne    1035af <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1035ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035f1:	c9                   	leave  
  1035f2:	c3                   	ret    
