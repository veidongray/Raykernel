#ifdef __cplusplus
extern "C" {
#endif

#define asmk(x) __asm__ __volatile__ (x)

inline static void hlt(void);
inline static void sti(void);
inline static void cli(void);
int putck(char, unsigned int);

int main(void)
{
    unsigned int addr = 0xb8000;
    for (int i = 0; i < 128; i++) {
        putck(i, addr);
        addr += 0x2;
    }
    while (1) {
        hlt();
    }
    return 0;
}

inline static void hlt(void)
{
    asmk("hlt");
}

inline static void sti(void)
{
    asmk("sti");
}

inline static void cli(void)
{
    asmk("cli");
}

int putck(char ch, unsigned int addr)
{
    asmk("push %eax");
    asmk("push %ebx");
    asmk("mov %0, %%al"::"g"(ch));
    asmk("mov %0, %%ebx"::"g"(addr));
    asmk("mov %al, (%ebx)");
    asmk("pop %ebx");
    asmk("pop %eax");
    return 0;
}
#ifdef __cplusplus
}
#endif