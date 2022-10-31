      program writeincon
c...Modelica to TOUGH connection
c...3/18/2021 Make all state variables double precision
c             Improve GENER format for more precision
c...3/19/2021 Read surface T and assign to first mesh element after borehole
c   MESH file reordered so Borehole elements are first, then surface element
      parameter(nn=1000)
      dimension Q1(nn)
      character*5 header,title,el
      character*80 aline
      real*8 tinit,tfinal,dt1,p,X,T,T1(nn),Tsurf
c...read input from keyboard or pipe from file 
c   Modelica provides tinit, tfinal, T1, Q1, Tsurf
      read *,header
      read *,n
      read *,header
      read *,nel
      read *,header
      read *,tinit
      read *,header
      read *,tfinal
      if(tfinal.gt.999999999.)then
        print *,' ERROR tfinal=',tfinal,' is too big '
        print *,' Max allowable tfinal=99999999. STOP'
        stop
      endif
      read *,header
      read *,(T1(i),i=1,n)
      read *,header
      read *,(Q1(i),i=1,n)
      read *,header
      read *,Tsurf
c...open files
      open(15,file='SAVE',status='old')
      open(16,file='INCON',status='new')
      open(17,file='INFILE',status='old')
      open(18,file='newINFILE',status='new')
      open(19,file='GENER',status='new')
c...read SAVE and write INCON and GENER
      read(15,1500)title
      write(16,1500)title
      write(19,1500)'GENER'
1500  format(a5)
c     iz=0
c     f1=0.
      do i=1,nel
        read(15,1501)el,por
        write(16,1501)el,por
1501    format(a5,10x,e15.8)
        read(15,1502)p,X,T
1502    format(3d20.12)
        if(i.le.n)then
          write(16,1502)p,X,T1(i)
          if(abs(Q1(i)).le.99999.999 .and. abs(Q1(i)).ge.0.1)then
            write(19,1901)el,'sou',i,'HEAT',Q1(i)
1901        format(a5,a3,i2,25x,a4,1x,f10.3)
          else
            write(19,1902)el,'sou',i,'HEAT',Q1(i)
1902        format(a5,a3,i2,25x,a4,1x,1pe10.3)
          endif
        elseif(i.eq.n+1)then
           Write(16,1502)p,X,Tsurf
        else
          write(16,1502)p,X,T
        endif
      enddo
ccd..7/14/20 begin: do not write +++ and restart info at end of INCON
c     read(15,1500)title
c     if(title.eq.'+++  ')then
c       write(16,1500)title
c     else
c       write(16,1500)'+++  '
c     endif
c     write(16,1503)iz,iz,iz,f1,tinit
c1503  format(3i5,2f15.4)
      write(16,1503)'     '
1503  format(a5)
      write(16,1504)
c1504  format('INCON updated from SAVE with Modelica T and t')
1504  format('INCON updated from SAVE with Modelica borehole T')
ccd..7/14/20 end
      write(19,1500)'     '
      close(15)
      close(16)
      close(19)
c...read INFILE and write newINFILE
c...look for PARAM block
100   read(17,1700)aline
      write(18,1700)aline
1700  format(a80)
      if(aline(1:5).ne.'PARAM')goto 100
      read(17,1700)aline
      write(18,1700)aline
      read(17,1701)tinit0,tfinal0,dt10,dtmax,g
1701  format(2f10.0,f10.4,f10.0,10x,f10.3)
      dt1=(tfinal-tinit)/10.d0
      if(dt1.le.0.d0)then
        print *,' ERROR in timestepping, tfinal=tinitial.  STOP '
        print *,' tfinal=',tfinal,' tinit=',tinit
        stop
      endif
      write(18,1701)tinit,tfinal,dt1,dtmax,g
200   read(17,1700,end=300)aline
      write(18,1700)aline
      goto 200
c...close files
300   close(17)
      close(18)
c...all done
      stop
      end
