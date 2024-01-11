
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 30 10 80       	mov    $0x80103040,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 74 10 80       	push   $0x80107420
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 c5 46 00 00       	call   80104720 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 74 10 80       	push   $0x80107427
80100097:	50                   	push   %eax
80100098:	e8 53 45 00 00       	call   801045f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 77 47 00 00       	call   80104860 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 b9 47 00 00       	call   80104920 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 44 00 00       	call   80104630 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ad 1f 00 00       	call   80102130 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 74 10 80       	push   $0x8010742e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 1d 45 00 00       	call   801046d0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 74 10 80       	push   $0x8010743f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 dc 44 00 00       	call   801046d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 44 00 00       	call   80104690 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 50 46 00 00       	call   80104860 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 bf 46 00 00       	jmp    80104920 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 74 10 80       	push   $0x80107446
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 cf 45 00 00       	call   80104860 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002a7:	39 15 c4 ff 10 80    	cmp    %edx,0x8010ffc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 c0 ff 10 80       	push   $0x8010ffc0
801002c5:	e8 86 3f 00 00       	call   80104250 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 ff 10 80    	cmp    0x8010ffc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 50 39 00 00       	call   80103c30 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 2c 46 00 00       	call   80104920 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 ff 10 80 	movsbl -0x7fef00c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 ce 45 00 00       	call   80104920 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 22 25 00 00       	call   801028d0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 74 10 80       	push   $0x8010744d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 9b 7d 10 80 	movl   $0x80107d9b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 63 43 00 00       	call   80104740 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 74 10 80       	push   $0x80107461
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 f1 5b 00 00       	call   80106030 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 3f 5b 00 00       	call   80106030 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 33 5b 00 00       	call   80106030 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 27 5b 00 00       	call   80106030 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 f7 44 00 00       	call   80104a20 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 2a 44 00 00       	call   80104970 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 74 10 80       	push   $0x80107465
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 90 74 10 80 	movzbl -0x7fef8b70(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 40 42 00 00       	call   80104860 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 d4 42 00 00       	call   80104920 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 fc 41 00 00       	call   80104920 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 78 74 10 80       	mov    $0x80107478,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 6b 40 00 00       	call   80104860 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 74 10 80       	push   $0x8010747f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 38 40 00 00       	call   80104860 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100856:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 93 40 00 00       	call   80104920 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
80100911:	68 c0 ff 10 80       	push   $0x8010ffc0
80100916:	e8 05 3b 00 00       	call   80104420 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010093d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100964:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 94 3b 00 00       	jmp    80104530 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 88 74 10 80       	push   $0x80107488
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 4b 3d 00 00       	call   80104720 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 09 11 80 00 	movl   $0x80100600,0x8011098c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 e2 18 00 00       	call   801022e0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 0f 32 00 00       	call   80103c30 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 14 23 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 3c 23 00 00       	call   80102db0 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 e7 66 00 00       	call   80107180 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 a5 64 00 00       	call   80106fa0 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 b3 63 00 00       	call   80106ee0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 89 65 00 00       	call   80107100 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 11 22 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 f1 63 00 00       	call   80106fa0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 3a 65 00 00       	call   80107100 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 d8 21 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 a1 74 10 80       	push   $0x801074a1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 15 66 00 00       	call   80107220 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 52 3f 00 00       	call   80104b90 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 3f 3f 00 00       	call   80104b90 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 1e 67 00 00       	call   80107380 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 b4 66 00 00       	call   80107380 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 41 3e 00 00       	call   80104b50 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 17 60 00 00       	call   80106d50 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 bf 63 00 00       	call   80107100 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 ad 74 10 80       	push   $0x801074ad
80100d6b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d70:	e8 ab 39 00 00       	call   80104720 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 14 00 11 80       	mov    $0x80110014,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d91:	e8 ca 3a 00 00       	call   80104860 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dc1:	e8 5a 3b 00 00       	call   80104920 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dda:	e8 41 3b 00 00       	call   80104920 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dff:	e8 5c 3a 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e1c:	e8 ff 3a 00 00       	call   80104920 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 b4 74 10 80       	push   $0x801074b4
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e51:	e8 0a 3a 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 9f 3a 00 00       	jmp    80104920 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 e0 ff 10 80       	push   $0x8010ffe0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 73 3a 00 00       	call   80104920 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 1a 26 00 00       	call   801034f0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 5b 1e 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 b1 1e 00 00       	jmp    80102db0 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 bc 74 10 80       	push   $0x801074bc
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 ce 26 00 00       	jmp    801036a0 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 c6 74 10 80       	push   $0x801074c6
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 62 1d 00 00       	call   80102db0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 c5 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 fe 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 9e 24 00 00       	jmp    80103590 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 cf 74 10 80       	push   $0x801074cf
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 d5 74 10 80       	push   $0x801074d5
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 df 74 10 80       	push   $0x801074df
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 3e 1d 00 00       	call   80102f10 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 76 37 00 00       	call   80104970 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 0e 1d 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 00 0a 11 80       	push   $0x80110a00
8010123a:	e8 21 36 00 00       	call   80104860 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 00 0a 11 80       	push   $0x80110a00
8010129f:	e8 7c 36 00 00       	call   80104920 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 00 0a 11 80       	push   $0x80110a00
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 4e 36 00 00       	call   80104920 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 f5 74 10 80       	push   $0x801074f5
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 ad 1b 00 00       	call   80102f10 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 05 75 10 80       	push   $0x80107505
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 2a 36 00 00       	call   80104a20 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 e0 09 11 80       	push   $0x801109e0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 a1 1a 00 00       	call   80102f10 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 18 75 10 80       	push   $0x80107518
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 2b 75 10 80       	push   $0x8010752b
801014a1:	68 00 0a 11 80       	push   $0x80110a00
801014a6:	e8 75 32 00 00       	call   80104720 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 32 75 10 80       	push   $0x80107532
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 2c 31 00 00       	call   801045f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 e0 09 11 80       	push   $0x801109e0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 f8 09 11 80    	pushl  0x801109f8
801014e5:	ff 35 f4 09 11 80    	pushl  0x801109f4
801014eb:	ff 35 f0 09 11 80    	pushl  0x801109f0
801014f1:	ff 35 ec 09 11 80    	pushl  0x801109ec
801014f7:	ff 35 e8 09 11 80    	pushl  0x801109e8
801014fd:	ff 35 e4 09 11 80    	pushl  0x801109e4
80101503:	ff 35 e0 09 11 80    	pushl  0x801109e0
80101509:	68 98 75 10 80       	push   $0x80107598
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 cd 33 00 00       	call   80104970 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 5b 19 00 00       	call   80102f10 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 38 75 10 80       	push   $0x80107538
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 da 33 00 00       	call   80104a20 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 c2 18 00 00       	call   80102f10 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 00 0a 11 80       	push   $0x80110a00
8010166f:	e8 ec 31 00 00       	call   80104860 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010167f:	e8 9c 32 00 00       	call   80104920 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 79 2f 00 00       	call   80104630 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 f3 32 00 00       	call   80104a20 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 50 75 10 80       	push   $0x80107550
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 4a 75 10 80       	push   $0x8010754a
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 48 2f 00 00       	call   801046d0 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 ec 2e 00 00       	jmp    80104690 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 5f 75 10 80       	push   $0x8010755f
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 5b 2e 00 00       	call   80104630 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 a1 2e 00 00       	call   80104690 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801017f6:	e8 65 30 00 00       	call   80104860 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 0b 31 00 00       	jmp    80104920 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 00 0a 11 80       	push   $0x80110a00
80101820:	e8 3b 30 00 00       	call   80104860 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010182f:	e8 ec 30 00 00       	call   80104920 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 04 30 00 00       	call   80104a20 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 08 2f 00 00       	call   80104a20 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 f0 13 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 dd 2e 00 00       	call   80104a90 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 7e 2e 00 00       	call   80104a90 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 79 75 10 80       	push   $0x80107579
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 67 75 10 80       	push   $0x80107567
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 a2 1f 00 00       	call   80103c30 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 00 0a 11 80       	push   $0x80110a00
80101c99:	e8 c2 2b 00 00       	call   80104860 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101ca9:	e8 72 2c 00 00       	call   80104920 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 16 2d 00 00       	call   80104a20 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 83 2c 00 00       	call   80104a20 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 5e 2c 00 00       	call   80104af0 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 88 75 10 80       	push   $0x80107588
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 82 7b 10 80       	push   $0x80107b82
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f39:	85 c0                	test   %eax,%eax
80101f3b:	0f 84 b4 00 00 00    	je     80101ff5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f41:	8b 58 08             	mov    0x8(%eax),%ebx
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f4c:	0f 87 96 00 00 00    	ja     80101fe8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f52:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f57:	89 f6                	mov    %esi,%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f60:	89 ca                	mov    %ecx,%edx
80101f62:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f63:	83 e0 c0             	and    $0xffffffc0,%eax
80101f66:	3c 40                	cmp    $0x40,%al
80101f68:	75 f6                	jne    80101f60 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f6a:	31 ff                	xor    %edi,%edi
80101f6c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f71:	89 f8                	mov    %edi,%eax
80101f73:	ee                   	out    %al,(%dx)
80101f74:	b8 01 00 00 00       	mov    $0x1,%eax
80101f79:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7e:	ee                   	out    %al,(%dx)
80101f7f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f84:	89 d8                	mov    %ebx,%eax
80101f86:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f8e:	c1 f8 08             	sar    $0x8,%eax
80101f91:	ee                   	out    %al,(%dx)
80101f92:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f97:	89 f8                	mov    %edi,%eax
80101f99:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f9a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fa3:	c1 e0 04             	shl    $0x4,%eax
80101fa6:	83 e0 10             	and    $0x10,%eax
80101fa9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fad:	f6 06 04             	testb  $0x4,(%esi)
80101fb0:	75 16                	jne    80101fc8 <idestart+0x98>
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	89 ca                	mov    %ecx,%edx
80101fb9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fbd:	5b                   	pop    %ebx
80101fbe:	5e                   	pop    %esi
80101fbf:	5f                   	pop    %edi
80101fc0:	5d                   	pop    %ebp
80101fc1:	c3                   	ret    
80101fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fc8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fcd:	89 ca                	mov    %ecx,%edx
80101fcf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fd0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fd5:	83 c6 5c             	add    $0x5c,%esi
80101fd8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fdd:	fc                   	cld    
80101fde:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe3:	5b                   	pop    %ebx
80101fe4:	5e                   	pop    %esi
80101fe5:	5f                   	pop    %edi
80101fe6:	5d                   	pop    %ebp
80101fe7:	c3                   	ret    
    panic("incorrect blockno");
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	68 f4 75 10 80       	push   $0x801075f4
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 eb 75 10 80       	push   $0x801075eb
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102016:	68 06 76 10 80       	push   $0x80107606
8010201b:	68 80 a5 10 80       	push   $0x8010a580
80102020:	e8 fb 26 00 00       	call   80104720 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102025:	58                   	pop    %eax
80102026:	a1 40 2d 11 80       	mov    0x80112d40,%eax
8010202b:	5a                   	pop    %edx
8010202c:	83 e8 01             	sub    $0x1,%eax
8010202f:	50                   	push   %eax
80102030:	6a 0e                	push   $0xe
80102032:	e8 a9 02 00 00       	call   801022e0 <ioapicenable>
80102037:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010203a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010203f:	90                   	nop
80102040:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102041:	83 e0 c0             	and    $0xffffffc0,%eax
80102044:	3c 40                	cmp    $0x40,%al
80102046:	75 f8                	jne    80102040 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102048:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102052:	ee                   	out    %al,(%dx)
80102053:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102058:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205d:	eb 06                	jmp    80102065 <ideinit+0x55>
8010205f:	90                   	nop
  for(i=0; i<1000; i++){
80102060:	83 e9 01             	sub    $0x1,%ecx
80102063:	74 0f                	je     80102074 <ideinit+0x64>
80102065:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102066:	84 c0                	test   %al,%al
80102068:	74 f6                	je     80102060 <ideinit+0x50>
      havedisk1 = 1;
8010206a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102071:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102074:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102079:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010207e:	ee                   	out    %al,(%dx)
}
8010207f:	c9                   	leave  
80102080:	c3                   	ret    
80102081:	eb 0d                	jmp    80102090 <ideintr>
80102083:	90                   	nop
80102084:	90                   	nop
80102085:	90                   	nop
80102086:	90                   	nop
80102087:	90                   	nop
80102088:	90                   	nop
80102089:	90                   	nop
8010208a:	90                   	nop
8010208b:	90                   	nop
8010208c:	90                   	nop
8010208d:	90                   	nop
8010208e:	90                   	nop
8010208f:	90                   	nop

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	68 80 a5 10 80       	push   $0x8010a580
8010209e:	e8 bd 27 00 00       	call   80104860 <acquire>

  if((b = idequeue) == 0){
801020a3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	85 db                	test   %ebx,%ebx
801020ae:	74 67                	je     80102117 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020b0:	8b 43 58             	mov    0x58(%ebx),%eax
801020b3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b8:	8b 3b                	mov    (%ebx),%edi
801020ba:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020c0:	75 31                	jne    801020f3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c7:	89 f6                	mov    %esi,%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d1:	89 c6                	mov    %eax,%esi
801020d3:	83 e6 c0             	and    $0xffffffc0,%esi
801020d6:	89 f1                	mov    %esi,%ecx
801020d8:	80 f9 40             	cmp    $0x40,%cl
801020db:	75 f3                	jne    801020d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020dd:	a8 21                	test   $0x21,%al
801020df:	75 12                	jne    801020f3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020e1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020e4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020e9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ee:	fc                   	cld    
801020ef:	f3 6d                	rep insl (%dx),%es:(%edi)
801020f1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020f3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020f6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020f9:	89 f9                	mov    %edi,%ecx
801020fb:	83 c9 02             	or     $0x2,%ecx
801020fe:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102100:	53                   	push   %ebx
80102101:	e8 1a 23 00 00       	call   80104420 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102106:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	85 c0                	test   %eax,%eax
80102110:	74 05                	je     80102117 <ideintr+0x87>
    idestart(idequeue);
80102112:	e8 19 fe ff ff       	call   80101f30 <idestart>
    release(&idelock);
80102117:	83 ec 0c             	sub    $0xc,%esp
8010211a:	68 80 a5 10 80       	push   $0x8010a580
8010211f:	e8 fc 27 00 00       	call   80104920 <release>

  release(&idelock);
}
80102124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102127:	5b                   	pop    %ebx
80102128:	5e                   	pop    %esi
80102129:	5f                   	pop    %edi
8010212a:	5d                   	pop    %ebp
8010212b:	c3                   	ret    
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 10             	sub    $0x10,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	50                   	push   %eax
8010213e:	e8 8d 25 00 00       	call   801046d0 <holdingsleep>
80102143:	83 c4 10             	add    $0x10,%esp
80102146:	85 c0                	test   %eax,%eax
80102148:	0f 84 c6 00 00 00    	je     80102214 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214e:	8b 03                	mov    (%ebx),%eax
80102150:	83 e0 06             	and    $0x6,%eax
80102153:	83 f8 02             	cmp    $0x2,%eax
80102156:	0f 84 ab 00 00 00    	je     80102207 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215c:	8b 53 04             	mov    0x4(%ebx),%edx
8010215f:	85 d2                	test   %edx,%edx
80102161:	74 0d                	je     80102170 <iderw+0x40>
80102163:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102168:	85 c0                	test   %eax,%eax
8010216a:	0f 84 b1 00 00 00    	je     80102221 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	68 80 a5 10 80       	push   $0x8010a580
80102178:	e8 e3 26 00 00       	call   80104860 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102183:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102186:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218d:	85 d2                	test   %edx,%edx
8010218f:	75 09                	jne    8010219a <iderw+0x6a>
80102191:	eb 6d                	jmp    80102200 <iderw+0xd0>
80102193:	90                   	nop
80102194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102198:	89 c2                	mov    %eax,%edx
8010219a:	8b 42 58             	mov    0x58(%edx),%eax
8010219d:	85 c0                	test   %eax,%eax
8010219f:	75 f7                	jne    80102198 <iderw+0x68>
801021a1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021a4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021a6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021ac:	74 42                	je     801021f0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ae:	8b 03                	mov    (%ebx),%eax
801021b0:	83 e0 06             	and    $0x6,%eax
801021b3:	83 f8 02             	cmp    $0x2,%eax
801021b6:	74 23                	je     801021db <iderw+0xab>
801021b8:	90                   	nop
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021c0:	83 ec 08             	sub    $0x8,%esp
801021c3:	68 80 a5 10 80       	push   $0x8010a580
801021c8:	53                   	push   %ebx
801021c9:	e8 82 20 00 00       	call   80104250 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	83 e0 06             	and    $0x6,%eax
801021d6:	83 f8 02             	cmp    $0x2,%eax
801021d9:	75 e5                	jne    801021c0 <iderw+0x90>
  }


  release(&idelock);
801021db:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021e5:	c9                   	leave  
  release(&idelock);
801021e6:	e9 35 27 00 00       	jmp    80104920 <release>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021f0:	89 d8                	mov    %ebx,%eax
801021f2:	e8 39 fd ff ff       	call   80101f30 <idestart>
801021f7:	eb b5                	jmp    801021ae <iderw+0x7e>
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102200:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102205:	eb 9d                	jmp    801021a4 <iderw+0x74>
    panic("iderw: nothing to do");
80102207:	83 ec 0c             	sub    $0xc,%esp
8010220a:	68 20 76 10 80       	push   $0x80107620
8010220f:	e8 7c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 0a 76 10 80       	push   $0x8010760a
8010221c:	e8 6f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	68 35 76 10 80       	push   $0x80107635
80102229:	e8 62 e1 ff ff       	call   80100390 <panic>
8010222e:	66 90                	xchg   %ax,%ax

80102230 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102231:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
80102238:	00 c0 fe 
{
8010223b:	89 e5                	mov    %esp,%ebp
8010223d:	56                   	push   %esi
8010223e:	53                   	push   %ebx
  ioapic->reg = reg;
8010223f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102246:	00 00 00 
  return ioapic->data;
80102249:	a1 54 26 11 80       	mov    0x80112654,%eax
8010224e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102257:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010225d:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102264:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102267:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010226a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010226d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102270:	39 c2                	cmp    %eax,%edx
80102272:	74 16                	je     8010228a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	68 54 76 10 80       	push   $0x80107654
8010227c:	e8 df e3 ff ff       	call   80100660 <cprintf>
80102281:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102287:	83 c4 10             	add    $0x10,%esp
8010228a:	83 c3 21             	add    $0x21,%ebx
{
8010228d:	ba 10 00 00 00       	mov    $0x10,%edx
80102292:	b8 20 00 00 00       	mov    $0x20,%eax
80102297:	89 f6                	mov    %esi,%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022a0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022a2:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022a8:	89 c6                	mov    %eax,%esi
801022aa:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022b0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022b3:	89 71 10             	mov    %esi,0x10(%ecx)
801022b6:	8d 72 01             	lea    0x1(%edx),%esi
801022b9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022bc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022be:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022c0:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
801022c6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022cd:	75 d1                	jne    801022a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d2:	5b                   	pop    %ebx
801022d3:	5e                   	pop    %esi
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	8d 76 00             	lea    0x0(%esi),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022e0:	55                   	push   %ebp
  ioapic->reg = reg;
801022e1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
801022e7:	89 e5                	mov    %esp,%ebp
801022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ec:	8d 50 20             	lea    0x20(%eax),%edx
801022ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f5:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102301:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102304:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102306:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010230b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010230e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102311:	5d                   	pop    %ebp
80102312:	c3                   	ret    
80102313:	66 90                	xchg   %ax,%ax
80102315:	66 90                	xchg   %ax,%ax
80102317:	66 90                	xchg   %ax,%ax
80102319:	66 90                	xchg   %ax,%ax
8010231b:	66 90                	xchg   %ax,%ax
8010231d:	66 90                	xchg   %ax,%ax
8010231f:	90                   	nop

80102320 <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 04             	sub    $0x4,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 70                	jne    801023a2 <kfree+0x82>
80102332:	81 fb 08 36 11 80    	cmp    $0x80113608,%ebx
80102338:	72 68                	jb     801023a2 <kfree+0x82>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 5b                	ja     801023a2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102347:	83 ec 04             	sub    $0x4,%esp
8010234a:	68 00 10 00 00       	push   $0x1000
8010234f:	6a 01                	push   $0x1
80102351:	53                   	push   %ebx
80102352:	e8 19 26 00 00       	call   80104970 <memset>

  if (kmem.use_lock)
80102357:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	85 d2                	test   %edx,%edx
80102362:	75 2c                	jne    80102390 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freelist;
80102364:	a1 98 26 11 80       	mov    0x80112698,%eax
80102369:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if (kmem.use_lock)
8010236b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102370:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if (kmem.use_lock)
80102376:	85 c0                	test   %eax,%eax
80102378:	75 06                	jne    80102380 <kfree+0x60>
    release(&kmem.lock);
}
8010237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237d:	c9                   	leave  
8010237e:	c3                   	ret    
8010237f:	90                   	nop
    release(&kmem.lock);
80102380:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238a:	c9                   	leave  
    release(&kmem.lock);
8010238b:	e9 90 25 00 00       	jmp    80104920 <release>
    acquire(&kmem.lock);
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 60 26 11 80       	push   $0x80112660
80102398:	e8 c3 24 00 00       	call   80104860 <acquire>
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	eb c2                	jmp    80102364 <kfree+0x44>
    panic("kfree");
801023a2:	83 ec 0c             	sub    $0xc,%esp
801023a5:	68 86 76 10 80       	push   $0x80107686
801023aa:	e8 e1 df ff ff       	call   80100390 <panic>
801023af:	90                   	nop

801023b0 <freerange>:
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
801023b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char *)PGROUNDUP((uint)vstart);
801023bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801023c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023cd:	39 de                	cmp    %ebx,%esi
801023cf:	72 23                	jb     801023f4 <freerange+0x44>
801023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023de:	83 ec 0c             	sub    $0xc,%esp
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801023e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023e7:	50                   	push   %eax
801023e8:	e8 33 ff ff ff       	call   80102320 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	39 f3                	cmp    %esi,%ebx
801023f2:	76 e4                	jbe    801023d8 <freerange+0x28>
}
801023f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023f7:	5b                   	pop    %ebx
801023f8:	5e                   	pop    %esi
801023f9:	5d                   	pop    %ebp
801023fa:	c3                   	ret    
801023fb:	90                   	nop
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102400 <kinit1>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102408:	83 ec 08             	sub    $0x8,%esp
8010240b:	68 8c 76 10 80       	push   $0x8010768c
80102410:	68 60 26 11 80       	push   $0x80112660
80102415:	e8 06 23 00 00       	call   80104720 <initlock>
  p = (char *)PGROUNDUP((uint)vstart);
8010241a:	8b 45 08             	mov    0x8(%ebp),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102420:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102427:	00 00 00 
  p = (char *)PGROUNDUP((uint)vstart);
8010242a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102430:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102436:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243c:	39 de                	cmp    %ebx,%esi
8010243e:	72 1c                	jb     8010245c <kinit1+0x5c>
    kfree(p);
80102440:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102446:	83 ec 0c             	sub    $0xc,%esp
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102449:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010244f:	50                   	push   %eax
80102450:	e8 cb fe ff ff       	call   80102320 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	39 de                	cmp    %ebx,%esi
8010245a:	73 e4                	jae    80102440 <kinit1+0x40>
}
8010245c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245f:	5b                   	pop    %ebx
80102460:	5e                   	pop    %esi
80102461:	5d                   	pop    %ebp
80102462:	c3                   	ret    
80102463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kinit2>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
80102475:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102478:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char *)PGROUNDUP((uint)vstart);
8010247b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102481:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102487:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248d:	39 de                	cmp    %ebx,%esi
8010248f:	72 23                	jb     801024b4 <kinit2+0x44>
80102491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102498:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010249e:	83 ec 0c             	sub    $0xc,%esp
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801024a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024a7:	50                   	push   %eax
801024a8:	e8 73 fe ff ff       	call   80102320 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	39 de                	cmp    %ebx,%esi
801024b2:	73 e4                	jae    80102498 <kinit2+0x28>
  kmem.use_lock = 1;
801024b4:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801024bb:	00 00 00 
}
801024be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c1:	5b                   	pop    %ebx
801024c2:	5e                   	pop    %esi
801024c3:	5d                   	pop    %ebp
801024c4:	c3                   	ret    
801024c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <kalloc>:
char *
kalloc(void)
{
  struct run *r;

  if (kmem.use_lock)
801024d0:	a1 94 26 11 80       	mov    0x80112694,%eax
801024d5:	85 c0                	test   %eax,%eax
801024d7:	75 1f                	jne    801024f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024d9:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (r)
801024de:	85 c0                	test   %eax,%eax
801024e0:	74 0e                	je     801024f0 <kalloc+0x20>
    kmem.freelist = r->next;
801024e2:	8b 10                	mov    (%eax),%edx
801024e4:	89 15 98 26 11 80    	mov    %edx,0x80112698
801024ea:	c3                   	ret    
801024eb:	90                   	nop
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (kmem.use_lock)
    release(&kmem.lock);
  return (char *)r;
}
801024f0:	f3 c3                	repz ret 
801024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024f8:	55                   	push   %ebp
801024f9:	89 e5                	mov    %esp,%ebp
801024fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024fe:	68 60 26 11 80       	push   $0x80112660
80102503:	e8 58 23 00 00       	call   80104860 <acquire>
  r = kmem.freelist;
80102508:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (r)
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102516:	85 c0                	test   %eax,%eax
80102518:	74 08                	je     80102522 <kalloc+0x52>
    kmem.freelist = r->next;
8010251a:	8b 08                	mov    (%eax),%ecx
8010251c:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if (kmem.use_lock)
80102522:	85 d2                	test   %edx,%edx
80102524:	74 16                	je     8010253c <kalloc+0x6c>
    release(&kmem.lock);
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010252c:	68 60 26 11 80       	push   $0x80112660
80102531:	e8 ea 23 00 00       	call   80104920 <release>
  return (char *)r;
80102536:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102539:	83 c4 10             	add    $0x10,%esp
}
8010253c:	c9                   	leave  
8010253d:	c3                   	ret    
8010253e:	66 90                	xchg   %ax,%ax

80102540 <k_free>:
Header *base_p;
char *sbrk_addr;
static Header *freep;

void k_free(void *ap)
{
80102540:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header *)ap - 1;
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
80102541:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
{
80102546:	89 e5                	mov    %esp,%ebp
80102548:	57                   	push   %edi
80102549:	56                   	push   %esi
8010254a:	53                   	push   %ebx
8010254b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header *)ap - 1;
8010254e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
80102551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
80102558:	39 c8                	cmp    %ecx,%eax
8010255a:	8b 10                	mov    (%eax),%edx
8010255c:	73 32                	jae    80102590 <k_free+0x50>
8010255e:	39 d1                	cmp    %edx,%ecx
80102560:	72 04                	jb     80102566 <k_free+0x26>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
80102562:	39 d0                	cmp    %edx,%eax
80102564:	72 32                	jb     80102598 <k_free+0x58>
      break;
  if (bp + bp->s.size == p->s.ptr)
80102566:	8b 73 fc             	mov    -0x4(%ebx),%esi
80102569:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
8010256c:	39 fa                	cmp    %edi,%edx
8010256e:	74 30                	je     801025a0 <k_free+0x60>
  {
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  }
  else
    bp->s.ptr = p->s.ptr;
80102570:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if (p + p->s.size == bp)
80102573:	8b 50 04             	mov    0x4(%eax),%edx
80102576:	8d 34 d0             	lea    (%eax,%edx,8),%esi
80102579:	39 f1                	cmp    %esi,%ecx
8010257b:	74 3a                	je     801025b7 <k_free+0x77>
  {
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  }
  else
    p->s.ptr = bp;
8010257d:	89 08                	mov    %ecx,(%eax)
  freep = p;
8010257f:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
}
80102584:	5b                   	pop    %ebx
80102585:	5e                   	pop    %esi
80102586:	5f                   	pop    %edi
80102587:	5d                   	pop    %ebp
80102588:	c3                   	ret    
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
80102590:	39 d0                	cmp    %edx,%eax
80102592:	72 04                	jb     80102598 <k_free+0x58>
80102594:	39 d1                	cmp    %edx,%ecx
80102596:	72 ce                	jb     80102566 <k_free+0x26>
{
80102598:	89 d0                	mov    %edx,%eax
8010259a:	eb bc                	jmp    80102558 <k_free+0x18>
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
801025a0:	03 72 04             	add    0x4(%edx),%esi
801025a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
801025a6:	8b 10                	mov    (%eax),%edx
801025a8:	8b 12                	mov    (%edx),%edx
801025aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if (p + p->s.size == bp)
801025ad:	8b 50 04             	mov    0x4(%eax),%edx
801025b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
801025b3:	39 f1                	cmp    %esi,%ecx
801025b5:	75 c6                	jne    8010257d <k_free+0x3d>
    p->s.size += bp->s.size;
801025b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
801025ba:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    p->s.size += bp->s.size;
801025bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
801025c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
801025c5:	89 10                	mov    %edx,(%eax)
}
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5f                   	pop    %edi
801025ca:	5d                   	pop    %ebp
801025cb:	c3                   	ret    
801025cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025d0 <k_malloc>:
  }
}

void *
k_malloc(uint nbytes)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	56                   	push   %esi
801025d4:	53                   	push   %ebx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
801025d5:	8b 45 08             	mov    0x8(%ebp),%eax
801025d8:	8d 70 07             	lea    0x7(%eax),%esi
  if ((prevp = freep) == 0)
801025db:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
801025e0:	c1 ee 03             	shr    $0x3,%esi
801025e3:	83 c6 01             	add    $0x1,%esi
  if ((prevp = freep) == 0)
801025e6:	85 c0                	test   %eax,%eax
801025e8:	0f 84 92 00 00 00    	je     80102680 <k_malloc+0xb0>
        base_p = (Header *)temp_p;
    }
    base_p->s.ptr = freep = prevp = base_p;
    base_p->s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
801025ee:	8b 10                	mov    (%eax),%edx
801025f0:	bb 00 10 00 00       	mov    $0x1000,%ebx
  {
    if (p->s.size >= nunits)
801025f5:	8b 4a 04             	mov    0x4(%edx),%ecx
801025f8:	39 ce                	cmp    %ecx,%esi
801025fa:	77 0d                	ja     80102609 <k_malloc+0x39>
801025fc:	eb 62                	jmp    80102660 <k_malloc+0x90>
801025fe:	66 90                	xchg   %ax,%ax
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
80102600:	8b 10                	mov    (%eax),%edx
    if (p->s.size >= nunits)
80102602:	8b 4a 04             	mov    0x4(%edx),%ecx
80102605:	39 f1                	cmp    %esi,%ecx
80102607:	73 57                	jae    80102660 <k_malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
80102609:	39 15 b4 a5 10 80    	cmp    %edx,0x8010a5b4
8010260f:	89 d0                	mov    %edx,%eax
80102611:	75 ed                	jne    80102600 <k_malloc+0x30>
  if (first)
80102613:	a1 00 80 10 80       	mov    0x80108000,%eax
80102618:	85 c0                	test   %eax,%eax
8010261a:	74 3a                	je     80102656 <k_malloc+0x86>
    p = sbrk_addr;
8010261c:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102621:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80102627:	89 da                	mov    %ebx,%edx
80102629:	0f 43 d6             	cmovae %esi,%edx
    first = 0;
8010262c:	c7 05 00 80 10 80 00 	movl   $0x0,0x80108000
80102633:	00 00 00 
    if (p == (char *)-1)
80102636:	83 f8 ff             	cmp    $0xffffffff,%eax
80102639:	74 1b                	je     80102656 <k_malloc+0x86>
    hp->s.size = nu;
8010263b:	89 50 04             	mov    %edx,0x4(%eax)
    k_free((void *)(hp + 1));
8010263e:	83 ec 0c             	sub    $0xc,%esp
80102641:	83 c0 08             	add    $0x8,%eax
80102644:	50                   	push   %eax
80102645:	e8 f6 fe ff ff       	call   80102540 <k_free>
    return freep;
8010264a:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
      if ((p = kmorecore(nunits)) == 0)
8010264f:	83 c4 10             	add    $0x10,%esp
80102652:	85 c0                	test   %eax,%eax
80102654:	75 aa                	jne    80102600 <k_malloc+0x30>
        return 0;
  }
}
80102656:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return 0;
80102659:	31 c0                	xor    %eax,%eax
}
8010265b:	5b                   	pop    %ebx
8010265c:	5e                   	pop    %esi
8010265d:	5d                   	pop    %ebp
8010265e:	c3                   	ret    
8010265f:	90                   	nop
      if (p->s.size == nunits)
80102660:	39 f1                	cmp    %esi,%ecx
80102662:	74 44                	je     801026a8 <k_malloc+0xd8>
        p->s.size -= nunits;
80102664:	29 f1                	sub    %esi,%ecx
80102666:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
80102669:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
8010266c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
8010266f:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
}
80102674:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return (void *)(p + 1);
80102677:	8d 42 08             	lea    0x8(%edx),%eax
}
8010267a:	5b                   	pop    %ebx
8010267b:	5e                   	pop    %esi
8010267c:	5d                   	pop    %ebp
8010267d:	c3                   	ret    
8010267e:	66 90                	xchg   %ax,%ax
80102680:	31 db                	xor    %ebx,%ebx
80102682:	eb 0c                	jmp    80102690 <k_malloc+0xc0>
80102684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (i == 8)
80102688:	83 fb 08             	cmp    $0x8,%ebx
8010268b:	74 21                	je     801026ae <k_malloc+0xde>
8010268d:	83 c3 01             	add    $0x1,%ebx
      char *temp_p = kalloc();
80102690:	e8 3b fe ff ff       	call   801024d0 <kalloc>
      if (i == 7)
80102695:	83 fb 07             	cmp    $0x7,%ebx
80102698:	75 ee                	jne    80102688 <k_malloc+0xb8>
        sbrk_addr = temp_p;
8010269a:	a3 a0 26 11 80       	mov    %eax,0x801126a0
8010269f:	eb ec                	jmp    8010268d <k_malloc+0xbd>
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
801026a8:	8b 0a                	mov    (%edx),%ecx
801026aa:	89 08                	mov    %ecx,(%eax)
801026ac:	eb c1                	jmp    8010266f <k_malloc+0x9f>
        base_p = (Header *)temp_p;
801026ae:	a3 9c 26 11 80       	mov    %eax,0x8011269c
    base_p->s.ptr = freep = prevp = base_p;
801026b3:	89 00                	mov    %eax,(%eax)
    base_p->s.size = 0;
801026b5:	8b 15 9c 26 11 80    	mov    0x8011269c,%edx
    base_p->s.ptr = freep = prevp = base_p;
801026bb:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    base_p->s.size = 0;
801026c0:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
801026c7:	e9 22 ff ff ff       	jmp    801025ee <k_malloc+0x1e>
801026cc:	66 90                	xchg   %ax,%ax
801026ce:	66 90                	xchg   %ax,%ax

801026d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026d0:	ba 64 00 00 00       	mov    $0x64,%edx
801026d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026d6:	a8 01                	test   $0x1,%al
801026d8:	0f 84 c2 00 00 00    	je     801027a0 <kbdgetc+0xd0>
801026de:	ba 60 00 00 00       	mov    $0x60,%edx
801026e3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801026e4:	0f b6 d0             	movzbl %al,%edx
801026e7:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx

  if(data == 0xE0){
801026ed:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801026f3:	0f 84 7f 00 00 00    	je     80102778 <kbdgetc+0xa8>
{
801026f9:	55                   	push   %ebp
801026fa:	89 e5                	mov    %esp,%ebp
801026fc:	53                   	push   %ebx
801026fd:	89 cb                	mov    %ecx,%ebx
801026ff:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102702:	84 c0                	test   %al,%al
80102704:	78 4a                	js     80102750 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102706:	85 db                	test   %ebx,%ebx
80102708:	74 09                	je     80102713 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010270a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010270d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102710:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102713:	0f b6 82 c0 77 10 80 	movzbl -0x7fef8840(%edx),%eax
8010271a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010271c:	0f b6 82 c0 76 10 80 	movzbl -0x7fef8940(%edx),%eax
80102723:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102725:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102727:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
  c = charcode[shift & (CTL | SHIFT)][data];
8010272d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102730:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102733:	8b 04 85 a0 76 10 80 	mov    -0x7fef8960(,%eax,4),%eax
8010273a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010273e:	74 31                	je     80102771 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102740:	8d 50 9f             	lea    -0x61(%eax),%edx
80102743:	83 fa 19             	cmp    $0x19,%edx
80102746:	77 40                	ja     80102788 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102748:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
8010274d:	c3                   	ret    
8010274e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102750:	83 e0 7f             	and    $0x7f,%eax
80102753:	85 db                	test   %ebx,%ebx
80102755:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102758:	0f b6 82 c0 77 10 80 	movzbl -0x7fef8840(%edx),%eax
8010275f:	83 c8 40             	or     $0x40,%eax
80102762:	0f b6 c0             	movzbl %al,%eax
80102765:	f7 d0                	not    %eax
80102767:	21 c1                	and    %eax,%ecx
    return 0;
80102769:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010276b:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
}
80102771:	5b                   	pop    %ebx
80102772:	5d                   	pop    %ebp
80102773:	c3                   	ret    
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102778:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010277b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010277d:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
    return 0;
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102788:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010278b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010278e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010278f:	83 f9 1a             	cmp    $0x1a,%ecx
80102792:	0f 42 c2             	cmovb  %edx,%eax
}
80102795:	5d                   	pop    %ebp
80102796:	c3                   	ret    
80102797:	89 f6                	mov    %esi,%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801027a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027a5:	c3                   	ret    
801027a6:	8d 76 00             	lea    0x0(%esi),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <kbdintr>:

void
kbdintr(void)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027b6:	68 d0 26 10 80       	push   $0x801026d0
801027bb:	e8 50 e0 ff ff       	call   80100810 <consoleintr>
}
801027c0:	83 c4 10             	add    $0x10,%esp
801027c3:	c9                   	leave  
801027c4:	c3                   	ret    
801027c5:	66 90                	xchg   %ax,%ax
801027c7:	66 90                	xchg   %ax,%ax
801027c9:	66 90                	xchg   %ax,%ax
801027cb:	66 90                	xchg   %ax,%ax
801027cd:	66 90                	xchg   %ax,%ax
801027cf:	90                   	nop

801027d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027d0:	a1 a4 26 11 80       	mov    0x801126a4,%eax
{
801027d5:	55                   	push   %ebp
801027d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801027d8:	85 c0                	test   %eax,%eax
801027da:	0f 84 c8 00 00 00    	je     801028a8 <lapicinit+0xd8>
  lapic[index] = value;
801027e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102801:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102807:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010280e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102811:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102814:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010281b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102828:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010282e:	8b 50 30             	mov    0x30(%eax),%edx
80102831:	c1 ea 10             	shr    $0x10,%edx
80102834:	80 fa 03             	cmp    $0x3,%dl
80102837:	77 77                	ja     801028b0 <lapicinit+0xe0>
  lapic[index] = value;
80102839:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102840:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102843:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102846:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010284d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102850:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102853:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010285a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102860:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102867:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102874:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102881:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
80102887:	89 f6                	mov    %esi,%esi
80102889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102890:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102896:	80 e6 10             	and    $0x10,%dh
80102899:	75 f5                	jne    80102890 <lapicinit+0xc0>
  lapic[index] = value;
8010289b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028a8:	5d                   	pop    %ebp
801028a9:	c3                   	ret    
801028aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801028b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ba:	8b 50 20             	mov    0x20(%eax),%edx
801028bd:	e9 77 ff ff ff       	jmp    80102839 <lapicinit+0x69>
801028c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028d0:	8b 15 a4 26 11 80    	mov    0x801126a4,%edx
{
801028d6:	55                   	push   %ebp
801028d7:	31 c0                	xor    %eax,%eax
801028d9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801028db:	85 d2                	test   %edx,%edx
801028dd:	74 06                	je     801028e5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801028df:	8b 42 20             	mov    0x20(%edx),%eax
801028e2:	c1 e8 18             	shr    $0x18,%eax
}
801028e5:	5d                   	pop    %ebp
801028e6:	c3                   	ret    
801028e7:	89 f6                	mov    %esi,%esi
801028e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028f0:	a1 a4 26 11 80       	mov    0x801126a4,%eax
{
801028f5:	55                   	push   %ebp
801028f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801028f8:	85 c0                	test   %eax,%eax
801028fa:	74 0d                	je     80102909 <lapiceoi+0x19>
  lapic[index] = value;
801028fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102903:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102906:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102909:	5d                   	pop    %ebp
8010290a:	c3                   	ret    
8010290b:	90                   	nop
8010290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102910 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102910:	55                   	push   %ebp
80102911:	89 e5                	mov    %esp,%ebp
}
80102913:	5d                   	pop    %ebp
80102914:	c3                   	ret    
80102915:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102920 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102920:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102921:	b8 0f 00 00 00       	mov    $0xf,%eax
80102926:	ba 70 00 00 00       	mov    $0x70,%edx
8010292b:	89 e5                	mov    %esp,%ebp
8010292d:	53                   	push   %ebx
8010292e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102931:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102934:	ee                   	out    %al,(%dx)
80102935:	b8 0a 00 00 00       	mov    $0xa,%eax
8010293a:	ba 71 00 00 00       	mov    $0x71,%edx
8010293f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102940:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102942:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102945:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010294b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010294d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102950:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102953:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102955:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102958:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010295e:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102963:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102973:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102976:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102979:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102980:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102986:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102995:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102998:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029aa:	5b                   	pop    %ebx
801029ab:	5d                   	pop    %ebp
801029ac:	c3                   	ret    
801029ad:	8d 76 00             	lea    0x0(%esi),%esi

801029b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029b0:	55                   	push   %ebp
801029b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	57                   	push   %edi
801029be:	56                   	push   %esi
801029bf:	53                   	push   %ebx
801029c0:	83 ec 4c             	sub    $0x4c,%esp
801029c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c4:	ba 71 00 00 00       	mov    $0x71,%edx
801029c9:	ec                   	in     (%dx),%al
801029ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cd:	bb 70 00 00 00       	mov    $0x70,%ebx
801029d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029d5:	8d 76 00             	lea    0x0(%esi),%esi
801029d8:	31 c0                	xor    %eax,%eax
801029da:	89 da                	mov    %ebx,%edx
801029dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029e2:	89 ca                	mov    %ecx,%edx
801029e4:	ec                   	in     (%dx),%al
801029e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e8:	89 da                	mov    %ebx,%edx
801029ea:	b8 02 00 00 00       	mov    $0x2,%eax
801029ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
801029f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f6:	89 da                	mov    %ebx,%edx
801029f8:	b8 04 00 00 00       	mov    $0x4,%eax
801029fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fe:	89 ca                	mov    %ecx,%edx
80102a00:	ec                   	in     (%dx),%al
80102a01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a04:	89 da                	mov    %ebx,%edx
80102a06:	b8 07 00 00 00       	mov    $0x7,%eax
80102a0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0c:	89 ca                	mov    %ecx,%edx
80102a0e:	ec                   	in     (%dx),%al
80102a0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a12:	89 da                	mov    %ebx,%edx
80102a14:	b8 08 00 00 00       	mov    $0x8,%eax
80102a19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1a:	89 ca                	mov    %ecx,%edx
80102a1c:	ec                   	in     (%dx),%al
80102a1d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1f:	89 da                	mov    %ebx,%edx
80102a21:	b8 09 00 00 00       	mov    $0x9,%eax
80102a26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a27:	89 ca                	mov    %ecx,%edx
80102a29:	ec                   	in     (%dx),%al
80102a2a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2c:	89 da                	mov    %ebx,%edx
80102a2e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a34:	89 ca                	mov    %ecx,%edx
80102a36:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a37:	84 c0                	test   %al,%al
80102a39:	78 9d                	js     801029d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a3b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a3f:	89 fa                	mov    %edi,%edx
80102a41:	0f b6 fa             	movzbl %dl,%edi
80102a44:	89 f2                	mov    %esi,%edx
80102a46:	0f b6 f2             	movzbl %dl,%esi
80102a49:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a51:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a54:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a58:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a5b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a62:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a66:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a69:	31 c0                	xor    %eax,%eax
80102a6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6c:	89 ca                	mov    %ecx,%edx
80102a6e:	ec                   	in     (%dx),%al
80102a6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a72:	89 da                	mov    %ebx,%edx
80102a74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a77:	b8 02 00 00 00       	mov    $0x2,%eax
80102a7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7d:	89 ca                	mov    %ecx,%edx
80102a7f:	ec                   	in     (%dx),%al
80102a80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a83:	89 da                	mov    %ebx,%edx
80102a85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a88:	b8 04 00 00 00       	mov    $0x4,%eax
80102a8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8e:	89 ca                	mov    %ecx,%edx
80102a90:	ec                   	in     (%dx),%al
80102a91:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a94:	89 da                	mov    %ebx,%edx
80102a96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a99:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9f:	89 ca                	mov    %ecx,%edx
80102aa1:	ec                   	in     (%dx),%al
80102aa2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa5:	89 da                	mov    %ebx,%edx
80102aa7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aaa:	b8 08 00 00 00       	mov    $0x8,%eax
80102aaf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab0:	89 ca                	mov    %ecx,%edx
80102ab2:	ec                   	in     (%dx),%al
80102ab3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab6:	89 da                	mov    %ebx,%edx
80102ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102abb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ac0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac1:	89 ca                	mov    %ecx,%edx
80102ac3:	ec                   	in     (%dx),%al
80102ac4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102acd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ad0:	6a 18                	push   $0x18
80102ad2:	50                   	push   %eax
80102ad3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ad6:	50                   	push   %eax
80102ad7:	e8 e4 1e 00 00       	call   801049c0 <memcmp>
80102adc:	83 c4 10             	add    $0x10,%esp
80102adf:	85 c0                	test   %eax,%eax
80102ae1:	0f 85 f1 fe ff ff    	jne    801029d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ae7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102aeb:	75 78                	jne    80102b65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102aed:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102af0:	89 c2                	mov    %eax,%edx
80102af2:	83 e0 0f             	and    $0xf,%eax
80102af5:	c1 ea 04             	shr    $0x4,%edx
80102af8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102afb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b04:	89 c2                	mov    %eax,%edx
80102b06:	83 e0 0f             	and    $0xf,%eax
80102b09:	c1 ea 04             	shr    $0x4,%edx
80102b0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b18:	89 c2                	mov    %eax,%edx
80102b1a:	83 e0 0f             	and    $0xf,%eax
80102b1d:	c1 ea 04             	shr    $0x4,%edx
80102b20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b2c:	89 c2                	mov    %eax,%edx
80102b2e:	83 e0 0f             	and    $0xf,%eax
80102b31:	c1 ea 04             	shr    $0x4,%edx
80102b34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b40:	89 c2                	mov    %eax,%edx
80102b42:	83 e0 0f             	and    $0xf,%eax
80102b45:	c1 ea 04             	shr    $0x4,%edx
80102b48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b54:	89 c2                	mov    %eax,%edx
80102b56:	83 e0 0f             	and    $0xf,%eax
80102b59:	c1 ea 04             	shr    $0x4,%edx
80102b5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b65:	8b 75 08             	mov    0x8(%ebp),%esi
80102b68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b6b:	89 06                	mov    %eax,(%esi)
80102b6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b70:	89 46 04             	mov    %eax,0x4(%esi)
80102b73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b76:	89 46 08             	mov    %eax,0x8(%esi)
80102b79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b82:	89 46 10             	mov    %eax,0x10(%esi)
80102b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b95:	5b                   	pop    %ebx
80102b96:	5e                   	pop    %esi
80102b97:	5f                   	pop    %edi
80102b98:	5d                   	pop    %ebp
80102b99:	c3                   	ret    
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
80102bb2:	56                   	push   %esi
80102bb3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb4:	31 db                	xor    %ebx,%ebx
{
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 d8                	add    %ebx,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 04 27 11 80    	pushl  0x80112704
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 9d 0c 27 11 80 	pushl  -0x7feed8f4(,%ebx,4)
80102be4:	ff 35 04 27 11 80    	pushl  0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
80102bf2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102bf7:	83 c4 0c             	add    $0xc,%esp
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 17 1e 00 00       	call   80104a20 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 34 24             	mov    %esi,(%esp)
80102c0c:	e8 8f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c11:	89 3c 24             	mov    %edi,(%esp)
80102c14:	e8 c7 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c19:	89 34 24             	mov    %esi,(%esp)
80102c1c:	e8 bf d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 1d 08 27 11 80    	cmp    %ebx,0x80112708
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	f3 c3                	repz ret 
80102c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	56                   	push   %esi
80102c44:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102c45:	83 ec 08             	sub    $0x8,%esp
80102c48:	ff 35 f4 26 11 80    	pushl  0x801126f4
80102c4e:	ff 35 04 27 11 80    	pushl  0x80112704
80102c54:	e8 77 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c59:	8b 1d 08 27 11 80    	mov    0x80112708,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c5f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c62:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102c64:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102c66:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102c69:	7e 16                	jle    80102c81 <write_head+0x41>
80102c6b:	c1 e3 02             	shl    $0x2,%ebx
80102c6e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102c70:	8b 8a 0c 27 11 80    	mov    -0x7feed8f4(%edx),%ecx
80102c76:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102c7a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102c7d:	39 da                	cmp    %ebx,%edx
80102c7f:	75 ef                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c81:	83 ec 0c             	sub    $0xc,%esp
80102c84:	56                   	push   %esi
80102c85:	e8 16 d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c8a:	89 34 24             	mov    %esi,(%esp)
80102c8d:	e8 4e d5 ff ff       	call   801001e0 <brelse>
}
80102c92:	83 c4 10             	add    $0x10,%esp
80102c95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c98:	5b                   	pop    %ebx
80102c99:	5e                   	pop    %esi
80102c9a:	5d                   	pop    %ebp
80102c9b:	c3                   	ret    
80102c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ca0 <initlog>:
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 2c             	sub    $0x2c,%esp
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102caa:	68 c0 78 10 80       	push   $0x801078c0
80102caf:	68 c0 26 11 80       	push   $0x801126c0
80102cb4:	e8 67 1a 00 00       	call   80104720 <initlock>
  readsb(dev, &sb);
80102cb9:	58                   	pop    %eax
80102cba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 0b e7 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102cc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ccb:	59                   	pop    %ecx
  log.dev = dev;
80102ccc:	89 1d 04 27 11 80    	mov    %ebx,0x80112704
  log.size = sb.nlog;
80102cd2:	89 15 f8 26 11 80    	mov    %edx,0x801126f8
  log.start = sb.logstart;
80102cd8:	a3 f4 26 11 80       	mov    %eax,0x801126f4
  struct buf *buf = bread(log.dev, log.start);
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 eb d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102ce5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ce8:	83 c4 10             	add    $0x10,%esp
80102ceb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102ced:	89 1d 08 27 11 80    	mov    %ebx,0x80112708
  for (i = 0; i < log.lh.n; i++) {
80102cf3:	7e 1c                	jle    80102d11 <initlog+0x71>
80102cf5:	c1 e3 02             	shl    $0x2,%ebx
80102cf8:	31 d2                	xor    %edx,%edx
80102cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102d00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d04:	83 c2 04             	add    $0x4,%edx
80102d07:	89 8a 08 27 11 80    	mov    %ecx,-0x7feed8f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102d0d:	39 d3                	cmp    %edx,%ebx
80102d0f:	75 ef                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d11:	83 ec 0c             	sub    $0xc,%esp
80102d14:	50                   	push   %eax
80102d15:	e8 c6 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1a:	e8 81 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d1f:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102d26:	00 00 00 
  write_head(); // clear the log
80102d29:	e8 12 ff ff ff       	call   80102c40 <write_head>
}
80102d2e:	83 c4 10             	add    $0x10,%esp
80102d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d34:	c9                   	leave  
80102d35:	c3                   	ret    
80102d36:	8d 76 00             	lea    0x0(%esi),%esi
80102d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d46:	68 c0 26 11 80       	push   $0x801126c0
80102d4b:	e8 10 1b 00 00       	call   80104860 <acquire>
80102d50:	83 c4 10             	add    $0x10,%esp
80102d53:	eb 18                	jmp    80102d6d <begin_op+0x2d>
80102d55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d58:	83 ec 08             	sub    $0x8,%esp
80102d5b:	68 c0 26 11 80       	push   $0x801126c0
80102d60:	68 c0 26 11 80       	push   $0x801126c0
80102d65:	e8 e6 14 00 00       	call   80104250 <sleep>
80102d6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d6d:	a1 00 27 11 80       	mov    0x80112700,%eax
80102d72:	85 c0                	test   %eax,%eax
80102d74:	75 e2                	jne    80102d58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d76:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102d7b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80102d81:	83 c0 01             	add    $0x1,%eax
80102d84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d8a:	83 fa 1e             	cmp    $0x1e,%edx
80102d8d:	7f c9                	jg     80102d58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d92:	a3 fc 26 11 80       	mov    %eax,0x801126fc
      release(&log.lock);
80102d97:	68 c0 26 11 80       	push   $0x801126c0
80102d9c:	e8 7f 1b 00 00       	call   80104920 <release>
      break;
    }
  }
}
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	c9                   	leave  
80102da5:	c3                   	ret    
80102da6:	8d 76 00             	lea    0x0(%esi),%esi
80102da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102db9:	68 c0 26 11 80       	push   $0x801126c0
80102dbe:	e8 9d 1a 00 00       	call   80104860 <acquire>
  log.outstanding -= 1;
80102dc3:	a1 fc 26 11 80       	mov    0x801126fc,%eax
  if(log.committing)
80102dc8:	8b 35 00 27 11 80    	mov    0x80112700,%esi
80102dce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102dd4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102dd6:	89 1d fc 26 11 80    	mov    %ebx,0x801126fc
  if(log.committing)
80102ddc:	0f 85 1a 01 00 00    	jne    80102efc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102de2:	85 db                	test   %ebx,%ebx
80102de4:	0f 85 ee 00 00 00    	jne    80102ed8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102dea:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102ded:	c7 05 00 27 11 80 01 	movl   $0x1,0x80112700
80102df4:	00 00 00 
  release(&log.lock);
80102df7:	68 c0 26 11 80       	push   $0x801126c0
80102dfc:	e8 1f 1b 00 00       	call   80104920 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e01:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	85 c9                	test   %ecx,%ecx
80102e0c:	0f 8e 85 00 00 00    	jle    80102e97 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e12:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102e17:	83 ec 08             	sub    $0x8,%esp
80102e1a:	01 d8                	add    %ebx,%eax
80102e1c:	83 c0 01             	add    $0x1,%eax
80102e1f:	50                   	push   %eax
80102e20:	ff 35 04 27 11 80    	pushl  0x80112704
80102e26:	e8 a5 d2 ff ff       	call   801000d0 <bread>
80102e2b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e2d:	58                   	pop    %eax
80102e2e:	5a                   	pop    %edx
80102e2f:	ff 34 9d 0c 27 11 80 	pushl  -0x7feed8f4(,%ebx,4)
80102e36:	ff 35 04 27 11 80    	pushl  0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102e3c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e3f:	e8 8c d2 ff ff       	call   801000d0 <bread>
80102e44:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e46:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e49:	83 c4 0c             	add    $0xc,%esp
80102e4c:	68 00 02 00 00       	push   $0x200
80102e51:	50                   	push   %eax
80102e52:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e55:	50                   	push   %eax
80102e56:	e8 c5 1b 00 00       	call   80104a20 <memmove>
    bwrite(to);  // write the log
80102e5b:	89 34 24             	mov    %esi,(%esp)
80102e5e:	e8 3d d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e63:	89 3c 24             	mov    %edi,(%esp)
80102e66:	e8 75 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102e6b:	89 34 24             	mov    %esi,(%esp)
80102e6e:	e8 6d d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e73:	83 c4 10             	add    $0x10,%esp
80102e76:	3b 1d 08 27 11 80    	cmp    0x80112708,%ebx
80102e7c:	7c 94                	jl     80102e12 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e7e:	e8 bd fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102e83:	e8 18 fd ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102e88:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102e8f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e92:	e8 a9 fd ff ff       	call   80102c40 <write_head>
    acquire(&log.lock);
80102e97:	83 ec 0c             	sub    $0xc,%esp
80102e9a:	68 c0 26 11 80       	push   $0x801126c0
80102e9f:	e8 bc 19 00 00       	call   80104860 <acquire>
    wakeup(&log);
80102ea4:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
    log.committing = 0;
80102eab:	c7 05 00 27 11 80 00 	movl   $0x0,0x80112700
80102eb2:	00 00 00 
    wakeup(&log);
80102eb5:	e8 66 15 00 00       	call   80104420 <wakeup>
    release(&log.lock);
80102eba:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80102ec1:	e8 5a 1a 00 00       	call   80104920 <release>
80102ec6:	83 c4 10             	add    $0x10,%esp
}
80102ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ecc:	5b                   	pop    %ebx
80102ecd:	5e                   	pop    %esi
80102ece:	5f                   	pop    %edi
80102ecf:	5d                   	pop    %ebp
80102ed0:	c3                   	ret    
80102ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102ed8:	83 ec 0c             	sub    $0xc,%esp
80102edb:	68 c0 26 11 80       	push   $0x801126c0
80102ee0:	e8 3b 15 00 00       	call   80104420 <wakeup>
  release(&log.lock);
80102ee5:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80102eec:	e8 2f 1a 00 00       	call   80104920 <release>
80102ef1:	83 c4 10             	add    $0x10,%esp
}
80102ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ef7:	5b                   	pop    %ebx
80102ef8:	5e                   	pop    %esi
80102ef9:	5f                   	pop    %edi
80102efa:	5d                   	pop    %ebp
80102efb:	c3                   	ret    
    panic("log.committing");
80102efc:	83 ec 0c             	sub    $0xc,%esp
80102eff:	68 c4 78 10 80       	push   $0x801078c4
80102f04:	e8 87 d4 ff ff       	call   80100390 <panic>
80102f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	53                   	push   %ebx
80102f14:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f17:	8b 15 08 27 11 80    	mov    0x80112708,%edx
{
80102f1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f20:	83 fa 1d             	cmp    $0x1d,%edx
80102f23:	0f 8f 9d 00 00 00    	jg     80102fc6 <log_write+0xb6>
80102f29:	a1 f8 26 11 80       	mov    0x801126f8,%eax
80102f2e:	83 e8 01             	sub    $0x1,%eax
80102f31:	39 c2                	cmp    %eax,%edx
80102f33:	0f 8d 8d 00 00 00    	jge    80102fc6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f39:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102f3e:	85 c0                	test   %eax,%eax
80102f40:	0f 8e 8d 00 00 00    	jle    80102fd3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f46:	83 ec 0c             	sub    $0xc,%esp
80102f49:	68 c0 26 11 80       	push   $0x801126c0
80102f4e:	e8 0d 19 00 00       	call   80104860 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f53:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102f59:	83 c4 10             	add    $0x10,%esp
80102f5c:	83 f9 00             	cmp    $0x0,%ecx
80102f5f:	7e 57                	jle    80102fb8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f61:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102f64:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f66:	3b 15 0c 27 11 80    	cmp    0x8011270c,%edx
80102f6c:	75 0b                	jne    80102f79 <log_write+0x69>
80102f6e:	eb 38                	jmp    80102fa8 <log_write+0x98>
80102f70:	39 14 85 0c 27 11 80 	cmp    %edx,-0x7feed8f4(,%eax,4)
80102f77:	74 2f                	je     80102fa8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f79:	83 c0 01             	add    $0x1,%eax
80102f7c:	39 c1                	cmp    %eax,%ecx
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 14 85 0c 27 11 80 	mov    %edx,-0x7feed8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f87:	83 c0 01             	add    $0x1,%eax
80102f8a:	a3 08 27 11 80       	mov    %eax,0x80112708
  b->flags |= B_DIRTY; // prevent eviction
80102f8f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f92:	c7 45 08 c0 26 11 80 	movl   $0x801126c0,0x8(%ebp)
}
80102f99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f9c:	c9                   	leave  
  release(&log.lock);
80102f9d:	e9 7e 19 00 00       	jmp    80104920 <release>
80102fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa8:	89 14 85 0c 27 11 80 	mov    %edx,-0x7feed8f4(,%eax,4)
80102faf:	eb de                	jmp    80102f8f <log_write+0x7f>
80102fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fb8:	8b 43 08             	mov    0x8(%ebx),%eax
80102fbb:	a3 0c 27 11 80       	mov    %eax,0x8011270c
  if (i == log.lh.n)
80102fc0:	75 cd                	jne    80102f8f <log_write+0x7f>
80102fc2:	31 c0                	xor    %eax,%eax
80102fc4:	eb c1                	jmp    80102f87 <log_write+0x77>
    panic("too big a transaction");
80102fc6:	83 ec 0c             	sub    $0xc,%esp
80102fc9:	68 d3 78 10 80       	push   $0x801078d3
80102fce:	e8 bd d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fd3:	83 ec 0c             	sub    $0xc,%esp
80102fd6:	68 e9 78 10 80       	push   $0x801078e9
80102fdb:	e8 b0 d3 ff ff       	call   80100390 <panic>

80102fe0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fe7:	e8 24 0c 00 00       	call   80103c10 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 1d 0c 00 00       	call   80103c10 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 04 79 10 80       	push   $0x80107904
80102ffd:	e8 5e d6 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103002:	e8 39 2c 00 00       	call   80105c40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 84 0b 00 00       	call   80103b90 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 e1 0e 00 00       	call   80103f00 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103026:	e8 05 3d 00 00       	call   80106d30 <switchkvm>
  seginit();
8010302b:	e8 70 3c 00 00       	call   80106ca0 <seginit>
  lapicinit();
80103030:	e8 9b f7 ff ff       	call   801027d0 <lapicinit>
  mpmain();
80103035:	e8 a6 ff ff ff       	call   80102fe0 <mpmain>
8010303a:	66 90                	xchg   %ax,%ax
8010303c:	66 90                	xchg   %ax,%ax
8010303e:	66 90                	xchg   %ax,%ax

80103040 <main>:
{
80103040:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103044:	83 e4 f0             	and    $0xfffffff0,%esp
80103047:	ff 71 fc             	pushl  -0x4(%ecx)
8010304a:	55                   	push   %ebp
8010304b:	89 e5                	mov    %esp,%ebp
8010304d:	53                   	push   %ebx
8010304e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010304f:	83 ec 08             	sub    $0x8,%esp
80103052:	68 00 00 40 80       	push   $0x80400000
80103057:	68 08 36 11 80       	push   $0x80113608
8010305c:	e8 9f f3 ff ff       	call   80102400 <kinit1>
  kvmalloc();      // kernel page table
80103061:	e8 9a 41 00 00       	call   80107200 <kvmalloc>
  mpinit();        // detect other processors
80103066:	e8 75 01 00 00       	call   801031e0 <mpinit>
  lapicinit();     // interrupt controller
8010306b:	e8 60 f7 ff ff       	call   801027d0 <lapicinit>
  seginit();       // segment descriptors
80103070:	e8 2b 3c 00 00       	call   80106ca0 <seginit>
  picinit();       // disable pic
80103075:	e8 46 03 00 00       	call   801033c0 <picinit>
  ioapicinit();    // another interrupt controller
8010307a:	e8 b1 f1 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
8010307f:	e8 3c d9 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103084:	e8 e7 2e 00 00       	call   80105f70 <uartinit>
  pinit();         // process table
80103089:	e8 d2 0a 00 00       	call   80103b60 <pinit>
  tvinit();        // trap vectors
8010308e:	e8 2d 2b 00 00       	call   80105bc0 <tvinit>
  binit();         // buffer cache
80103093:	e8 a8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103098:	e8 c3 dc ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
8010309d:	e8 6e ef ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030a2:	83 c4 0c             	add    $0xc,%esp
801030a5:	68 8a 00 00 00       	push   $0x8a
801030aa:	68 8c a4 10 80       	push   $0x8010a48c
801030af:	68 00 70 00 80       	push   $0x80007000
801030b4:	e8 67 19 00 00       	call   80104a20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030b9:	69 05 40 2d 11 80 b0 	imul   $0xb0,0x80112d40,%eax
801030c0:	00 00 00 
801030c3:	83 c4 10             	add    $0x10,%esp
801030c6:	05 c0 27 11 80       	add    $0x801127c0,%eax
801030cb:	3d c0 27 11 80       	cmp    $0x801127c0,%eax
801030d0:	76 71                	jbe    80103143 <main+0x103>
801030d2:	bb c0 27 11 80       	mov    $0x801127c0,%ebx
801030d7:	89 f6                	mov    %esi,%esi
801030d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801030e0:	e8 ab 0a 00 00       	call   80103b90 <mycpu>
801030e5:	39 d8                	cmp    %ebx,%eax
801030e7:	74 41                	je     8010312a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030e9:	e8 e2 f3 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801030ee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801030f3:	c7 05 f8 6f 00 80 20 	movl   $0x80103020,0x80006ff8
801030fa:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030fd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103104:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103107:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010310c:	0f b6 03             	movzbl (%ebx),%eax
8010310f:	83 ec 08             	sub    $0x8,%esp
80103112:	68 00 70 00 00       	push   $0x7000
80103117:	50                   	push   %eax
80103118:	e8 03 f8 ff ff       	call   80102920 <lapicstartap>
8010311d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103120:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103126:	85 c0                	test   %eax,%eax
80103128:	74 f6                	je     80103120 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010312a:	69 05 40 2d 11 80 b0 	imul   $0xb0,0x80112d40,%eax
80103131:	00 00 00 
80103134:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010313a:	05 c0 27 11 80       	add    $0x801127c0,%eax
8010313f:	39 c3                	cmp    %eax,%ebx
80103141:	72 9d                	jb     801030e0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103143:	83 ec 08             	sub    $0x8,%esp
80103146:	68 00 00 00 8e       	push   $0x8e000000
8010314b:	68 00 00 40 80       	push   $0x80400000
80103150:	e8 1b f3 ff ff       	call   80102470 <kinit2>
  userinit();      // first user process
80103155:	e8 06 0b 00 00       	call   80103c60 <userinit>
  mpmain();        // finish this processor's setup
8010315a:	e8 81 fe ff ff       	call   80102fe0 <mpmain>
8010315f:	90                   	nop

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103165:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010316b:	53                   	push   %ebx
  e = addr+len;
8010316c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010316f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103172:	39 de                	cmp    %ebx,%esi
80103174:	72 10                	jb     80103186 <mpsearch1+0x26>
80103176:	eb 50                	jmp    801031c8 <mpsearch1+0x68>
80103178:	90                   	nop
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103180:	39 fb                	cmp    %edi,%ebx
80103182:	89 fe                	mov    %edi,%esi
80103184:	76 42                	jbe    801031c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103186:	83 ec 04             	sub    $0x4,%esp
80103189:	8d 7e 10             	lea    0x10(%esi),%edi
8010318c:	6a 04                	push   $0x4
8010318e:	68 18 79 10 80       	push   $0x80107918
80103193:	56                   	push   %esi
80103194:	e8 27 18 00 00       	call   801049c0 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 e0                	jne    80103180 <mpsearch1+0x20>
801031a0:	89 f1                	mov    %esi,%ecx
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031a8:	0f b6 11             	movzbl (%ecx),%edx
801031ab:	83 c1 01             	add    $0x1,%ecx
801031ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801031b0:	39 f9                	cmp    %edi,%ecx
801031b2:	75 f4                	jne    801031a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b4:	84 c0                	test   %al,%al
801031b6:	75 c8                	jne    80103180 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bb:	89 f0                	mov    %esi,%eax
801031bd:	5b                   	pop    %ebx
801031be:	5e                   	pop    %esi
801031bf:	5f                   	pop    %edi
801031c0:	5d                   	pop    %ebp
801031c1:	c3                   	ret    
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031cb:	31 f6                	xor    %esi,%esi
}
801031cd:	89 f0                	mov    %esi,%eax
801031cf:	5b                   	pop    %ebx
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret    
801031d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801031e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031f7:	c1 e0 08             	shl    $0x8,%eax
801031fa:	09 d0                	or     %edx,%eax
801031fc:	c1 e0 04             	shl    $0x4,%eax
801031ff:	85 c0                	test   %eax,%eax
80103201:	75 1b                	jne    8010321e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103203:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010320a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103211:	c1 e0 08             	shl    $0x8,%eax
80103214:	09 d0                	or     %edx,%eax
80103216:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103219:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010321e:	ba 00 04 00 00       	mov    $0x400,%edx
80103223:	e8 38 ff ff ff       	call   80103160 <mpsearch1>
80103228:	85 c0                	test   %eax,%eax
8010322a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010322d:	0f 84 3d 01 00 00    	je     80103370 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103236:	8b 58 04             	mov    0x4(%eax),%ebx
80103239:	85 db                	test   %ebx,%ebx
8010323b:	0f 84 4f 01 00 00    	je     80103390 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103241:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103247:	83 ec 04             	sub    $0x4,%esp
8010324a:	6a 04                	push   $0x4
8010324c:	68 35 79 10 80       	push   $0x80107935
80103251:	56                   	push   %esi
80103252:	e8 69 17 00 00       	call   801049c0 <memcmp>
80103257:	83 c4 10             	add    $0x10,%esp
8010325a:	85 c0                	test   %eax,%eax
8010325c:	0f 85 2e 01 00 00    	jne    80103390 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103262:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103269:	3c 01                	cmp    $0x1,%al
8010326b:	0f 95 c2             	setne  %dl
8010326e:	3c 04                	cmp    $0x4,%al
80103270:	0f 95 c0             	setne  %al
80103273:	20 c2                	and    %al,%dl
80103275:	0f 85 15 01 00 00    	jne    80103390 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010327b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103282:	66 85 ff             	test   %di,%di
80103285:	74 1a                	je     801032a1 <mpinit+0xc1>
80103287:	89 f0                	mov    %esi,%eax
80103289:	01 f7                	add    %esi,%edi
  sum = 0;
8010328b:	31 d2                	xor    %edx,%edx
8010328d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103290:	0f b6 08             	movzbl (%eax),%ecx
80103293:	83 c0 01             	add    $0x1,%eax
80103296:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103298:	39 c7                	cmp    %eax,%edi
8010329a:	75 f4                	jne    80103290 <mpinit+0xb0>
8010329c:	84 d2                	test   %dl,%dl
8010329e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801032a1:	85 f6                	test   %esi,%esi
801032a3:	0f 84 e7 00 00 00    	je     80103390 <mpinit+0x1b0>
801032a9:	84 d2                	test   %dl,%dl
801032ab:	0f 85 df 00 00 00    	jne    80103390 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032b1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032b7:	a3 a4 26 11 80       	mov    %eax,0x801126a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032bc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801032c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801032c9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ce:	01 d6                	add    %edx,%esi
801032d0:	39 c6                	cmp    %eax,%esi
801032d2:	76 23                	jbe    801032f7 <mpinit+0x117>
    switch(*p){
801032d4:	0f b6 10             	movzbl (%eax),%edx
801032d7:	80 fa 04             	cmp    $0x4,%dl
801032da:	0f 87 ca 00 00 00    	ja     801033aa <mpinit+0x1ca>
801032e0:	ff 24 95 5c 79 10 80 	jmp    *-0x7fef86a4(,%edx,4)
801032e7:	89 f6                	mov    %esi,%esi
801032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032f0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f3:	39 c6                	cmp    %eax,%esi
801032f5:	77 dd                	ja     801032d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032f7:	85 db                	test   %ebx,%ebx
801032f9:	0f 84 9e 00 00 00    	je     8010339d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103302:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103306:	74 15                	je     8010331d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103308:	b8 70 00 00 00       	mov    $0x70,%eax
8010330d:	ba 22 00 00 00       	mov    $0x22,%edx
80103312:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103313:	ba 23 00 00 00       	mov    $0x23,%edx
80103318:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103319:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331c:	ee                   	out    %al,(%dx)
  }
}
8010331d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103320:	5b                   	pop    %ebx
80103321:	5e                   	pop    %esi
80103322:	5f                   	pop    %edi
80103323:	5d                   	pop    %ebp
80103324:	c3                   	ret    
80103325:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103328:	8b 0d 40 2d 11 80    	mov    0x80112d40,%ecx
8010332e:	83 f9 07             	cmp    $0x7,%ecx
80103331:	7f 19                	jg     8010334c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103333:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103337:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010333d:	83 c1 01             	add    $0x1,%ecx
80103340:	89 0d 40 2d 11 80    	mov    %ecx,0x80112d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103346:	88 97 c0 27 11 80    	mov    %dl,-0x7feed840(%edi)
      p += sizeof(struct mpproc);
8010334c:	83 c0 14             	add    $0x14,%eax
      continue;
8010334f:	e9 7c ff ff ff       	jmp    801032d0 <mpinit+0xf0>
80103354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 15 a0 27 11 80    	mov    %dl,0x801127a0
      continue;
80103365:	e9 66 ff ff ff       	jmp    801032d0 <mpinit+0xf0>
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103370:	ba 00 00 01 00       	mov    $0x10000,%edx
80103375:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010337a:	e8 e1 fd ff ff       	call   80103160 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010337f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103381:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103384:	0f 85 a9 fe ff ff    	jne    80103233 <mpinit+0x53>
8010338a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 1d 79 10 80       	push   $0x8010791d
80103398:	e8 f3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010339d:	83 ec 0c             	sub    $0xc,%esp
801033a0:	68 3c 79 10 80       	push   $0x8010793c
801033a5:	e8 e6 cf ff ff       	call   80100390 <panic>
      ismp = 0;
801033aa:	31 db                	xor    %ebx,%ebx
801033ac:	e9 26 ff ff ff       	jmp    801032d7 <mpinit+0xf7>
801033b1:	66 90                	xchg   %ax,%ax
801033b3:	66 90                	xchg   %ax,%ax
801033b5:	66 90                	xchg   %ax,%ax
801033b7:	66 90                	xchg   %ax,%ax
801033b9:	66 90                	xchg   %ax,%ax
801033bb:	66 90                	xchg   %ax,%ax
801033bd:	66 90                	xchg   %ax,%ax
801033bf:	90                   	nop

801033c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033c0:	55                   	push   %ebp
801033c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033c6:	ba 21 00 00 00       	mov    $0x21,%edx
801033cb:	89 e5                	mov    %esp,%ebp
801033cd:	ee                   	out    %al,(%dx)
801033ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801033d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033d4:	5d                   	pop    %ebp
801033d5:	c3                   	ret    
801033d6:	66 90                	xchg   %ax,%ax
801033d8:	66 90                	xchg   %ax,%ax
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 0c             	sub    $0xc,%esp
801033e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801033f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033fb:	e8 80 d9 ff ff       	call   80100d80 <filealloc>
80103400:	85 c0                	test   %eax,%eax
80103402:	89 03                	mov    %eax,(%ebx)
80103404:	74 22                	je     80103428 <pipealloc+0x48>
80103406:	e8 75 d9 ff ff       	call   80100d80 <filealloc>
8010340b:	85 c0                	test   %eax,%eax
8010340d:	89 06                	mov    %eax,(%esi)
8010340f:	74 3f                	je     80103450 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103411:	e8 ba f0 ff ff       	call   801024d0 <kalloc>
80103416:	85 c0                	test   %eax,%eax
80103418:	89 c7                	mov    %eax,%edi
8010341a:	75 54                	jne    80103470 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010341c:	8b 03                	mov    (%ebx),%eax
8010341e:	85 c0                	test   %eax,%eax
80103420:	75 34                	jne    80103456 <pipealloc+0x76>
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103428:	8b 06                	mov    (%esi),%eax
8010342a:	85 c0                	test   %eax,%eax
8010342c:	74 0c                	je     8010343a <pipealloc+0x5a>
    fileclose(*f1);
8010342e:	83 ec 0c             	sub    $0xc,%esp
80103431:	50                   	push   %eax
80103432:	e8 09 da ff ff       	call   80100e40 <fileclose>
80103437:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010343a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010343d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103442:	5b                   	pop    %ebx
80103443:	5e                   	pop    %esi
80103444:	5f                   	pop    %edi
80103445:	5d                   	pop    %ebp
80103446:	c3                   	ret    
80103447:	89 f6                	mov    %esi,%esi
80103449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103450:	8b 03                	mov    (%ebx),%eax
80103452:	85 c0                	test   %eax,%eax
80103454:	74 e4                	je     8010343a <pipealloc+0x5a>
    fileclose(*f0);
80103456:	83 ec 0c             	sub    $0xc,%esp
80103459:	50                   	push   %eax
8010345a:	e8 e1 d9 ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010345f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103461:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103464:	85 c0                	test   %eax,%eax
80103466:	75 c6                	jne    8010342e <pipealloc+0x4e>
80103468:	eb d0                	jmp    8010343a <pipealloc+0x5a>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103470:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103473:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347a:	00 00 00 
  p->writeopen = 1;
8010347d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103484:	00 00 00 
  p->nwrite = 0;
80103487:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010348e:	00 00 00 
  p->nread = 0;
80103491:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103498:	00 00 00 
  initlock(&p->lock, "pipe");
8010349b:	68 70 79 10 80       	push   $0x80107970
801034a0:	50                   	push   %eax
801034a1:	e8 7a 12 00 00       	call   80104720 <initlock>
  (*f0)->type = FD_PIPE;
801034a6:	8b 03                	mov    (%ebx),%eax
  return 0;
801034a8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b1:	8b 03                	mov    (%ebx),%eax
801034b3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034b7:	8b 03                	mov    (%ebx),%eax
801034b9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034bd:	8b 03                	mov    (%ebx),%eax
801034bf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034c2:	8b 06                	mov    (%esi),%eax
801034c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d0:	8b 06                	mov    (%esi),%eax
801034d2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034d6:	8b 06                	mov    (%esi),%eax
801034d8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801034db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034de:	31 c0                	xor    %eax,%eax
}
801034e0:	5b                   	pop    %ebx
801034e1:	5e                   	pop    %esi
801034e2:	5f                   	pop    %edi
801034e3:	5d                   	pop    %ebp
801034e4:	c3                   	ret    
801034e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801034f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	56                   	push   %esi
801034f4:	53                   	push   %ebx
801034f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801034fb:	83 ec 0c             	sub    $0xc,%esp
801034fe:	53                   	push   %ebx
801034ff:	e8 5c 13 00 00       	call   80104860 <acquire>
  if(writable){
80103504:	83 c4 10             	add    $0x10,%esp
80103507:	85 f6                	test   %esi,%esi
80103509:	74 45                	je     80103550 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010350b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103511:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103514:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010351b:	00 00 00 
    wakeup(&p->nread);
8010351e:	50                   	push   %eax
8010351f:	e8 fc 0e 00 00       	call   80104420 <wakeup>
80103524:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103527:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010352d:	85 d2                	test   %edx,%edx
8010352f:	75 0a                	jne    8010353b <pipeclose+0x4b>
80103531:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103537:	85 c0                	test   %eax,%eax
80103539:	74 35                	je     80103570 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010353b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010353e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103541:	5b                   	pop    %ebx
80103542:	5e                   	pop    %esi
80103543:	5d                   	pop    %ebp
    release(&p->lock);
80103544:	e9 d7 13 00 00       	jmp    80104920 <release>
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103550:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103556:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103559:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103560:	00 00 00 
    wakeup(&p->nwrite);
80103563:	50                   	push   %eax
80103564:	e8 b7 0e 00 00       	call   80104420 <wakeup>
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	eb b9                	jmp    80103527 <pipeclose+0x37>
8010356e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	53                   	push   %ebx
80103574:	e8 a7 13 00 00       	call   80104920 <release>
    kfree((char*)p);
80103579:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010357c:	83 c4 10             	add    $0x10,%esp
}
8010357f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103582:	5b                   	pop    %ebx
80103583:	5e                   	pop    %esi
80103584:	5d                   	pop    %ebp
    kfree((char*)p);
80103585:	e9 96 ed ff ff       	jmp    80102320 <kfree>
8010358a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103590 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	57                   	push   %edi
80103594:	56                   	push   %esi
80103595:	53                   	push   %ebx
80103596:	83 ec 28             	sub    $0x28,%esp
80103599:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010359c:	53                   	push   %ebx
8010359d:	e8 be 12 00 00       	call   80104860 <acquire>
  for(i = 0; i < n; i++){
801035a2:	8b 45 10             	mov    0x10(%ebp),%eax
801035a5:	83 c4 10             	add    $0x10,%esp
801035a8:	85 c0                	test   %eax,%eax
801035aa:	0f 8e c9 00 00 00    	jle    80103679 <pipewrite+0xe9>
801035b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035b3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035bf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035c2:	03 4d 10             	add    0x10(%ebp),%ecx
801035c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801035ce:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801035d4:	39 d0                	cmp    %edx,%eax
801035d6:	75 71                	jne    80103649 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801035d8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035de:	85 c0                	test   %eax,%eax
801035e0:	74 4e                	je     80103630 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801035e8:	eb 3a                	jmp    80103624 <pipewrite+0x94>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	57                   	push   %edi
801035f4:	e8 27 0e 00 00       	call   80104420 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f9:	5a                   	pop    %edx
801035fa:	59                   	pop    %ecx
801035fb:	53                   	push   %ebx
801035fc:	56                   	push   %esi
801035fd:	e8 4e 0c 00 00       	call   80104250 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103602:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103608:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010360e:	83 c4 10             	add    $0x10,%esp
80103611:	05 00 02 00 00       	add    $0x200,%eax
80103616:	39 c2                	cmp    %eax,%edx
80103618:	75 36                	jne    80103650 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010361a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103620:	85 c0                	test   %eax,%eax
80103622:	74 0c                	je     80103630 <pipewrite+0xa0>
80103624:	e8 07 06 00 00       	call   80103c30 <myproc>
80103629:	8b 40 24             	mov    0x24(%eax),%eax
8010362c:	85 c0                	test   %eax,%eax
8010362e:	74 c0                	je     801035f0 <pipewrite+0x60>
        release(&p->lock);
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	53                   	push   %ebx
80103634:	e8 e7 12 00 00       	call   80104920 <release>
        return -1;
80103639:	83 c4 10             	add    $0x10,%esp
8010363c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103641:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103644:	5b                   	pop    %ebx
80103645:	5e                   	pop    %esi
80103646:	5f                   	pop    %edi
80103647:	5d                   	pop    %ebp
80103648:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103649:	89 c2                	mov    %eax,%edx
8010364b:	90                   	nop
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103650:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103653:	8d 42 01             	lea    0x1(%edx),%eax
80103656:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010365c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103662:	83 c6 01             	add    $0x1,%esi
80103665:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103669:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010366c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010366f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103673:	0f 85 4f ff ff ff    	jne    801035c8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103679:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010367f:	83 ec 0c             	sub    $0xc,%esp
80103682:	50                   	push   %eax
80103683:	e8 98 0d 00 00       	call   80104420 <wakeup>
  release(&p->lock);
80103688:	89 1c 24             	mov    %ebx,(%esp)
8010368b:	e8 90 12 00 00       	call   80104920 <release>
  return n;
80103690:	83 c4 10             	add    $0x10,%esp
80103693:	8b 45 10             	mov    0x10(%ebp),%eax
80103696:	eb a9                	jmp    80103641 <pipewrite+0xb1>
80103698:	90                   	nop
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	57                   	push   %edi
801036a4:	56                   	push   %esi
801036a5:	53                   	push   %ebx
801036a6:	83 ec 18             	sub    $0x18,%esp
801036a9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036af:	56                   	push   %esi
801036b0:	e8 ab 11 00 00       	call   80104860 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036b5:	83 c4 10             	add    $0x10,%esp
801036b8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036be:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036c4:	75 6a                	jne    80103730 <piperead+0x90>
801036c6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801036cc:	85 db                	test   %ebx,%ebx
801036ce:	0f 84 c4 00 00 00    	je     80103798 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036d4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036da:	eb 2d                	jmp    80103709 <piperead+0x69>
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036e0:	83 ec 08             	sub    $0x8,%esp
801036e3:	56                   	push   %esi
801036e4:	53                   	push   %ebx
801036e5:	e8 66 0b 00 00       	call   80104250 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036f3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036f9:	75 35                	jne    80103730 <piperead+0x90>
801036fb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103701:	85 d2                	test   %edx,%edx
80103703:	0f 84 8f 00 00 00    	je     80103798 <piperead+0xf8>
    if(myproc()->killed){
80103709:	e8 22 05 00 00       	call   80103c30 <myproc>
8010370e:	8b 48 24             	mov    0x24(%eax),%ecx
80103711:	85 c9                	test   %ecx,%ecx
80103713:	74 cb                	je     801036e0 <piperead+0x40>
      release(&p->lock);
80103715:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103718:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010371d:	56                   	push   %esi
8010371e:	e8 fd 11 00 00       	call   80104920 <release>
      return -1;
80103723:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103726:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103729:	89 d8                	mov    %ebx,%eax
8010372b:	5b                   	pop    %ebx
8010372c:	5e                   	pop    %esi
8010372d:	5f                   	pop    %edi
8010372e:	5d                   	pop    %ebp
8010372f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103730:	8b 45 10             	mov    0x10(%ebp),%eax
80103733:	85 c0                	test   %eax,%eax
80103735:	7e 61                	jle    80103798 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103737:	31 db                	xor    %ebx,%ebx
80103739:	eb 13                	jmp    8010374e <piperead+0xae>
8010373b:	90                   	nop
8010373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103740:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103746:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010374c:	74 1f                	je     8010376d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010374e:	8d 41 01             	lea    0x1(%ecx),%eax
80103751:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103757:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010375d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103762:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103765:	83 c3 01             	add    $0x1,%ebx
80103768:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010376b:	75 d3                	jne    80103740 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103773:	83 ec 0c             	sub    $0xc,%esp
80103776:	50                   	push   %eax
80103777:	e8 a4 0c 00 00       	call   80104420 <wakeup>
  release(&p->lock);
8010377c:	89 34 24             	mov    %esi,(%esp)
8010377f:	e8 9c 11 00 00       	call   80104920 <release>
  return i;
80103784:	83 c4 10             	add    $0x10,%esp
}
80103787:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010378a:	89 d8                	mov    %ebx,%eax
8010378c:	5b                   	pop    %ebx
8010378d:	5e                   	pop    %esi
8010378e:	5f                   	pop    %edi
8010378f:	5d                   	pop    %ebp
80103790:	c3                   	ret    
80103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103798:	31 db                	xor    %ebx,%ebx
8010379a:	eb d1                	jmp    8010376d <piperead+0xcd>
8010379c:	66 90                	xchg   %ax,%ax
8010379e:	66 90                	xchg   %ax,%ax

801037a0 <allocproc>:
//  Look in the process table for an UNUSED proc.
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	56                   	push   %esi
801037a4:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801037a5:	83 ec 0c             	sub    $0xc,%esp
801037a8:	68 60 2d 11 80       	push   $0x80112d60
801037ad:	e8 ae 10 00 00       	call   80104860 <acquire>

  p = (struct proc *)k_malloc(sizeof(struct proc));
801037b2:	c7 04 24 8c 00 00 00 	movl   $0x8c,(%esp)
801037b9:	e8 12 ee ff ff       	call   801025d0 <k_malloc>

  if (p != NULL)
801037be:	83 c4 10             	add    $0x10,%esp
801037c1:	85 c0                	test   %eax,%eax
  p = (struct proc *)k_malloc(sizeof(struct proc));
801037c3:	89 c3                	mov    %eax,%ebx
  if (p != NULL)
801037c5:	0f 84 d5 00 00 00    	je     801038a0 <allocproc+0x100>
  {
    memset(p, 0, sizeof(struct proc));
801037cb:	83 ec 04             	sub    $0x4,%esp
801037ce:	68 8c 00 00 00       	push   $0x8c
801037d3:	6a 00                	push   $0x0
801037d5:	50                   	push   %eax
801037d6:	e8 95 11 00 00       	call   80104970 <memset>
  node_t *tmp = ptable.head;
801037db:	8b 35 94 2d 11 80    	mov    0x80112d94,%esi
  node_t *new_node = k_malloc(sizeof(node_t));
801037e1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801037e8:	e8 e3 ed ff ff       	call   801025d0 <k_malloc>
  new_node->proc = proc;
801037ed:	89 18                	mov    %ebx,(%eax)
  new_node->next = tmp;
801037ef:	89 70 04             	mov    %esi,0x4(%eax)
  ptable.head = new_node;
801037f2:	a3 94 2d 11 80       	mov    %eax,0x80112d94
  proc->stride_info.pass_value=ptable.min_pass_value;
801037f7:	a1 9c 2d 11 80       	mov    0x80112d9c,%eax
801037fc:	8b 15 a0 2d 11 80    	mov    0x80112da0,%edx
  proc->stride_info.tickets=100;
80103802:	c7 83 80 00 00 00 64 	movl   $0x64,0x80(%ebx)
80103809:	00 00 00 
  proc->stride_info.stride = STRIDE_LARGE_NUMBER/ proc->stride_info.tickets;
8010380c:	c7 43 7c 64 00 00 00 	movl   $0x64,0x7c(%ebx)
  list_insert(p);

  /* stride scheduling */
  initialize_stride_info(p);

  p->state = EMBRYO;
80103813:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  proc->stride_info.pass_value=ptable.min_pass_value;
8010381a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  p->pid = nextpid++;
80103820:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  proc->stride_info.pass_value=ptable.min_pass_value;
80103825:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
  p->pid = nextpid++;
8010382b:	8d 50 01             	lea    0x1(%eax),%edx
8010382e:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103831:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
  p->pid = nextpid++;
80103838:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010383e:	e8 dd 10 00 00       	call   80104920 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
80103843:	e8 88 ec ff ff       	call   801024d0 <kalloc>
80103848:	83 c4 10             	add    $0x10,%esp
8010384b:	85 c0                	test   %eax,%eax
8010384d:	89 43 08             	mov    %eax,0x8(%ebx)
80103850:	74 3e                	je     80103890 <allocproc+0xf0>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103852:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103858:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010385b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103860:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80103863:	c7 40 14 af 5b 10 80 	movl   $0x80105baf,0x14(%eax)
  p->context = (struct context *)sp;
8010386a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010386d:	6a 14                	push   $0x14
8010386f:	6a 00                	push   $0x0
80103871:	50                   	push   %eax
80103872:	e8 f9 10 00 00       	call   80104970 <memset>
  p->context->eip = (uint)forkret;
80103877:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010387a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010387d:	c7 40 10 c0 38 10 80 	movl   $0x801038c0,0x10(%eax)
}
80103884:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103887:	89 d8                	mov    %ebx,%eax
80103889:	5b                   	pop    %ebx
8010388a:	5e                   	pop    %esi
8010388b:	5d                   	pop    %ebp
8010388c:	c3                   	ret    
8010388d:	8d 76 00             	lea    0x0(%esi),%esi
    p->state = UNUSED;
80103890:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103897:	31 db                	xor    %ebx,%ebx
80103899:	eb e9                	jmp    80103884 <allocproc+0xe4>
8010389b:	90                   	nop
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	68 60 2d 11 80       	push   $0x80112d60
801038a8:	e8 73 10 00 00       	call   80104920 <release>
    return 0;
801038ad:	83 c4 10             	add    $0x10,%esp
801038b0:	eb d2                	jmp    80103884 <allocproc+0xe4>
801038b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038c0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038c6:	68 60 2d 11 80       	push   $0x80112d60
801038cb:	e8 50 10 00 00       	call   80104920 <release>

  if (first)
801038d0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	85 c0                	test   %eax,%eax
801038da:	75 04                	jne    801038e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038dc:	c9                   	leave  
801038dd:	c3                   	ret    
801038de:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801038e0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801038e3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038ea:	00 00 00 
    iinit(ROOTDEV);
801038ed:	6a 01                	push   $0x1
801038ef:	e8 9c db ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
801038f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038fb:	e8 a0 f3 ff ff       	call   80102ca0 <initlog>
80103900:	83 c4 10             	add    $0x10,%esp
}
80103903:	c9                   	leave  
80103904:	c3                   	ret    
80103905:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103910 <list_remove>:
  node_t *tmp= ptable.head;
80103910:	8b 0d 94 2d 11 80    	mov    0x80112d94,%ecx
{
80103916:	55                   	push   %ebp
80103917:	89 e5                	mov    %esp,%ebp
80103919:	53                   	push   %ebx
  if (ptable.head==NULL)
8010391a:	85 c9                	test   %ecx,%ecx
{
8010391c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (ptable.head==NULL)
8010391f:	74 2f                	je     80103950 <list_remove+0x40>
  if(proc == tmp->proc){
80103921:	39 19                	cmp    %ebx,(%ecx)
80103923:	8b 41 04             	mov    0x4(%ecx),%eax
80103926:	75 0c                	jne    80103934 <list_remove+0x24>
80103928:	eb 2e                	jmp    80103958 <list_remove+0x48>
8010392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103930:	89 c1                	mov    %eax,%ecx
80103932:	89 d0                	mov    %edx,%eax
    if(proc==tmp->next->proc){
80103934:	39 18                	cmp    %ebx,(%eax)
80103936:	8b 50 04             	mov    0x4(%eax),%edx
80103939:	75 f5                	jne    80103930 <list_remove+0x20>
    previous->next = tmp->next;
8010393b:	89 51 04             	mov    %edx,0x4(%ecx)
    k_free(tmp);
8010393e:	89 45 08             	mov    %eax,0x8(%ebp)
}
80103941:	5b                   	pop    %ebx
80103942:	5d                   	pop    %ebp
    k_free(tmp);
80103943:	e9 f8 eb ff ff       	jmp    80102540 <k_free>
80103948:	90                   	nop
80103949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80103950:	5b                   	pop    %ebx
80103951:	5d                   	pop    %ebp
80103952:	c3                   	ret    
80103953:	90                   	nop
80103954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    k_free(tmp);
80103958:	89 4d 08             	mov    %ecx,0x8(%ebp)
    ptable.head = tmp->next;
8010395b:	a3 94 2d 11 80       	mov    %eax,0x80112d94
}
80103960:	5b                   	pop    %ebx
80103961:	5d                   	pop    %ebp
    k_free(tmp);
80103962:	e9 d9 eb ff ff       	jmp    80102540 <k_free>
80103967:	89 f6                	mov    %esi,%esi
80103969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103970 <remove_min>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	57                   	push   %edi
80103974:	56                   	push   %esi
80103975:	53                   	push   %ebx
80103976:	83 ec 1c             	sub    $0x1c,%esp
  for (current = ptable.head; current != NULL; current = current->next)
80103979:	8b 15 94 2d 11 80    	mov    0x80112d94,%edx
8010397f:	85 d2                	test   %edx,%edx
80103981:	74 7d                	je     80103a00 <remove_min+0x90>
  long long min = 92233720384775807;
80103983:	c7 45 e4 7f e6 d8 7b 	movl   $0x7bd8e67f,-0x1c(%ebp)
8010398a:	b8 14 ae 47 01       	mov    $0x147ae14,%eax
  struct proc *special =NULL;
8010398f:	31 f6                	xor    %esi,%esi
80103991:	eb 0c                	jmp    8010399f <remove_min+0x2f>
80103993:	90                   	nop
80103994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (current = ptable.head; current != NULL; current = current->next)
80103998:	8b 52 04             	mov    0x4(%edx),%edx
8010399b:	85 d2                	test   %edx,%edx
8010399d:	74 31                	je     801039d0 <remove_min+0x60>
    proc = current->proc;
8010399f:	8b 0a                	mov    (%edx),%ecx
    if (proc->state == RUNNABLE){
801039a1:	83 79 0c 03          	cmpl   $0x3,0xc(%ecx)
801039a5:	75 f1                	jne    80103998 <remove_min+0x28>
      if(proc->stride_info.pass_value<min){
801039a7:	8b 99 88 00 00 00    	mov    0x88(%ecx),%ebx
801039ad:	8b b9 84 00 00 00    	mov    0x84(%ecx),%edi
801039b3:	39 c3                	cmp    %eax,%ebx
801039b5:	7f e1                	jg     80103998 <remove_min+0x28>
801039b7:	7d 37                	jge    801039f0 <remove_min+0x80>
801039b9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801039bc:	89 d8                	mov    %ebx,%eax
801039be:	89 ce                	mov    %ecx,%esi
  for (current = ptable.head; current != NULL; current = current->next)
801039c0:	8b 52 04             	mov    0x4(%edx),%edx
801039c3:	85 d2                	test   %edx,%edx
801039c5:	75 d8                	jne    8010399f <remove_min+0x2f>
801039c7:	89 f6                	mov    %esi,%esi
801039c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(special !=NULL){
801039d0:	85 f6                	test   %esi,%esi
801039d2:	74 0c                	je     801039e0 <remove_min+0x70>
    list_remove(special);
801039d4:	83 ec 0c             	sub    $0xc,%esp
801039d7:	56                   	push   %esi
801039d8:	e8 33 ff ff ff       	call   80103910 <list_remove>
801039dd:	83 c4 10             	add    $0x10,%esp
}
801039e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039e3:	89 f0                	mov    %esi,%eax
801039e5:	5b                   	pop    %ebx
801039e6:	5e                   	pop    %esi
801039e7:	5f                   	pop    %edi
801039e8:	5d                   	pop    %ebp
801039e9:	c3                   	ret    
801039ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(proc->stride_info.pass_value<min){
801039f0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801039f3:	73 a3                	jae    80103998 <remove_min+0x28>
801039f5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801039f8:	89 d8                	mov    %ebx,%eax
801039fa:	89 ce                	mov    %ecx,%esi
801039fc:	eb c2                	jmp    801039c0 <remove_min+0x50>
801039fe:	66 90                	xchg   %ax,%ax
}
80103a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  struct proc *special =NULL;
80103a03:	31 f6                	xor    %esi,%esi
}
80103a05:	89 f0                	mov    %esi,%eax
80103a07:	5b                   	pop    %ebx
80103a08:	5e                   	pop    %esi
80103a09:	5f                   	pop    %edi
80103a0a:	5d                   	pop    %ebp
80103a0b:	c3                   	ret    
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a10 <update_pass_value>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	53                   	push   %ebx
80103a14:	8b 45 08             	mov    0x8(%ebp),%eax
  proc->stride_info.pass_value += proc->stride_info.stride;
80103a17:	8b 48 7c             	mov    0x7c(%eax),%ecx
80103a1a:	89 cb                	mov    %ecx,%ebx
80103a1c:	c1 fb 1f             	sar    $0x1f,%ebx
80103a1f:	01 88 84 00 00 00    	add    %ecx,0x84(%eax)
80103a25:	11 98 88 00 00 00    	adc    %ebx,0x88(%eax)
}
80103a2b:	5b                   	pop    %ebx
80103a2c:	5d                   	pop    %ebp
80103a2d:	c3                   	ret    
80103a2e:	66 90                	xchg   %ax,%ax

80103a30 <update_min_pass_value>:
  for (current = ptable.head; current != NULL; current = current->next)
80103a30:	a1 94 2d 11 80       	mov    0x80112d94,%eax
80103a35:	85 c0                	test   %eax,%eax
80103a37:	0f 84 83 00 00 00    	je     80103ac0 <update_min_pass_value+0x90>
{
80103a3d:	55                   	push   %ebp
80103a3e:	89 e5                	mov    %esp,%ebp
80103a40:	57                   	push   %edi
80103a41:	56                   	push   %esi
80103a42:	53                   	push   %ebx
  long long min = 92233720384775807;
80103a43:	bf 7f e6 d8 7b       	mov    $0x7bd8e67f,%edi
80103a48:	bb 14 ae 47 01       	mov    $0x147ae14,%ebx
{
80103a4d:	83 ec 0c             	sub    $0xc,%esp
  struct proc *special =NULL;
80103a50:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80103a57:	eb 0e                	jmp    80103a67 <update_min_pass_value+0x37>
80103a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (current = ptable.head; current != NULL; current = current->next)
80103a60:	8b 40 04             	mov    0x4(%eax),%eax
80103a63:	85 c0                	test   %eax,%eax
80103a65:	74 29                	je     80103a90 <update_min_pass_value+0x60>
  {   proc = current->proc;
80103a67:	8b 10                	mov    (%eax),%edx
    if (proc->state == RUNNABLE){
80103a69:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103a6d:	75 f1                	jne    80103a60 <update_min_pass_value+0x30>
      if(proc->stride_info.pass_value<min){
80103a6f:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80103a75:	8b b2 84 00 00 00    	mov    0x84(%edx),%esi
80103a7b:	39 d9                	cmp    %ebx,%ecx
80103a7d:	7f e1                	jg     80103a60 <update_min_pass_value+0x30>
80103a7f:	7d 2f                	jge    80103ab0 <update_min_pass_value+0x80>
80103a81:	89 f7                	mov    %esi,%edi
80103a83:	89 cb                	mov    %ecx,%ebx
80103a85:	89 55 ec             	mov    %edx,-0x14(%ebp)
  for (current = ptable.head; current != NULL; current = current->next)
80103a88:	8b 40 04             	mov    0x4(%eax),%eax
80103a8b:	85 c0                	test   %eax,%eax
80103a8d:	75 d8                	jne    80103a67 <update_min_pass_value+0x37>
80103a8f:	90                   	nop
  if(special !=NULL){
80103a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a93:	85 c0                	test   %eax,%eax
80103a95:	74 0c                	je     80103aa3 <update_min_pass_value+0x73>
    ptable.min_pass_value=min;
80103a97:	89 3d 9c 2d 11 80    	mov    %edi,0x80112d9c
80103a9d:	89 1d a0 2d 11 80    	mov    %ebx,0x80112da0
}
80103aa3:	83 c4 0c             	add    $0xc,%esp
80103aa6:	5b                   	pop    %ebx
80103aa7:	5e                   	pop    %esi
80103aa8:	5f                   	pop    %edi
80103aa9:	5d                   	pop    %ebp
80103aaa:	c3                   	ret    
80103aab:	90                   	nop
80103aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(proc->stride_info.pass_value<min){
80103ab0:	39 fe                	cmp    %edi,%esi
80103ab2:	73 ac                	jae    80103a60 <update_min_pass_value+0x30>
80103ab4:	89 f7                	mov    %esi,%edi
80103ab6:	89 cb                	mov    %ecx,%ebx
80103ab8:	89 55 ec             	mov    %edx,-0x14(%ebp)
80103abb:	eb cb                	jmp    80103a88 <update_min_pass_value+0x58>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
80103ac0:	f3 c3                	repz ret 
80103ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ad0 <insert>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	53                   	push   %ebx
80103ad4:	83 ec 10             	sub    $0x10,%esp
  node_t *tmp = ptable.head;
80103ad7:	8b 1d 94 2d 11 80    	mov    0x80112d94,%ebx
  node_t *new_node = k_malloc(sizeof(node_t));
80103add:	6a 08                	push   $0x8
80103adf:	e8 ec ea ff ff       	call   801025d0 <k_malloc>
  new_node->proc = proc;
80103ae4:	8b 55 08             	mov    0x8(%ebp),%edx
  new_node->next = tmp;
80103ae7:	89 58 04             	mov    %ebx,0x4(%eax)
}
80103aea:	83 c4 10             	add    $0x10,%esp
  new_node->proc = proc;
80103aed:	89 10                	mov    %edx,(%eax)
  ptable.head = new_node;
80103aef:	a3 94 2d 11 80       	mov    %eax,0x80112d94
}
80103af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103af7:	c9                   	leave  
80103af8:	c3                   	ret    
80103af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b00 <list_insert>:
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	5d                   	pop    %ebp
80103b04:	eb ca                	jmp    80103ad0 <insert>
80103b06:	8d 76 00             	lea    0x0(%esi),%esi
80103b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b10 <assign_min_pass_value>:
{
80103b10:	55                   	push   %ebp
  proc->stride_info.pass_value = ptable.min_pass_value;
80103b11:	a1 9c 2d 11 80       	mov    0x80112d9c,%eax
80103b16:	8b 15 a0 2d 11 80    	mov    0x80112da0,%edx
{
80103b1c:	89 e5                	mov    %esp,%ebp
  proc->stride_info.pass_value = ptable.min_pass_value;
80103b1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103b21:	89 81 84 00 00 00    	mov    %eax,0x84(%ecx)
80103b27:	89 91 88 00 00 00    	mov    %edx,0x88(%ecx)
}
80103b2d:	5d                   	pop    %ebp
80103b2e:	c3                   	ret    
80103b2f:	90                   	nop

80103b30 <initialize_stride_info>:
{
80103b30:	55                   	push   %ebp
  proc->stride_info.pass_value=ptable.min_pass_value;
80103b31:	a1 9c 2d 11 80       	mov    0x80112d9c,%eax
80103b36:	8b 15 a0 2d 11 80    	mov    0x80112da0,%edx
{
80103b3c:	89 e5                	mov    %esp,%ebp
80103b3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  proc->stride_info.tickets=100;
80103b41:	c7 81 80 00 00 00 64 	movl   $0x64,0x80(%ecx)
80103b48:	00 00 00 
  proc->stride_info.pass_value=ptable.min_pass_value;
80103b4b:	89 81 84 00 00 00    	mov    %eax,0x84(%ecx)
80103b51:	89 91 88 00 00 00    	mov    %edx,0x88(%ecx)
  proc->stride_info.stride = STRIDE_LARGE_NUMBER/ proc->stride_info.tickets;
80103b57:	c7 41 7c 64 00 00 00 	movl   $0x64,0x7c(%ecx)
}
80103b5e:	5d                   	pop    %ebp
80103b5f:	c3                   	ret    

80103b60 <pinit>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b66:	68 75 79 10 80       	push   $0x80107975
80103b6b:	68 60 2d 11 80       	push   $0x80112d60
80103b70:	e8 ab 0b 00 00       	call   80104720 <initlock>
  ptable.head = NULL;
80103b75:	c7 05 94 2d 11 80 00 	movl   $0x0,0x80112d94
80103b7c:	00 00 00 
  ptable.large_number = STRIDE_LARGE_NUMBER;
80103b7f:	c7 05 98 2d 11 80 10 	movl   $0x2710,0x80112d98
80103b86:	27 00 00 
}
80103b89:	83 c4 10             	add    $0x10,%esp
80103b8c:	c9                   	leave  
80103b8d:	c3                   	ret    
80103b8e:	66 90                	xchg   %ax,%ax

80103b90 <mycpu>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	56                   	push   %esi
80103b94:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b95:	9c                   	pushf  
80103b96:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103b97:	f6 c4 02             	test   $0x2,%ah
80103b9a:	75 5e                	jne    80103bfa <mycpu+0x6a>
  apicid = lapicid();
80103b9c:	e8 2f ed ff ff       	call   801028d0 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103ba1:	8b 35 40 2d 11 80    	mov    0x80112d40,%esi
80103ba7:	85 f6                	test   %esi,%esi
80103ba9:	7e 42                	jle    80103bed <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103bab:	0f b6 15 c0 27 11 80 	movzbl 0x801127c0,%edx
80103bb2:	39 d0                	cmp    %edx,%eax
80103bb4:	74 30                	je     80103be6 <mycpu+0x56>
80103bb6:	b9 70 28 11 80       	mov    $0x80112870,%ecx
  for (i = 0; i < ncpu; ++i)
80103bbb:	31 d2                	xor    %edx,%edx
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
80103bc0:	83 c2 01             	add    $0x1,%edx
80103bc3:	39 f2                	cmp    %esi,%edx
80103bc5:	74 26                	je     80103bed <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103bc7:	0f b6 19             	movzbl (%ecx),%ebx
80103bca:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103bd0:	39 c3                	cmp    %eax,%ebx
80103bd2:	75 ec                	jne    80103bc0 <mycpu+0x30>
80103bd4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103bda:	05 c0 27 11 80       	add    $0x801127c0,%eax
}
80103bdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103be2:	5b                   	pop    %ebx
80103be3:	5e                   	pop    %esi
80103be4:	5d                   	pop    %ebp
80103be5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103be6:	b8 c0 27 11 80       	mov    $0x801127c0,%eax
      return &cpus[i];
80103beb:	eb f2                	jmp    80103bdf <mycpu+0x4f>
  panic("unknown apicid\n");
80103bed:	83 ec 0c             	sub    $0xc,%esp
80103bf0:	68 7c 79 10 80       	push   $0x8010797c
80103bf5:	e8 96 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103bfa:	83 ec 0c             	sub    $0xc,%esp
80103bfd:	68 58 7a 10 80       	push   $0x80107a58
80103c02:	e8 89 c7 ff ff       	call   80100390 <panic>
80103c07:	89 f6                	mov    %esi,%esi
80103c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c10 <cpuid>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103c16:	e8 75 ff ff ff       	call   80103b90 <mycpu>
80103c1b:	2d c0 27 11 80       	sub    $0x801127c0,%eax
}
80103c20:	c9                   	leave  
  return mycpu() - cpus;
80103c21:	c1 f8 04             	sar    $0x4,%eax
80103c24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c2a:	c3                   	ret    
80103c2b:	90                   	nop
80103c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c30 <myproc>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	53                   	push   %ebx
80103c34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c37:	e8 54 0b 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103c3c:	e8 4f ff ff ff       	call   80103b90 <mycpu>
  p = c->proc;
80103c41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c47:	e8 84 0b 00 00       	call   801047d0 <popcli>
}
80103c4c:	83 c4 04             	add    $0x4,%esp
80103c4f:	89 d8                	mov    %ebx,%eax
80103c51:	5b                   	pop    %ebx
80103c52:	5d                   	pop    %ebp
80103c53:	c3                   	ret    
80103c54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c60 <userinit>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	53                   	push   %ebx
80103c64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c67:	e8 34 fb ff ff       	call   801037a0 <allocproc>
80103c6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c6e:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if ((p->pgdir = setupkvm()) == 0)
80103c73:	e8 08 35 00 00       	call   80107180 <setupkvm>
80103c78:	85 c0                	test   %eax,%eax
80103c7a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c7d:	0f 84 bd 00 00 00    	je     80103d40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c83:	83 ec 04             	sub    $0x4,%esp
80103c86:	68 2c 00 00 00       	push   $0x2c
80103c8b:	68 60 a4 10 80       	push   $0x8010a460
80103c90:	50                   	push   %eax
80103c91:	e8 ca 31 00 00       	call   80106e60 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c9f:	6a 4c                	push   $0x4c
80103ca1:	6a 00                	push   $0x0
80103ca3:	ff 73 18             	pushl  0x18(%ebx)
80103ca6:	e8 c5 0c 00 00       	call   80104970 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cab:	8b 43 18             	mov    0x18(%ebx),%eax
80103cae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cb3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cb8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cbf:	8b 43 18             	mov    0x18(%ebx),%eax
80103cc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103cc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ccd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103cd1:	8b 43 18             	mov    0x18(%ebx),%eax
80103cd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103cdc:	8b 43 18             	mov    0x18(%ebx),%eax
80103cdf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ce6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ce9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103cf0:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cfa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103cfd:	6a 10                	push   $0x10
80103cff:	68 a5 79 10 80       	push   $0x801079a5
80103d04:	50                   	push   %eax
80103d05:	e8 46 0e 00 00       	call   80104b50 <safestrcpy>
  p->cwd = namei("/");
80103d0a:	c7 04 24 ae 79 10 80 	movl   $0x801079ae,(%esp)
80103d11:	e8 da e1 ff ff       	call   80101ef0 <namei>
80103d16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d19:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103d20:	e8 3b 0b 00 00       	call   80104860 <acquire>
  p->state = RUNNABLE;
80103d25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103d2c:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103d33:	e8 e8 0b 00 00       	call   80104920 <release>
}
80103d38:	83 c4 10             	add    $0x10,%esp
80103d3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d3e:	c9                   	leave  
80103d3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103d40:	83 ec 0c             	sub    $0xc,%esp
80103d43:	68 8c 79 10 80       	push   $0x8010798c
80103d48:	e8 43 c6 ff ff       	call   80100390 <panic>
80103d4d:	8d 76 00             	lea    0x0(%esi),%esi

80103d50 <growproc>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	56                   	push   %esi
80103d54:	53                   	push   %ebx
80103d55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d58:	e8 33 0a 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103d5d:	e8 2e fe ff ff       	call   80103b90 <mycpu>
  p = c->proc;
80103d62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d68:	e8 63 0a 00 00       	call   801047d0 <popcli>
  if (n > 0)
80103d6d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103d70:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103d72:	7f 1c                	jg     80103d90 <growproc+0x40>
  else if (n < 0)
80103d74:	75 3a                	jne    80103db0 <growproc+0x60>
  switchuvm(curproc);
80103d76:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d79:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d7b:	53                   	push   %ebx
80103d7c:	e8 cf 2f 00 00       	call   80106d50 <switchuvm>
  return 0;
80103d81:	83 c4 10             	add    $0x10,%esp
80103d84:	31 c0                	xor    %eax,%eax
}
80103d86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d89:	5b                   	pop    %ebx
80103d8a:	5e                   	pop    %esi
80103d8b:	5d                   	pop    %ebp
80103d8c:	c3                   	ret    
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d90:	83 ec 04             	sub    $0x4,%esp
80103d93:	01 c6                	add    %eax,%esi
80103d95:	56                   	push   %esi
80103d96:	50                   	push   %eax
80103d97:	ff 73 04             	pushl  0x4(%ebx)
80103d9a:	e8 01 32 00 00       	call   80106fa0 <allocuvm>
80103d9f:	83 c4 10             	add    $0x10,%esp
80103da2:	85 c0                	test   %eax,%eax
80103da4:	75 d0                	jne    80103d76 <growproc+0x26>
      return -1;
80103da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dab:	eb d9                	jmp    80103d86 <growproc+0x36>
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103db0:	83 ec 04             	sub    $0x4,%esp
80103db3:	01 c6                	add    %eax,%esi
80103db5:	56                   	push   %esi
80103db6:	50                   	push   %eax
80103db7:	ff 73 04             	pushl  0x4(%ebx)
80103dba:	e8 11 33 00 00       	call   801070d0 <deallocuvm>
80103dbf:	83 c4 10             	add    $0x10,%esp
80103dc2:	85 c0                	test   %eax,%eax
80103dc4:	75 b0                	jne    80103d76 <growproc+0x26>
80103dc6:	eb de                	jmp    80103da6 <growproc+0x56>
80103dc8:	90                   	nop
80103dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103dd0 <fork>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103dd9:	e8 b2 09 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103dde:	e8 ad fd ff ff       	call   80103b90 <mycpu>
  p = c->proc;
80103de3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103de9:	e8 e2 09 00 00       	call   801047d0 <popcli>
  if ((np = allocproc()) == 0)
80103dee:	e8 ad f9 ff ff       	call   801037a0 <allocproc>
80103df3:	85 c0                	test   %eax,%eax
80103df5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103df8:	0f 84 cf 00 00 00    	je     80103ecd <fork+0xfd>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103dfe:	83 ec 08             	sub    $0x8,%esp
80103e01:	ff 33                	pushl  (%ebx)
80103e03:	ff 73 04             	pushl  0x4(%ebx)
80103e06:	89 c7                	mov    %eax,%edi
80103e08:	e8 43 34 00 00       	call   80107250 <copyuvm>
80103e0d:	83 c4 10             	add    $0x10,%esp
80103e10:	85 c0                	test   %eax,%eax
80103e12:	89 47 04             	mov    %eax,0x4(%edi)
80103e15:	0f 84 b9 00 00 00    	je     80103ed4 <fork+0x104>
  np->sz = curproc->sz;
80103e1b:	8b 03                	mov    (%ebx),%eax
80103e1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e20:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103e22:	89 59 14             	mov    %ebx,0x14(%ecx)
80103e25:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103e27:	8b 79 18             	mov    0x18(%ecx),%edi
80103e2a:	8b 73 18             	mov    0x18(%ebx),%esi
80103e2d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80103e34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e36:	8b 40 18             	mov    0x18(%eax),%eax
80103e39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
80103e40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e44:	85 c0                	test   %eax,%eax
80103e46:	74 13                	je     80103e5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e48:	83 ec 0c             	sub    $0xc,%esp
80103e4b:	50                   	push   %eax
80103e4c:	e8 9f cf ff ff       	call   80100df0 <filedup>
80103e51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e54:	83 c4 10             	add    $0x10,%esp
80103e57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80103e5b:	83 c6 01             	add    $0x1,%esi
80103e5e:	83 fe 10             	cmp    $0x10,%esi
80103e61:	75 dd                	jne    80103e40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e63:	83 ec 0c             	sub    $0xc,%esp
80103e66:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e6c:	e8 ef d7 ff ff       	call   80101660 <idup>
80103e71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e7d:	6a 10                	push   $0x10
80103e7f:	53                   	push   %ebx
80103e80:	50                   	push   %eax
80103e81:	e8 ca 0c 00 00       	call   80104b50 <safestrcpy>
  pid = np->pid;
80103e86:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
80103e89:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103e90:	e8 cb 09 00 00       	call   80104860 <acquire>
  np->state = RUNNABLE;
80103e95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  proc->stride_info.pass_value = ptable.min_pass_value;
80103e9c:	8b 0d 9c 2d 11 80    	mov    0x80112d9c,%ecx
80103ea2:	8b 1d a0 2d 11 80    	mov    0x80112da0,%ebx
80103ea8:	89 8f 84 00 00 00    	mov    %ecx,0x84(%edi)
80103eae:	89 9f 88 00 00 00    	mov    %ebx,0x88(%edi)
  release(&ptable.lock);
80103eb4:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103ebb:	e8 60 0a 00 00       	call   80104920 <release>
  return pid;
80103ec0:	83 c4 10             	add    $0x10,%esp
}
80103ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ec6:	89 f0                	mov    %esi,%eax
80103ec8:	5b                   	pop    %ebx
80103ec9:	5e                   	pop    %esi
80103eca:	5f                   	pop    %edi
80103ecb:	5d                   	pop    %ebp
80103ecc:	c3                   	ret    
    return -1;
80103ecd:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103ed2:	eb ef                	jmp    80103ec3 <fork+0xf3>
    kfree(np->kstack);
80103ed4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ed7:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103eda:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103edf:	ff 73 08             	pushl  0x8(%ebx)
80103ee2:	e8 39 e4 ff ff       	call   80102320 <kfree>
    np->kstack = 0;
80103ee7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103eee:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ef5:	83 c4 10             	add    $0x10,%esp
80103ef8:	eb c9                	jmp    80103ec3 <fork+0xf3>
80103efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f00 <scheduler>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	57                   	push   %edi
80103f04:	56                   	push   %esi
80103f05:	53                   	push   %ebx
80103f06:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103f09:	e8 82 fc ff ff       	call   80103b90 <mycpu>
  c->proc = 0;
80103f0e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f15:	00 00 00 
  struct cpu *c = mycpu();
80103f18:	89 c3                	mov    %eax,%ebx
80103f1a:	8d 40 04             	lea    0x4(%eax),%eax
80103f1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103f20:	fb                   	sti    
    acquire(&ptable.lock);
80103f21:	83 ec 0c             	sub    $0xc,%esp
80103f24:	68 60 2d 11 80       	push   $0x80112d60
80103f29:	e8 32 09 00 00       	call   80104860 <acquire>
    p = remove_min();
80103f2e:	e8 3d fa ff ff       	call   80103970 <remove_min>
    if (p != NULL)
80103f33:	83 c4 10             	add    $0x10,%esp
80103f36:	85 c0                	test   %eax,%eax
    p = remove_min();
80103f38:	89 c7                	mov    %eax,%edi
    if (p != NULL)
80103f3a:	74 66                	je     80103fa2 <scheduler+0xa2>
      switchuvm(p);
80103f3c:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f3f:	89 83 ac 00 00 00    	mov    %eax,0xac(%ebx)
      switchuvm(p);
80103f45:	50                   	push   %eax
80103f46:	e8 05 2e 00 00       	call   80106d50 <switchuvm>
      p->state = RUNNING;
80103f4b:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), p->context);
80103f52:	58                   	pop    %eax
80103f53:	5a                   	pop    %edx
80103f54:	ff 77 1c             	pushl  0x1c(%edi)
80103f57:	ff 75 e4             	pushl  -0x1c(%ebp)
80103f5a:	e8 4c 0c 00 00       	call   80104bab <swtch>
      switchkvm();
80103f5f:	e8 cc 2d 00 00       	call   80106d30 <switchkvm>
  proc->stride_info.pass_value += proc->stride_info.stride;
80103f64:	8b 47 7c             	mov    0x7c(%edi),%eax
  node_t *tmp = ptable.head;
80103f67:	8b 35 94 2d 11 80    	mov    0x80112d94,%esi
  proc->stride_info.pass_value += proc->stride_info.stride;
80103f6d:	99                   	cltd   
80103f6e:	01 87 84 00 00 00    	add    %eax,0x84(%edi)
80103f74:	11 97 88 00 00 00    	adc    %edx,0x88(%edi)
  node_t *new_node = k_malloc(sizeof(node_t));
80103f7a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103f81:	e8 4a e6 ff ff       	call   801025d0 <k_malloc>
  new_node->proc = proc;
80103f86:	89 38                	mov    %edi,(%eax)
  new_node->next = tmp;
80103f88:	89 70 04             	mov    %esi,0x4(%eax)
  ptable.head = new_node;
80103f8b:	a3 94 2d 11 80       	mov    %eax,0x80112d94
      update_min_pass_value();
80103f90:	e8 9b fa ff ff       	call   80103a30 <update_min_pass_value>
      c->proc = 0;
80103f95:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103f9c:	00 00 00 
80103f9f:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80103fa2:	83 ec 0c             	sub    $0xc,%esp
80103fa5:	68 60 2d 11 80       	push   $0x80112d60
80103faa:	e8 71 09 00 00       	call   80104920 <release>
    sti();
80103faf:	83 c4 10             	add    $0x10,%esp
80103fb2:	e9 69 ff ff ff       	jmp    80103f20 <scheduler+0x20>
80103fb7:	89 f6                	mov    %esi,%esi
80103fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fc0 <sched>:
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	56                   	push   %esi
80103fc4:	53                   	push   %ebx
  pushcli();
80103fc5:	e8 c6 07 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103fca:	e8 c1 fb ff ff       	call   80103b90 <mycpu>
  p = c->proc;
80103fcf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fd5:	e8 f6 07 00 00       	call   801047d0 <popcli>
  if (!holding(&ptable.lock))
80103fda:	83 ec 0c             	sub    $0xc,%esp
80103fdd:	68 60 2d 11 80       	push   $0x80112d60
80103fe2:	e8 49 08 00 00       	call   80104830 <holding>
80103fe7:	83 c4 10             	add    $0x10,%esp
80103fea:	85 c0                	test   %eax,%eax
80103fec:	74 4f                	je     8010403d <sched+0x7d>
  if (mycpu()->ncli != 1)
80103fee:	e8 9d fb ff ff       	call   80103b90 <mycpu>
80103ff3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103ffa:	75 68                	jne    80104064 <sched+0xa4>
  if (p->state == RUNNING)
80103ffc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104000:	74 55                	je     80104057 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104002:	9c                   	pushf  
80104003:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104004:	f6 c4 02             	test   $0x2,%ah
80104007:	75 41                	jne    8010404a <sched+0x8a>
  intena = mycpu()->intena;
80104009:	e8 82 fb ff ff       	call   80103b90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010400e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104011:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104017:	e8 74 fb ff ff       	call   80103b90 <mycpu>
8010401c:	83 ec 08             	sub    $0x8,%esp
8010401f:	ff 70 04             	pushl  0x4(%eax)
80104022:	53                   	push   %ebx
80104023:	e8 83 0b 00 00       	call   80104bab <swtch>
  mycpu()->intena = intena;
80104028:	e8 63 fb ff ff       	call   80103b90 <mycpu>
}
8010402d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104030:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104036:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104039:	5b                   	pop    %ebx
8010403a:	5e                   	pop    %esi
8010403b:	5d                   	pop    %ebp
8010403c:	c3                   	ret    
    panic("sched ptable.lock");
8010403d:	83 ec 0c             	sub    $0xc,%esp
80104040:	68 b0 79 10 80       	push   $0x801079b0
80104045:	e8 46 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010404a:	83 ec 0c             	sub    $0xc,%esp
8010404d:	68 dc 79 10 80       	push   $0x801079dc
80104052:	e8 39 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80104057:	83 ec 0c             	sub    $0xc,%esp
8010405a:	68 ce 79 10 80       	push   $0x801079ce
8010405f:	e8 2c c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104064:	83 ec 0c             	sub    $0xc,%esp
80104067:	68 c2 79 10 80       	push   $0x801079c2
8010406c:	e8 1f c3 ff ff       	call   80100390 <panic>
80104071:	eb 0d                	jmp    80104080 <exit>
80104073:	90                   	nop
80104074:	90                   	nop
80104075:	90                   	nop
80104076:	90                   	nop
80104077:	90                   	nop
80104078:	90                   	nop
80104079:	90                   	nop
8010407a:	90                   	nop
8010407b:	90                   	nop
8010407c:	90                   	nop
8010407d:	90                   	nop
8010407e:	90                   	nop
8010407f:	90                   	nop

80104080 <exit>:
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104089:	e8 02 07 00 00       	call   80104790 <pushcli>
  c = mycpu();
8010408e:	e8 fd fa ff ff       	call   80103b90 <mycpu>
  p = c->proc;
80104093:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104099:	e8 32 07 00 00       	call   801047d0 <popcli>
  if (curproc == initproc)
8010409e:	39 1d bc a5 10 80    	cmp    %ebx,0x8010a5bc
801040a4:	8d 73 28             	lea    0x28(%ebx),%esi
801040a7:	8d 7b 68             	lea    0x68(%ebx),%edi
801040aa:	0f 84 3d 01 00 00    	je     801041ed <exit+0x16d>
    if (curproc->ofile[fd])
801040b0:	8b 06                	mov    (%esi),%eax
801040b2:	85 c0                	test   %eax,%eax
801040b4:	74 12                	je     801040c8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801040b6:	83 ec 0c             	sub    $0xc,%esp
801040b9:	50                   	push   %eax
801040ba:	e8 81 cd ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
801040bf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801040c5:	83 c4 10             	add    $0x10,%esp
801040c8:	83 c6 04             	add    $0x4,%esi
  for (fd = 0; fd < NOFILE; fd++)
801040cb:	39 f7                	cmp    %esi,%edi
801040cd:	75 e1                	jne    801040b0 <exit+0x30>
  begin_op();
801040cf:	e8 6c ec ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
801040d4:	83 ec 0c             	sub    $0xc,%esp
801040d7:	ff 73 68             	pushl  0x68(%ebx)
801040da:	e8 e1 d6 ff ff       	call   801017c0 <iput>
  end_op();
801040df:	e8 cc ec ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
801040e4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801040eb:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
801040f2:	e8 69 07 00 00       	call   80104860 <acquire>
static void wakeup1(void *chan)
{
  struct proc *p;

  node_t *current;
  for (current = ptable.head; current != NULL; current = current->next)
801040f7:	8b 0d 94 2d 11 80    	mov    0x80112d94,%ecx
801040fd:	83 c4 10             	add    $0x10,%esp
  wakeup1(curproc->parent);
80104100:	8b 7b 14             	mov    0x14(%ebx),%edi
  for (current = ptable.head; current != NULL; current = current->next)
80104103:	85 c9                	test   %ecx,%ecx
80104105:	75 10                	jne    80104117 <exit+0x97>
80104107:	eb 3f                	jmp    80104148 <exit+0xc8>
80104109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104110:	8b 49 04             	mov    0x4(%ecx),%ecx
80104113:	85 c9                	test   %ecx,%ecx
80104115:	74 51                	je     80104168 <exit+0xe8>
  {

    p = current->proc;
80104117:	8b 31                	mov    (%ecx),%esi
    if (p->state == SLEEPING && p->chan == chan)
80104119:	83 7e 0c 02          	cmpl   $0x2,0xc(%esi)
8010411d:	75 f1                	jne    80104110 <exit+0x90>
8010411f:	3b 7e 20             	cmp    0x20(%esi),%edi
80104122:	75 ec                	jne    80104110 <exit+0x90>
    {
      p->state = RUNNABLE;
80104124:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  proc->stride_info.pass_value = ptable.min_pass_value;
8010412b:	a1 9c 2d 11 80       	mov    0x80112d9c,%eax
80104130:	8b 15 a0 2d 11 80    	mov    0x80112da0,%edx
80104136:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
8010413c:	89 96 88 00 00 00    	mov    %edx,0x88(%esi)
80104142:	eb cc                	jmp    80104110 <exit+0x90>
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
80104148:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010414f:	e8 6c fe ff ff       	call   80103fc0 <sched>
  panic("zombie exit");
80104154:	83 ec 0c             	sub    $0xc,%esp
80104157:	68 fd 79 10 80       	push   $0x801079fd
8010415c:	e8 2f c2 ff ff       	call   80100390 <panic>
80104161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (current = ptable.head; current != NULL; current = current->next)
80104168:	a1 94 2d 11 80       	mov    0x80112d94,%eax
8010416d:	85 c0                	test   %eax,%eax
8010416f:	74 d7                	je     80104148 <exit+0xc8>
      p->parent = initproc;
80104171:	8b 35 bc a5 10 80    	mov    0x8010a5bc,%esi
80104177:	eb 0e                	jmp    80104187 <exit+0x107>
80104179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (current = ptable.head; current != NULL; current = current->next)
80104180:	8b 40 04             	mov    0x4(%eax),%eax
80104183:	85 c0                	test   %eax,%eax
80104185:	74 c1                	je     80104148 <exit+0xc8>
    p = current->proc;
80104187:	8b 10                	mov    (%eax),%edx
    if (p->parent == curproc)
80104189:	39 5a 14             	cmp    %ebx,0x14(%edx)
8010418c:	75 f2                	jne    80104180 <exit+0x100>
      if (p->state == ZOMBIE)
8010418e:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104192:	89 72 14             	mov    %esi,0x14(%edx)
      if (p->state == ZOMBIE)
80104195:	75 e9                	jne    80104180 <exit+0x100>
  for (current = ptable.head; current != NULL; current = current->next)
80104197:	8b 15 94 2d 11 80    	mov    0x80112d94,%edx
8010419d:	85 d2                	test   %edx,%edx
8010419f:	74 df                	je     80104180 <exit+0x100>
801041a1:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801041a4:	eb 11                	jmp    801041b7 <exit+0x137>
801041a6:	8d 76 00             	lea    0x0(%esi),%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801041b0:	8b 52 04             	mov    0x4(%edx),%edx
801041b3:	85 d2                	test   %edx,%edx
801041b5:	74 31                	je     801041e8 <exit+0x168>
    p = current->proc;
801041b7:	8b 0a                	mov    (%edx),%ecx
    if (p->state == SLEEPING && p->chan == chan)
801041b9:	83 79 0c 02          	cmpl   $0x2,0xc(%ecx)
801041bd:	75 f1                	jne    801041b0 <exit+0x130>
801041bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801041c2:	3b 79 20             	cmp    0x20(%ecx),%edi
801041c5:	75 e9                	jne    801041b0 <exit+0x130>
      p->state = RUNNABLE;
801041c7:	c7 41 0c 03 00 00 00 	movl   $0x3,0xc(%ecx)
  proc->stride_info.pass_value = ptable.min_pass_value;
801041ce:	8b 35 9c 2d 11 80    	mov    0x80112d9c,%esi
801041d4:	8b 3d a0 2d 11 80    	mov    0x80112da0,%edi
801041da:	89 b1 84 00 00 00    	mov    %esi,0x84(%ecx)
801041e0:	89 b9 88 00 00 00    	mov    %edi,0x88(%ecx)
801041e6:	eb c8                	jmp    801041b0 <exit+0x130>
801041e8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801041eb:	eb 93                	jmp    80104180 <exit+0x100>
    panic("init exiting");
801041ed:	83 ec 0c             	sub    $0xc,%esp
801041f0:	68 f0 79 10 80       	push   $0x801079f0
801041f5:	e8 96 c1 ff ff       	call   80100390 <panic>
801041fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104200 <yield>:
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80104207:	68 60 2d 11 80       	push   $0x80112d60
8010420c:	e8 4f 06 00 00       	call   80104860 <acquire>
  pushcli();
80104211:	e8 7a 05 00 00       	call   80104790 <pushcli>
  c = mycpu();
80104216:	e8 75 f9 ff ff       	call   80103b90 <mycpu>
  p = c->proc;
8010421b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104221:	e8 aa 05 00 00       	call   801047d0 <popcli>
  myproc()->state = RUNNABLE;
80104226:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010422d:	e8 8e fd ff ff       	call   80103fc0 <sched>
  release(&ptable.lock);
80104232:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80104239:	e8 e2 06 00 00       	call   80104920 <release>
}
8010423e:	83 c4 10             	add    $0x10,%esp
80104241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104244:	c9                   	leave  
80104245:	c3                   	ret    
80104246:	8d 76 00             	lea    0x0(%esi),%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <sleep>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
80104254:	56                   	push   %esi
80104255:	53                   	push   %ebx
80104256:	83 ec 0c             	sub    $0xc,%esp
80104259:	8b 7d 08             	mov    0x8(%ebp),%edi
8010425c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010425f:	e8 2c 05 00 00       	call   80104790 <pushcli>
  c = mycpu();
80104264:	e8 27 f9 ff ff       	call   80103b90 <mycpu>
  p = c->proc;
80104269:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010426f:	e8 5c 05 00 00       	call   801047d0 <popcli>
  if (p == 0)
80104274:	85 db                	test   %ebx,%ebx
80104276:	0f 84 87 00 00 00    	je     80104303 <sleep+0xb3>
  if (lk == 0)
8010427c:	85 f6                	test   %esi,%esi
8010427e:	74 76                	je     801042f6 <sleep+0xa6>
  if (lk != &ptable.lock)
80104280:	81 fe 60 2d 11 80    	cmp    $0x80112d60,%esi
80104286:	74 50                	je     801042d8 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
80104288:	83 ec 0c             	sub    $0xc,%esp
8010428b:	68 60 2d 11 80       	push   $0x80112d60
80104290:	e8 cb 05 00 00       	call   80104860 <acquire>
    release(lk);
80104295:	89 34 24             	mov    %esi,(%esp)
80104298:	e8 83 06 00 00       	call   80104920 <release>
  p->chan = chan;
8010429d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042a7:	e8 14 fd ff ff       	call   80103fc0 <sched>
  p->chan = 0;
801042ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042b3:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
801042ba:	e8 61 06 00 00       	call   80104920 <release>
    acquire(lk);
801042bf:	89 75 08             	mov    %esi,0x8(%ebp)
801042c2:	83 c4 10             	add    $0x10,%esp
}
801042c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042c8:	5b                   	pop    %ebx
801042c9:	5e                   	pop    %esi
801042ca:	5f                   	pop    %edi
801042cb:	5d                   	pop    %ebp
    acquire(lk);
801042cc:	e9 8f 05 00 00       	jmp    80104860 <acquire>
801042d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042e2:	e8 d9 fc ff ff       	call   80103fc0 <sched>
  p->chan = 0;
801042e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f1:	5b                   	pop    %ebx
801042f2:	5e                   	pop    %esi
801042f3:	5f                   	pop    %edi
801042f4:	5d                   	pop    %ebp
801042f5:	c3                   	ret    
    panic("sleep without lk");
801042f6:	83 ec 0c             	sub    $0xc,%esp
801042f9:	68 0f 7a 10 80       	push   $0x80107a0f
801042fe:	e8 8d c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104303:	83 ec 0c             	sub    $0xc,%esp
80104306:	68 09 7a 10 80       	push   $0x80107a09
8010430b:	e8 80 c0 ff ff       	call   80100390 <panic>

80104310 <wait>:
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
  pushcli();
80104315:	e8 76 04 00 00       	call   80104790 <pushcli>
  c = mycpu();
8010431a:	e8 71 f8 ff ff       	call   80103b90 <mycpu>
  p = c->proc;
8010431f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104325:	e8 a6 04 00 00       	call   801047d0 <popcli>
  acquire(&ptable.lock);
8010432a:	83 ec 0c             	sub    $0xc,%esp
8010432d:	68 60 2d 11 80       	push   $0x80112d60
80104332:	e8 29 05 00 00       	call   80104860 <acquire>
    for (current = ptable.head; current != NULL; current = current->next)
80104337:	a1 94 2d 11 80       	mov    0x80112d94,%eax
  acquire(&ptable.lock);
8010433c:	83 c4 10             	add    $0x10,%esp
    for (current = ptable.head; current != NULL; current = current->next)
8010433f:	85 c0                	test   %eax,%eax
80104341:	74 52                	je     80104395 <wait+0x85>
    havekids = 0;
80104343:	31 d2                	xor    %edx,%edx
80104345:	eb 10                	jmp    80104357 <wait+0x47>
80104347:	89 f6                	mov    %esi,%esi
80104349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for (current = ptable.head; current != NULL; current = current->next)
80104350:	8b 40 04             	mov    0x4(%eax),%eax
80104353:	85 c0                	test   %eax,%eax
80104355:	74 19                	je     80104370 <wait+0x60>
      p = current->proc;
80104357:	8b 18                	mov    (%eax),%ebx
      if (p->parent != curproc)
80104359:	39 73 14             	cmp    %esi,0x14(%ebx)
8010435c:	75 f2                	jne    80104350 <wait+0x40>
      if (p->state == ZOMBIE)
8010435e:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104362:	74 54                	je     801043b8 <wait+0xa8>
    for (current = ptable.head; current != NULL; current = current->next)
80104364:	8b 40 04             	mov    0x4(%eax),%eax
      havekids = 1;
80104367:	ba 01 00 00 00       	mov    $0x1,%edx
    for (current = ptable.head; current != NULL; current = current->next)
8010436c:	85 c0                	test   %eax,%eax
8010436e:	75 e7                	jne    80104357 <wait+0x47>
    if (!havekids || curproc->killed)
80104370:	85 d2                	test   %edx,%edx
80104372:	74 21                	je     80104395 <wait+0x85>
80104374:	8b 46 24             	mov    0x24(%esi),%eax
80104377:	85 c0                	test   %eax,%eax
80104379:	75 1a                	jne    80104395 <wait+0x85>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
8010437b:	83 ec 08             	sub    $0x8,%esp
8010437e:	68 60 2d 11 80       	push   $0x80112d60
80104383:	56                   	push   %esi
80104384:	e8 c7 fe ff ff       	call   80104250 <sleep>
    for (current = ptable.head; current != NULL; current = current->next)
80104389:	a1 94 2d 11 80       	mov    0x80112d94,%eax
  {
8010438e:	83 c4 10             	add    $0x10,%esp
    for (current = ptable.head; current != NULL; current = current->next)
80104391:	85 c0                	test   %eax,%eax
80104393:	75 ae                	jne    80104343 <wait+0x33>
      release(&ptable.lock);
80104395:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104398:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010439d:	68 60 2d 11 80       	push   $0x80112d60
801043a2:	e8 79 05 00 00       	call   80104920 <release>
      return -1;
801043a7:	83 c4 10             	add    $0x10,%esp
}
801043aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043ad:	89 f0                	mov    %esi,%eax
801043af:	5b                   	pop    %ebx
801043b0:	5e                   	pop    %esi
801043b1:	5d                   	pop    %ebp
801043b2:	c3                   	ret    
801043b3:	90                   	nop
801043b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801043b8:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801043bb:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801043be:	ff 73 08             	pushl  0x8(%ebx)
801043c1:	e8 5a df ff ff       	call   80102320 <kfree>
        p->kstack = 0;
801043c6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801043cd:	5a                   	pop    %edx
801043ce:	ff 73 04             	pushl  0x4(%ebx)
801043d1:	e8 2a 2d 00 00       	call   80107100 <freevm>
        p->pid = 0;
801043d6:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801043dd:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801043e4:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801043e8:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801043ef:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        list_remove(p);
801043f6:	89 1c 24             	mov    %ebx,(%esp)
801043f9:	e8 12 f5 ff ff       	call   80103910 <list_remove>
        k_free(p);
801043fe:	89 1c 24             	mov    %ebx,(%esp)
80104401:	e8 3a e1 ff ff       	call   80102540 <k_free>
        release(&ptable.lock);
80104406:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
8010440d:	e8 0e 05 00 00       	call   80104920 <release>
        return pid;
80104412:	83 c4 10             	add    $0x10,%esp
}
80104415:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104418:	89 f0                	mov    %esi,%eax
8010441a:	5b                   	pop    %ebx
8010441b:	5e                   	pop    %esi
8010441c:	5d                   	pop    %ebp
8010441d:	c3                   	ret    
8010441e:	66 90                	xchg   %ax,%ax

80104420 <wakeup>:
  }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
80104425:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&ptable.lock);
80104428:	83 ec 0c             	sub    $0xc,%esp
8010442b:	68 60 2d 11 80       	push   $0x80112d60
80104430:	e8 2b 04 00 00       	call   80104860 <acquire>
  for (current = ptable.head; current != NULL; current = current->next)
80104435:	8b 0d 94 2d 11 80    	mov    0x80112d94,%ecx
8010443b:	83 c4 10             	add    $0x10,%esp
8010443e:	85 c9                	test   %ecx,%ecx
80104440:	75 0d                	jne    8010444f <wakeup+0x2f>
80104442:	eb 3d                	jmp    80104481 <wakeup+0x61>
80104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104448:	8b 49 04             	mov    0x4(%ecx),%ecx
8010444b:	85 c9                	test   %ecx,%ecx
8010444d:	74 32                	je     80104481 <wakeup+0x61>
    p = current->proc;
8010444f:	8b 19                	mov    (%ecx),%ebx
    if (p->state == SLEEPING && p->chan == chan)
80104451:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104455:	75 f1                	jne    80104448 <wakeup+0x28>
80104457:	3b 73 20             	cmp    0x20(%ebx),%esi
8010445a:	75 ec                	jne    80104448 <wakeup+0x28>
      p->state = RUNNABLE;
8010445c:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  proc->stride_info.pass_value = ptable.min_pass_value;
80104463:	a1 9c 2d 11 80       	mov    0x80112d9c,%eax
80104468:	8b 15 a0 2d 11 80    	mov    0x80112da0,%edx
8010446e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
80104474:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
  for (current = ptable.head; current != NULL; current = current->next)
8010447a:	8b 49 04             	mov    0x4(%ecx),%ecx
8010447d:	85 c9                	test   %ecx,%ecx
8010447f:	75 ce                	jne    8010444f <wakeup+0x2f>
  wakeup1(chan);
  release(&ptable.lock);
80104481:	c7 45 08 60 2d 11 80 	movl   $0x80112d60,0x8(%ebp)
}
80104488:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010448b:	5b                   	pop    %ebx
8010448c:	5e                   	pop    %esi
8010448d:	5d                   	pop    %ebp
  release(&ptable.lock);
8010448e:	e9 8d 04 00 00       	jmp    80104920 <release>
80104493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044a0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 10             	sub    $0x10,%esp
801044a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044aa:	68 60 2d 11 80       	push   $0x80112d60
801044af:	e8 ac 03 00 00       	call   80104860 <acquire>

  node_t *current;

  for (current = ptable.head; current != NULL; current = current->next)
801044b4:	a1 94 2d 11 80       	mov    0x80112d94,%eax
801044b9:	83 c4 10             	add    $0x10,%esp
801044bc:	85 c0                	test   %eax,%eax
801044be:	74 1e                	je     801044de <kill+0x3e>
  {
    p = current->proc;
801044c0:	8b 10                	mov    (%eax),%edx

    if (p->pid == pid)
801044c2:	3b 5a 10             	cmp    0x10(%edx),%ebx
801044c5:	75 10                	jne    801044d7 <kill+0x37>
801044c7:	eb 37                	jmp    80104500 <kill+0x60>
801044c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p = current->proc;
801044d0:	8b 10                	mov    (%eax),%edx
    if (p->pid == pid)
801044d2:	39 5a 10             	cmp    %ebx,0x10(%edx)
801044d5:	74 29                	je     80104500 <kill+0x60>
  for (current = ptable.head; current != NULL; current = current->next)
801044d7:	8b 40 04             	mov    0x4(%eax),%eax
801044da:	85 c0                	test   %eax,%eax
801044dc:	75 f2                	jne    801044d0 <kill+0x30>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801044de:	83 ec 0c             	sub    $0xc,%esp
801044e1:	68 60 2d 11 80       	push   $0x80112d60
801044e6:	e8 35 04 00 00       	call   80104920 <release>
  return -1;
801044eb:	83 c4 10             	add    $0x10,%esp
801044ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f6:	c9                   	leave  
801044f7:	c3                   	ret    
801044f8:	90                   	nop
801044f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (p->state == SLEEPING)
80104500:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
      p->killed = 1;
80104504:	c7 42 24 01 00 00 00 	movl   $0x1,0x24(%edx)
      if (p->state == SLEEPING)
8010450b:	75 07                	jne    80104514 <kill+0x74>
        p->state = RUNNABLE;
8010450d:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
      release(&ptable.lock);
80104514:	83 ec 0c             	sub    $0xc,%esp
80104517:	68 60 2d 11 80       	push   $0x80112d60
8010451c:	e8 ff 03 00 00       	call   80104920 <release>
      return 0;
80104521:	83 c4 10             	add    $0x10,%esp
80104524:	31 c0                	xor    %eax,%eax
}
80104526:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104529:	c9                   	leave  
8010452a:	c3                   	ret    
8010452b:	90                   	nop
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	57                   	push   %edi
80104534:	56                   	push   %esi
80104535:	53                   	push   %ebx
80104536:	83 ec 3c             	sub    $0x3c,%esp
  char *state;
  uint pc[10];

  node_t *current;

  for (current = ptable.head; current != NULL; current = current->next)
80104539:	8b 1d 94 2d 11 80    	mov    0x80112d94,%ebx
8010453f:	85 db                	test   %ebx,%ebx
80104541:	74 63                	je     801045a6 <procdump+0x76>
80104543:	8d 7d e8             	lea    -0x18(%ebp),%edi
80104546:	8d 76 00             	lea    0x0(%esi),%esi
80104549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  {
    p = current->proc;
80104550:	8b 33                	mov    (%ebx),%esi
    if (p->state == UNUSED)
80104552:	8b 46 0c             	mov    0xc(%esi),%eax
80104555:	85 c0                	test   %eax,%eax
80104557:	74 46                	je     8010459f <procdump+0x6f>
      continue;

    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104559:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
8010455c:	ba 20 7a 10 80       	mov    $0x80107a20,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104561:	77 11                	ja     80104574 <procdump+0x44>
80104563:	8b 14 85 80 7a 10 80 	mov    -0x7fef8580(,%eax,4),%edx
      state = "???";
8010456a:	b8 20 7a 10 80       	mov    $0x80107a20,%eax
8010456f:	85 d2                	test   %edx,%edx
80104571:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104574:	8d 46 6c             	lea    0x6c(%esi),%eax
80104577:	50                   	push   %eax
80104578:	52                   	push   %edx
80104579:	ff 76 10             	pushl  0x10(%esi)
8010457c:	68 24 7a 10 80       	push   $0x80107a24
80104581:	e8 da c0 ff ff       	call   80100660 <cprintf>
    if (p->state == SLEEPING)
80104586:	83 c4 10             	add    $0x10,%esp
80104589:	83 7e 0c 02          	cmpl   $0x2,0xc(%esi)
8010458d:	74 21                	je     801045b0 <procdump+0x80>
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
8010458f:	83 ec 0c             	sub    $0xc,%esp
80104592:	68 9b 7d 10 80       	push   $0x80107d9b
80104597:	e8 c4 c0 ff ff       	call   80100660 <cprintf>
8010459c:	83 c4 10             	add    $0x10,%esp
  for (current = ptable.head; current != NULL; current = current->next)
8010459f:	8b 5b 04             	mov    0x4(%ebx),%ebx
801045a2:	85 db                	test   %ebx,%ebx
801045a4:	75 aa                	jne    80104550 <procdump+0x20>
  }
}
801045a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045a9:	5b                   	pop    %ebx
801045aa:	5e                   	pop    %esi
801045ab:	5f                   	pop    %edi
801045ac:	5d                   	pop    %ebp
801045ad:	c3                   	ret    
801045ae:	66 90                	xchg   %ax,%ax
      getcallerpcs((uint *)p->context->ebp + 2, pc);
801045b0:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045b3:	83 ec 08             	sub    $0x8,%esp
801045b6:	50                   	push   %eax
801045b7:	8b 46 1c             	mov    0x1c(%esi),%eax
801045ba:	8d 75 c0             	lea    -0x40(%ebp),%esi
801045bd:	8b 40 0c             	mov    0xc(%eax),%eax
801045c0:	83 c0 08             	add    $0x8,%eax
801045c3:	50                   	push   %eax
801045c4:	e8 77 01 00 00       	call   80104740 <getcallerpcs>
801045c9:	83 c4 10             	add    $0x10,%esp
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for (i = 0; i < 10 && pc[i] != 0; i++)
801045d0:	8b 06                	mov    (%esi),%eax
801045d2:	85 c0                	test   %eax,%eax
801045d4:	74 b9                	je     8010458f <procdump+0x5f>
        cprintf(" %p", pc[i]);
801045d6:	83 ec 08             	sub    $0x8,%esp
801045d9:	83 c6 04             	add    $0x4,%esi
801045dc:	50                   	push   %eax
801045dd:	68 61 74 10 80       	push   $0x80107461
801045e2:	e8 79 c0 ff ff       	call   80100660 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
801045e7:	83 c4 10             	add    $0x10,%esp
801045ea:	39 fe                	cmp    %edi,%esi
801045ec:	75 e2                	jne    801045d0 <procdump+0xa0>
801045ee:	eb 9f                	jmp    8010458f <procdump+0x5f>

801045f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 0c             	sub    $0xc,%esp
801045f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045fa:	68 98 7a 10 80       	push   $0x80107a98
801045ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104602:	50                   	push   %eax
80104603:	e8 18 01 00 00       	call   80104720 <initlock>
  lk->name = name;
80104608:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010460b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104611:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104614:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010461b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010461e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104621:	c9                   	leave  
80104622:	c3                   	ret    
80104623:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	8d 73 04             	lea    0x4(%ebx),%esi
8010463e:	56                   	push   %esi
8010463f:	e8 1c 02 00 00       	call   80104860 <acquire>
  while (lk->locked) {
80104644:	8b 13                	mov    (%ebx),%edx
80104646:	83 c4 10             	add    $0x10,%esp
80104649:	85 d2                	test   %edx,%edx
8010464b:	74 16                	je     80104663 <acquiresleep+0x33>
8010464d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104650:	83 ec 08             	sub    $0x8,%esp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	e8 f6 fb ff ff       	call   80104250 <sleep>
  while (lk->locked) {
8010465a:	8b 03                	mov    (%ebx),%eax
8010465c:	83 c4 10             	add    $0x10,%esp
8010465f:	85 c0                	test   %eax,%eax
80104661:	75 ed                	jne    80104650 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104663:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104669:	e8 c2 f5 ff ff       	call   80103c30 <myproc>
8010466e:	8b 40 10             	mov    0x10(%eax),%eax
80104671:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104674:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104677:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010467a:	5b                   	pop    %ebx
8010467b:	5e                   	pop    %esi
8010467c:	5d                   	pop    %ebp
  release(&lk->lk);
8010467d:	e9 9e 02 00 00       	jmp    80104920 <release>
80104682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104690 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104698:	83 ec 0c             	sub    $0xc,%esp
8010469b:	8d 73 04             	lea    0x4(%ebx),%esi
8010469e:	56                   	push   %esi
8010469f:	e8 bc 01 00 00       	call   80104860 <acquire>
  lk->locked = 0;
801046a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046b1:	89 1c 24             	mov    %ebx,(%esp)
801046b4:	e8 67 fd ff ff       	call   80104420 <wakeup>
  release(&lk->lk);
801046b9:	89 75 08             	mov    %esi,0x8(%ebp)
801046bc:	83 c4 10             	add    $0x10,%esp
}
801046bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c2:	5b                   	pop    %ebx
801046c3:	5e                   	pop    %esi
801046c4:	5d                   	pop    %ebp
  release(&lk->lk);
801046c5:	e9 56 02 00 00       	jmp    80104920 <release>
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	56                   	push   %esi
801046d5:	53                   	push   %ebx
801046d6:	31 ff                	xor    %edi,%edi
801046d8:	83 ec 18             	sub    $0x18,%esp
801046db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801046de:	8d 73 04             	lea    0x4(%ebx),%esi
801046e1:	56                   	push   %esi
801046e2:	e8 79 01 00 00       	call   80104860 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801046e7:	8b 03                	mov    (%ebx),%eax
801046e9:	83 c4 10             	add    $0x10,%esp
801046ec:	85 c0                	test   %eax,%eax
801046ee:	74 13                	je     80104703 <holdingsleep+0x33>
801046f0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801046f3:	e8 38 f5 ff ff       	call   80103c30 <myproc>
801046f8:	39 58 10             	cmp    %ebx,0x10(%eax)
801046fb:	0f 94 c0             	sete   %al
801046fe:	0f b6 c0             	movzbl %al,%eax
80104701:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104703:	83 ec 0c             	sub    $0xc,%esp
80104706:	56                   	push   %esi
80104707:	e8 14 02 00 00       	call   80104920 <release>
  return r;
}
8010470c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010470f:	89 f8                	mov    %edi,%eax
80104711:	5b                   	pop    %ebx
80104712:	5e                   	pop    %esi
80104713:	5f                   	pop    %edi
80104714:	5d                   	pop    %ebp
80104715:	c3                   	ret    
80104716:	66 90                	xchg   %ax,%ax
80104718:	66 90                	xchg   %ax,%ax
8010471a:	66 90                	xchg   %ax,%ax
8010471c:	66 90                	xchg   %ax,%ax
8010471e:	66 90                	xchg   %ax,%ax

80104720 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104726:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104729:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010472f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104732:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    
8010473b:	90                   	nop
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104740 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104740:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104741:	31 d2                	xor    %edx,%edx
{
80104743:	89 e5                	mov    %esp,%ebp
80104745:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104746:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104749:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010474c:	83 e8 08             	sub    $0x8,%eax
8010474f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104750:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104756:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010475c:	77 1a                	ja     80104778 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010475e:	8b 58 04             	mov    0x4(%eax),%ebx
80104761:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104764:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104767:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104769:	83 fa 0a             	cmp    $0xa,%edx
8010476c:	75 e2                	jne    80104750 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010476e:	5b                   	pop    %ebx
8010476f:	5d                   	pop    %ebp
80104770:	c3                   	ret    
80104771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104778:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010477b:	83 c1 28             	add    $0x28,%ecx
8010477e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104780:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104786:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104789:	39 c1                	cmp    %eax,%ecx
8010478b:	75 f3                	jne    80104780 <getcallerpcs+0x40>
}
8010478d:	5b                   	pop    %ebx
8010478e:	5d                   	pop    %ebp
8010478f:	c3                   	ret    

80104790 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
80104794:	83 ec 04             	sub    $0x4,%esp
80104797:	9c                   	pushf  
80104798:	5b                   	pop    %ebx
  asm volatile("cli");
80104799:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010479a:	e8 f1 f3 ff ff       	call   80103b90 <mycpu>
8010479f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047a5:	85 c0                	test   %eax,%eax
801047a7:	75 11                	jne    801047ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801047a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047af:	e8 dc f3 ff ff       	call   80103b90 <mycpu>
801047b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801047ba:	e8 d1 f3 ff ff       	call   80103b90 <mycpu>
801047bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047c6:	83 c4 04             	add    $0x4,%esp
801047c9:	5b                   	pop    %ebx
801047ca:	5d                   	pop    %ebp
801047cb:	c3                   	ret    
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <popcli>:

void
popcli(void)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047d6:	9c                   	pushf  
801047d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047d8:	f6 c4 02             	test   $0x2,%ah
801047db:	75 35                	jne    80104812 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047dd:	e8 ae f3 ff ff       	call   80103b90 <mycpu>
801047e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801047e9:	78 34                	js     8010481f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047eb:	e8 a0 f3 ff ff       	call   80103b90 <mycpu>
801047f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801047f6:	85 d2                	test   %edx,%edx
801047f8:	74 06                	je     80104800 <popcli+0x30>
    sti();
}
801047fa:	c9                   	leave  
801047fb:	c3                   	ret    
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104800:	e8 8b f3 ff ff       	call   80103b90 <mycpu>
80104805:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010480b:	85 c0                	test   %eax,%eax
8010480d:	74 eb                	je     801047fa <popcli+0x2a>
  asm volatile("sti");
8010480f:	fb                   	sti    
}
80104810:	c9                   	leave  
80104811:	c3                   	ret    
    panic("popcli - interruptible");
80104812:	83 ec 0c             	sub    $0xc,%esp
80104815:	68 a3 7a 10 80       	push   $0x80107aa3
8010481a:	e8 71 bb ff ff       	call   80100390 <panic>
    panic("popcli");
8010481f:	83 ec 0c             	sub    $0xc,%esp
80104822:	68 ba 7a 10 80       	push   $0x80107aba
80104827:	e8 64 bb ff ff       	call   80100390 <panic>
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104830 <holding>:
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	8b 75 08             	mov    0x8(%ebp),%esi
80104838:	31 db                	xor    %ebx,%ebx
  pushcli();
8010483a:	e8 51 ff ff ff       	call   80104790 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010483f:	8b 06                	mov    (%esi),%eax
80104841:	85 c0                	test   %eax,%eax
80104843:	74 10                	je     80104855 <holding+0x25>
80104845:	8b 5e 08             	mov    0x8(%esi),%ebx
80104848:	e8 43 f3 ff ff       	call   80103b90 <mycpu>
8010484d:	39 c3                	cmp    %eax,%ebx
8010484f:	0f 94 c3             	sete   %bl
80104852:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104855:	e8 76 ff ff ff       	call   801047d0 <popcli>
}
8010485a:	89 d8                	mov    %ebx,%eax
8010485c:	5b                   	pop    %ebx
8010485d:	5e                   	pop    %esi
8010485e:	5d                   	pop    %ebp
8010485f:	c3                   	ret    

80104860 <acquire>:
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104865:	e8 26 ff ff ff       	call   80104790 <pushcli>
  if(holding(lk))
8010486a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010486d:	83 ec 0c             	sub    $0xc,%esp
80104870:	53                   	push   %ebx
80104871:	e8 ba ff ff ff       	call   80104830 <holding>
80104876:	83 c4 10             	add    $0x10,%esp
80104879:	85 c0                	test   %eax,%eax
8010487b:	0f 85 83 00 00 00    	jne    80104904 <acquire+0xa4>
80104881:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104883:	ba 01 00 00 00       	mov    $0x1,%edx
80104888:	eb 09                	jmp    80104893 <acquire+0x33>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104890:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104893:	89 d0                	mov    %edx,%eax
80104895:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104898:	85 c0                	test   %eax,%eax
8010489a:	75 f4                	jne    80104890 <acquire+0x30>
  __sync_synchronize();
8010489c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048a4:	e8 e7 f2 ff ff       	call   80103b90 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048a9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801048ac:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801048af:	89 e8                	mov    %ebp,%eax
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048b8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801048be:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801048c4:	77 1a                	ja     801048e0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801048c6:	8b 48 04             	mov    0x4(%eax),%ecx
801048c9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801048cc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801048cf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801048d1:	83 fe 0a             	cmp    $0xa,%esi
801048d4:	75 e2                	jne    801048b8 <acquire+0x58>
}
801048d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048d9:	5b                   	pop    %ebx
801048da:	5e                   	pop    %esi
801048db:	5d                   	pop    %ebp
801048dc:	c3                   	ret    
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
801048e0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801048e3:	83 c2 28             	add    $0x28,%edx
801048e6:	8d 76 00             	lea    0x0(%esi),%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801048f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801048f6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801048f9:	39 d0                	cmp    %edx,%eax
801048fb:	75 f3                	jne    801048f0 <acquire+0x90>
}
801048fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104900:	5b                   	pop    %ebx
80104901:	5e                   	pop    %esi
80104902:	5d                   	pop    %ebp
80104903:	c3                   	ret    
    panic("acquire");
80104904:	83 ec 0c             	sub    $0xc,%esp
80104907:	68 c1 7a 10 80       	push   $0x80107ac1
8010490c:	e8 7f ba ff ff       	call   80100390 <panic>
80104911:	eb 0d                	jmp    80104920 <release>
80104913:	90                   	nop
80104914:	90                   	nop
80104915:	90                   	nop
80104916:	90                   	nop
80104917:	90                   	nop
80104918:	90                   	nop
80104919:	90                   	nop
8010491a:	90                   	nop
8010491b:	90                   	nop
8010491c:	90                   	nop
8010491d:	90                   	nop
8010491e:	90                   	nop
8010491f:	90                   	nop

80104920 <release>:
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 10             	sub    $0x10,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010492a:	53                   	push   %ebx
8010492b:	e8 00 ff ff ff       	call   80104830 <holding>
80104930:	83 c4 10             	add    $0x10,%esp
80104933:	85 c0                	test   %eax,%eax
80104935:	74 22                	je     80104959 <release+0x39>
  lk->pcs[0] = 0;
80104937:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010493e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104945:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010494a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104950:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104953:	c9                   	leave  
  popcli();
80104954:	e9 77 fe ff ff       	jmp    801047d0 <popcli>
    panic("release");
80104959:	83 ec 0c             	sub    $0xc,%esp
8010495c:	68 c9 7a 10 80       	push   $0x80107ac9
80104961:	e8 2a ba ff ff       	call   80100390 <panic>
80104966:	66 90                	xchg   %ax,%ax
80104968:	66 90                	xchg   %ax,%ax
8010496a:	66 90                	xchg   %ax,%ax
8010496c:	66 90                	xchg   %ax,%ax
8010496e:	66 90                	xchg   %ax,%ax

80104970 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	53                   	push   %ebx
80104975:	8b 55 08             	mov    0x8(%ebp),%edx
80104978:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010497b:	f6 c2 03             	test   $0x3,%dl
8010497e:	75 05                	jne    80104985 <memset+0x15>
80104980:	f6 c1 03             	test   $0x3,%cl
80104983:	74 13                	je     80104998 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104985:	89 d7                	mov    %edx,%edi
80104987:	8b 45 0c             	mov    0xc(%ebp),%eax
8010498a:	fc                   	cld    
8010498b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010498d:	5b                   	pop    %ebx
8010498e:	89 d0                	mov    %edx,%eax
80104990:	5f                   	pop    %edi
80104991:	5d                   	pop    %ebp
80104992:	c3                   	ret    
80104993:	90                   	nop
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104998:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010499c:	c1 e9 02             	shr    $0x2,%ecx
8010499f:	89 f8                	mov    %edi,%eax
801049a1:	89 fb                	mov    %edi,%ebx
801049a3:	c1 e0 18             	shl    $0x18,%eax
801049a6:	c1 e3 10             	shl    $0x10,%ebx
801049a9:	09 d8                	or     %ebx,%eax
801049ab:	09 f8                	or     %edi,%eax
801049ad:	c1 e7 08             	shl    $0x8,%edi
801049b0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801049b2:	89 d7                	mov    %edx,%edi
801049b4:	fc                   	cld    
801049b5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801049b7:	5b                   	pop    %ebx
801049b8:	89 d0                	mov    %edx,%eax
801049ba:	5f                   	pop    %edi
801049bb:	5d                   	pop    %ebp
801049bc:	c3                   	ret    
801049bd:	8d 76 00             	lea    0x0(%esi),%esi

801049c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	56                   	push   %esi
801049c5:	53                   	push   %ebx
801049c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801049c9:	8b 75 08             	mov    0x8(%ebp),%esi
801049cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049cf:	85 db                	test   %ebx,%ebx
801049d1:	74 29                	je     801049fc <memcmp+0x3c>
    if(*s1 != *s2)
801049d3:	0f b6 16             	movzbl (%esi),%edx
801049d6:	0f b6 0f             	movzbl (%edi),%ecx
801049d9:	38 d1                	cmp    %dl,%cl
801049db:	75 2b                	jne    80104a08 <memcmp+0x48>
801049dd:	b8 01 00 00 00       	mov    $0x1,%eax
801049e2:	eb 14                	jmp    801049f8 <memcmp+0x38>
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801049ec:	83 c0 01             	add    $0x1,%eax
801049ef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801049f4:	38 ca                	cmp    %cl,%dl
801049f6:	75 10                	jne    80104a08 <memcmp+0x48>
  while(n-- > 0){
801049f8:	39 d8                	cmp    %ebx,%eax
801049fa:	75 ec                	jne    801049e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801049fc:	5b                   	pop    %ebx
  return 0;
801049fd:	31 c0                	xor    %eax,%eax
}
801049ff:	5e                   	pop    %esi
80104a00:	5f                   	pop    %edi
80104a01:	5d                   	pop    %ebp
80104a02:	c3                   	ret    
80104a03:	90                   	nop
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104a08:	0f b6 c2             	movzbl %dl,%eax
}
80104a0b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104a0c:	29 c8                	sub    %ecx,%eax
}
80104a0e:	5e                   	pop    %esi
80104a0f:	5f                   	pop    %edi
80104a10:	5d                   	pop    %ebp
80104a11:	c3                   	ret    
80104a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 45 08             	mov    0x8(%ebp),%eax
80104a28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a2b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a2e:	39 c3                	cmp    %eax,%ebx
80104a30:	73 26                	jae    80104a58 <memmove+0x38>
80104a32:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104a35:	39 c8                	cmp    %ecx,%eax
80104a37:	73 1f                	jae    80104a58 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104a39:	85 f6                	test   %esi,%esi
80104a3b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104a3e:	74 0f                	je     80104a4f <memmove+0x2f>
      *--d = *--s;
80104a40:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104a47:	83 ea 01             	sub    $0x1,%edx
80104a4a:	83 fa ff             	cmp    $0xffffffff,%edx
80104a4d:	75 f1                	jne    80104a40 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a4f:	5b                   	pop    %ebx
80104a50:	5e                   	pop    %esi
80104a51:	5d                   	pop    %ebp
80104a52:	c3                   	ret    
80104a53:	90                   	nop
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104a58:	31 d2                	xor    %edx,%edx
80104a5a:	85 f6                	test   %esi,%esi
80104a5c:	74 f1                	je     80104a4f <memmove+0x2f>
80104a5e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104a60:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a67:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104a6a:	39 d6                	cmp    %edx,%esi
80104a6c:	75 f2                	jne    80104a60 <memmove+0x40>
}
80104a6e:	5b                   	pop    %ebx
80104a6f:	5e                   	pop    %esi
80104a70:	5d                   	pop    %ebp
80104a71:	c3                   	ret    
80104a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104a83:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104a84:	eb 9a                	jmp    80104a20 <memmove>
80104a86:	8d 76 00             	lea    0x0(%esi),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	56                   	push   %esi
80104a95:	8b 7d 10             	mov    0x10(%ebp),%edi
80104a98:	53                   	push   %ebx
80104a99:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104a9f:	85 ff                	test   %edi,%edi
80104aa1:	74 2f                	je     80104ad2 <strncmp+0x42>
80104aa3:	0f b6 01             	movzbl (%ecx),%eax
80104aa6:	0f b6 1e             	movzbl (%esi),%ebx
80104aa9:	84 c0                	test   %al,%al
80104aab:	74 37                	je     80104ae4 <strncmp+0x54>
80104aad:	38 c3                	cmp    %al,%bl
80104aaf:	75 33                	jne    80104ae4 <strncmp+0x54>
80104ab1:	01 f7                	add    %esi,%edi
80104ab3:	eb 13                	jmp    80104ac8 <strncmp+0x38>
80104ab5:	8d 76 00             	lea    0x0(%esi),%esi
80104ab8:	0f b6 01             	movzbl (%ecx),%eax
80104abb:	84 c0                	test   %al,%al
80104abd:	74 21                	je     80104ae0 <strncmp+0x50>
80104abf:	0f b6 1a             	movzbl (%edx),%ebx
80104ac2:	89 d6                	mov    %edx,%esi
80104ac4:	38 d8                	cmp    %bl,%al
80104ac6:	75 1c                	jne    80104ae4 <strncmp+0x54>
    n--, p++, q++;
80104ac8:	8d 56 01             	lea    0x1(%esi),%edx
80104acb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104ace:	39 fa                	cmp    %edi,%edx
80104ad0:	75 e6                	jne    80104ab8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104ad2:	5b                   	pop    %ebx
    return 0;
80104ad3:	31 c0                	xor    %eax,%eax
}
80104ad5:	5e                   	pop    %esi
80104ad6:	5f                   	pop    %edi
80104ad7:	5d                   	pop    %ebp
80104ad8:	c3                   	ret    
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104ae4:	29 d8                	sub    %ebx,%eax
}
80104ae6:	5b                   	pop    %ebx
80104ae7:	5e                   	pop    %esi
80104ae8:	5f                   	pop    %edi
80104ae9:	5d                   	pop    %ebp
80104aea:	c3                   	ret    
80104aeb:	90                   	nop
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104af0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	8b 45 08             	mov    0x8(%ebp),%eax
80104af8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104afb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104afe:	89 c2                	mov    %eax,%edx
80104b00:	eb 19                	jmp    80104b1b <strncpy+0x2b>
80104b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b08:	83 c3 01             	add    $0x1,%ebx
80104b0b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104b0f:	83 c2 01             	add    $0x1,%edx
80104b12:	84 c9                	test   %cl,%cl
80104b14:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b17:	74 09                	je     80104b22 <strncpy+0x32>
80104b19:	89 f1                	mov    %esi,%ecx
80104b1b:	85 c9                	test   %ecx,%ecx
80104b1d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104b20:	7f e6                	jg     80104b08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104b22:	31 c9                	xor    %ecx,%ecx
80104b24:	85 f6                	test   %esi,%esi
80104b26:	7e 17                	jle    80104b3f <strncpy+0x4f>
80104b28:	90                   	nop
80104b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b30:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104b34:	89 f3                	mov    %esi,%ebx
80104b36:	83 c1 01             	add    $0x1,%ecx
80104b39:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104b3b:	85 db                	test   %ebx,%ebx
80104b3d:	7f f1                	jg     80104b30 <strncpy+0x40>
  return os;
}
80104b3f:	5b                   	pop    %ebx
80104b40:	5e                   	pop    %esi
80104b41:	5d                   	pop    %ebp
80104b42:	c3                   	ret    
80104b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
80104b55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b58:	8b 45 08             	mov    0x8(%ebp),%eax
80104b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104b5e:	85 c9                	test   %ecx,%ecx
80104b60:	7e 26                	jle    80104b88 <safestrcpy+0x38>
80104b62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b66:	89 c1                	mov    %eax,%ecx
80104b68:	eb 17                	jmp    80104b81 <safestrcpy+0x31>
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b70:	83 c2 01             	add    $0x1,%edx
80104b73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b77:	83 c1 01             	add    $0x1,%ecx
80104b7a:	84 db                	test   %bl,%bl
80104b7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b7f:	74 04                	je     80104b85 <safestrcpy+0x35>
80104b81:	39 f2                	cmp    %esi,%edx
80104b83:	75 eb                	jne    80104b70 <safestrcpy+0x20>
    ;
  *s = 0;
80104b85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b88:	5b                   	pop    %ebx
80104b89:	5e                   	pop    %esi
80104b8a:	5d                   	pop    %ebp
80104b8b:	c3                   	ret    
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b90 <strlen>:

int
strlen(const char *s)
{
80104b90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b91:	31 c0                	xor    %eax,%eax
{
80104b93:	89 e5                	mov    %esp,%ebp
80104b95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b98:	80 3a 00             	cmpb   $0x0,(%edx)
80104b9b:	74 0c                	je     80104ba9 <strlen+0x19>
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ba0:	83 c0 01             	add    $0x1,%eax
80104ba3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ba7:	75 f7                	jne    80104ba0 <strlen+0x10>
    ;
  return n;
}
80104ba9:	5d                   	pop    %ebp
80104baa:	c3                   	ret    

80104bab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104bab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104baf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104bb3:	55                   	push   %ebp
  pushl %ebx
80104bb4:	53                   	push   %ebx
  pushl %esi
80104bb5:	56                   	push   %esi
  pushl %edi
80104bb6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104bb7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104bb9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104bbb:	5f                   	pop    %edi
  popl %esi
80104bbc:	5e                   	pop    %esi
  popl %ebx
80104bbd:	5b                   	pop    %ebx
  popl %ebp
80104bbe:	5d                   	pop    %ebp
  ret
80104bbf:	c3                   	ret    

80104bc0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 04             	sub    $0x4,%esp
80104bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bca:	e8 61 f0 ff ff       	call   80103c30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bcf:	8b 00                	mov    (%eax),%eax
80104bd1:	39 d8                	cmp    %ebx,%eax
80104bd3:	76 1b                	jbe    80104bf0 <fetchint+0x30>
80104bd5:	8d 53 04             	lea    0x4(%ebx),%edx
80104bd8:	39 d0                	cmp    %edx,%eax
80104bda:	72 14                	jb     80104bf0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bdf:	8b 13                	mov    (%ebx),%edx
80104be1:	89 10                	mov    %edx,(%eax)
  return 0;
80104be3:	31 c0                	xor    %eax,%eax
}
80104be5:	83 c4 04             	add    $0x4,%esp
80104be8:	5b                   	pop    %ebx
80104be9:	5d                   	pop    %ebp
80104bea:	c3                   	ret    
80104beb:	90                   	nop
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bf5:	eb ee                	jmp    80104be5 <fetchint+0x25>
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	83 ec 04             	sub    $0x4,%esp
80104c07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c0a:	e8 21 f0 ff ff       	call   80103c30 <myproc>

  if(addr >= curproc->sz)
80104c0f:	39 18                	cmp    %ebx,(%eax)
80104c11:	76 29                	jbe    80104c3c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104c13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104c16:	89 da                	mov    %ebx,%edx
80104c18:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104c1a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104c1c:	39 c3                	cmp    %eax,%ebx
80104c1e:	73 1c                	jae    80104c3c <fetchstr+0x3c>
    if(*s == 0)
80104c20:	80 3b 00             	cmpb   $0x0,(%ebx)
80104c23:	75 10                	jne    80104c35 <fetchstr+0x35>
80104c25:	eb 39                	jmp    80104c60 <fetchstr+0x60>
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c30:	80 3a 00             	cmpb   $0x0,(%edx)
80104c33:	74 1b                	je     80104c50 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104c35:	83 c2 01             	add    $0x1,%edx
80104c38:	39 d0                	cmp    %edx,%eax
80104c3a:	77 f4                	ja     80104c30 <fetchstr+0x30>
    return -1;
80104c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104c41:	83 c4 04             	add    $0x4,%esp
80104c44:	5b                   	pop    %ebx
80104c45:	5d                   	pop    %ebp
80104c46:	c3                   	ret    
80104c47:	89 f6                	mov    %esi,%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c50:	83 c4 04             	add    $0x4,%esp
80104c53:	89 d0                	mov    %edx,%eax
80104c55:	29 d8                	sub    %ebx,%eax
80104c57:	5b                   	pop    %ebx
80104c58:	5d                   	pop    %ebp
80104c59:	c3                   	ret    
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104c60:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c62:	eb dd                	jmp    80104c41 <fetchstr+0x41>
80104c64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c75:	e8 b6 ef ff ff       	call   80103c30 <myproc>
80104c7a:	8b 40 18             	mov    0x18(%eax),%eax
80104c7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c80:	8b 40 44             	mov    0x44(%eax),%eax
80104c83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c86:	e8 a5 ef ff ff       	call   80103c30 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c8b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c8d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c90:	39 c6                	cmp    %eax,%esi
80104c92:	73 1c                	jae    80104cb0 <argint+0x40>
80104c94:	8d 53 08             	lea    0x8(%ebx),%edx
80104c97:	39 d0                	cmp    %edx,%eax
80104c99:	72 15                	jb     80104cb0 <argint+0x40>
  *ip = *(int*)(addr);
80104c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104ca1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ca3:	31 c0                	xor    %eax,%eax
}
80104ca5:	5b                   	pop    %ebx
80104ca6:	5e                   	pop    %esi
80104ca7:	5d                   	pop    %ebp
80104ca8:	c3                   	ret    
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cb5:	eb ee                	jmp    80104ca5 <argint+0x35>
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
80104cc5:	83 ec 10             	sub    $0x10,%esp
80104cc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104ccb:	e8 60 ef ff ff       	call   80103c30 <myproc>
80104cd0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104cd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cd5:	83 ec 08             	sub    $0x8,%esp
80104cd8:	50                   	push   %eax
80104cd9:	ff 75 08             	pushl  0x8(%ebp)
80104cdc:	e8 8f ff ff ff       	call   80104c70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ce1:	83 c4 10             	add    $0x10,%esp
80104ce4:	85 c0                	test   %eax,%eax
80104ce6:	78 28                	js     80104d10 <argptr+0x50>
80104ce8:	85 db                	test   %ebx,%ebx
80104cea:	78 24                	js     80104d10 <argptr+0x50>
80104cec:	8b 16                	mov    (%esi),%edx
80104cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf1:	39 c2                	cmp    %eax,%edx
80104cf3:	76 1b                	jbe    80104d10 <argptr+0x50>
80104cf5:	01 c3                	add    %eax,%ebx
80104cf7:	39 da                	cmp    %ebx,%edx
80104cf9:	72 15                	jb     80104d10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cfe:	89 02                	mov    %eax,(%edx)
  return 0;
80104d00:	31 c0                	xor    %eax,%eax
}
80104d02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d05:	5b                   	pop    %ebx
80104d06:	5e                   	pop    %esi
80104d07:	5d                   	pop    %ebp
80104d08:	c3                   	ret    
80104d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d15:	eb eb                	jmp    80104d02 <argptr+0x42>
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d29:	50                   	push   %eax
80104d2a:	ff 75 08             	pushl  0x8(%ebp)
80104d2d:	e8 3e ff ff ff       	call   80104c70 <argint>
80104d32:	83 c4 10             	add    $0x10,%esp
80104d35:	85 c0                	test   %eax,%eax
80104d37:	78 17                	js     80104d50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104d39:	83 ec 08             	sub    $0x8,%esp
80104d3c:	ff 75 0c             	pushl  0xc(%ebp)
80104d3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d42:	e8 b9 fe ff ff       	call   80104c00 <fetchstr>
80104d47:	83 c4 10             	add    $0x10,%esp
}
80104d4a:	c9                   	leave  
80104d4b:	c3                   	ret    
80104d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d55:	c9                   	leave  
80104d56:	c3                   	ret    
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d60 <syscall>:
[SYS_stride] sys_stride,
};

void
syscall(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d67:	e8 c4 ee ff ff       	call   80103c30 <myproc>
80104d6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d6e:	8b 40 18             	mov    0x18(%eax),%eax
80104d71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d77:	83 fa 15             	cmp    $0x15,%edx
80104d7a:	77 1c                	ja     80104d98 <syscall+0x38>
80104d7c:	8b 14 85 00 7b 10 80 	mov    -0x7fef8500(,%eax,4),%edx
80104d83:	85 d2                	test   %edx,%edx
80104d85:	74 11                	je     80104d98 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104d87:	ff d2                	call   *%edx
80104d89:	8b 53 18             	mov    0x18(%ebx),%edx
80104d8c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d92:	c9                   	leave  
80104d93:	c3                   	ret    
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d98:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d99:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d9c:	50                   	push   %eax
80104d9d:	ff 73 10             	pushl  0x10(%ebx)
80104da0:	68 d1 7a 10 80       	push   $0x80107ad1
80104da5:	e8 b6 b8 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104daa:	8b 43 18             	mov    0x18(%ebx),%eax
80104dad:	83 c4 10             	add    $0x10,%esp
80104db0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104db7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dba:	c9                   	leave  
80104dbb:	c3                   	ret    
80104dbc:	66 90                	xchg   %ax,%ax
80104dbe:	66 90                	xchg   %ax,%ax

80104dc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	57                   	push   %edi
80104dc4:	56                   	push   %esi
80104dc5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104dc6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104dc9:	83 ec 44             	sub    $0x44,%esp
80104dcc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104dd2:	56                   	push   %esi
80104dd3:	50                   	push   %eax
{
80104dd4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104dd7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104dda:	e8 31 d1 ff ff       	call   80101f10 <nameiparent>
80104ddf:	83 c4 10             	add    $0x10,%esp
80104de2:	85 c0                	test   %eax,%eax
80104de4:	0f 84 46 01 00 00    	je     80104f30 <create+0x170>
    return 0;
  ilock(dp);
80104dea:	83 ec 0c             	sub    $0xc,%esp
80104ded:	89 c3                	mov    %eax,%ebx
80104def:	50                   	push   %eax
80104df0:	e8 9b c8 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104df5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104df8:	83 c4 0c             	add    $0xc,%esp
80104dfb:	50                   	push   %eax
80104dfc:	56                   	push   %esi
80104dfd:	53                   	push   %ebx
80104dfe:	e8 bd cd ff ff       	call   80101bc0 <dirlookup>
80104e03:	83 c4 10             	add    $0x10,%esp
80104e06:	85 c0                	test   %eax,%eax
80104e08:	89 c7                	mov    %eax,%edi
80104e0a:	74 34                	je     80104e40 <create+0x80>
    iunlockput(dp);
80104e0c:	83 ec 0c             	sub    $0xc,%esp
80104e0f:	53                   	push   %ebx
80104e10:	e8 0b cb ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104e15:	89 3c 24             	mov    %edi,(%esp)
80104e18:	e8 73 c8 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e1d:	83 c4 10             	add    $0x10,%esp
80104e20:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104e25:	0f 85 95 00 00 00    	jne    80104ec0 <create+0x100>
80104e2b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104e30:	0f 85 8a 00 00 00    	jne    80104ec0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e39:	89 f8                	mov    %edi,%eax
80104e3b:	5b                   	pop    %ebx
80104e3c:	5e                   	pop    %esi
80104e3d:	5f                   	pop    %edi
80104e3e:	5d                   	pop    %ebp
80104e3f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104e40:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104e44:	83 ec 08             	sub    $0x8,%esp
80104e47:	50                   	push   %eax
80104e48:	ff 33                	pushl  (%ebx)
80104e4a:	e8 d1 c6 ff ff       	call   80101520 <ialloc>
80104e4f:	83 c4 10             	add    $0x10,%esp
80104e52:	85 c0                	test   %eax,%eax
80104e54:	89 c7                	mov    %eax,%edi
80104e56:	0f 84 e8 00 00 00    	je     80104f44 <create+0x184>
  ilock(ip);
80104e5c:	83 ec 0c             	sub    $0xc,%esp
80104e5f:	50                   	push   %eax
80104e60:	e8 2b c8 ff ff       	call   80101690 <ilock>
  ip->major = major;
80104e65:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104e69:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104e6d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104e71:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104e75:	b8 01 00 00 00       	mov    $0x1,%eax
80104e7a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104e7e:	89 3c 24             	mov    %edi,(%esp)
80104e81:	e8 5a c7 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e86:	83 c4 10             	add    $0x10,%esp
80104e89:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104e8e:	74 50                	je     80104ee0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e90:	83 ec 04             	sub    $0x4,%esp
80104e93:	ff 77 04             	pushl  0x4(%edi)
80104e96:	56                   	push   %esi
80104e97:	53                   	push   %ebx
80104e98:	e8 93 cf ff ff       	call   80101e30 <dirlink>
80104e9d:	83 c4 10             	add    $0x10,%esp
80104ea0:	85 c0                	test   %eax,%eax
80104ea2:	0f 88 8f 00 00 00    	js     80104f37 <create+0x177>
  iunlockput(dp);
80104ea8:	83 ec 0c             	sub    $0xc,%esp
80104eab:	53                   	push   %ebx
80104eac:	e8 6f ca ff ff       	call   80101920 <iunlockput>
  return ip;
80104eb1:	83 c4 10             	add    $0x10,%esp
}
80104eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb7:	89 f8                	mov    %edi,%eax
80104eb9:	5b                   	pop    %ebx
80104eba:	5e                   	pop    %esi
80104ebb:	5f                   	pop    %edi
80104ebc:	5d                   	pop    %ebp
80104ebd:	c3                   	ret    
80104ebe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104ec0:	83 ec 0c             	sub    $0xc,%esp
80104ec3:	57                   	push   %edi
    return 0;
80104ec4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104ec6:	e8 55 ca ff ff       	call   80101920 <iunlockput>
    return 0;
80104ecb:	83 c4 10             	add    $0x10,%esp
}
80104ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ed1:	89 f8                	mov    %edi,%eax
80104ed3:	5b                   	pop    %ebx
80104ed4:	5e                   	pop    %esi
80104ed5:	5f                   	pop    %edi
80104ed6:	5d                   	pop    %ebp
80104ed7:	c3                   	ret    
80104ed8:	90                   	nop
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104ee0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ee5:	83 ec 0c             	sub    $0xc,%esp
80104ee8:	53                   	push   %ebx
80104ee9:	e8 f2 c6 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104eee:	83 c4 0c             	add    $0xc,%esp
80104ef1:	ff 77 04             	pushl  0x4(%edi)
80104ef4:	68 78 7b 10 80       	push   $0x80107b78
80104ef9:	57                   	push   %edi
80104efa:	e8 31 cf ff ff       	call   80101e30 <dirlink>
80104eff:	83 c4 10             	add    $0x10,%esp
80104f02:	85 c0                	test   %eax,%eax
80104f04:	78 1c                	js     80104f22 <create+0x162>
80104f06:	83 ec 04             	sub    $0x4,%esp
80104f09:	ff 73 04             	pushl  0x4(%ebx)
80104f0c:	68 77 7b 10 80       	push   $0x80107b77
80104f11:	57                   	push   %edi
80104f12:	e8 19 cf ff ff       	call   80101e30 <dirlink>
80104f17:	83 c4 10             	add    $0x10,%esp
80104f1a:	85 c0                	test   %eax,%eax
80104f1c:	0f 89 6e ff ff ff    	jns    80104e90 <create+0xd0>
      panic("create dots");
80104f22:	83 ec 0c             	sub    $0xc,%esp
80104f25:	68 6b 7b 10 80       	push   $0x80107b6b
80104f2a:	e8 61 b4 ff ff       	call   80100390 <panic>
80104f2f:	90                   	nop
    return 0;
80104f30:	31 ff                	xor    %edi,%edi
80104f32:	e9 ff fe ff ff       	jmp    80104e36 <create+0x76>
    panic("create: dirlink");
80104f37:	83 ec 0c             	sub    $0xc,%esp
80104f3a:	68 7a 7b 10 80       	push   $0x80107b7a
80104f3f:	e8 4c b4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104f44:	83 ec 0c             	sub    $0xc,%esp
80104f47:	68 5c 7b 10 80       	push   $0x80107b5c
80104f4c:	e8 3f b4 ff ff       	call   80100390 <panic>
80104f51:	eb 0d                	jmp    80104f60 <argfd.constprop.0>
80104f53:	90                   	nop
80104f54:	90                   	nop
80104f55:	90                   	nop
80104f56:	90                   	nop
80104f57:	90                   	nop
80104f58:	90                   	nop
80104f59:	90                   	nop
80104f5a:	90                   	nop
80104f5b:	90                   	nop
80104f5c:	90                   	nop
80104f5d:	90                   	nop
80104f5e:	90                   	nop
80104f5f:	90                   	nop

80104f60 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
80104f65:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104f67:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104f6a:	89 d6                	mov    %edx,%esi
80104f6c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f6f:	50                   	push   %eax
80104f70:	6a 00                	push   $0x0
80104f72:	e8 f9 fc ff ff       	call   80104c70 <argint>
80104f77:	83 c4 10             	add    $0x10,%esp
80104f7a:	85 c0                	test   %eax,%eax
80104f7c:	78 2a                	js     80104fa8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f7e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f82:	77 24                	ja     80104fa8 <argfd.constprop.0+0x48>
80104f84:	e8 a7 ec ff ff       	call   80103c30 <myproc>
80104f89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f8c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104f90:	85 c0                	test   %eax,%eax
80104f92:	74 14                	je     80104fa8 <argfd.constprop.0+0x48>
  if(pfd)
80104f94:	85 db                	test   %ebx,%ebx
80104f96:	74 02                	je     80104f9a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104f98:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104f9a:	89 06                	mov    %eax,(%esi)
  return 0;
80104f9c:	31 c0                	xor    %eax,%eax
}
80104f9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fa1:	5b                   	pop    %ebx
80104fa2:	5e                   	pop    %esi
80104fa3:	5d                   	pop    %ebp
80104fa4:	c3                   	ret    
80104fa5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fad:	eb ef                	jmp    80104f9e <argfd.constprop.0+0x3e>
80104faf:	90                   	nop

80104fb0 <sys_dup>:
{
80104fb0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104fb1:	31 c0                	xor    %eax,%eax
{
80104fb3:	89 e5                	mov    %esp,%ebp
80104fb5:	56                   	push   %esi
80104fb6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104fb7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104fba:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104fbd:	e8 9e ff ff ff       	call   80104f60 <argfd.constprop.0>
80104fc2:	85 c0                	test   %eax,%eax
80104fc4:	78 42                	js     80105008 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104fc6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104fc9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104fcb:	e8 60 ec ff ff       	call   80103c30 <myproc>
80104fd0:	eb 0e                	jmp    80104fe0 <sys_dup+0x30>
80104fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104fd8:	83 c3 01             	add    $0x1,%ebx
80104fdb:	83 fb 10             	cmp    $0x10,%ebx
80104fde:	74 28                	je     80105008 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104fe0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fe4:	85 d2                	test   %edx,%edx
80104fe6:	75 f0                	jne    80104fd8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104fe8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104fec:	83 ec 0c             	sub    $0xc,%esp
80104fef:	ff 75 f4             	pushl  -0xc(%ebp)
80104ff2:	e8 f9 bd ff ff       	call   80100df0 <filedup>
  return fd;
80104ff7:	83 c4 10             	add    $0x10,%esp
}
80104ffa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ffd:	89 d8                	mov    %ebx,%eax
80104fff:	5b                   	pop    %ebx
80105000:	5e                   	pop    %esi
80105001:	5d                   	pop    %ebp
80105002:	c3                   	ret    
80105003:	90                   	nop
80105004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105008:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010500b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105010:	89 d8                	mov    %ebx,%eax
80105012:	5b                   	pop    %ebx
80105013:	5e                   	pop    %esi
80105014:	5d                   	pop    %ebp
80105015:	c3                   	ret    
80105016:	8d 76 00             	lea    0x0(%esi),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <sys_read>:
{
80105020:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105021:	31 c0                	xor    %eax,%eax
{
80105023:	89 e5                	mov    %esp,%ebp
80105025:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105028:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010502b:	e8 30 ff ff ff       	call   80104f60 <argfd.constprop.0>
80105030:	85 c0                	test   %eax,%eax
80105032:	78 4c                	js     80105080 <sys_read+0x60>
80105034:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105037:	83 ec 08             	sub    $0x8,%esp
8010503a:	50                   	push   %eax
8010503b:	6a 02                	push   $0x2
8010503d:	e8 2e fc ff ff       	call   80104c70 <argint>
80105042:	83 c4 10             	add    $0x10,%esp
80105045:	85 c0                	test   %eax,%eax
80105047:	78 37                	js     80105080 <sys_read+0x60>
80105049:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010504c:	83 ec 04             	sub    $0x4,%esp
8010504f:	ff 75 f0             	pushl  -0x10(%ebp)
80105052:	50                   	push   %eax
80105053:	6a 01                	push   $0x1
80105055:	e8 66 fc ff ff       	call   80104cc0 <argptr>
8010505a:	83 c4 10             	add    $0x10,%esp
8010505d:	85 c0                	test   %eax,%eax
8010505f:	78 1f                	js     80105080 <sys_read+0x60>
  return fileread(f, p, n);
80105061:	83 ec 04             	sub    $0x4,%esp
80105064:	ff 75 f0             	pushl  -0x10(%ebp)
80105067:	ff 75 f4             	pushl  -0xc(%ebp)
8010506a:	ff 75 ec             	pushl  -0x14(%ebp)
8010506d:	e8 ee be ff ff       	call   80100f60 <fileread>
80105072:	83 c4 10             	add    $0x10,%esp
}
80105075:	c9                   	leave  
80105076:	c3                   	ret    
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105085:	c9                   	leave  
80105086:	c3                   	ret    
80105087:	89 f6                	mov    %esi,%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105090 <sys_write>:
{
80105090:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105091:	31 c0                	xor    %eax,%eax
{
80105093:	89 e5                	mov    %esp,%ebp
80105095:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105098:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010509b:	e8 c0 fe ff ff       	call   80104f60 <argfd.constprop.0>
801050a0:	85 c0                	test   %eax,%eax
801050a2:	78 4c                	js     801050f0 <sys_write+0x60>
801050a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050a7:	83 ec 08             	sub    $0x8,%esp
801050aa:	50                   	push   %eax
801050ab:	6a 02                	push   $0x2
801050ad:	e8 be fb ff ff       	call   80104c70 <argint>
801050b2:	83 c4 10             	add    $0x10,%esp
801050b5:	85 c0                	test   %eax,%eax
801050b7:	78 37                	js     801050f0 <sys_write+0x60>
801050b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050bc:	83 ec 04             	sub    $0x4,%esp
801050bf:	ff 75 f0             	pushl  -0x10(%ebp)
801050c2:	50                   	push   %eax
801050c3:	6a 01                	push   $0x1
801050c5:	e8 f6 fb ff ff       	call   80104cc0 <argptr>
801050ca:	83 c4 10             	add    $0x10,%esp
801050cd:	85 c0                	test   %eax,%eax
801050cf:	78 1f                	js     801050f0 <sys_write+0x60>
  return filewrite(f, p, n);
801050d1:	83 ec 04             	sub    $0x4,%esp
801050d4:	ff 75 f0             	pushl  -0x10(%ebp)
801050d7:	ff 75 f4             	pushl  -0xc(%ebp)
801050da:	ff 75 ec             	pushl  -0x14(%ebp)
801050dd:	e8 0e bf ff ff       	call   80100ff0 <filewrite>
801050e2:	83 c4 10             	add    $0x10,%esp
}
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    
801050e7:	89 f6                	mov    %esi,%esi
801050e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	89 f6                	mov    %esi,%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105100 <sys_close>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105106:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105109:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010510c:	e8 4f fe ff ff       	call   80104f60 <argfd.constprop.0>
80105111:	85 c0                	test   %eax,%eax
80105113:	78 2b                	js     80105140 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105115:	e8 16 eb ff ff       	call   80103c30 <myproc>
8010511a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010511d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105120:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105127:	00 
  fileclose(f);
80105128:	ff 75 f4             	pushl  -0xc(%ebp)
8010512b:	e8 10 bd ff ff       	call   80100e40 <fileclose>
  return 0;
80105130:	83 c4 10             	add    $0x10,%esp
80105133:	31 c0                	xor    %eax,%eax
}
80105135:	c9                   	leave  
80105136:	c3                   	ret    
80105137:	89 f6                	mov    %esi,%esi
80105139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105145:	c9                   	leave  
80105146:	c3                   	ret    
80105147:	89 f6                	mov    %esi,%esi
80105149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105150 <sys_fstat>:
{
80105150:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105151:	31 c0                	xor    %eax,%eax
{
80105153:	89 e5                	mov    %esp,%ebp
80105155:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105158:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010515b:	e8 00 fe ff ff       	call   80104f60 <argfd.constprop.0>
80105160:	85 c0                	test   %eax,%eax
80105162:	78 2c                	js     80105190 <sys_fstat+0x40>
80105164:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105167:	83 ec 04             	sub    $0x4,%esp
8010516a:	6a 14                	push   $0x14
8010516c:	50                   	push   %eax
8010516d:	6a 01                	push   $0x1
8010516f:	e8 4c fb ff ff       	call   80104cc0 <argptr>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	78 15                	js     80105190 <sys_fstat+0x40>
  return filestat(f, st);
8010517b:	83 ec 08             	sub    $0x8,%esp
8010517e:	ff 75 f4             	pushl  -0xc(%ebp)
80105181:	ff 75 f0             	pushl  -0x10(%ebp)
80105184:	e8 87 bd ff ff       	call   80100f10 <filestat>
80105189:	83 c4 10             	add    $0x10,%esp
}
8010518c:	c9                   	leave  
8010518d:	c3                   	ret    
8010518e:	66 90                	xchg   %ax,%ax
    return -1;
80105190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105195:	c9                   	leave  
80105196:	c3                   	ret    
80105197:	89 f6                	mov    %esi,%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051a0 <sys_link>:
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	57                   	push   %edi
801051a4:	56                   	push   %esi
801051a5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051ac:	50                   	push   %eax
801051ad:	6a 00                	push   $0x0
801051af:	e8 6c fb ff ff       	call   80104d20 <argstr>
801051b4:	83 c4 10             	add    $0x10,%esp
801051b7:	85 c0                	test   %eax,%eax
801051b9:	0f 88 fb 00 00 00    	js     801052ba <sys_link+0x11a>
801051bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051c2:	83 ec 08             	sub    $0x8,%esp
801051c5:	50                   	push   %eax
801051c6:	6a 01                	push   $0x1
801051c8:	e8 53 fb ff ff       	call   80104d20 <argstr>
801051cd:	83 c4 10             	add    $0x10,%esp
801051d0:	85 c0                	test   %eax,%eax
801051d2:	0f 88 e2 00 00 00    	js     801052ba <sys_link+0x11a>
  begin_op();
801051d8:	e8 63 db ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
801051dd:	83 ec 0c             	sub    $0xc,%esp
801051e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801051e3:	e8 08 cd ff ff       	call   80101ef0 <namei>
801051e8:	83 c4 10             	add    $0x10,%esp
801051eb:	85 c0                	test   %eax,%eax
801051ed:	89 c3                	mov    %eax,%ebx
801051ef:	0f 84 ea 00 00 00    	je     801052df <sys_link+0x13f>
  ilock(ip);
801051f5:	83 ec 0c             	sub    $0xc,%esp
801051f8:	50                   	push   %eax
801051f9:	e8 92 c4 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
801051fe:	83 c4 10             	add    $0x10,%esp
80105201:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105206:	0f 84 bb 00 00 00    	je     801052c7 <sys_link+0x127>
  ip->nlink++;
8010520c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105211:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105214:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105217:	53                   	push   %ebx
80105218:	e8 c3 c3 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
8010521d:	89 1c 24             	mov    %ebx,(%esp)
80105220:	e8 4b c5 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105225:	58                   	pop    %eax
80105226:	5a                   	pop    %edx
80105227:	57                   	push   %edi
80105228:	ff 75 d0             	pushl  -0x30(%ebp)
8010522b:	e8 e0 cc ff ff       	call   80101f10 <nameiparent>
80105230:	83 c4 10             	add    $0x10,%esp
80105233:	85 c0                	test   %eax,%eax
80105235:	89 c6                	mov    %eax,%esi
80105237:	74 5b                	je     80105294 <sys_link+0xf4>
  ilock(dp);
80105239:	83 ec 0c             	sub    $0xc,%esp
8010523c:	50                   	push   %eax
8010523d:	e8 4e c4 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105242:	83 c4 10             	add    $0x10,%esp
80105245:	8b 03                	mov    (%ebx),%eax
80105247:	39 06                	cmp    %eax,(%esi)
80105249:	75 3d                	jne    80105288 <sys_link+0xe8>
8010524b:	83 ec 04             	sub    $0x4,%esp
8010524e:	ff 73 04             	pushl  0x4(%ebx)
80105251:	57                   	push   %edi
80105252:	56                   	push   %esi
80105253:	e8 d8 cb ff ff       	call   80101e30 <dirlink>
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	85 c0                	test   %eax,%eax
8010525d:	78 29                	js     80105288 <sys_link+0xe8>
  iunlockput(dp);
8010525f:	83 ec 0c             	sub    $0xc,%esp
80105262:	56                   	push   %esi
80105263:	e8 b8 c6 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80105268:	89 1c 24             	mov    %ebx,(%esp)
8010526b:	e8 50 c5 ff ff       	call   801017c0 <iput>
  end_op();
80105270:	e8 3b db ff ff       	call   80102db0 <end_op>
  return 0;
80105275:	83 c4 10             	add    $0x10,%esp
80105278:	31 c0                	xor    %eax,%eax
}
8010527a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010527d:	5b                   	pop    %ebx
8010527e:	5e                   	pop    %esi
8010527f:	5f                   	pop    %edi
80105280:	5d                   	pop    %ebp
80105281:	c3                   	ret    
80105282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105288:	83 ec 0c             	sub    $0xc,%esp
8010528b:	56                   	push   %esi
8010528c:	e8 8f c6 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105291:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105294:	83 ec 0c             	sub    $0xc,%esp
80105297:	53                   	push   %ebx
80105298:	e8 f3 c3 ff ff       	call   80101690 <ilock>
  ip->nlink--;
8010529d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052a2:	89 1c 24             	mov    %ebx,(%esp)
801052a5:	e8 36 c3 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
801052aa:	89 1c 24             	mov    %ebx,(%esp)
801052ad:	e8 6e c6 ff ff       	call   80101920 <iunlockput>
  end_op();
801052b2:	e8 f9 da ff ff       	call   80102db0 <end_op>
  return -1;
801052b7:	83 c4 10             	add    $0x10,%esp
}
801052ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801052bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052c2:	5b                   	pop    %ebx
801052c3:	5e                   	pop    %esi
801052c4:	5f                   	pop    %edi
801052c5:	5d                   	pop    %ebp
801052c6:	c3                   	ret    
    iunlockput(ip);
801052c7:	83 ec 0c             	sub    $0xc,%esp
801052ca:	53                   	push   %ebx
801052cb:	e8 50 c6 ff ff       	call   80101920 <iunlockput>
    end_op();
801052d0:	e8 db da ff ff       	call   80102db0 <end_op>
    return -1;
801052d5:	83 c4 10             	add    $0x10,%esp
801052d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052dd:	eb 9b                	jmp    8010527a <sys_link+0xda>
    end_op();
801052df:	e8 cc da ff ff       	call   80102db0 <end_op>
    return -1;
801052e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052e9:	eb 8f                	jmp    8010527a <sys_link+0xda>
801052eb:	90                   	nop
801052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052f0 <sys_unlink>:
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	56                   	push   %esi
801052f5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801052f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052f9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801052fc:	50                   	push   %eax
801052fd:	6a 00                	push   $0x0
801052ff:	e8 1c fa ff ff       	call   80104d20 <argstr>
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	85 c0                	test   %eax,%eax
80105309:	0f 88 77 01 00 00    	js     80105486 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010530f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105312:	e8 29 da ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105317:	83 ec 08             	sub    $0x8,%esp
8010531a:	53                   	push   %ebx
8010531b:	ff 75 c0             	pushl  -0x40(%ebp)
8010531e:	e8 ed cb ff ff       	call   80101f10 <nameiparent>
80105323:	83 c4 10             	add    $0x10,%esp
80105326:	85 c0                	test   %eax,%eax
80105328:	89 c6                	mov    %eax,%esi
8010532a:	0f 84 60 01 00 00    	je     80105490 <sys_unlink+0x1a0>
  ilock(dp);
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	50                   	push   %eax
80105334:	e8 57 c3 ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105339:	58                   	pop    %eax
8010533a:	5a                   	pop    %edx
8010533b:	68 78 7b 10 80       	push   $0x80107b78
80105340:	53                   	push   %ebx
80105341:	e8 5a c8 ff ff       	call   80101ba0 <namecmp>
80105346:	83 c4 10             	add    $0x10,%esp
80105349:	85 c0                	test   %eax,%eax
8010534b:	0f 84 03 01 00 00    	je     80105454 <sys_unlink+0x164>
80105351:	83 ec 08             	sub    $0x8,%esp
80105354:	68 77 7b 10 80       	push   $0x80107b77
80105359:	53                   	push   %ebx
8010535a:	e8 41 c8 ff ff       	call   80101ba0 <namecmp>
8010535f:	83 c4 10             	add    $0x10,%esp
80105362:	85 c0                	test   %eax,%eax
80105364:	0f 84 ea 00 00 00    	je     80105454 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010536a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010536d:	83 ec 04             	sub    $0x4,%esp
80105370:	50                   	push   %eax
80105371:	53                   	push   %ebx
80105372:	56                   	push   %esi
80105373:	e8 48 c8 ff ff       	call   80101bc0 <dirlookup>
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	85 c0                	test   %eax,%eax
8010537d:	89 c3                	mov    %eax,%ebx
8010537f:	0f 84 cf 00 00 00    	je     80105454 <sys_unlink+0x164>
  ilock(ip);
80105385:	83 ec 0c             	sub    $0xc,%esp
80105388:	50                   	push   %eax
80105389:	e8 02 c3 ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
8010538e:	83 c4 10             	add    $0x10,%esp
80105391:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105396:	0f 8e 10 01 00 00    	jle    801054ac <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010539c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053a1:	74 6d                	je     80105410 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801053a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053a6:	83 ec 04             	sub    $0x4,%esp
801053a9:	6a 10                	push   $0x10
801053ab:	6a 00                	push   $0x0
801053ad:	50                   	push   %eax
801053ae:	e8 bd f5 ff ff       	call   80104970 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053b6:	6a 10                	push   $0x10
801053b8:	ff 75 c4             	pushl  -0x3c(%ebp)
801053bb:	50                   	push   %eax
801053bc:	56                   	push   %esi
801053bd:	e8 ae c6 ff ff       	call   80101a70 <writei>
801053c2:	83 c4 20             	add    $0x20,%esp
801053c5:	83 f8 10             	cmp    $0x10,%eax
801053c8:	0f 85 eb 00 00 00    	jne    801054b9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801053ce:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053d3:	0f 84 97 00 00 00    	je     80105470 <sys_unlink+0x180>
  iunlockput(dp);
801053d9:	83 ec 0c             	sub    $0xc,%esp
801053dc:	56                   	push   %esi
801053dd:	e8 3e c5 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
801053e2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053e7:	89 1c 24             	mov    %ebx,(%esp)
801053ea:	e8 f1 c1 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
801053ef:	89 1c 24             	mov    %ebx,(%esp)
801053f2:	e8 29 c5 ff ff       	call   80101920 <iunlockput>
  end_op();
801053f7:	e8 b4 d9 ff ff       	call   80102db0 <end_op>
  return 0;
801053fc:	83 c4 10             	add    $0x10,%esp
801053ff:	31 c0                	xor    %eax,%eax
}
80105401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105404:	5b                   	pop    %ebx
80105405:	5e                   	pop    %esi
80105406:	5f                   	pop    %edi
80105407:	5d                   	pop    %ebp
80105408:	c3                   	ret    
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105410:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105414:	76 8d                	jbe    801053a3 <sys_unlink+0xb3>
80105416:	bf 20 00 00 00       	mov    $0x20,%edi
8010541b:	eb 0f                	jmp    8010542c <sys_unlink+0x13c>
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
80105420:	83 c7 10             	add    $0x10,%edi
80105423:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105426:	0f 83 77 ff ff ff    	jae    801053a3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010542c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010542f:	6a 10                	push   $0x10
80105431:	57                   	push   %edi
80105432:	50                   	push   %eax
80105433:	53                   	push   %ebx
80105434:	e8 37 c5 ff ff       	call   80101970 <readi>
80105439:	83 c4 10             	add    $0x10,%esp
8010543c:	83 f8 10             	cmp    $0x10,%eax
8010543f:	75 5e                	jne    8010549f <sys_unlink+0x1af>
    if(de.inum != 0)
80105441:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105446:	74 d8                	je     80105420 <sys_unlink+0x130>
    iunlockput(ip);
80105448:	83 ec 0c             	sub    $0xc,%esp
8010544b:	53                   	push   %ebx
8010544c:	e8 cf c4 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105451:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105454:	83 ec 0c             	sub    $0xc,%esp
80105457:	56                   	push   %esi
80105458:	e8 c3 c4 ff ff       	call   80101920 <iunlockput>
  end_op();
8010545d:	e8 4e d9 ff ff       	call   80102db0 <end_op>
  return -1;
80105462:	83 c4 10             	add    $0x10,%esp
80105465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546a:	eb 95                	jmp    80105401 <sys_unlink+0x111>
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105470:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105475:	83 ec 0c             	sub    $0xc,%esp
80105478:	56                   	push   %esi
80105479:	e8 62 c1 ff ff       	call   801015e0 <iupdate>
8010547e:	83 c4 10             	add    $0x10,%esp
80105481:	e9 53 ff ff ff       	jmp    801053d9 <sys_unlink+0xe9>
    return -1;
80105486:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010548b:	e9 71 ff ff ff       	jmp    80105401 <sys_unlink+0x111>
    end_op();
80105490:	e8 1b d9 ff ff       	call   80102db0 <end_op>
    return -1;
80105495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549a:	e9 62 ff ff ff       	jmp    80105401 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010549f:	83 ec 0c             	sub    $0xc,%esp
801054a2:	68 9c 7b 10 80       	push   $0x80107b9c
801054a7:	e8 e4 ae ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801054ac:	83 ec 0c             	sub    $0xc,%esp
801054af:	68 8a 7b 10 80       	push   $0x80107b8a
801054b4:	e8 d7 ae ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801054b9:	83 ec 0c             	sub    $0xc,%esp
801054bc:	68 ae 7b 10 80       	push   $0x80107bae
801054c1:	e8 ca ae ff ff       	call   80100390 <panic>
801054c6:	8d 76 00             	lea    0x0(%esi),%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054d0 <sys_open>:

int
sys_open(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	57                   	push   %edi
801054d4:	56                   	push   %esi
801054d5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054dc:	50                   	push   %eax
801054dd:	6a 00                	push   $0x0
801054df:	e8 3c f8 ff ff       	call   80104d20 <argstr>
801054e4:	83 c4 10             	add    $0x10,%esp
801054e7:	85 c0                	test   %eax,%eax
801054e9:	0f 88 1d 01 00 00    	js     8010560c <sys_open+0x13c>
801054ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054f2:	83 ec 08             	sub    $0x8,%esp
801054f5:	50                   	push   %eax
801054f6:	6a 01                	push   $0x1
801054f8:	e8 73 f7 ff ff       	call   80104c70 <argint>
801054fd:	83 c4 10             	add    $0x10,%esp
80105500:	85 c0                	test   %eax,%eax
80105502:	0f 88 04 01 00 00    	js     8010560c <sys_open+0x13c>
    return -1;

  begin_op();
80105508:	e8 33 d8 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
8010550d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105511:	0f 85 a9 00 00 00    	jne    801055c0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105517:	83 ec 0c             	sub    $0xc,%esp
8010551a:	ff 75 e0             	pushl  -0x20(%ebp)
8010551d:	e8 ce c9 ff ff       	call   80101ef0 <namei>
80105522:	83 c4 10             	add    $0x10,%esp
80105525:	85 c0                	test   %eax,%eax
80105527:	89 c6                	mov    %eax,%esi
80105529:	0f 84 b2 00 00 00    	je     801055e1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010552f:	83 ec 0c             	sub    $0xc,%esp
80105532:	50                   	push   %eax
80105533:	e8 58 c1 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105538:	83 c4 10             	add    $0x10,%esp
8010553b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105540:	0f 84 aa 00 00 00    	je     801055f0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105546:	e8 35 b8 ff ff       	call   80100d80 <filealloc>
8010554b:	85 c0                	test   %eax,%eax
8010554d:	89 c7                	mov    %eax,%edi
8010554f:	0f 84 a6 00 00 00    	je     801055fb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105555:	e8 d6 e6 ff ff       	call   80103c30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010555a:	31 db                	xor    %ebx,%ebx
8010555c:	eb 0e                	jmp    8010556c <sys_open+0x9c>
8010555e:	66 90                	xchg   %ax,%ax
80105560:	83 c3 01             	add    $0x1,%ebx
80105563:	83 fb 10             	cmp    $0x10,%ebx
80105566:	0f 84 ac 00 00 00    	je     80105618 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010556c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105570:	85 d2                	test   %edx,%edx
80105572:	75 ec                	jne    80105560 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105574:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105577:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010557b:	56                   	push   %esi
8010557c:	e8 ef c1 ff ff       	call   80101770 <iunlock>
  end_op();
80105581:	e8 2a d8 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
80105586:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010558c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010558f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105592:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105595:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010559c:	89 d0                	mov    %edx,%eax
8010559e:	f7 d0                	not    %eax
801055a0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055a3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055a6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055a9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055b0:	89 d8                	mov    %ebx,%eax
801055b2:	5b                   	pop    %ebx
801055b3:	5e                   	pop    %esi
801055b4:	5f                   	pop    %edi
801055b5:	5d                   	pop    %ebp
801055b6:	c3                   	ret    
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055c6:	31 c9                	xor    %ecx,%ecx
801055c8:	6a 00                	push   $0x0
801055ca:	ba 02 00 00 00       	mov    $0x2,%edx
801055cf:	e8 ec f7 ff ff       	call   80104dc0 <create>
    if(ip == 0){
801055d4:	83 c4 10             	add    $0x10,%esp
801055d7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801055d9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055db:	0f 85 65 ff ff ff    	jne    80105546 <sys_open+0x76>
      end_op();
801055e1:	e8 ca d7 ff ff       	call   80102db0 <end_op>
      return -1;
801055e6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055eb:	eb c0                	jmp    801055ad <sys_open+0xdd>
801055ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801055f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055f3:	85 c9                	test   %ecx,%ecx
801055f5:	0f 84 4b ff ff ff    	je     80105546 <sys_open+0x76>
    iunlockput(ip);
801055fb:	83 ec 0c             	sub    $0xc,%esp
801055fe:	56                   	push   %esi
801055ff:	e8 1c c3 ff ff       	call   80101920 <iunlockput>
    end_op();
80105604:	e8 a7 d7 ff ff       	call   80102db0 <end_op>
    return -1;
80105609:	83 c4 10             	add    $0x10,%esp
8010560c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105611:	eb 9a                	jmp    801055ad <sys_open+0xdd>
80105613:	90                   	nop
80105614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	57                   	push   %edi
8010561c:	e8 1f b8 ff ff       	call   80100e40 <fileclose>
80105621:	83 c4 10             	add    $0x10,%esp
80105624:	eb d5                	jmp    801055fb <sys_open+0x12b>
80105626:	8d 76 00             	lea    0x0(%esi),%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <sys_mkdir>:

int
sys_mkdir(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105636:	e8 05 d7 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010563b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010563e:	83 ec 08             	sub    $0x8,%esp
80105641:	50                   	push   %eax
80105642:	6a 00                	push   $0x0
80105644:	e8 d7 f6 ff ff       	call   80104d20 <argstr>
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	85 c0                	test   %eax,%eax
8010564e:	78 30                	js     80105680 <sys_mkdir+0x50>
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105656:	31 c9                	xor    %ecx,%ecx
80105658:	6a 00                	push   $0x0
8010565a:	ba 01 00 00 00       	mov    $0x1,%edx
8010565f:	e8 5c f7 ff ff       	call   80104dc0 <create>
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	85 c0                	test   %eax,%eax
80105669:	74 15                	je     80105680 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010566b:	83 ec 0c             	sub    $0xc,%esp
8010566e:	50                   	push   %eax
8010566f:	e8 ac c2 ff ff       	call   80101920 <iunlockput>
  end_op();
80105674:	e8 37 d7 ff ff       	call   80102db0 <end_op>
  return 0;
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	31 c0                	xor    %eax,%eax
}
8010567e:	c9                   	leave  
8010567f:	c3                   	ret    
    end_op();
80105680:	e8 2b d7 ff ff       	call   80102db0 <end_op>
    return -1;
80105685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010568a:	c9                   	leave  
8010568b:	c3                   	ret    
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105690 <sys_mknod>:

int
sys_mknod(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105696:	e8 a5 d6 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010569b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010569e:	83 ec 08             	sub    $0x8,%esp
801056a1:	50                   	push   %eax
801056a2:	6a 00                	push   $0x0
801056a4:	e8 77 f6 ff ff       	call   80104d20 <argstr>
801056a9:	83 c4 10             	add    $0x10,%esp
801056ac:	85 c0                	test   %eax,%eax
801056ae:	78 60                	js     80105710 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b3:	83 ec 08             	sub    $0x8,%esp
801056b6:	50                   	push   %eax
801056b7:	6a 01                	push   $0x1
801056b9:	e8 b2 f5 ff ff       	call   80104c70 <argint>
  if((argstr(0, &path)) < 0 ||
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	85 c0                	test   %eax,%eax
801056c3:	78 4b                	js     80105710 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c8:	83 ec 08             	sub    $0x8,%esp
801056cb:	50                   	push   %eax
801056cc:	6a 02                	push   $0x2
801056ce:	e8 9d f5 ff ff       	call   80104c70 <argint>
     argint(1, &major) < 0 ||
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	78 36                	js     80105710 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801056de:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801056e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801056e5:	ba 03 00 00 00       	mov    $0x3,%edx
801056ea:	50                   	push   %eax
801056eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056ee:	e8 cd f6 ff ff       	call   80104dc0 <create>
801056f3:	83 c4 10             	add    $0x10,%esp
801056f6:	85 c0                	test   %eax,%eax
801056f8:	74 16                	je     80105710 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056fa:	83 ec 0c             	sub    $0xc,%esp
801056fd:	50                   	push   %eax
801056fe:	e8 1d c2 ff ff       	call   80101920 <iunlockput>
  end_op();
80105703:	e8 a8 d6 ff ff       	call   80102db0 <end_op>
  return 0;
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	31 c0                	xor    %eax,%eax
}
8010570d:	c9                   	leave  
8010570e:	c3                   	ret    
8010570f:	90                   	nop
    end_op();
80105710:	e8 9b d6 ff ff       	call   80102db0 <end_op>
    return -1;
80105715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010571a:	c9                   	leave  
8010571b:	c3                   	ret    
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_chdir>:

int
sys_chdir(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	56                   	push   %esi
80105724:	53                   	push   %ebx
80105725:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105728:	e8 03 e5 ff ff       	call   80103c30 <myproc>
8010572d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010572f:	e8 0c d6 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105734:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105737:	83 ec 08             	sub    $0x8,%esp
8010573a:	50                   	push   %eax
8010573b:	6a 00                	push   $0x0
8010573d:	e8 de f5 ff ff       	call   80104d20 <argstr>
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	85 c0                	test   %eax,%eax
80105747:	78 77                	js     801057c0 <sys_chdir+0xa0>
80105749:	83 ec 0c             	sub    $0xc,%esp
8010574c:	ff 75 f4             	pushl  -0xc(%ebp)
8010574f:	e8 9c c7 ff ff       	call   80101ef0 <namei>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	85 c0                	test   %eax,%eax
80105759:	89 c3                	mov    %eax,%ebx
8010575b:	74 63                	je     801057c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010575d:	83 ec 0c             	sub    $0xc,%esp
80105760:	50                   	push   %eax
80105761:	e8 2a bf ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010576e:	75 30                	jne    801057a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105770:	83 ec 0c             	sub    $0xc,%esp
80105773:	53                   	push   %ebx
80105774:	e8 f7 bf ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105779:	58                   	pop    %eax
8010577a:	ff 76 68             	pushl  0x68(%esi)
8010577d:	e8 3e c0 ff ff       	call   801017c0 <iput>
  end_op();
80105782:	e8 29 d6 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
80105787:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	31 c0                	xor    %eax,%eax
}
8010578f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105792:	5b                   	pop    %ebx
80105793:	5e                   	pop    %esi
80105794:	5d                   	pop    %ebp
80105795:	c3                   	ret    
80105796:	8d 76 00             	lea    0x0(%esi),%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	53                   	push   %ebx
801057a4:	e8 77 c1 ff ff       	call   80101920 <iunlockput>
    end_op();
801057a9:	e8 02 d6 ff ff       	call   80102db0 <end_op>
    return -1;
801057ae:	83 c4 10             	add    $0x10,%esp
801057b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b6:	eb d7                	jmp    8010578f <sys_chdir+0x6f>
801057b8:	90                   	nop
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801057c0:	e8 eb d5 ff ff       	call   80102db0 <end_op>
    return -1;
801057c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ca:	eb c3                	jmp    8010578f <sys_chdir+0x6f>
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_exec>:

int
sys_exec(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
801057d5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057d6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057e2:	50                   	push   %eax
801057e3:	6a 00                	push   $0x0
801057e5:	e8 36 f5 ff ff       	call   80104d20 <argstr>
801057ea:	83 c4 10             	add    $0x10,%esp
801057ed:	85 c0                	test   %eax,%eax
801057ef:	0f 88 87 00 00 00    	js     8010587c <sys_exec+0xac>
801057f5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057fb:	83 ec 08             	sub    $0x8,%esp
801057fe:	50                   	push   %eax
801057ff:	6a 01                	push   $0x1
80105801:	e8 6a f4 ff ff       	call   80104c70 <argint>
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	85 c0                	test   %eax,%eax
8010580b:	78 6f                	js     8010587c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010580d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105813:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105816:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105818:	68 80 00 00 00       	push   $0x80
8010581d:	6a 00                	push   $0x0
8010581f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105825:	50                   	push   %eax
80105826:	e8 45 f1 ff ff       	call   80104970 <memset>
8010582b:	83 c4 10             	add    $0x10,%esp
8010582e:	eb 2c                	jmp    8010585c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105830:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105836:	85 c0                	test   %eax,%eax
80105838:	74 56                	je     80105890 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010583a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105840:	83 ec 08             	sub    $0x8,%esp
80105843:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105846:	52                   	push   %edx
80105847:	50                   	push   %eax
80105848:	e8 b3 f3 ff ff       	call   80104c00 <fetchstr>
8010584d:	83 c4 10             	add    $0x10,%esp
80105850:	85 c0                	test   %eax,%eax
80105852:	78 28                	js     8010587c <sys_exec+0xac>
  for(i=0;; i++){
80105854:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105857:	83 fb 20             	cmp    $0x20,%ebx
8010585a:	74 20                	je     8010587c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010585c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105862:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105869:	83 ec 08             	sub    $0x8,%esp
8010586c:	57                   	push   %edi
8010586d:	01 f0                	add    %esi,%eax
8010586f:	50                   	push   %eax
80105870:	e8 4b f3 ff ff       	call   80104bc0 <fetchint>
80105875:	83 c4 10             	add    $0x10,%esp
80105878:	85 c0                	test   %eax,%eax
8010587a:	79 b4                	jns    80105830 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010587c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010587f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105884:	5b                   	pop    %ebx
80105885:	5e                   	pop    %esi
80105886:	5f                   	pop    %edi
80105887:	5d                   	pop    %ebp
80105888:	c3                   	ret    
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105890:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105896:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105899:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058a0:	00 00 00 00 
  return exec(path, argv);
801058a4:	50                   	push   %eax
801058a5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801058ab:	e8 60 b1 ff ff       	call   80100a10 <exec>
801058b0:	83 c4 10             	add    $0x10,%esp
}
801058b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058b6:	5b                   	pop    %ebx
801058b7:	5e                   	pop    %esi
801058b8:	5f                   	pop    %edi
801058b9:	5d                   	pop    %ebp
801058ba:	c3                   	ret    
801058bb:	90                   	nop
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_pipe>:

int
sys_pipe(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	57                   	push   %edi
801058c4:	56                   	push   %esi
801058c5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058cc:	6a 08                	push   $0x8
801058ce:	50                   	push   %eax
801058cf:	6a 00                	push   $0x0
801058d1:	e8 ea f3 ff ff       	call   80104cc0 <argptr>
801058d6:	83 c4 10             	add    $0x10,%esp
801058d9:	85 c0                	test   %eax,%eax
801058db:	0f 88 ae 00 00 00    	js     8010598f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058e4:	83 ec 08             	sub    $0x8,%esp
801058e7:	50                   	push   %eax
801058e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058eb:	50                   	push   %eax
801058ec:	e8 ef da ff ff       	call   801033e0 <pipealloc>
801058f1:	83 c4 10             	add    $0x10,%esp
801058f4:	85 c0                	test   %eax,%eax
801058f6:	0f 88 93 00 00 00    	js     8010598f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058ff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105901:	e8 2a e3 ff ff       	call   80103c30 <myproc>
80105906:	eb 10                	jmp    80105918 <sys_pipe+0x58>
80105908:	90                   	nop
80105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105910:	83 c3 01             	add    $0x1,%ebx
80105913:	83 fb 10             	cmp    $0x10,%ebx
80105916:	74 60                	je     80105978 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105918:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010591c:	85 f6                	test   %esi,%esi
8010591e:	75 f0                	jne    80105910 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105920:	8d 73 08             	lea    0x8(%ebx),%esi
80105923:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105927:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010592a:	e8 01 e3 ff ff       	call   80103c30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010592f:	31 d2                	xor    %edx,%edx
80105931:	eb 0d                	jmp    80105940 <sys_pipe+0x80>
80105933:	90                   	nop
80105934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105938:	83 c2 01             	add    $0x1,%edx
8010593b:	83 fa 10             	cmp    $0x10,%edx
8010593e:	74 28                	je     80105968 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105940:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105944:	85 c9                	test   %ecx,%ecx
80105946:	75 f0                	jne    80105938 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105948:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010594c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010594f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105951:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105954:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105957:	31 c0                	xor    %eax,%eax
}
80105959:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010595c:	5b                   	pop    %ebx
8010595d:	5e                   	pop    %esi
8010595e:	5f                   	pop    %edi
8010595f:	5d                   	pop    %ebp
80105960:	c3                   	ret    
80105961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105968:	e8 c3 e2 ff ff       	call   80103c30 <myproc>
8010596d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105974:	00 
80105975:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105978:	83 ec 0c             	sub    $0xc,%esp
8010597b:	ff 75 e0             	pushl  -0x20(%ebp)
8010597e:	e8 bd b4 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105983:	58                   	pop    %eax
80105984:	ff 75 e4             	pushl  -0x1c(%ebp)
80105987:	e8 b4 b4 ff ff       	call   80100e40 <fileclose>
    return -1;
8010598c:	83 c4 10             	add    $0x10,%esp
8010598f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105994:	eb c3                	jmp    80105959 <sys_pipe+0x99>
80105996:	66 90                	xchg   %ax,%ax
80105998:	66 90                	xchg   %ax,%ax
8010599a:	66 90                	xchg   %ax,%ax
8010599c:	66 90                	xchg   %ax,%ax
8010599e:	66 90                	xchg   %ax,%ax

801059a0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801059a3:	5d                   	pop    %ebp
  return fork();
801059a4:	e9 27 e4 ff ff       	jmp    80103dd0 <fork>
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_exit>:

int
sys_exit(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059b6:	e8 c5 e6 ff ff       	call   80104080 <exit>
  return 0;  // not reached
}
801059bb:	31 c0                	xor    %eax,%eax
801059bd:	c9                   	leave  
801059be:	c3                   	ret    
801059bf:	90                   	nop

801059c0 <sys_wait>:

int
sys_wait(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801059c3:	5d                   	pop    %ebp
  return wait();
801059c4:	e9 47 e9 ff ff       	jmp    80104310 <wait>
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_kill>:

int
sys_kill(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d9:	50                   	push   %eax
801059da:	6a 00                	push   $0x0
801059dc:	e8 8f f2 ff ff       	call   80104c70 <argint>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	85 c0                	test   %eax,%eax
801059e6:	78 18                	js     80105a00 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059e8:	83 ec 0c             	sub    $0xc,%esp
801059eb:	ff 75 f4             	pushl  -0xc(%ebp)
801059ee:	e8 ad ea ff ff       	call   801044a0 <kill>
801059f3:	83 c4 10             	add    $0x10,%esp
}
801059f6:	c9                   	leave  
801059f7:	c3                   	ret    
801059f8:	90                   	nop
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a05:	c9                   	leave  
80105a06:	c3                   	ret    
80105a07:	89 f6                	mov    %esi,%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a10 <sys_getpid>:

int
sys_getpid(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a16:	e8 15 e2 ff ff       	call   80103c30 <myproc>
80105a1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a1e:	c9                   	leave  
80105a1f:	c3                   	ret    

80105a20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a2a:	50                   	push   %eax
80105a2b:	6a 00                	push   $0x0
80105a2d:	e8 3e f2 ff ff       	call   80104c70 <argint>
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	85 c0                	test   %eax,%eax
80105a37:	78 27                	js     80105a60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a39:	e8 f2 e1 ff ff       	call   80103c30 <myproc>
  if(growproc(n) < 0)
80105a3e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a43:	ff 75 f4             	pushl  -0xc(%ebp)
80105a46:	e8 05 e3 ff ff       	call   80103d50 <growproc>
80105a4b:	83 c4 10             	add    $0x10,%esp
80105a4e:	85 c0                	test   %eax,%eax
80105a50:	78 0e                	js     80105a60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a52:	89 d8                	mov    %ebx,%eax
80105a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a57:	c9                   	leave  
80105a58:	c3                   	ret    
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a65:	eb eb                	jmp    80105a52 <sys_sbrk+0x32>
80105a67:	89 f6                	mov    %esi,%esi
80105a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a70 <sys_sleep>:

int
sys_sleep(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a7a:	50                   	push   %eax
80105a7b:	6a 00                	push   $0x0
80105a7d:	e8 ee f1 ff ff       	call   80104c70 <argint>
80105a82:	83 c4 10             	add    $0x10,%esp
80105a85:	85 c0                	test   %eax,%eax
80105a87:	0f 88 8a 00 00 00    	js     80105b17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	68 c0 2d 11 80       	push   $0x80112dc0
80105a95:	e8 c6 ed ff ff       	call   80104860 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a9d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105aa0:	8b 1d 00 36 11 80    	mov    0x80113600,%ebx
  while(ticks - ticks0 < n){
80105aa6:	85 d2                	test   %edx,%edx
80105aa8:	75 27                	jne    80105ad1 <sys_sleep+0x61>
80105aaa:	eb 54                	jmp    80105b00 <sys_sleep+0x90>
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ab0:	83 ec 08             	sub    $0x8,%esp
80105ab3:	68 c0 2d 11 80       	push   $0x80112dc0
80105ab8:	68 00 36 11 80       	push   $0x80113600
80105abd:	e8 8e e7 ff ff       	call   80104250 <sleep>
  while(ticks - ticks0 < n){
80105ac2:	a1 00 36 11 80       	mov    0x80113600,%eax
80105ac7:	83 c4 10             	add    $0x10,%esp
80105aca:	29 d8                	sub    %ebx,%eax
80105acc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105acf:	73 2f                	jae    80105b00 <sys_sleep+0x90>
    if(myproc()->killed){
80105ad1:	e8 5a e1 ff ff       	call   80103c30 <myproc>
80105ad6:	8b 40 24             	mov    0x24(%eax),%eax
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	74 d3                	je     80105ab0 <sys_sleep+0x40>
      release(&tickslock);
80105add:	83 ec 0c             	sub    $0xc,%esp
80105ae0:	68 c0 2d 11 80       	push   $0x80112dc0
80105ae5:	e8 36 ee ff ff       	call   80104920 <release>
      return -1;
80105aea:	83 c4 10             	add    $0x10,%esp
80105aed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105af2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	68 c0 2d 11 80       	push   $0x80112dc0
80105b08:	e8 13 ee ff ff       	call   80104920 <release>
  return 0;
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	31 c0                	xor    %eax,%eax
}
80105b12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b15:	c9                   	leave  
80105b16:	c3                   	ret    
    return -1;
80105b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1c:	eb f4                	jmp    80105b12 <sys_sleep+0xa2>
80105b1e:	66 90                	xchg   %ax,%ax

80105b20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
80105b24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b27:	68 c0 2d 11 80       	push   $0x80112dc0
80105b2c:	e8 2f ed ff ff       	call   80104860 <acquire>
  xticks = ticks;
80105b31:	8b 1d 00 36 11 80    	mov    0x80113600,%ebx
  release(&tickslock);
80105b37:	c7 04 24 c0 2d 11 80 	movl   $0x80112dc0,(%esp)
80105b3e:	e8 dd ed ff ff       	call   80104920 <release>
  return xticks;
}
80105b43:	89 d8                	mov    %ebx,%eax
80105b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b48:	c9                   	leave  
80105b49:	c3                   	ret    
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b50 <sys_stride>:

int
sys_stride(void){
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	53                   	push   %ebx
  int tickets;
  if(argint(0,&tickets)<0){
80105b54:	8d 45 f4             	lea    -0xc(%ebp),%eax
sys_stride(void){
80105b57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0,&tickets)<0){
80105b5a:	50                   	push   %eax
80105b5b:	6a 00                	push   $0x0
80105b5d:	e8 0e f1 ff ff       	call   80104c70 <argint>
80105b62:	83 c4 10             	add    $0x10,%esp
80105b65:	85 c0                	test   %eax,%eax
80105b67:	78 27                	js     80105b90 <sys_stride+0x40>
    return -1;
  }
  
  myproc()->stride_info.tickets=tickets;
80105b69:	e8 c2 e0 ff ff       	call   80103c30 <myproc>
80105b6e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105b71:	89 98 80 00 00 00    	mov    %ebx,0x80(%eax)
  myproc()->stride_info.stride=STRIDE_LARGE_NUMBER/tickets;
80105b77:	e8 b4 e0 ff ff       	call   80103c30 <myproc>
80105b7c:	89 c1                	mov    %eax,%ecx
80105b7e:	b8 10 27 00 00       	mov    $0x2710,%eax
80105b83:	99                   	cltd   
80105b84:	f7 fb                	idiv   %ebx
80105b86:	89 41 7c             	mov    %eax,0x7c(%ecx)
  return 0;
80105b89:	31 c0                	xor    %eax,%eax
  }
80105b8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b8e:	c9                   	leave  
80105b8f:	c3                   	ret    
    return -1;
80105b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b95:	eb f4                	jmp    80105b8b <sys_stride+0x3b>

80105b97 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b97:	1e                   	push   %ds
  pushl %es
80105b98:	06                   	push   %es
  pushl %fs
80105b99:	0f a0                	push   %fs
  pushl %gs
80105b9b:	0f a8                	push   %gs
  pushal
80105b9d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b9e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ba2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ba4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ba6:	54                   	push   %esp
  call trap
80105ba7:	e8 c4 00 00 00       	call   80105c70 <trap>
  addl $4, %esp
80105bac:	83 c4 04             	add    $0x4,%esp

80105baf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105baf:	61                   	popa   
  popl %gs
80105bb0:	0f a9                	pop    %gs
  popl %fs
80105bb2:	0f a1                	pop    %fs
  popl %es
80105bb4:	07                   	pop    %es
  popl %ds
80105bb5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bb6:	83 c4 08             	add    $0x8,%esp
  iret
80105bb9:	cf                   	iret   
80105bba:	66 90                	xchg   %ax,%ax
80105bbc:	66 90                	xchg   %ax,%ax
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bc0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105bc1:	31 c0                	xor    %eax,%eax
{
80105bc3:	89 e5                	mov    %esp,%ebp
80105bc5:	83 ec 08             	sub    $0x8,%esp
80105bc8:	90                   	nop
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bd0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105bd7:	c7 04 c5 02 2e 11 80 	movl   $0x8e000008,-0x7feed1fe(,%eax,8)
80105bde:	08 00 00 8e 
80105be2:	66 89 14 c5 00 2e 11 	mov    %dx,-0x7feed200(,%eax,8)
80105be9:	80 
80105bea:	c1 ea 10             	shr    $0x10,%edx
80105bed:	66 89 14 c5 06 2e 11 	mov    %dx,-0x7feed1fa(,%eax,8)
80105bf4:	80 
  for(i = 0; i < 256; i++)
80105bf5:	83 c0 01             	add    $0x1,%eax
80105bf8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bfd:	75 d1                	jne    80105bd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bff:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105c04:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c07:	c7 05 02 30 11 80 08 	movl   $0xef000008,0x80113002
80105c0e:	00 00 ef 
  initlock(&tickslock, "time");
80105c11:	68 bd 7b 10 80       	push   $0x80107bbd
80105c16:	68 c0 2d 11 80       	push   $0x80112dc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c1b:	66 a3 00 30 11 80    	mov    %ax,0x80113000
80105c21:	c1 e8 10             	shr    $0x10,%eax
80105c24:	66 a3 06 30 11 80    	mov    %ax,0x80113006
  initlock(&tickslock, "time");
80105c2a:	e8 f1 ea ff ff       	call   80104720 <initlock>
}
80105c2f:	83 c4 10             	add    $0x10,%esp
80105c32:	c9                   	leave  
80105c33:	c3                   	ret    
80105c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c40 <idtinit>:

void
idtinit(void)
{
80105c40:	55                   	push   %ebp
  pd[0] = size-1;
80105c41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c46:	89 e5                	mov    %esp,%ebp
80105c48:	83 ec 10             	sub    $0x10,%esp
80105c4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c4f:	b8 00 2e 11 80       	mov    $0x80112e00,%eax
80105c54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c58:	c1 e8 10             	shr    $0x10,%eax
80105c5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c65:	c9                   	leave  
80105c66:	c3                   	ret    
80105c67:	89 f6                	mov    %esi,%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
80105c75:	53                   	push   %ebx
80105c76:	83 ec 1c             	sub    $0x1c,%esp
80105c79:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105c7c:	8b 47 30             	mov    0x30(%edi),%eax
80105c7f:	83 f8 40             	cmp    $0x40,%eax
80105c82:	0f 84 f0 00 00 00    	je     80105d78 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c88:	83 e8 20             	sub    $0x20,%eax
80105c8b:	83 f8 1f             	cmp    $0x1f,%eax
80105c8e:	77 10                	ja     80105ca0 <trap+0x30>
80105c90:	ff 24 85 64 7c 10 80 	jmp    *-0x7fef839c(,%eax,4)
80105c97:	89 f6                	mov    %esi,%esi
80105c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ca0:	e8 8b df ff ff       	call   80103c30 <myproc>
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105caa:	0f 84 14 02 00 00    	je     80105ec4 <trap+0x254>
80105cb0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105cb4:	0f 84 0a 02 00 00    	je     80105ec4 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105cba:	0f 20 d1             	mov    %cr2,%ecx
80105cbd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cc0:	e8 4b df ff ff       	call   80103c10 <cpuid>
80105cc5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105cc8:	8b 47 34             	mov    0x34(%edi),%eax
80105ccb:	8b 77 30             	mov    0x30(%edi),%esi
80105cce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105cd1:	e8 5a df ff ff       	call   80103c30 <myproc>
80105cd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105cd9:	e8 52 df ff ff       	call   80103c30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cde:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ce1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ce4:	51                   	push   %ecx
80105ce5:	53                   	push   %ebx
80105ce6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105ce7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cea:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ced:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105cee:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cf1:	52                   	push   %edx
80105cf2:	ff 70 10             	pushl  0x10(%eax)
80105cf5:	68 20 7c 10 80       	push   $0x80107c20
80105cfa:	e8 61 a9 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105cff:	83 c4 20             	add    $0x20,%esp
80105d02:	e8 29 df ff ff       	call   80103c30 <myproc>
80105d07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d0e:	e8 1d df ff ff       	call   80103c30 <myproc>
80105d13:	85 c0                	test   %eax,%eax
80105d15:	74 1d                	je     80105d34 <trap+0xc4>
80105d17:	e8 14 df ff ff       	call   80103c30 <myproc>
80105d1c:	8b 50 24             	mov    0x24(%eax),%edx
80105d1f:	85 d2                	test   %edx,%edx
80105d21:	74 11                	je     80105d34 <trap+0xc4>
80105d23:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d27:	83 e0 03             	and    $0x3,%eax
80105d2a:	66 83 f8 03          	cmp    $0x3,%ax
80105d2e:	0f 84 4c 01 00 00    	je     80105e80 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d34:	e8 f7 de ff ff       	call   80103c30 <myproc>
80105d39:	85 c0                	test   %eax,%eax
80105d3b:	74 0b                	je     80105d48 <trap+0xd8>
80105d3d:	e8 ee de ff ff       	call   80103c30 <myproc>
80105d42:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d46:	74 68                	je     80105db0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d48:	e8 e3 de ff ff       	call   80103c30 <myproc>
80105d4d:	85 c0                	test   %eax,%eax
80105d4f:	74 19                	je     80105d6a <trap+0xfa>
80105d51:	e8 da de ff ff       	call   80103c30 <myproc>
80105d56:	8b 40 24             	mov    0x24(%eax),%eax
80105d59:	85 c0                	test   %eax,%eax
80105d5b:	74 0d                	je     80105d6a <trap+0xfa>
80105d5d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d61:	83 e0 03             	and    $0x3,%eax
80105d64:	66 83 f8 03          	cmp    $0x3,%ax
80105d68:	74 37                	je     80105da1 <trap+0x131>
    exit();
}
80105d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d6d:	5b                   	pop    %ebx
80105d6e:	5e                   	pop    %esi
80105d6f:	5f                   	pop    %edi
80105d70:	5d                   	pop    %ebp
80105d71:	c3                   	ret    
80105d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105d78:	e8 b3 de ff ff       	call   80103c30 <myproc>
80105d7d:	8b 58 24             	mov    0x24(%eax),%ebx
80105d80:	85 db                	test   %ebx,%ebx
80105d82:	0f 85 e8 00 00 00    	jne    80105e70 <trap+0x200>
    myproc()->tf = tf;
80105d88:	e8 a3 de ff ff       	call   80103c30 <myproc>
80105d8d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105d90:	e8 cb ef ff ff       	call   80104d60 <syscall>
    if(myproc()->killed)
80105d95:	e8 96 de ff ff       	call   80103c30 <myproc>
80105d9a:	8b 48 24             	mov    0x24(%eax),%ecx
80105d9d:	85 c9                	test   %ecx,%ecx
80105d9f:	74 c9                	je     80105d6a <trap+0xfa>
}
80105da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da4:	5b                   	pop    %ebx
80105da5:	5e                   	pop    %esi
80105da6:	5f                   	pop    %edi
80105da7:	5d                   	pop    %ebp
      exit();
80105da8:	e9 d3 e2 ff ff       	jmp    80104080 <exit>
80105dad:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105db0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105db4:	75 92                	jne    80105d48 <trap+0xd8>
    yield();
80105db6:	e8 45 e4 ff ff       	call   80104200 <yield>
80105dbb:	eb 8b                	jmp    80105d48 <trap+0xd8>
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105dc0:	e8 4b de ff ff       	call   80103c10 <cpuid>
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	0f 84 c3 00 00 00    	je     80105e90 <trap+0x220>
    lapiceoi();
80105dcd:	e8 1e cb ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd2:	e8 59 de ff ff       	call   80103c30 <myproc>
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	0f 85 38 ff ff ff    	jne    80105d17 <trap+0xa7>
80105ddf:	e9 50 ff ff ff       	jmp    80105d34 <trap+0xc4>
80105de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105de8:	e8 c3 c9 ff ff       	call   801027b0 <kbdintr>
    lapiceoi();
80105ded:	e8 fe ca ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105df2:	e8 39 de ff ff       	call   80103c30 <myproc>
80105df7:	85 c0                	test   %eax,%eax
80105df9:	0f 85 18 ff ff ff    	jne    80105d17 <trap+0xa7>
80105dff:	e9 30 ff ff ff       	jmp    80105d34 <trap+0xc4>
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e08:	e8 53 02 00 00       	call   80106060 <uartintr>
    lapiceoi();
80105e0d:	e8 de ca ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e12:	e8 19 de ff ff       	call   80103c30 <myproc>
80105e17:	85 c0                	test   %eax,%eax
80105e19:	0f 85 f8 fe ff ff    	jne    80105d17 <trap+0xa7>
80105e1f:	e9 10 ff ff ff       	jmp    80105d34 <trap+0xc4>
80105e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e28:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105e2c:	8b 77 38             	mov    0x38(%edi),%esi
80105e2f:	e8 dc dd ff ff       	call   80103c10 <cpuid>
80105e34:	56                   	push   %esi
80105e35:	53                   	push   %ebx
80105e36:	50                   	push   %eax
80105e37:	68 c8 7b 10 80       	push   $0x80107bc8
80105e3c:	e8 1f a8 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105e41:	e8 aa ca ff ff       	call   801028f0 <lapiceoi>
    break;
80105e46:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e49:	e8 e2 dd ff ff       	call   80103c30 <myproc>
80105e4e:	85 c0                	test   %eax,%eax
80105e50:	0f 85 c1 fe ff ff    	jne    80105d17 <trap+0xa7>
80105e56:	e9 d9 fe ff ff       	jmp    80105d34 <trap+0xc4>
80105e5b:	90                   	nop
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e60:	e8 2b c2 ff ff       	call   80102090 <ideintr>
80105e65:	e9 63 ff ff ff       	jmp    80105dcd <trap+0x15d>
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e70:	e8 0b e2 ff ff       	call   80104080 <exit>
80105e75:	e9 0e ff ff ff       	jmp    80105d88 <trap+0x118>
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105e80:	e8 fb e1 ff ff       	call   80104080 <exit>
80105e85:	e9 aa fe ff ff       	jmp    80105d34 <trap+0xc4>
80105e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	68 c0 2d 11 80       	push   $0x80112dc0
80105e98:	e8 c3 e9 ff ff       	call   80104860 <acquire>
      wakeup(&ticks);
80105e9d:	c7 04 24 00 36 11 80 	movl   $0x80113600,(%esp)
      ticks++;
80105ea4:	83 05 00 36 11 80 01 	addl   $0x1,0x80113600
      wakeup(&ticks);
80105eab:	e8 70 e5 ff ff       	call   80104420 <wakeup>
      release(&tickslock);
80105eb0:	c7 04 24 c0 2d 11 80 	movl   $0x80112dc0,(%esp)
80105eb7:	e8 64 ea ff ff       	call   80104920 <release>
80105ebc:	83 c4 10             	add    $0x10,%esp
80105ebf:	e9 09 ff ff ff       	jmp    80105dcd <trap+0x15d>
80105ec4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ec7:	e8 44 dd ff ff       	call   80103c10 <cpuid>
80105ecc:	83 ec 0c             	sub    $0xc,%esp
80105ecf:	56                   	push   %esi
80105ed0:	53                   	push   %ebx
80105ed1:	50                   	push   %eax
80105ed2:	ff 77 30             	pushl  0x30(%edi)
80105ed5:	68 ec 7b 10 80       	push   $0x80107bec
80105eda:	e8 81 a7 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105edf:	83 c4 14             	add    $0x14,%esp
80105ee2:	68 c2 7b 10 80       	push   $0x80107bc2
80105ee7:	e8 a4 a4 ff ff       	call   80100390 <panic>
80105eec:	66 90                	xchg   %ax,%ax
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ef0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
{
80105ef5:	55                   	push   %ebp
80105ef6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ef8:	85 c0                	test   %eax,%eax
80105efa:	74 1c                	je     80105f18 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105efc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f01:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f02:	a8 01                	test   $0x1,%al
80105f04:	74 12                	je     80105f18 <uartgetc+0x28>
80105f06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f0b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f0c:	0f b6 c0             	movzbl %al,%eax
}
80105f0f:	5d                   	pop    %ebp
80105f10:	c3                   	ret    
80105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f1d:	5d                   	pop    %ebp
80105f1e:	c3                   	ret    
80105f1f:	90                   	nop

80105f20 <uartputc.part.0>:
uartputc(int c)
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	57                   	push   %edi
80105f24:	56                   	push   %esi
80105f25:	53                   	push   %ebx
80105f26:	89 c7                	mov    %eax,%edi
80105f28:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f32:	83 ec 0c             	sub    $0xc,%esp
80105f35:	eb 1b                	jmp    80105f52 <uartputc.part.0+0x32>
80105f37:	89 f6                	mov    %esi,%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	6a 0a                	push   $0xa
80105f45:	e8 c6 c9 ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f4a:	83 c4 10             	add    $0x10,%esp
80105f4d:	83 eb 01             	sub    $0x1,%ebx
80105f50:	74 07                	je     80105f59 <uartputc.part.0+0x39>
80105f52:	89 f2                	mov    %esi,%edx
80105f54:	ec                   	in     (%dx),%al
80105f55:	a8 20                	test   $0x20,%al
80105f57:	74 e7                	je     80105f40 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f59:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f5e:	89 f8                	mov    %edi,%eax
80105f60:	ee                   	out    %al,(%dx)
}
80105f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f64:	5b                   	pop    %ebx
80105f65:	5e                   	pop    %esi
80105f66:	5f                   	pop    %edi
80105f67:	5d                   	pop    %ebp
80105f68:	c3                   	ret    
80105f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f70 <uartinit>:
{
80105f70:	55                   	push   %ebp
80105f71:	31 c9                	xor    %ecx,%ecx
80105f73:	89 c8                	mov    %ecx,%eax
80105f75:	89 e5                	mov    %esp,%ebp
80105f77:	57                   	push   %edi
80105f78:	56                   	push   %esi
80105f79:	53                   	push   %ebx
80105f7a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f7f:	89 da                	mov    %ebx,%edx
80105f81:	83 ec 0c             	sub    $0xc,%esp
80105f84:	ee                   	out    %al,(%dx)
80105f85:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f8f:	89 fa                	mov    %edi,%edx
80105f91:	ee                   	out    %al,(%dx)
80105f92:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f9c:	ee                   	out    %al,(%dx)
80105f9d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105fa2:	89 c8                	mov    %ecx,%eax
80105fa4:	89 f2                	mov    %esi,%edx
80105fa6:	ee                   	out    %al,(%dx)
80105fa7:	b8 03 00 00 00       	mov    $0x3,%eax
80105fac:	89 fa                	mov    %edi,%edx
80105fae:	ee                   	out    %al,(%dx)
80105faf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fb4:	89 c8                	mov    %ecx,%eax
80105fb6:	ee                   	out    %al,(%dx)
80105fb7:	b8 01 00 00 00       	mov    $0x1,%eax
80105fbc:	89 f2                	mov    %esi,%edx
80105fbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fbf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fc4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fc5:	3c ff                	cmp    $0xff,%al
80105fc7:	74 5a                	je     80106023 <uartinit+0xb3>
  uart = 1;
80105fc9:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105fd0:	00 00 00 
80105fd3:	89 da                	mov    %ebx,%edx
80105fd5:	ec                   	in     (%dx),%al
80105fd6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fdb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fdc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105fdf:	bb e4 7c 10 80       	mov    $0x80107ce4,%ebx
  ioapicenable(IRQ_COM1, 0);
80105fe4:	6a 00                	push   $0x0
80105fe6:	6a 04                	push   $0x4
80105fe8:	e8 f3 c2 ff ff       	call   801022e0 <ioapicenable>
80105fed:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105ff0:	b8 78 00 00 00       	mov    $0x78,%eax
80105ff5:	eb 13                	jmp    8010600a <uartinit+0x9a>
80105ff7:	89 f6                	mov    %esi,%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106000:	83 c3 01             	add    $0x1,%ebx
80106003:	0f be 03             	movsbl (%ebx),%eax
80106006:	84 c0                	test   %al,%al
80106008:	74 19                	je     80106023 <uartinit+0xb3>
  if(!uart)
8010600a:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80106010:	85 d2                	test   %edx,%edx
80106012:	74 ec                	je     80106000 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106014:	83 c3 01             	add    $0x1,%ebx
80106017:	e8 04 ff ff ff       	call   80105f20 <uartputc.part.0>
8010601c:	0f be 03             	movsbl (%ebx),%eax
8010601f:	84 c0                	test   %al,%al
80106021:	75 e7                	jne    8010600a <uartinit+0x9a>
}
80106023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106026:	5b                   	pop    %ebx
80106027:	5e                   	pop    %esi
80106028:	5f                   	pop    %edi
80106029:	5d                   	pop    %ebp
8010602a:	c3                   	ret    
8010602b:	90                   	nop
8010602c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106030 <uartputc>:
  if(!uart)
80106030:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
{
80106036:	55                   	push   %ebp
80106037:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106039:	85 d2                	test   %edx,%edx
{
8010603b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010603e:	74 10                	je     80106050 <uartputc+0x20>
}
80106040:	5d                   	pop    %ebp
80106041:	e9 da fe ff ff       	jmp    80105f20 <uartputc.part.0>
80106046:	8d 76 00             	lea    0x0(%esi),%esi
80106049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106050:	5d                   	pop    %ebp
80106051:	c3                   	ret    
80106052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106060 <uartintr>:

void
uartintr(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106066:	68 f0 5e 10 80       	push   $0x80105ef0
8010606b:	e8 a0 a7 ff ff       	call   80100810 <consoleintr>
}
80106070:	83 c4 10             	add    $0x10,%esp
80106073:	c9                   	leave  
80106074:	c3                   	ret    

80106075 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106075:	6a 00                	push   $0x0
  pushl $0
80106077:	6a 00                	push   $0x0
  jmp alltraps
80106079:	e9 19 fb ff ff       	jmp    80105b97 <alltraps>

8010607e <vector1>:
.globl vector1
vector1:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $1
80106080:	6a 01                	push   $0x1
  jmp alltraps
80106082:	e9 10 fb ff ff       	jmp    80105b97 <alltraps>

80106087 <vector2>:
.globl vector2
vector2:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $2
80106089:	6a 02                	push   $0x2
  jmp alltraps
8010608b:	e9 07 fb ff ff       	jmp    80105b97 <alltraps>

80106090 <vector3>:
.globl vector3
vector3:
  pushl $0
80106090:	6a 00                	push   $0x0
  pushl $3
80106092:	6a 03                	push   $0x3
  jmp alltraps
80106094:	e9 fe fa ff ff       	jmp    80105b97 <alltraps>

80106099 <vector4>:
.globl vector4
vector4:
  pushl $0
80106099:	6a 00                	push   $0x0
  pushl $4
8010609b:	6a 04                	push   $0x4
  jmp alltraps
8010609d:	e9 f5 fa ff ff       	jmp    80105b97 <alltraps>

801060a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $5
801060a4:	6a 05                	push   $0x5
  jmp alltraps
801060a6:	e9 ec fa ff ff       	jmp    80105b97 <alltraps>

801060ab <vector6>:
.globl vector6
vector6:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $6
801060ad:	6a 06                	push   $0x6
  jmp alltraps
801060af:	e9 e3 fa ff ff       	jmp    80105b97 <alltraps>

801060b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801060b4:	6a 00                	push   $0x0
  pushl $7
801060b6:	6a 07                	push   $0x7
  jmp alltraps
801060b8:	e9 da fa ff ff       	jmp    80105b97 <alltraps>

801060bd <vector8>:
.globl vector8
vector8:
  pushl $8
801060bd:	6a 08                	push   $0x8
  jmp alltraps
801060bf:	e9 d3 fa ff ff       	jmp    80105b97 <alltraps>

801060c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $9
801060c6:	6a 09                	push   $0x9
  jmp alltraps
801060c8:	e9 ca fa ff ff       	jmp    80105b97 <alltraps>

801060cd <vector10>:
.globl vector10
vector10:
  pushl $10
801060cd:	6a 0a                	push   $0xa
  jmp alltraps
801060cf:	e9 c3 fa ff ff       	jmp    80105b97 <alltraps>

801060d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060d4:	6a 0b                	push   $0xb
  jmp alltraps
801060d6:	e9 bc fa ff ff       	jmp    80105b97 <alltraps>

801060db <vector12>:
.globl vector12
vector12:
  pushl $12
801060db:	6a 0c                	push   $0xc
  jmp alltraps
801060dd:	e9 b5 fa ff ff       	jmp    80105b97 <alltraps>

801060e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060e2:	6a 0d                	push   $0xd
  jmp alltraps
801060e4:	e9 ae fa ff ff       	jmp    80105b97 <alltraps>

801060e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060e9:	6a 0e                	push   $0xe
  jmp alltraps
801060eb:	e9 a7 fa ff ff       	jmp    80105b97 <alltraps>

801060f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $15
801060f2:	6a 0f                	push   $0xf
  jmp alltraps
801060f4:	e9 9e fa ff ff       	jmp    80105b97 <alltraps>

801060f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $16
801060fb:	6a 10                	push   $0x10
  jmp alltraps
801060fd:	e9 95 fa ff ff       	jmp    80105b97 <alltraps>

80106102 <vector17>:
.globl vector17
vector17:
  pushl $17
80106102:	6a 11                	push   $0x11
  jmp alltraps
80106104:	e9 8e fa ff ff       	jmp    80105b97 <alltraps>

80106109 <vector18>:
.globl vector18
vector18:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $18
8010610b:	6a 12                	push   $0x12
  jmp alltraps
8010610d:	e9 85 fa ff ff       	jmp    80105b97 <alltraps>

80106112 <vector19>:
.globl vector19
vector19:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $19
80106114:	6a 13                	push   $0x13
  jmp alltraps
80106116:	e9 7c fa ff ff       	jmp    80105b97 <alltraps>

8010611b <vector20>:
.globl vector20
vector20:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $20
8010611d:	6a 14                	push   $0x14
  jmp alltraps
8010611f:	e9 73 fa ff ff       	jmp    80105b97 <alltraps>

80106124 <vector21>:
.globl vector21
vector21:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $21
80106126:	6a 15                	push   $0x15
  jmp alltraps
80106128:	e9 6a fa ff ff       	jmp    80105b97 <alltraps>

8010612d <vector22>:
.globl vector22
vector22:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $22
8010612f:	6a 16                	push   $0x16
  jmp alltraps
80106131:	e9 61 fa ff ff       	jmp    80105b97 <alltraps>

80106136 <vector23>:
.globl vector23
vector23:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $23
80106138:	6a 17                	push   $0x17
  jmp alltraps
8010613a:	e9 58 fa ff ff       	jmp    80105b97 <alltraps>

8010613f <vector24>:
.globl vector24
vector24:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $24
80106141:	6a 18                	push   $0x18
  jmp alltraps
80106143:	e9 4f fa ff ff       	jmp    80105b97 <alltraps>

80106148 <vector25>:
.globl vector25
vector25:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $25
8010614a:	6a 19                	push   $0x19
  jmp alltraps
8010614c:	e9 46 fa ff ff       	jmp    80105b97 <alltraps>

80106151 <vector26>:
.globl vector26
vector26:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $26
80106153:	6a 1a                	push   $0x1a
  jmp alltraps
80106155:	e9 3d fa ff ff       	jmp    80105b97 <alltraps>

8010615a <vector27>:
.globl vector27
vector27:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $27
8010615c:	6a 1b                	push   $0x1b
  jmp alltraps
8010615e:	e9 34 fa ff ff       	jmp    80105b97 <alltraps>

80106163 <vector28>:
.globl vector28
vector28:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $28
80106165:	6a 1c                	push   $0x1c
  jmp alltraps
80106167:	e9 2b fa ff ff       	jmp    80105b97 <alltraps>

8010616c <vector29>:
.globl vector29
vector29:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $29
8010616e:	6a 1d                	push   $0x1d
  jmp alltraps
80106170:	e9 22 fa ff ff       	jmp    80105b97 <alltraps>

80106175 <vector30>:
.globl vector30
vector30:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $30
80106177:	6a 1e                	push   $0x1e
  jmp alltraps
80106179:	e9 19 fa ff ff       	jmp    80105b97 <alltraps>

8010617e <vector31>:
.globl vector31
vector31:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $31
80106180:	6a 1f                	push   $0x1f
  jmp alltraps
80106182:	e9 10 fa ff ff       	jmp    80105b97 <alltraps>

80106187 <vector32>:
.globl vector32
vector32:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $32
80106189:	6a 20                	push   $0x20
  jmp alltraps
8010618b:	e9 07 fa ff ff       	jmp    80105b97 <alltraps>

80106190 <vector33>:
.globl vector33
vector33:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $33
80106192:	6a 21                	push   $0x21
  jmp alltraps
80106194:	e9 fe f9 ff ff       	jmp    80105b97 <alltraps>

80106199 <vector34>:
.globl vector34
vector34:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $34
8010619b:	6a 22                	push   $0x22
  jmp alltraps
8010619d:	e9 f5 f9 ff ff       	jmp    80105b97 <alltraps>

801061a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $35
801061a4:	6a 23                	push   $0x23
  jmp alltraps
801061a6:	e9 ec f9 ff ff       	jmp    80105b97 <alltraps>

801061ab <vector36>:
.globl vector36
vector36:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $36
801061ad:	6a 24                	push   $0x24
  jmp alltraps
801061af:	e9 e3 f9 ff ff       	jmp    80105b97 <alltraps>

801061b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $37
801061b6:	6a 25                	push   $0x25
  jmp alltraps
801061b8:	e9 da f9 ff ff       	jmp    80105b97 <alltraps>

801061bd <vector38>:
.globl vector38
vector38:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $38
801061bf:	6a 26                	push   $0x26
  jmp alltraps
801061c1:	e9 d1 f9 ff ff       	jmp    80105b97 <alltraps>

801061c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $39
801061c8:	6a 27                	push   $0x27
  jmp alltraps
801061ca:	e9 c8 f9 ff ff       	jmp    80105b97 <alltraps>

801061cf <vector40>:
.globl vector40
vector40:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $40
801061d1:	6a 28                	push   $0x28
  jmp alltraps
801061d3:	e9 bf f9 ff ff       	jmp    80105b97 <alltraps>

801061d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $41
801061da:	6a 29                	push   $0x29
  jmp alltraps
801061dc:	e9 b6 f9 ff ff       	jmp    80105b97 <alltraps>

801061e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $42
801061e3:	6a 2a                	push   $0x2a
  jmp alltraps
801061e5:	e9 ad f9 ff ff       	jmp    80105b97 <alltraps>

801061ea <vector43>:
.globl vector43
vector43:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $43
801061ec:	6a 2b                	push   $0x2b
  jmp alltraps
801061ee:	e9 a4 f9 ff ff       	jmp    80105b97 <alltraps>

801061f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $44
801061f5:	6a 2c                	push   $0x2c
  jmp alltraps
801061f7:	e9 9b f9 ff ff       	jmp    80105b97 <alltraps>

801061fc <vector45>:
.globl vector45
vector45:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $45
801061fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106200:	e9 92 f9 ff ff       	jmp    80105b97 <alltraps>

80106205 <vector46>:
.globl vector46
vector46:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $46
80106207:	6a 2e                	push   $0x2e
  jmp alltraps
80106209:	e9 89 f9 ff ff       	jmp    80105b97 <alltraps>

8010620e <vector47>:
.globl vector47
vector47:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $47
80106210:	6a 2f                	push   $0x2f
  jmp alltraps
80106212:	e9 80 f9 ff ff       	jmp    80105b97 <alltraps>

80106217 <vector48>:
.globl vector48
vector48:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $48
80106219:	6a 30                	push   $0x30
  jmp alltraps
8010621b:	e9 77 f9 ff ff       	jmp    80105b97 <alltraps>

80106220 <vector49>:
.globl vector49
vector49:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $49
80106222:	6a 31                	push   $0x31
  jmp alltraps
80106224:	e9 6e f9 ff ff       	jmp    80105b97 <alltraps>

80106229 <vector50>:
.globl vector50
vector50:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $50
8010622b:	6a 32                	push   $0x32
  jmp alltraps
8010622d:	e9 65 f9 ff ff       	jmp    80105b97 <alltraps>

80106232 <vector51>:
.globl vector51
vector51:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $51
80106234:	6a 33                	push   $0x33
  jmp alltraps
80106236:	e9 5c f9 ff ff       	jmp    80105b97 <alltraps>

8010623b <vector52>:
.globl vector52
vector52:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $52
8010623d:	6a 34                	push   $0x34
  jmp alltraps
8010623f:	e9 53 f9 ff ff       	jmp    80105b97 <alltraps>

80106244 <vector53>:
.globl vector53
vector53:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $53
80106246:	6a 35                	push   $0x35
  jmp alltraps
80106248:	e9 4a f9 ff ff       	jmp    80105b97 <alltraps>

8010624d <vector54>:
.globl vector54
vector54:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $54
8010624f:	6a 36                	push   $0x36
  jmp alltraps
80106251:	e9 41 f9 ff ff       	jmp    80105b97 <alltraps>

80106256 <vector55>:
.globl vector55
vector55:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $55
80106258:	6a 37                	push   $0x37
  jmp alltraps
8010625a:	e9 38 f9 ff ff       	jmp    80105b97 <alltraps>

8010625f <vector56>:
.globl vector56
vector56:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $56
80106261:	6a 38                	push   $0x38
  jmp alltraps
80106263:	e9 2f f9 ff ff       	jmp    80105b97 <alltraps>

80106268 <vector57>:
.globl vector57
vector57:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $57
8010626a:	6a 39                	push   $0x39
  jmp alltraps
8010626c:	e9 26 f9 ff ff       	jmp    80105b97 <alltraps>

80106271 <vector58>:
.globl vector58
vector58:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $58
80106273:	6a 3a                	push   $0x3a
  jmp alltraps
80106275:	e9 1d f9 ff ff       	jmp    80105b97 <alltraps>

8010627a <vector59>:
.globl vector59
vector59:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $59
8010627c:	6a 3b                	push   $0x3b
  jmp alltraps
8010627e:	e9 14 f9 ff ff       	jmp    80105b97 <alltraps>

80106283 <vector60>:
.globl vector60
vector60:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $60
80106285:	6a 3c                	push   $0x3c
  jmp alltraps
80106287:	e9 0b f9 ff ff       	jmp    80105b97 <alltraps>

8010628c <vector61>:
.globl vector61
vector61:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $61
8010628e:	6a 3d                	push   $0x3d
  jmp alltraps
80106290:	e9 02 f9 ff ff       	jmp    80105b97 <alltraps>

80106295 <vector62>:
.globl vector62
vector62:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $62
80106297:	6a 3e                	push   $0x3e
  jmp alltraps
80106299:	e9 f9 f8 ff ff       	jmp    80105b97 <alltraps>

8010629e <vector63>:
.globl vector63
vector63:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $63
801062a0:	6a 3f                	push   $0x3f
  jmp alltraps
801062a2:	e9 f0 f8 ff ff       	jmp    80105b97 <alltraps>

801062a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $64
801062a9:	6a 40                	push   $0x40
  jmp alltraps
801062ab:	e9 e7 f8 ff ff       	jmp    80105b97 <alltraps>

801062b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $65
801062b2:	6a 41                	push   $0x41
  jmp alltraps
801062b4:	e9 de f8 ff ff       	jmp    80105b97 <alltraps>

801062b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $66
801062bb:	6a 42                	push   $0x42
  jmp alltraps
801062bd:	e9 d5 f8 ff ff       	jmp    80105b97 <alltraps>

801062c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $67
801062c4:	6a 43                	push   $0x43
  jmp alltraps
801062c6:	e9 cc f8 ff ff       	jmp    80105b97 <alltraps>

801062cb <vector68>:
.globl vector68
vector68:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $68
801062cd:	6a 44                	push   $0x44
  jmp alltraps
801062cf:	e9 c3 f8 ff ff       	jmp    80105b97 <alltraps>

801062d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $69
801062d6:	6a 45                	push   $0x45
  jmp alltraps
801062d8:	e9 ba f8 ff ff       	jmp    80105b97 <alltraps>

801062dd <vector70>:
.globl vector70
vector70:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $70
801062df:	6a 46                	push   $0x46
  jmp alltraps
801062e1:	e9 b1 f8 ff ff       	jmp    80105b97 <alltraps>

801062e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $71
801062e8:	6a 47                	push   $0x47
  jmp alltraps
801062ea:	e9 a8 f8 ff ff       	jmp    80105b97 <alltraps>

801062ef <vector72>:
.globl vector72
vector72:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $72
801062f1:	6a 48                	push   $0x48
  jmp alltraps
801062f3:	e9 9f f8 ff ff       	jmp    80105b97 <alltraps>

801062f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $73
801062fa:	6a 49                	push   $0x49
  jmp alltraps
801062fc:	e9 96 f8 ff ff       	jmp    80105b97 <alltraps>

80106301 <vector74>:
.globl vector74
vector74:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $74
80106303:	6a 4a                	push   $0x4a
  jmp alltraps
80106305:	e9 8d f8 ff ff       	jmp    80105b97 <alltraps>

8010630a <vector75>:
.globl vector75
vector75:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $75
8010630c:	6a 4b                	push   $0x4b
  jmp alltraps
8010630e:	e9 84 f8 ff ff       	jmp    80105b97 <alltraps>

80106313 <vector76>:
.globl vector76
vector76:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $76
80106315:	6a 4c                	push   $0x4c
  jmp alltraps
80106317:	e9 7b f8 ff ff       	jmp    80105b97 <alltraps>

8010631c <vector77>:
.globl vector77
vector77:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $77
8010631e:	6a 4d                	push   $0x4d
  jmp alltraps
80106320:	e9 72 f8 ff ff       	jmp    80105b97 <alltraps>

80106325 <vector78>:
.globl vector78
vector78:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $78
80106327:	6a 4e                	push   $0x4e
  jmp alltraps
80106329:	e9 69 f8 ff ff       	jmp    80105b97 <alltraps>

8010632e <vector79>:
.globl vector79
vector79:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $79
80106330:	6a 4f                	push   $0x4f
  jmp alltraps
80106332:	e9 60 f8 ff ff       	jmp    80105b97 <alltraps>

80106337 <vector80>:
.globl vector80
vector80:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $80
80106339:	6a 50                	push   $0x50
  jmp alltraps
8010633b:	e9 57 f8 ff ff       	jmp    80105b97 <alltraps>

80106340 <vector81>:
.globl vector81
vector81:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $81
80106342:	6a 51                	push   $0x51
  jmp alltraps
80106344:	e9 4e f8 ff ff       	jmp    80105b97 <alltraps>

80106349 <vector82>:
.globl vector82
vector82:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $82
8010634b:	6a 52                	push   $0x52
  jmp alltraps
8010634d:	e9 45 f8 ff ff       	jmp    80105b97 <alltraps>

80106352 <vector83>:
.globl vector83
vector83:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $83
80106354:	6a 53                	push   $0x53
  jmp alltraps
80106356:	e9 3c f8 ff ff       	jmp    80105b97 <alltraps>

8010635b <vector84>:
.globl vector84
vector84:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $84
8010635d:	6a 54                	push   $0x54
  jmp alltraps
8010635f:	e9 33 f8 ff ff       	jmp    80105b97 <alltraps>

80106364 <vector85>:
.globl vector85
vector85:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $85
80106366:	6a 55                	push   $0x55
  jmp alltraps
80106368:	e9 2a f8 ff ff       	jmp    80105b97 <alltraps>

8010636d <vector86>:
.globl vector86
vector86:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $86
8010636f:	6a 56                	push   $0x56
  jmp alltraps
80106371:	e9 21 f8 ff ff       	jmp    80105b97 <alltraps>

80106376 <vector87>:
.globl vector87
vector87:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $87
80106378:	6a 57                	push   $0x57
  jmp alltraps
8010637a:	e9 18 f8 ff ff       	jmp    80105b97 <alltraps>

8010637f <vector88>:
.globl vector88
vector88:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $88
80106381:	6a 58                	push   $0x58
  jmp alltraps
80106383:	e9 0f f8 ff ff       	jmp    80105b97 <alltraps>

80106388 <vector89>:
.globl vector89
vector89:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $89
8010638a:	6a 59                	push   $0x59
  jmp alltraps
8010638c:	e9 06 f8 ff ff       	jmp    80105b97 <alltraps>

80106391 <vector90>:
.globl vector90
vector90:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $90
80106393:	6a 5a                	push   $0x5a
  jmp alltraps
80106395:	e9 fd f7 ff ff       	jmp    80105b97 <alltraps>

8010639a <vector91>:
.globl vector91
vector91:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $91
8010639c:	6a 5b                	push   $0x5b
  jmp alltraps
8010639e:	e9 f4 f7 ff ff       	jmp    80105b97 <alltraps>

801063a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $92
801063a5:	6a 5c                	push   $0x5c
  jmp alltraps
801063a7:	e9 eb f7 ff ff       	jmp    80105b97 <alltraps>

801063ac <vector93>:
.globl vector93
vector93:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $93
801063ae:	6a 5d                	push   $0x5d
  jmp alltraps
801063b0:	e9 e2 f7 ff ff       	jmp    80105b97 <alltraps>

801063b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $94
801063b7:	6a 5e                	push   $0x5e
  jmp alltraps
801063b9:	e9 d9 f7 ff ff       	jmp    80105b97 <alltraps>

801063be <vector95>:
.globl vector95
vector95:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $95
801063c0:	6a 5f                	push   $0x5f
  jmp alltraps
801063c2:	e9 d0 f7 ff ff       	jmp    80105b97 <alltraps>

801063c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $96
801063c9:	6a 60                	push   $0x60
  jmp alltraps
801063cb:	e9 c7 f7 ff ff       	jmp    80105b97 <alltraps>

801063d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $97
801063d2:	6a 61                	push   $0x61
  jmp alltraps
801063d4:	e9 be f7 ff ff       	jmp    80105b97 <alltraps>

801063d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $98
801063db:	6a 62                	push   $0x62
  jmp alltraps
801063dd:	e9 b5 f7 ff ff       	jmp    80105b97 <alltraps>

801063e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $99
801063e4:	6a 63                	push   $0x63
  jmp alltraps
801063e6:	e9 ac f7 ff ff       	jmp    80105b97 <alltraps>

801063eb <vector100>:
.globl vector100
vector100:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $100
801063ed:	6a 64                	push   $0x64
  jmp alltraps
801063ef:	e9 a3 f7 ff ff       	jmp    80105b97 <alltraps>

801063f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $101
801063f6:	6a 65                	push   $0x65
  jmp alltraps
801063f8:	e9 9a f7 ff ff       	jmp    80105b97 <alltraps>

801063fd <vector102>:
.globl vector102
vector102:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $102
801063ff:	6a 66                	push   $0x66
  jmp alltraps
80106401:	e9 91 f7 ff ff       	jmp    80105b97 <alltraps>

80106406 <vector103>:
.globl vector103
vector103:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $103
80106408:	6a 67                	push   $0x67
  jmp alltraps
8010640a:	e9 88 f7 ff ff       	jmp    80105b97 <alltraps>

8010640f <vector104>:
.globl vector104
vector104:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $104
80106411:	6a 68                	push   $0x68
  jmp alltraps
80106413:	e9 7f f7 ff ff       	jmp    80105b97 <alltraps>

80106418 <vector105>:
.globl vector105
vector105:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $105
8010641a:	6a 69                	push   $0x69
  jmp alltraps
8010641c:	e9 76 f7 ff ff       	jmp    80105b97 <alltraps>

80106421 <vector106>:
.globl vector106
vector106:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $106
80106423:	6a 6a                	push   $0x6a
  jmp alltraps
80106425:	e9 6d f7 ff ff       	jmp    80105b97 <alltraps>

8010642a <vector107>:
.globl vector107
vector107:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $107
8010642c:	6a 6b                	push   $0x6b
  jmp alltraps
8010642e:	e9 64 f7 ff ff       	jmp    80105b97 <alltraps>

80106433 <vector108>:
.globl vector108
vector108:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $108
80106435:	6a 6c                	push   $0x6c
  jmp alltraps
80106437:	e9 5b f7 ff ff       	jmp    80105b97 <alltraps>

8010643c <vector109>:
.globl vector109
vector109:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $109
8010643e:	6a 6d                	push   $0x6d
  jmp alltraps
80106440:	e9 52 f7 ff ff       	jmp    80105b97 <alltraps>

80106445 <vector110>:
.globl vector110
vector110:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $110
80106447:	6a 6e                	push   $0x6e
  jmp alltraps
80106449:	e9 49 f7 ff ff       	jmp    80105b97 <alltraps>

8010644e <vector111>:
.globl vector111
vector111:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $111
80106450:	6a 6f                	push   $0x6f
  jmp alltraps
80106452:	e9 40 f7 ff ff       	jmp    80105b97 <alltraps>

80106457 <vector112>:
.globl vector112
vector112:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $112
80106459:	6a 70                	push   $0x70
  jmp alltraps
8010645b:	e9 37 f7 ff ff       	jmp    80105b97 <alltraps>

80106460 <vector113>:
.globl vector113
vector113:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $113
80106462:	6a 71                	push   $0x71
  jmp alltraps
80106464:	e9 2e f7 ff ff       	jmp    80105b97 <alltraps>

80106469 <vector114>:
.globl vector114
vector114:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $114
8010646b:	6a 72                	push   $0x72
  jmp alltraps
8010646d:	e9 25 f7 ff ff       	jmp    80105b97 <alltraps>

80106472 <vector115>:
.globl vector115
vector115:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $115
80106474:	6a 73                	push   $0x73
  jmp alltraps
80106476:	e9 1c f7 ff ff       	jmp    80105b97 <alltraps>

8010647b <vector116>:
.globl vector116
vector116:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $116
8010647d:	6a 74                	push   $0x74
  jmp alltraps
8010647f:	e9 13 f7 ff ff       	jmp    80105b97 <alltraps>

80106484 <vector117>:
.globl vector117
vector117:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $117
80106486:	6a 75                	push   $0x75
  jmp alltraps
80106488:	e9 0a f7 ff ff       	jmp    80105b97 <alltraps>

8010648d <vector118>:
.globl vector118
vector118:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $118
8010648f:	6a 76                	push   $0x76
  jmp alltraps
80106491:	e9 01 f7 ff ff       	jmp    80105b97 <alltraps>

80106496 <vector119>:
.globl vector119
vector119:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $119
80106498:	6a 77                	push   $0x77
  jmp alltraps
8010649a:	e9 f8 f6 ff ff       	jmp    80105b97 <alltraps>

8010649f <vector120>:
.globl vector120
vector120:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $120
801064a1:	6a 78                	push   $0x78
  jmp alltraps
801064a3:	e9 ef f6 ff ff       	jmp    80105b97 <alltraps>

801064a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $121
801064aa:	6a 79                	push   $0x79
  jmp alltraps
801064ac:	e9 e6 f6 ff ff       	jmp    80105b97 <alltraps>

801064b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $122
801064b3:	6a 7a                	push   $0x7a
  jmp alltraps
801064b5:	e9 dd f6 ff ff       	jmp    80105b97 <alltraps>

801064ba <vector123>:
.globl vector123
vector123:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $123
801064bc:	6a 7b                	push   $0x7b
  jmp alltraps
801064be:	e9 d4 f6 ff ff       	jmp    80105b97 <alltraps>

801064c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $124
801064c5:	6a 7c                	push   $0x7c
  jmp alltraps
801064c7:	e9 cb f6 ff ff       	jmp    80105b97 <alltraps>

801064cc <vector125>:
.globl vector125
vector125:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $125
801064ce:	6a 7d                	push   $0x7d
  jmp alltraps
801064d0:	e9 c2 f6 ff ff       	jmp    80105b97 <alltraps>

801064d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $126
801064d7:	6a 7e                	push   $0x7e
  jmp alltraps
801064d9:	e9 b9 f6 ff ff       	jmp    80105b97 <alltraps>

801064de <vector127>:
.globl vector127
vector127:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $127
801064e0:	6a 7f                	push   $0x7f
  jmp alltraps
801064e2:	e9 b0 f6 ff ff       	jmp    80105b97 <alltraps>

801064e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $128
801064e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064ee:	e9 a4 f6 ff ff       	jmp    80105b97 <alltraps>

801064f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $129
801064f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064fa:	e9 98 f6 ff ff       	jmp    80105b97 <alltraps>

801064ff <vector130>:
.globl vector130
vector130:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $130
80106501:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106506:	e9 8c f6 ff ff       	jmp    80105b97 <alltraps>

8010650b <vector131>:
.globl vector131
vector131:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $131
8010650d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106512:	e9 80 f6 ff ff       	jmp    80105b97 <alltraps>

80106517 <vector132>:
.globl vector132
vector132:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $132
80106519:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010651e:	e9 74 f6 ff ff       	jmp    80105b97 <alltraps>

80106523 <vector133>:
.globl vector133
vector133:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $133
80106525:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010652a:	e9 68 f6 ff ff       	jmp    80105b97 <alltraps>

8010652f <vector134>:
.globl vector134
vector134:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $134
80106531:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106536:	e9 5c f6 ff ff       	jmp    80105b97 <alltraps>

8010653b <vector135>:
.globl vector135
vector135:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $135
8010653d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106542:	e9 50 f6 ff ff       	jmp    80105b97 <alltraps>

80106547 <vector136>:
.globl vector136
vector136:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $136
80106549:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010654e:	e9 44 f6 ff ff       	jmp    80105b97 <alltraps>

80106553 <vector137>:
.globl vector137
vector137:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $137
80106555:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010655a:	e9 38 f6 ff ff       	jmp    80105b97 <alltraps>

8010655f <vector138>:
.globl vector138
vector138:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $138
80106561:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106566:	e9 2c f6 ff ff       	jmp    80105b97 <alltraps>

8010656b <vector139>:
.globl vector139
vector139:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $139
8010656d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106572:	e9 20 f6 ff ff       	jmp    80105b97 <alltraps>

80106577 <vector140>:
.globl vector140
vector140:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $140
80106579:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010657e:	e9 14 f6 ff ff       	jmp    80105b97 <alltraps>

80106583 <vector141>:
.globl vector141
vector141:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $141
80106585:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010658a:	e9 08 f6 ff ff       	jmp    80105b97 <alltraps>

8010658f <vector142>:
.globl vector142
vector142:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $142
80106591:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106596:	e9 fc f5 ff ff       	jmp    80105b97 <alltraps>

8010659b <vector143>:
.globl vector143
vector143:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $143
8010659d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801065a2:	e9 f0 f5 ff ff       	jmp    80105b97 <alltraps>

801065a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $144
801065a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801065ae:	e9 e4 f5 ff ff       	jmp    80105b97 <alltraps>

801065b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $145
801065b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065ba:	e9 d8 f5 ff ff       	jmp    80105b97 <alltraps>

801065bf <vector146>:
.globl vector146
vector146:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $146
801065c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065c6:	e9 cc f5 ff ff       	jmp    80105b97 <alltraps>

801065cb <vector147>:
.globl vector147
vector147:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $147
801065cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065d2:	e9 c0 f5 ff ff       	jmp    80105b97 <alltraps>

801065d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $148
801065d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065de:	e9 b4 f5 ff ff       	jmp    80105b97 <alltraps>

801065e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $149
801065e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065ea:	e9 a8 f5 ff ff       	jmp    80105b97 <alltraps>

801065ef <vector150>:
.globl vector150
vector150:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $150
801065f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065f6:	e9 9c f5 ff ff       	jmp    80105b97 <alltraps>

801065fb <vector151>:
.globl vector151
vector151:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $151
801065fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106602:	e9 90 f5 ff ff       	jmp    80105b97 <alltraps>

80106607 <vector152>:
.globl vector152
vector152:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $152
80106609:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010660e:	e9 84 f5 ff ff       	jmp    80105b97 <alltraps>

80106613 <vector153>:
.globl vector153
vector153:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $153
80106615:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010661a:	e9 78 f5 ff ff       	jmp    80105b97 <alltraps>

8010661f <vector154>:
.globl vector154
vector154:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $154
80106621:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106626:	e9 6c f5 ff ff       	jmp    80105b97 <alltraps>

8010662b <vector155>:
.globl vector155
vector155:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $155
8010662d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106632:	e9 60 f5 ff ff       	jmp    80105b97 <alltraps>

80106637 <vector156>:
.globl vector156
vector156:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $156
80106639:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010663e:	e9 54 f5 ff ff       	jmp    80105b97 <alltraps>

80106643 <vector157>:
.globl vector157
vector157:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $157
80106645:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010664a:	e9 48 f5 ff ff       	jmp    80105b97 <alltraps>

8010664f <vector158>:
.globl vector158
vector158:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $158
80106651:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106656:	e9 3c f5 ff ff       	jmp    80105b97 <alltraps>

8010665b <vector159>:
.globl vector159
vector159:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $159
8010665d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106662:	e9 30 f5 ff ff       	jmp    80105b97 <alltraps>

80106667 <vector160>:
.globl vector160
vector160:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $160
80106669:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010666e:	e9 24 f5 ff ff       	jmp    80105b97 <alltraps>

80106673 <vector161>:
.globl vector161
vector161:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $161
80106675:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010667a:	e9 18 f5 ff ff       	jmp    80105b97 <alltraps>

8010667f <vector162>:
.globl vector162
vector162:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $162
80106681:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106686:	e9 0c f5 ff ff       	jmp    80105b97 <alltraps>

8010668b <vector163>:
.globl vector163
vector163:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $163
8010668d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106692:	e9 00 f5 ff ff       	jmp    80105b97 <alltraps>

80106697 <vector164>:
.globl vector164
vector164:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $164
80106699:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010669e:	e9 f4 f4 ff ff       	jmp    80105b97 <alltraps>

801066a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $165
801066a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801066aa:	e9 e8 f4 ff ff       	jmp    80105b97 <alltraps>

801066af <vector166>:
.globl vector166
vector166:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $166
801066b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066b6:	e9 dc f4 ff ff       	jmp    80105b97 <alltraps>

801066bb <vector167>:
.globl vector167
vector167:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $167
801066bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066c2:	e9 d0 f4 ff ff       	jmp    80105b97 <alltraps>

801066c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $168
801066c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066ce:	e9 c4 f4 ff ff       	jmp    80105b97 <alltraps>

801066d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $169
801066d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066da:	e9 b8 f4 ff ff       	jmp    80105b97 <alltraps>

801066df <vector170>:
.globl vector170
vector170:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $170
801066e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066e6:	e9 ac f4 ff ff       	jmp    80105b97 <alltraps>

801066eb <vector171>:
.globl vector171
vector171:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $171
801066ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066f2:	e9 a0 f4 ff ff       	jmp    80105b97 <alltraps>

801066f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $172
801066f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066fe:	e9 94 f4 ff ff       	jmp    80105b97 <alltraps>

80106703 <vector173>:
.globl vector173
vector173:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $173
80106705:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010670a:	e9 88 f4 ff ff       	jmp    80105b97 <alltraps>

8010670f <vector174>:
.globl vector174
vector174:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $174
80106711:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106716:	e9 7c f4 ff ff       	jmp    80105b97 <alltraps>

8010671b <vector175>:
.globl vector175
vector175:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $175
8010671d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106722:	e9 70 f4 ff ff       	jmp    80105b97 <alltraps>

80106727 <vector176>:
.globl vector176
vector176:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $176
80106729:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010672e:	e9 64 f4 ff ff       	jmp    80105b97 <alltraps>

80106733 <vector177>:
.globl vector177
vector177:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $177
80106735:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010673a:	e9 58 f4 ff ff       	jmp    80105b97 <alltraps>

8010673f <vector178>:
.globl vector178
vector178:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $178
80106741:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106746:	e9 4c f4 ff ff       	jmp    80105b97 <alltraps>

8010674b <vector179>:
.globl vector179
vector179:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $179
8010674d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106752:	e9 40 f4 ff ff       	jmp    80105b97 <alltraps>

80106757 <vector180>:
.globl vector180
vector180:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $180
80106759:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010675e:	e9 34 f4 ff ff       	jmp    80105b97 <alltraps>

80106763 <vector181>:
.globl vector181
vector181:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $181
80106765:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010676a:	e9 28 f4 ff ff       	jmp    80105b97 <alltraps>

8010676f <vector182>:
.globl vector182
vector182:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $182
80106771:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106776:	e9 1c f4 ff ff       	jmp    80105b97 <alltraps>

8010677b <vector183>:
.globl vector183
vector183:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $183
8010677d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106782:	e9 10 f4 ff ff       	jmp    80105b97 <alltraps>

80106787 <vector184>:
.globl vector184
vector184:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $184
80106789:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010678e:	e9 04 f4 ff ff       	jmp    80105b97 <alltraps>

80106793 <vector185>:
.globl vector185
vector185:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $185
80106795:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010679a:	e9 f8 f3 ff ff       	jmp    80105b97 <alltraps>

8010679f <vector186>:
.globl vector186
vector186:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $186
801067a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801067a6:	e9 ec f3 ff ff       	jmp    80105b97 <alltraps>

801067ab <vector187>:
.globl vector187
vector187:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $187
801067ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067b2:	e9 e0 f3 ff ff       	jmp    80105b97 <alltraps>

801067b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $188
801067b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067be:	e9 d4 f3 ff ff       	jmp    80105b97 <alltraps>

801067c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $189
801067c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067ca:	e9 c8 f3 ff ff       	jmp    80105b97 <alltraps>

801067cf <vector190>:
.globl vector190
vector190:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $190
801067d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067d6:	e9 bc f3 ff ff       	jmp    80105b97 <alltraps>

801067db <vector191>:
.globl vector191
vector191:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $191
801067dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067e2:	e9 b0 f3 ff ff       	jmp    80105b97 <alltraps>

801067e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $192
801067e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067ee:	e9 a4 f3 ff ff       	jmp    80105b97 <alltraps>

801067f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $193
801067f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067fa:	e9 98 f3 ff ff       	jmp    80105b97 <alltraps>

801067ff <vector194>:
.globl vector194
vector194:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $194
80106801:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106806:	e9 8c f3 ff ff       	jmp    80105b97 <alltraps>

8010680b <vector195>:
.globl vector195
vector195:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $195
8010680d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106812:	e9 80 f3 ff ff       	jmp    80105b97 <alltraps>

80106817 <vector196>:
.globl vector196
vector196:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $196
80106819:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010681e:	e9 74 f3 ff ff       	jmp    80105b97 <alltraps>

80106823 <vector197>:
.globl vector197
vector197:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $197
80106825:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010682a:	e9 68 f3 ff ff       	jmp    80105b97 <alltraps>

8010682f <vector198>:
.globl vector198
vector198:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $198
80106831:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106836:	e9 5c f3 ff ff       	jmp    80105b97 <alltraps>

8010683b <vector199>:
.globl vector199
vector199:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $199
8010683d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106842:	e9 50 f3 ff ff       	jmp    80105b97 <alltraps>

80106847 <vector200>:
.globl vector200
vector200:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $200
80106849:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010684e:	e9 44 f3 ff ff       	jmp    80105b97 <alltraps>

80106853 <vector201>:
.globl vector201
vector201:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $201
80106855:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010685a:	e9 38 f3 ff ff       	jmp    80105b97 <alltraps>

8010685f <vector202>:
.globl vector202
vector202:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $202
80106861:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106866:	e9 2c f3 ff ff       	jmp    80105b97 <alltraps>

8010686b <vector203>:
.globl vector203
vector203:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $203
8010686d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106872:	e9 20 f3 ff ff       	jmp    80105b97 <alltraps>

80106877 <vector204>:
.globl vector204
vector204:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $204
80106879:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010687e:	e9 14 f3 ff ff       	jmp    80105b97 <alltraps>

80106883 <vector205>:
.globl vector205
vector205:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $205
80106885:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010688a:	e9 08 f3 ff ff       	jmp    80105b97 <alltraps>

8010688f <vector206>:
.globl vector206
vector206:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $206
80106891:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106896:	e9 fc f2 ff ff       	jmp    80105b97 <alltraps>

8010689b <vector207>:
.globl vector207
vector207:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $207
8010689d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801068a2:	e9 f0 f2 ff ff       	jmp    80105b97 <alltraps>

801068a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $208
801068a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801068ae:	e9 e4 f2 ff ff       	jmp    80105b97 <alltraps>

801068b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $209
801068b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068ba:	e9 d8 f2 ff ff       	jmp    80105b97 <alltraps>

801068bf <vector210>:
.globl vector210
vector210:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $210
801068c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068c6:	e9 cc f2 ff ff       	jmp    80105b97 <alltraps>

801068cb <vector211>:
.globl vector211
vector211:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $211
801068cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068d2:	e9 c0 f2 ff ff       	jmp    80105b97 <alltraps>

801068d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $212
801068d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068de:	e9 b4 f2 ff ff       	jmp    80105b97 <alltraps>

801068e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $213
801068e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068ea:	e9 a8 f2 ff ff       	jmp    80105b97 <alltraps>

801068ef <vector214>:
.globl vector214
vector214:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $214
801068f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068f6:	e9 9c f2 ff ff       	jmp    80105b97 <alltraps>

801068fb <vector215>:
.globl vector215
vector215:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $215
801068fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106902:	e9 90 f2 ff ff       	jmp    80105b97 <alltraps>

80106907 <vector216>:
.globl vector216
vector216:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $216
80106909:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010690e:	e9 84 f2 ff ff       	jmp    80105b97 <alltraps>

80106913 <vector217>:
.globl vector217
vector217:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $217
80106915:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010691a:	e9 78 f2 ff ff       	jmp    80105b97 <alltraps>

8010691f <vector218>:
.globl vector218
vector218:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $218
80106921:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106926:	e9 6c f2 ff ff       	jmp    80105b97 <alltraps>

8010692b <vector219>:
.globl vector219
vector219:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $219
8010692d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106932:	e9 60 f2 ff ff       	jmp    80105b97 <alltraps>

80106937 <vector220>:
.globl vector220
vector220:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $220
80106939:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010693e:	e9 54 f2 ff ff       	jmp    80105b97 <alltraps>

80106943 <vector221>:
.globl vector221
vector221:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $221
80106945:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010694a:	e9 48 f2 ff ff       	jmp    80105b97 <alltraps>

8010694f <vector222>:
.globl vector222
vector222:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $222
80106951:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106956:	e9 3c f2 ff ff       	jmp    80105b97 <alltraps>

8010695b <vector223>:
.globl vector223
vector223:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $223
8010695d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106962:	e9 30 f2 ff ff       	jmp    80105b97 <alltraps>

80106967 <vector224>:
.globl vector224
vector224:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $224
80106969:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010696e:	e9 24 f2 ff ff       	jmp    80105b97 <alltraps>

80106973 <vector225>:
.globl vector225
vector225:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $225
80106975:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010697a:	e9 18 f2 ff ff       	jmp    80105b97 <alltraps>

8010697f <vector226>:
.globl vector226
vector226:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $226
80106981:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106986:	e9 0c f2 ff ff       	jmp    80105b97 <alltraps>

8010698b <vector227>:
.globl vector227
vector227:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $227
8010698d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106992:	e9 00 f2 ff ff       	jmp    80105b97 <alltraps>

80106997 <vector228>:
.globl vector228
vector228:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $228
80106999:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010699e:	e9 f4 f1 ff ff       	jmp    80105b97 <alltraps>

801069a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $229
801069a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801069aa:	e9 e8 f1 ff ff       	jmp    80105b97 <alltraps>

801069af <vector230>:
.globl vector230
vector230:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $230
801069b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069b6:	e9 dc f1 ff ff       	jmp    80105b97 <alltraps>

801069bb <vector231>:
.globl vector231
vector231:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $231
801069bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069c2:	e9 d0 f1 ff ff       	jmp    80105b97 <alltraps>

801069c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $232
801069c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069ce:	e9 c4 f1 ff ff       	jmp    80105b97 <alltraps>

801069d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $233
801069d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069da:	e9 b8 f1 ff ff       	jmp    80105b97 <alltraps>

801069df <vector234>:
.globl vector234
vector234:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $234
801069e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069e6:	e9 ac f1 ff ff       	jmp    80105b97 <alltraps>

801069eb <vector235>:
.globl vector235
vector235:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $235
801069ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069f2:	e9 a0 f1 ff ff       	jmp    80105b97 <alltraps>

801069f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $236
801069f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069fe:	e9 94 f1 ff ff       	jmp    80105b97 <alltraps>

80106a03 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $237
80106a05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a0a:	e9 88 f1 ff ff       	jmp    80105b97 <alltraps>

80106a0f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $238
80106a11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a16:	e9 7c f1 ff ff       	jmp    80105b97 <alltraps>

80106a1b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $239
80106a1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a22:	e9 70 f1 ff ff       	jmp    80105b97 <alltraps>

80106a27 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $240
80106a29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a2e:	e9 64 f1 ff ff       	jmp    80105b97 <alltraps>

80106a33 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $241
80106a35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a3a:	e9 58 f1 ff ff       	jmp    80105b97 <alltraps>

80106a3f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $242
80106a41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a46:	e9 4c f1 ff ff       	jmp    80105b97 <alltraps>

80106a4b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $243
80106a4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a52:	e9 40 f1 ff ff       	jmp    80105b97 <alltraps>

80106a57 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $244
80106a59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a5e:	e9 34 f1 ff ff       	jmp    80105b97 <alltraps>

80106a63 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $245
80106a65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a6a:	e9 28 f1 ff ff       	jmp    80105b97 <alltraps>

80106a6f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $246
80106a71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a76:	e9 1c f1 ff ff       	jmp    80105b97 <alltraps>

80106a7b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $247
80106a7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a82:	e9 10 f1 ff ff       	jmp    80105b97 <alltraps>

80106a87 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $248
80106a89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a8e:	e9 04 f1 ff ff       	jmp    80105b97 <alltraps>

80106a93 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $249
80106a95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a9a:	e9 f8 f0 ff ff       	jmp    80105b97 <alltraps>

80106a9f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $250
80106aa1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106aa6:	e9 ec f0 ff ff       	jmp    80105b97 <alltraps>

80106aab <vector251>:
.globl vector251
vector251:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $251
80106aad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ab2:	e9 e0 f0 ff ff       	jmp    80105b97 <alltraps>

80106ab7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $252
80106ab9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106abe:	e9 d4 f0 ff ff       	jmp    80105b97 <alltraps>

80106ac3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $253
80106ac5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106aca:	e9 c8 f0 ff ff       	jmp    80105b97 <alltraps>

80106acf <vector254>:
.globl vector254
vector254:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $254
80106ad1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ad6:	e9 bc f0 ff ff       	jmp    80105b97 <alltraps>

80106adb <vector255>:
.globl vector255
vector255:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $255
80106add:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ae2:	e9 b0 f0 ff ff       	jmp    80105b97 <alltraps>
80106ae7:	66 90                	xchg   %ax,%ax
80106ae9:	66 90                	xchg   %ax,%ax
80106aeb:	66 90                	xchg   %ax,%ax
80106aed:	66 90                	xchg   %ax,%ax
80106aef:	90                   	nop

80106af0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106af6:	89 d3                	mov    %edx,%ebx
{
80106af8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106afa:	c1 eb 16             	shr    $0x16,%ebx
80106afd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106b00:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106b03:	8b 06                	mov    (%esi),%eax
80106b05:	a8 01                	test   $0x1,%al
80106b07:	74 27                	je     80106b30 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b0e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106b14:	c1 ef 0a             	shr    $0xa,%edi
}
80106b17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106b1a:	89 fa                	mov    %edi,%edx
80106b1c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b22:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106b25:	5b                   	pop    %ebx
80106b26:	5e                   	pop    %esi
80106b27:	5f                   	pop    %edi
80106b28:	5d                   	pop    %ebp
80106b29:	c3                   	ret    
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b30:	85 c9                	test   %ecx,%ecx
80106b32:	74 2c                	je     80106b60 <walkpgdir+0x70>
80106b34:	e8 97 b9 ff ff       	call   801024d0 <kalloc>
80106b39:	85 c0                	test   %eax,%eax
80106b3b:	89 c3                	mov    %eax,%ebx
80106b3d:	74 21                	je     80106b60 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106b3f:	83 ec 04             	sub    $0x4,%esp
80106b42:	68 00 10 00 00       	push   $0x1000
80106b47:	6a 00                	push   $0x0
80106b49:	50                   	push   %eax
80106b4a:	e8 21 de ff ff       	call   80104970 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b4f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b55:	83 c4 10             	add    $0x10,%esp
80106b58:	83 c8 07             	or     $0x7,%eax
80106b5b:	89 06                	mov    %eax,(%esi)
80106b5d:	eb b5                	jmp    80106b14 <walkpgdir+0x24>
80106b5f:	90                   	nop
}
80106b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b63:	31 c0                	xor    %eax,%eax
}
80106b65:	5b                   	pop    %ebx
80106b66:	5e                   	pop    %esi
80106b67:	5f                   	pop    %edi
80106b68:	5d                   	pop    %ebp
80106b69:	c3                   	ret    
80106b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b70 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b76:	89 d3                	mov    %edx,%ebx
80106b78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b7e:	83 ec 1c             	sub    $0x1c,%esp
80106b81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b84:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b88:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b93:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b96:	29 df                	sub    %ebx,%edi
80106b98:	83 c8 01             	or     $0x1,%eax
80106b9b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b9e:	eb 15                	jmp    80106bb5 <mappages+0x45>
    if(*pte & PTE_P)
80106ba0:	f6 00 01             	testb  $0x1,(%eax)
80106ba3:	75 45                	jne    80106bea <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106ba5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106ba8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106bab:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106bad:	74 31                	je     80106be0 <mappages+0x70>
      break;
    a += PGSIZE;
80106baf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106bb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bb8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106bbd:	89 da                	mov    %ebx,%edx
80106bbf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106bc2:	e8 29 ff ff ff       	call   80106af0 <walkpgdir>
80106bc7:	85 c0                	test   %eax,%eax
80106bc9:	75 d5                	jne    80106ba0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106bcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bd3:	5b                   	pop    %ebx
80106bd4:	5e                   	pop    %esi
80106bd5:	5f                   	pop    %edi
80106bd6:	5d                   	pop    %ebp
80106bd7:	c3                   	ret    
80106bd8:	90                   	nop
80106bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106be3:	31 c0                	xor    %eax,%eax
}
80106be5:	5b                   	pop    %ebx
80106be6:	5e                   	pop    %esi
80106be7:	5f                   	pop    %edi
80106be8:	5d                   	pop    %ebp
80106be9:	c3                   	ret    
      panic("remap");
80106bea:	83 ec 0c             	sub    $0xc,%esp
80106bed:	68 ec 7c 10 80       	push   $0x80107cec
80106bf2:	e8 99 97 ff ff       	call   80100390 <panic>
80106bf7:	89 f6                	mov    %esi,%esi
80106bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c0c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106c0e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c14:	83 ec 1c             	sub    $0x1c,%esp
80106c17:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c1a:	39 d3                	cmp    %edx,%ebx
80106c1c:	73 66                	jae    80106c84 <deallocuvm.part.0+0x84>
80106c1e:	89 d6                	mov    %edx,%esi
80106c20:	eb 3d                	jmp    80106c5f <deallocuvm.part.0+0x5f>
80106c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106c28:	8b 10                	mov    (%eax),%edx
80106c2a:	f6 c2 01             	test   $0x1,%dl
80106c2d:	74 26                	je     80106c55 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106c2f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c35:	74 58                	je     80106c8f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106c37:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c3a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106c43:	52                   	push   %edx
80106c44:	e8 d7 b6 ff ff       	call   80102320 <kfree>
      *pte = 0;
80106c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c4c:	83 c4 10             	add    $0x10,%esp
80106c4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106c55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c5b:	39 f3                	cmp    %esi,%ebx
80106c5d:	73 25                	jae    80106c84 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106c5f:	31 c9                	xor    %ecx,%ecx
80106c61:	89 da                	mov    %ebx,%edx
80106c63:	89 f8                	mov    %edi,%eax
80106c65:	e8 86 fe ff ff       	call   80106af0 <walkpgdir>
    if(!pte)
80106c6a:	85 c0                	test   %eax,%eax
80106c6c:	75 ba                	jne    80106c28 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c6e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c74:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c80:	39 f3                	cmp    %esi,%ebx
80106c82:	72 db                	jb     80106c5f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106c84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c8a:	5b                   	pop    %ebx
80106c8b:	5e                   	pop    %esi
80106c8c:	5f                   	pop    %edi
80106c8d:	5d                   	pop    %ebp
80106c8e:	c3                   	ret    
        panic("kfree");
80106c8f:	83 ec 0c             	sub    $0xc,%esp
80106c92:	68 86 76 10 80       	push   $0x80107686
80106c97:	e8 f4 96 ff ff       	call   80100390 <panic>
80106c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ca0 <seginit>:
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ca6:	e8 65 cf ff ff       	call   80103c10 <cpuid>
80106cab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106cb1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106cb6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106cba:	c7 80 38 28 11 80 ff 	movl   $0xffff,-0x7feed7c8(%eax)
80106cc1:	ff 00 00 
80106cc4:	c7 80 3c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7c4(%eax)
80106ccb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cce:	c7 80 40 28 11 80 ff 	movl   $0xffff,-0x7feed7c0(%eax)
80106cd5:	ff 00 00 
80106cd8:	c7 80 44 28 11 80 00 	movl   $0xcf9200,-0x7feed7bc(%eax)
80106cdf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ce2:	c7 80 48 28 11 80 ff 	movl   $0xffff,-0x7feed7b8(%eax)
80106ce9:	ff 00 00 
80106cec:	c7 80 4c 28 11 80 00 	movl   $0xcffa00,-0x7feed7b4(%eax)
80106cf3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cf6:	c7 80 50 28 11 80 ff 	movl   $0xffff,-0x7feed7b0(%eax)
80106cfd:	ff 00 00 
80106d00:	c7 80 54 28 11 80 00 	movl   $0xcff200,-0x7feed7ac(%eax)
80106d07:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d0a:	05 30 28 11 80       	add    $0x80112830,%eax
  pd[1] = (uint)p;
80106d0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d13:	c1 e8 10             	shr    $0x10,%eax
80106d16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d1d:	0f 01 10             	lgdtl  (%eax)
}
80106d20:	c9                   	leave  
80106d21:	c3                   	ret    
80106d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d30:	a1 04 36 11 80       	mov    0x80113604,%eax
{
80106d35:	55                   	push   %ebp
80106d36:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d38:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d3d:	0f 22 d8             	mov    %eax,%cr3
}
80106d40:	5d                   	pop    %ebp
80106d41:	c3                   	ret    
80106d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d50 <switchuvm>:
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	57                   	push   %edi
80106d54:	56                   	push   %esi
80106d55:	53                   	push   %ebx
80106d56:	83 ec 1c             	sub    $0x1c,%esp
80106d59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106d5c:	85 db                	test   %ebx,%ebx
80106d5e:	0f 84 cb 00 00 00    	je     80106e2f <switchuvm+0xdf>
  if(p->kstack == 0)
80106d64:	8b 43 08             	mov    0x8(%ebx),%eax
80106d67:	85 c0                	test   %eax,%eax
80106d69:	0f 84 da 00 00 00    	je     80106e49 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d6f:	8b 43 04             	mov    0x4(%ebx),%eax
80106d72:	85 c0                	test   %eax,%eax
80106d74:	0f 84 c2 00 00 00    	je     80106e3c <switchuvm+0xec>
  pushcli();
80106d7a:	e8 11 da ff ff       	call   80104790 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d7f:	e8 0c ce ff ff       	call   80103b90 <mycpu>
80106d84:	89 c6                	mov    %eax,%esi
80106d86:	e8 05 ce ff ff       	call   80103b90 <mycpu>
80106d8b:	89 c7                	mov    %eax,%edi
80106d8d:	e8 fe cd ff ff       	call   80103b90 <mycpu>
80106d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d95:	83 c7 08             	add    $0x8,%edi
80106d98:	e8 f3 cd ff ff       	call   80103b90 <mycpu>
80106d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106da0:	83 c0 08             	add    $0x8,%eax
80106da3:	ba 67 00 00 00       	mov    $0x67,%edx
80106da8:	c1 e8 18             	shr    $0x18,%eax
80106dab:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106db2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106db9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dbf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dc4:	83 c1 08             	add    $0x8,%ecx
80106dc7:	c1 e9 10             	shr    $0x10,%ecx
80106dca:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106dd0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106dd5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ddc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106de1:	e8 aa cd ff ff       	call   80103b90 <mycpu>
80106de6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ded:	e8 9e cd ff ff       	call   80103b90 <mycpu>
80106df2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106df6:	8b 73 08             	mov    0x8(%ebx),%esi
80106df9:	e8 92 cd ff ff       	call   80103b90 <mycpu>
80106dfe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e04:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e07:	e8 84 cd ff ff       	call   80103b90 <mycpu>
80106e0c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e10:	b8 28 00 00 00       	mov    $0x28,%eax
80106e15:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e18:	8b 43 04             	mov    0x4(%ebx),%eax
80106e1b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e20:	0f 22 d8             	mov    %eax,%cr3
}
80106e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e26:	5b                   	pop    %ebx
80106e27:	5e                   	pop    %esi
80106e28:	5f                   	pop    %edi
80106e29:	5d                   	pop    %ebp
  popcli();
80106e2a:	e9 a1 d9 ff ff       	jmp    801047d0 <popcli>
    panic("switchuvm: no process");
80106e2f:	83 ec 0c             	sub    $0xc,%esp
80106e32:	68 f2 7c 10 80       	push   $0x80107cf2
80106e37:	e8 54 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106e3c:	83 ec 0c             	sub    $0xc,%esp
80106e3f:	68 1d 7d 10 80       	push   $0x80107d1d
80106e44:	e8 47 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106e49:	83 ec 0c             	sub    $0xc,%esp
80106e4c:	68 08 7d 10 80       	push   $0x80107d08
80106e51:	e8 3a 95 ff ff       	call   80100390 <panic>
80106e56:	8d 76 00             	lea    0x0(%esi),%esi
80106e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e60 <inituvm>:
{
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	57                   	push   %edi
80106e64:	56                   	push   %esi
80106e65:	53                   	push   %ebx
80106e66:	83 ec 1c             	sub    $0x1c,%esp
80106e69:	8b 75 10             	mov    0x10(%ebp),%esi
80106e6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e72:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e7b:	77 49                	ja     80106ec6 <inituvm+0x66>
  mem = kalloc();
80106e7d:	e8 4e b6 ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106e82:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106e85:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e87:	68 00 10 00 00       	push   $0x1000
80106e8c:	6a 00                	push   $0x0
80106e8e:	50                   	push   %eax
80106e8f:	e8 dc da ff ff       	call   80104970 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e94:	58                   	pop    %eax
80106e95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e9b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ea0:	5a                   	pop    %edx
80106ea1:	6a 06                	push   $0x6
80106ea3:	50                   	push   %eax
80106ea4:	31 d2                	xor    %edx,%edx
80106ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ea9:	e8 c2 fc ff ff       	call   80106b70 <mappages>
  memmove(mem, init, sz);
80106eae:	89 75 10             	mov    %esi,0x10(%ebp)
80106eb1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106eb4:	83 c4 10             	add    $0x10,%esp
80106eb7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ebd:	5b                   	pop    %ebx
80106ebe:	5e                   	pop    %esi
80106ebf:	5f                   	pop    %edi
80106ec0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ec1:	e9 5a db ff ff       	jmp    80104a20 <memmove>
    panic("inituvm: more than a page");
80106ec6:	83 ec 0c             	sub    $0xc,%esp
80106ec9:	68 31 7d 10 80       	push   $0x80107d31
80106ece:	e8 bd 94 ff ff       	call   80100390 <panic>
80106ed3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ee0 <loaduvm>:
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	57                   	push   %edi
80106ee4:	56                   	push   %esi
80106ee5:	53                   	push   %ebx
80106ee6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106ee9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ef0:	0f 85 91 00 00 00    	jne    80106f87 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106ef6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ef9:	31 db                	xor    %ebx,%ebx
80106efb:	85 f6                	test   %esi,%esi
80106efd:	75 1a                	jne    80106f19 <loaduvm+0x39>
80106eff:	eb 6f                	jmp    80106f70 <loaduvm+0x90>
80106f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f08:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f0e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106f14:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106f17:	76 57                	jbe    80106f70 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f19:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f1f:	31 c9                	xor    %ecx,%ecx
80106f21:	01 da                	add    %ebx,%edx
80106f23:	e8 c8 fb ff ff       	call   80106af0 <walkpgdir>
80106f28:	85 c0                	test   %eax,%eax
80106f2a:	74 4e                	je     80106f7a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106f2c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f31:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f3b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f41:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f44:	01 d9                	add    %ebx,%ecx
80106f46:	05 00 00 00 80       	add    $0x80000000,%eax
80106f4b:	57                   	push   %edi
80106f4c:	51                   	push   %ecx
80106f4d:	50                   	push   %eax
80106f4e:	ff 75 10             	pushl  0x10(%ebp)
80106f51:	e8 1a aa ff ff       	call   80101970 <readi>
80106f56:	83 c4 10             	add    $0x10,%esp
80106f59:	39 f8                	cmp    %edi,%eax
80106f5b:	74 ab                	je     80106f08 <loaduvm+0x28>
}
80106f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f65:	5b                   	pop    %ebx
80106f66:	5e                   	pop    %esi
80106f67:	5f                   	pop    %edi
80106f68:	5d                   	pop    %ebp
80106f69:	c3                   	ret    
80106f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f73:	31 c0                	xor    %eax,%eax
}
80106f75:	5b                   	pop    %ebx
80106f76:	5e                   	pop    %esi
80106f77:	5f                   	pop    %edi
80106f78:	5d                   	pop    %ebp
80106f79:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f7a:	83 ec 0c             	sub    $0xc,%esp
80106f7d:	68 4b 7d 10 80       	push   $0x80107d4b
80106f82:	e8 09 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106f87:	83 ec 0c             	sub    $0xc,%esp
80106f8a:	68 ec 7d 10 80       	push   $0x80107dec
80106f8f:	e8 fc 93 ff ff       	call   80100390 <panic>
80106f94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106fa0 <allocuvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
80106fa6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106fa9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106fac:	85 ff                	test   %edi,%edi
80106fae:	0f 88 8e 00 00 00    	js     80107042 <allocuvm+0xa2>
  if(newsz < oldsz)
80106fb4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106fb7:	0f 82 93 00 00 00    	jb     80107050 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fc0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106fc6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106fcc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106fcf:	0f 86 7e 00 00 00    	jbe    80107053 <allocuvm+0xb3>
80106fd5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106fd8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fdb:	eb 42                	jmp    8010701f <allocuvm+0x7f>
80106fdd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106fe0:	83 ec 04             	sub    $0x4,%esp
80106fe3:	68 00 10 00 00       	push   $0x1000
80106fe8:	6a 00                	push   $0x0
80106fea:	50                   	push   %eax
80106feb:	e8 80 d9 ff ff       	call   80104970 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ff0:	58                   	pop    %eax
80106ff1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106ff7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ffc:	5a                   	pop    %edx
80106ffd:	6a 06                	push   $0x6
80106fff:	50                   	push   %eax
80107000:	89 da                	mov    %ebx,%edx
80107002:	89 f8                	mov    %edi,%eax
80107004:	e8 67 fb ff ff       	call   80106b70 <mappages>
80107009:	83 c4 10             	add    $0x10,%esp
8010700c:	85 c0                	test   %eax,%eax
8010700e:	78 50                	js     80107060 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107010:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107016:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107019:	0f 86 81 00 00 00    	jbe    801070a0 <allocuvm+0x100>
    mem = kalloc();
8010701f:	e8 ac b4 ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
80107024:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107026:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107028:	75 b6                	jne    80106fe0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010702a:	83 ec 0c             	sub    $0xc,%esp
8010702d:	68 69 7d 10 80       	push   $0x80107d69
80107032:	e8 29 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107037:	83 c4 10             	add    $0x10,%esp
8010703a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010703d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107040:	77 6e                	ja     801070b0 <allocuvm+0x110>
}
80107042:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107045:	31 ff                	xor    %edi,%edi
}
80107047:	89 f8                	mov    %edi,%eax
80107049:	5b                   	pop    %ebx
8010704a:	5e                   	pop    %esi
8010704b:	5f                   	pop    %edi
8010704c:	5d                   	pop    %ebp
8010704d:	c3                   	ret    
8010704e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107050:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107053:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107056:	89 f8                	mov    %edi,%eax
80107058:	5b                   	pop    %ebx
80107059:	5e                   	pop    %esi
8010705a:	5f                   	pop    %edi
8010705b:	5d                   	pop    %ebp
8010705c:	c3                   	ret    
8010705d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107060:	83 ec 0c             	sub    $0xc,%esp
80107063:	68 81 7d 10 80       	push   $0x80107d81
80107068:	e8 f3 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010706d:	83 c4 10             	add    $0x10,%esp
80107070:	8b 45 0c             	mov    0xc(%ebp),%eax
80107073:	39 45 10             	cmp    %eax,0x10(%ebp)
80107076:	76 0d                	jbe    80107085 <allocuvm+0xe5>
80107078:	89 c1                	mov    %eax,%ecx
8010707a:	8b 55 10             	mov    0x10(%ebp),%edx
8010707d:	8b 45 08             	mov    0x8(%ebp),%eax
80107080:	e8 7b fb ff ff       	call   80106c00 <deallocuvm.part.0>
      kfree(mem);
80107085:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107088:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010708a:	56                   	push   %esi
8010708b:	e8 90 b2 ff ff       	call   80102320 <kfree>
      return 0;
80107090:	83 c4 10             	add    $0x10,%esp
}
80107093:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107096:	89 f8                	mov    %edi,%eax
80107098:	5b                   	pop    %ebx
80107099:	5e                   	pop    %esi
8010709a:	5f                   	pop    %edi
8010709b:	5d                   	pop    %ebp
8010709c:	c3                   	ret    
8010709d:	8d 76 00             	lea    0x0(%esi),%esi
801070a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801070a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070a6:	5b                   	pop    %ebx
801070a7:	89 f8                	mov    %edi,%eax
801070a9:	5e                   	pop    %esi
801070aa:	5f                   	pop    %edi
801070ab:	5d                   	pop    %ebp
801070ac:	c3                   	ret    
801070ad:	8d 76 00             	lea    0x0(%esi),%esi
801070b0:	89 c1                	mov    %eax,%ecx
801070b2:	8b 55 10             	mov    0x10(%ebp),%edx
801070b5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801070b8:	31 ff                	xor    %edi,%edi
801070ba:	e8 41 fb ff ff       	call   80106c00 <deallocuvm.part.0>
801070bf:	eb 92                	jmp    80107053 <allocuvm+0xb3>
801070c1:	eb 0d                	jmp    801070d0 <deallocuvm>
801070c3:	90                   	nop
801070c4:	90                   	nop
801070c5:	90                   	nop
801070c6:	90                   	nop
801070c7:	90                   	nop
801070c8:	90                   	nop
801070c9:	90                   	nop
801070ca:	90                   	nop
801070cb:	90                   	nop
801070cc:	90                   	nop
801070cd:	90                   	nop
801070ce:	90                   	nop
801070cf:	90                   	nop

801070d0 <deallocuvm>:
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070dc:	39 d1                	cmp    %edx,%ecx
801070de:	73 10                	jae    801070f0 <deallocuvm+0x20>
}
801070e0:	5d                   	pop    %ebp
801070e1:	e9 1a fb ff ff       	jmp    80106c00 <deallocuvm.part.0>
801070e6:	8d 76 00             	lea    0x0(%esi),%esi
801070e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801070f0:	89 d0                	mov    %edx,%eax
801070f2:	5d                   	pop    %ebp
801070f3:	c3                   	ret    
801070f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107100 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 0c             	sub    $0xc,%esp
80107109:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010710c:	85 f6                	test   %esi,%esi
8010710e:	74 59                	je     80107169 <freevm+0x69>
80107110:	31 c9                	xor    %ecx,%ecx
80107112:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107117:	89 f0                	mov    %esi,%eax
80107119:	e8 e2 fa ff ff       	call   80106c00 <deallocuvm.part.0>
8010711e:	89 f3                	mov    %esi,%ebx
80107120:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107126:	eb 0f                	jmp    80107137 <freevm+0x37>
80107128:	90                   	nop
80107129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107130:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107133:	39 fb                	cmp    %edi,%ebx
80107135:	74 23                	je     8010715a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107137:	8b 03                	mov    (%ebx),%eax
80107139:	a8 01                	test   $0x1,%al
8010713b:	74 f3                	je     80107130 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010713d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107142:	83 ec 0c             	sub    $0xc,%esp
80107145:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107148:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010714d:	50                   	push   %eax
8010714e:	e8 cd b1 ff ff       	call   80102320 <kfree>
80107153:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107156:	39 fb                	cmp    %edi,%ebx
80107158:	75 dd                	jne    80107137 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010715a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010715d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107160:	5b                   	pop    %ebx
80107161:	5e                   	pop    %esi
80107162:	5f                   	pop    %edi
80107163:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107164:	e9 b7 b1 ff ff       	jmp    80102320 <kfree>
    panic("freevm: no pgdir");
80107169:	83 ec 0c             	sub    $0xc,%esp
8010716c:	68 9d 7d 10 80       	push   $0x80107d9d
80107171:	e8 1a 92 ff ff       	call   80100390 <panic>
80107176:	8d 76 00             	lea    0x0(%esi),%esi
80107179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107180 <setupkvm>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	56                   	push   %esi
80107184:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107185:	e8 46 b3 ff ff       	call   801024d0 <kalloc>
8010718a:	85 c0                	test   %eax,%eax
8010718c:	89 c6                	mov    %eax,%esi
8010718e:	74 42                	je     801071d2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107190:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107193:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107198:	68 00 10 00 00       	push   $0x1000
8010719d:	6a 00                	push   $0x0
8010719f:	50                   	push   %eax
801071a0:	e8 cb d7 ff ff       	call   80104970 <memset>
801071a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071ab:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071ae:	83 ec 08             	sub    $0x8,%esp
801071b1:	8b 13                	mov    (%ebx),%edx
801071b3:	ff 73 0c             	pushl  0xc(%ebx)
801071b6:	50                   	push   %eax
801071b7:	29 c1                	sub    %eax,%ecx
801071b9:	89 f0                	mov    %esi,%eax
801071bb:	e8 b0 f9 ff ff       	call   80106b70 <mappages>
801071c0:	83 c4 10             	add    $0x10,%esp
801071c3:	85 c0                	test   %eax,%eax
801071c5:	78 19                	js     801071e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071c7:	83 c3 10             	add    $0x10,%ebx
801071ca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801071d0:	75 d6                	jne    801071a8 <setupkvm+0x28>
}
801071d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071d5:	89 f0                	mov    %esi,%eax
801071d7:	5b                   	pop    %ebx
801071d8:	5e                   	pop    %esi
801071d9:	5d                   	pop    %ebp
801071da:	c3                   	ret    
801071db:	90                   	nop
801071dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801071e0:	83 ec 0c             	sub    $0xc,%esp
801071e3:	56                   	push   %esi
      return 0;
801071e4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071e6:	e8 15 ff ff ff       	call   80107100 <freevm>
      return 0;
801071eb:	83 c4 10             	add    $0x10,%esp
}
801071ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071f1:	89 f0                	mov    %esi,%eax
801071f3:	5b                   	pop    %ebx
801071f4:	5e                   	pop    %esi
801071f5:	5d                   	pop    %ebp
801071f6:	c3                   	ret    
801071f7:	89 f6                	mov    %esi,%esi
801071f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107200 <kvmalloc>:
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107206:	e8 75 ff ff ff       	call   80107180 <setupkvm>
8010720b:	a3 04 36 11 80       	mov    %eax,0x80113604
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107210:	05 00 00 00 80       	add    $0x80000000,%eax
80107215:	0f 22 d8             	mov    %eax,%cr3
}
80107218:	c9                   	leave  
80107219:	c3                   	ret    
8010721a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107220 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107220:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107221:	31 c9                	xor    %ecx,%ecx
{
80107223:	89 e5                	mov    %esp,%ebp
80107225:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107228:	8b 55 0c             	mov    0xc(%ebp),%edx
8010722b:	8b 45 08             	mov    0x8(%ebp),%eax
8010722e:	e8 bd f8 ff ff       	call   80106af0 <walkpgdir>
  if(pte == 0)
80107233:	85 c0                	test   %eax,%eax
80107235:	74 05                	je     8010723c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107237:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010723a:	c9                   	leave  
8010723b:	c3                   	ret    
    panic("clearpteu");
8010723c:	83 ec 0c             	sub    $0xc,%esp
8010723f:	68 ae 7d 10 80       	push   $0x80107dae
80107244:	e8 47 91 ff ff       	call   80100390 <panic>
80107249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107250 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
80107256:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107259:	e8 22 ff ff ff       	call   80107180 <setupkvm>
8010725e:	85 c0                	test   %eax,%eax
80107260:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107263:	0f 84 9f 00 00 00    	je     80107308 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107269:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010726c:	85 c9                	test   %ecx,%ecx
8010726e:	0f 84 94 00 00 00    	je     80107308 <copyuvm+0xb8>
80107274:	31 ff                	xor    %edi,%edi
80107276:	eb 4a                	jmp    801072c2 <copyuvm+0x72>
80107278:	90                   	nop
80107279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107280:	83 ec 04             	sub    $0x4,%esp
80107283:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107289:	68 00 10 00 00       	push   $0x1000
8010728e:	53                   	push   %ebx
8010728f:	50                   	push   %eax
80107290:	e8 8b d7 ff ff       	call   80104a20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107295:	58                   	pop    %eax
80107296:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010729c:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072a1:	5a                   	pop    %edx
801072a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801072a5:	50                   	push   %eax
801072a6:	89 fa                	mov    %edi,%edx
801072a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072ab:	e8 c0 f8 ff ff       	call   80106b70 <mappages>
801072b0:	83 c4 10             	add    $0x10,%esp
801072b3:	85 c0                	test   %eax,%eax
801072b5:	78 61                	js     80107318 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801072b7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801072bd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801072c0:	76 46                	jbe    80107308 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072c2:	8b 45 08             	mov    0x8(%ebp),%eax
801072c5:	31 c9                	xor    %ecx,%ecx
801072c7:	89 fa                	mov    %edi,%edx
801072c9:	e8 22 f8 ff ff       	call   80106af0 <walkpgdir>
801072ce:	85 c0                	test   %eax,%eax
801072d0:	74 61                	je     80107333 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801072d2:	8b 00                	mov    (%eax),%eax
801072d4:	a8 01                	test   $0x1,%al
801072d6:	74 4e                	je     80107326 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801072d8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801072da:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801072df:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801072e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801072e8:	e8 e3 b1 ff ff       	call   801024d0 <kalloc>
801072ed:	85 c0                	test   %eax,%eax
801072ef:	89 c6                	mov    %eax,%esi
801072f1:	75 8d                	jne    80107280 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801072f3:	83 ec 0c             	sub    $0xc,%esp
801072f6:	ff 75 e0             	pushl  -0x20(%ebp)
801072f9:	e8 02 fe ff ff       	call   80107100 <freevm>
  return 0;
801072fe:	83 c4 10             	add    $0x10,%esp
80107301:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107308:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010730b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010730e:	5b                   	pop    %ebx
8010730f:	5e                   	pop    %esi
80107310:	5f                   	pop    %edi
80107311:	5d                   	pop    %ebp
80107312:	c3                   	ret    
80107313:	90                   	nop
80107314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107318:	83 ec 0c             	sub    $0xc,%esp
8010731b:	56                   	push   %esi
8010731c:	e8 ff af ff ff       	call   80102320 <kfree>
      goto bad;
80107321:	83 c4 10             	add    $0x10,%esp
80107324:	eb cd                	jmp    801072f3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	68 d2 7d 10 80       	push   $0x80107dd2
8010732e:	e8 5d 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107333:	83 ec 0c             	sub    $0xc,%esp
80107336:	68 b8 7d 10 80       	push   $0x80107db8
8010733b:	e8 50 90 ff ff       	call   80100390 <panic>

80107340 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107340:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107341:	31 c9                	xor    %ecx,%ecx
{
80107343:	89 e5                	mov    %esp,%ebp
80107345:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107348:	8b 55 0c             	mov    0xc(%ebp),%edx
8010734b:	8b 45 08             	mov    0x8(%ebp),%eax
8010734e:	e8 9d f7 ff ff       	call   80106af0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107353:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107355:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107356:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107358:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010735d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107360:	05 00 00 00 80       	add    $0x80000000,%eax
80107365:	83 fa 05             	cmp    $0x5,%edx
80107368:	ba 00 00 00 00       	mov    $0x0,%edx
8010736d:	0f 45 c2             	cmovne %edx,%eax
}
80107370:	c3                   	ret    
80107371:	eb 0d                	jmp    80107380 <copyout>
80107373:	90                   	nop
80107374:	90                   	nop
80107375:	90                   	nop
80107376:	90                   	nop
80107377:	90                   	nop
80107378:	90                   	nop
80107379:	90                   	nop
8010737a:	90                   	nop
8010737b:	90                   	nop
8010737c:	90                   	nop
8010737d:	90                   	nop
8010737e:	90                   	nop
8010737f:	90                   	nop

80107380 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	57                   	push   %edi
80107384:	56                   	push   %esi
80107385:	53                   	push   %ebx
80107386:	83 ec 1c             	sub    $0x1c,%esp
80107389:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010738c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010738f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107392:	85 db                	test   %ebx,%ebx
80107394:	75 40                	jne    801073d6 <copyout+0x56>
80107396:	eb 70                	jmp    80107408 <copyout+0x88>
80107398:	90                   	nop
80107399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801073a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801073a3:	89 f1                	mov    %esi,%ecx
801073a5:	29 d1                	sub    %edx,%ecx
801073a7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801073ad:	39 d9                	cmp    %ebx,%ecx
801073af:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801073b2:	29 f2                	sub    %esi,%edx
801073b4:	83 ec 04             	sub    $0x4,%esp
801073b7:	01 d0                	add    %edx,%eax
801073b9:	51                   	push   %ecx
801073ba:	57                   	push   %edi
801073bb:	50                   	push   %eax
801073bc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801073bf:	e8 5c d6 ff ff       	call   80104a20 <memmove>
    len -= n;
    buf += n;
801073c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801073c7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801073ca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801073d0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801073d2:	29 cb                	sub    %ecx,%ebx
801073d4:	74 32                	je     80107408 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801073d6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801073d8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801073db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801073de:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801073e4:	56                   	push   %esi
801073e5:	ff 75 08             	pushl  0x8(%ebp)
801073e8:	e8 53 ff ff ff       	call   80107340 <uva2ka>
    if(pa0 == 0)
801073ed:	83 c4 10             	add    $0x10,%esp
801073f0:	85 c0                	test   %eax,%eax
801073f2:	75 ac                	jne    801073a0 <copyout+0x20>
  }
  return 0;
}
801073f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073fc:	5b                   	pop    %ebx
801073fd:	5e                   	pop    %esi
801073fe:	5f                   	pop    %edi
801073ff:	5d                   	pop    %ebp
80107400:	c3                   	ret    
80107401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107408:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010740b:	31 c0                	xor    %eax,%eax
}
8010740d:	5b                   	pop    %ebx
8010740e:	5e                   	pop    %esi
8010740f:	5f                   	pop    %edi
80107410:	5d                   	pop    %ebp
80107411:	c3                   	ret    
