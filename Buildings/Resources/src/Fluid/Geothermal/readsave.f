      program readsave
c...3/18/21 modify for eos3
      parameter(nn=1000)
      character*5 header,title,el
      real*8 p,x,t
c...read input from keyboard or pipe from file
      read *,header
      read *,n
      read *,header
      read *,nel
      read *,header
      read *,nip
c...open files
      open(15,file='SAVE',status='old')
c...read SAVE and print desired T's
      read(15,*)title
      do i=1,nel
        read(15,1501)el,por
1501    format(a5,10x,e15.8)
        read(15,1502)p,x,t
1502    format(3d20.12)
        if(i.le.n)then
          print 1503,t
1503      format(f12.5)
        endif
        if(i.eq.(n+1))then
          print 1506,t
1506      format(' Surface T=',f12.5)
        endif
        if((i.gt.(n+1)).and.(i.le.(n+1+nip)))then
          print 1507,el,p,x,t
1507      format(a5,5x,d20.12,5x,d20.12,5x,d20.12)
        endif
      enddo
      read(15,*)title
      read(15,1504)i1,i2,i3,f1,tfinal
1504  format(3i5,2e15.8)
      print 1505,i1,i2,tfinal
1505  format(' Number steps',i5,' Number iterations ',i5,' Final time',
     x e15.8)
      close(15)
c...all done
      stop
      end
