" paper tape bootstrap for jk device.
" reads system into memory at address 0:
" 4096 words starting at block 14400 (equivalent to track 180 on RB09)
" (track 180 * 80 segments per track -> 14400)
" j. dersch 10/21/2019

" JK instructions:
" jkld - 704624 - loads block address (64 words/block) 
" jkrd - 704602 - reads next word into AC
" jkwr - 704604 - writes next word into AC

jkld = 0704624
jkrd = 0704612
jkwr = 0704604

" must be output as a "rim" tape for SIMH to boot!!!

" load at normal (user) address of 010000
   iof				" interrupts off
   caf				" reset cpu

   lac sblock
   jkld		" load JK's block address with the kernel's block

wloop:
   jkrd		" read next word into AC
   dac i caddr  " stow in memory
   isz caddr    " move to next word
   isz wcount
   jmp wloop    " do the next word
  
   " all words read, jump to kernel entrypoint
   jmp 0100
    
caddr: 0
wcount: -4096 
sblock: 14400
