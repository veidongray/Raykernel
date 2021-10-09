inline static void hlt(void);

inline static void hlt(void)
{
    __asm__ __volatile__ ("hlt");
}

int main(void)
{
    while (1) {
        hlt();
    }
    return 0;
}