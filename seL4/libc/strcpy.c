char *strcpy(char *dest, const char *restrict src)
{
	char *d = dest;

	while ((*d++ = *src++));

	return dest;
}

