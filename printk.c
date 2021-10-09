#ifdef __cplusplus
extern "C"
{
#endif

inline static void hlt(void);
static void print_char(char, unsigned int);
static void print_str(char *, unsigned int);

int main(void)
{
	char str0[7] = "RayOS!";
	for (int i = 0; i < 6; i++) {
		print_str(str0, 6);
	}
	while (1)
	{
		hlt();
	}
	return 0;
}
inline static void hlt(void)
{
	__asm__ __volatile__("hlt");
}
static void print_char(char ch, unsigned int addr)
{
	__asm__ __volatile__ (
	"push %%eax;"
	"mov %0, %%al;"
	"mov %1, %%ebx;"
	"mov %%al, (%%ebx);"
	"pop %%eax"
	:
	:"g"(ch), "g"(addr));
}

static void print_str(char *_str, unsigned int size)
{
	unsigned int addr = 0xb8000;
	for (int i = 0; i < size; i++) {
		print_char(_str[i], addr);
		addr += 0x2;
	}
}
#ifdef __cplusplus
}
#endif