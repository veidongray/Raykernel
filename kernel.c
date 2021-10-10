#ifdef __cplusplus
extern "C" {
#endif

#define asmk(x) __asm__ __volatile__ (x)

inline static void hlt(void);
inline static void sti(void);
inline static void cli(void);
int putck(char, unsigned int);
int putsk(char *, unsigned int);

int main(void)
{
	char str[7] = "RayOS!";
	putsk(str, 6);
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

int putsk(char * _str, unsigned int _size)
{
	unsigned int addr = 0xb8000;
	for (int i = 0; i < _size; i++) {
		putck(_str[i], addr);
		addr += 0x2;
	}
	return 0;
}
#ifdef __cplusplus
}
#endif