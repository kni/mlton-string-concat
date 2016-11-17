#include <sys/types.h>
#include <string.h>

void bcopy_to_pos(void *dst, size_t dst_pos, const void *src, size_t src_len) {
	memmove(dst+dst_pos, src, src_len);
	return;
}
