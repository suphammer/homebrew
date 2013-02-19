require 'formula'

class Ipsc < Formula
  homepage 'http://directory.fsf.org/wiki/Ipsc'
  url 'http://ftp.freebsd.org/pub/FreeBSD/ports/distfiles/ipsc-0.4.2-src.tar.gz'
  sha1 '61ed0c648680ab5877a4e3443758bd113f5cf20f'
  depends_on 'prips'

  def install
    system "make -C src ipsc"
    bin.install "src/ipsc"
  end

  def test
    system "ipsc"
  end

  def patches
    # Adapt build configuration
    DATA
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index 4e3722b..9aeb733 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -4,12 +4,13 @@ LIBS = -lm
 
 GNOMELIBS = `gnome-config --libs gnomeui`
 GNOMEFLAGS = `gnome-config --cflags gnomeui`
+PRIPS = /usr/local/lib/prips.o
 
 all: ipsc gipsc
 
-gipsc: gmain.o gipsc.o ipsc.o ifc.o ../../prips/prips.o
+gipsc: gmain.o gipsc.o ipsc.o ifc.o $(PRIPS)
 	$(CC) $(CFLAGS) $(GNOMELIBS) gmain.o gipsc.o ipsc.o ifc.o \
-	     ../../prips/prips.o -o gipsc
+	     $(PRIPS) -o gipsc
 
 gipsc.o: gui/gipsc.c gui/gipsc.h
 	$(CC) $(CFLAGS) $(GNOMEFLAGS) -c gui/gipsc.c
@@ -17,9 +18,9 @@ gipsc.o: gui/gipsc.c gui/gipsc.h
 gmain.o: gui/gmain.c gui/gipsc.h
 	$(CC) $(CFLAGS) $(GNOMEFLAGS) -c gui/gmain.c
 
-ipsc: main.o ipsc.o ifc.o ../../prips/prips.o
+ipsc: main.o ipsc.o ifc.o $(PRIPS)
 	$(CC) $(CFLAGS) $(LIBS) main.o ipsc.o ifc.o \
-		../../prips/prips.o -o ipsc
+		$(PRIPS) -o ipsc
 
 ipsc.o: ipsc.c ipsc.h
 	$(CC) $(CFLAGS) -c ipsc.c
diff --git a/src/ipsc.c b/src/ipsc.c
index fe40c92..9c25b7b 100644
--- a/src/ipsc.c
+++ b/src/ipsc.c
@@ -8,7 +8,7 @@
 
 #include "ipsc.h"
 #include "ifc.h"
-#include "../../prips/prips.h"
+#include <prips.h>
 
 #define DOT(x) (8*(x))+((x)-1)
 
diff --git a/src/main.c b/src/main.c
index 6fe9736..f00d6b0 100644
--- a/src/main.c
+++ b/src/main.c
@@ -142,18 +142,18 @@ int main(int argc, char *argv[])
 
 void usage(const char *prog)
 {
-        fprintf(stderr, "usage: %s [options] <addr/mask | addr/offset | addr>
-        -C <class>      Network class (a, b, or c).  Must be used with -B
-	-B <bits>	Subnet bits (must be used with -C)
-        -i <if>		Reverse engineer an interface (e.g. eth0)
-	-a		Print all information available
-	-g		Print general information
-        -s 		Print all possible subnets
-	-h		Print host information
-	-c		Print CIDR information
-        -v		Print the program version
-        -?		Print this help message
-
+        fprintf(stderr, "usage: %s [options] <addr/mask | addr/offset | addr>\n\
+        -C <class>      Network class (a, b, or c).  Must be used with -B\n\
+	-B <bits>	Subnet bits (must be used with -C)\n\
+        -i <if>		Reverse engineer an interface (e.g. eth0)\n\
+	-a		Print all information available\n\
+	-g		Print general information\n\
+        -s 		Print all possible subnets\n\
+	-h		Print host information\n\
+	-c		Print CIDR information\n\
+        -v		Print the program version\n\
+        -?		Print this help message\n\
+\n\
         \rReport bugs to %s\n",
                         prog, MAINTAINER);
 }
