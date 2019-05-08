#!d:\perl\bin\perl
#Author : Thomas Thaliath 
#Program File: linkextr2.pl

use Win32::API::Type;
 ApiLink( 'kernel32.dll', `BOOL GetVolumeInformation(
                                   LPCTSTR lpRootPathName,
                                 LPTSTR lpVolumeNameBuffer,
                                 DWORD nVolumeNameSize,
                                   LPDWORD lpVolumeSerialNumber,
                                   LPDWORD lpMaximumComponentLength,
                                   LPDWORD lpFileSystemFlags,
                                   LPTSTR lpFileSystemNameBuffer,
                                   DWORD nFileSystemNameSize )' )
     || die "Can not link to GetVolumeInformation()";
 ApiLink( 'kernel32.dll', `BOOL GetDiskFreeSpaceEx(
                                   LPCTSTR lpDirectoryName,
                                 PVOID lpFreeBytesAvailable,
                                  PVOID lpTotalNumberOfBytes,
                                   PVOID lpTotalNumberOfFreeBytes )' )
     || die "Wrong version of NT";

 %FLAGS = (
   0x00000001  =>  `FS_CASE_SENSITIVE',
   0x00000002  =>  `FS_CASE_IS_PRESERVED',
   0x00000004  =>  `FS_UNICODE_STORED_ON_DISK',
   0x00000008  =>  `FS_PERSISTENT_ACLS',
   0x00000010  =>  `FS_FILE_COMPRESSION',
   0x00000020  =>  `FILE_VOLUME_QUOTAS',
  0x00000040  =>  `FILE_SUPPORTS_SPARSE_FILES',
   0x00000080  =>  `FILE_SUPPORTS_REPARSE_POINTS',
   0x00008000  =>  `FS_VOL_IS_COMPRESSED',
   0x00000000  =>  `FILE_NAMED_STREAMS',
   0x00020000  =>  `FILE_SUPPORTS_ENCRYPTION',
   0x00010000  =>  `FILE_SUPPORTS_OBJECT_IDS',
);

 push( @ARGV, "\\" ) if( 0 == scalar @ARGV );

 foreach my $Path ( @ARGV )
 {
  my $dwVolSize = 256;
   my $szVolName = NewString( $dwVolSize );
   my $pdwSerialNum = pack( "L", 0 );
   my $pdwMaxLength = pack( "L", 0 );
   my $pdwFlags = pack( "L", 0 );
   my $dwFSNameSize = 256;
   my $szFSName = NewString( $dwFSNameSize );
   
   $Path .= "\\" unless( $Path =~ /\\$/ );
   next unless( -d $Path );
   $Path = NewString( $Path );
  
   print "\n$Path:\n";
   $~ = DumpVol;
   if( GetVolumeInformation( $Path, $szVolName,
                           $dwVolSize, $pdwSerialNum,
                             $pdwMaxLength, $pdwFlags,
                            $szFSName, $dwFSNameSize ) )
   {
     local %Vol = (
       path        =>  $Path,
       volume_name =>  CleanString( $szVolName ),
       serial_num  =>  sprintf( "\U%04x-%04x",
                               reverse( unpack( "S2",
                                                 $pdwSerialNum ) ) ),
       max_length  =>  unpack( "L", $pdwMaxLength ),
       flags       =>  DecodeFlags( unpack( "L", $pdwFlags ) ),
       fs_name     =>  CleanString( $szFSName )
     );
     my $pFree  = pack( "L2", 0, 0 );
     my $pTotal = pack( "L2", 0, 0 );
    my $pTotalFree = pack( "L2", 0, 0 );
     if( GetDiskFreeSpaceEx( $Path, $pFree, $pTotal, $pTotalFree ) )
     {
       $Vol{free} = FormatNumber( MakeLargeInt( unpack( "L2",
                                                        $pTotalFree ) ) );
       $Vol{total} = FormatNumber( MakeLargeInt( unpack( "L2",
                                                         $pTotal ) ) );
     }
     write;
   }
 }

 sub MakeLargeInt
 {
   my( $Low, $High ) = @_;
   return( $High * ( 1 + 0xFFFFFFFF ) + $Low );
 }

 sub DecodeFlags
 {
   my( $Flags ) = @_;
   my $String = "";
   foreach my $Key ( keys( %FLAGS ) )
  {
     if( $Flags & $Key )
     {
       $String .= sprintf( "%- 30s\n", $FLAGS{$Key} );
     }
   }
   return( $String );       
 }

 sub FormatNumber
 {
   my( $Num ) = @_;
   {} while( $Num =~ s/^(-?\d+)(\d{3})/$1,$2/ );
   return( $Num );
 }

 