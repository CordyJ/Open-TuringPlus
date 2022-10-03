// Turing Plus Unix Character Graphics Interface Support
// November 1986 (Rev June 2020)

#include <stdio.h>
#include <sys/ioctl.h>
#include <unistd.h>

int thasch()
{
    int nChars;
    if( ioctl(0, FIONREAD, &nChars) < 0 ) return( 0 );
    return( nChars > 0 );
}

int trows() 
{
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
    return w.ws_row; 
}

int tcols() 
{
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
    return w.ws_col; 
}
