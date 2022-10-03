/*
% Turing+ v6.2, Sept 2022
% Copyright 1986 University of Toronto, 2022 Queen's University at Kingston
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software
% and associated documentation files (the “Software”), to deal in the Software without restriction,
% including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
% and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
% subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies
% or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
% AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
** Convert a double to a string in decimal.
**
** If expformat = 1, ndigits is the number of digits to convert,
** If expformat = 0, ndigits is the number of digits after the
** decimal point to convert.
**
** *Decpnt is set to the position of the decimal point relative
** to the beginning of the string (negative values mean to the
** left of the string).
**
** *Sign is set to 0 if arg >= 0, otherwise 1.
**
** We return a pointer to the string of converted digits.
** The result is rounded to the number of digits specified;
** ties are rounded up
**
** This routine is taken from the C library
** and modified to round correctly.
*/

extern double modf();


#define	StringLength	255
#define	BufferSize	500
static char buffer[BufferSize];


void TL_TLA_TLAVRS (result, arg, ndigits, decpt, sign, expformat, err)
char *result;
double arg;
int ndigits;
int *decpt;
char *sign;
char expformat;
char *err;
{
    register int exponent;
    double intPart;
    register char *dst, *ptr;

    *err = 0;

    /*
    ** Make sure ndigits is in the range 0 .. StringLength-1.
    */
    if (ndigits > StringLength-1) {
        ndigits = StringLength-1;
    }

    /*
    ** Determine the sign of the value and then replace	it with
    ** an absolute value.
    */
    if (arg < 0) {
        *sign = 1;
        arg = -arg;
    } else {
        *sign = 0;
    }

    /*
    ** Set "arg" to be the fractional part of the value
    ** and "intPart" to be the integral part.
    */
    arg = modf(arg, &intPart);

    /*
    ** Convert the integer part to string format.
    ** Use exponent to count the number of significant digits before
    ** the decimal point (negative or zero if value < 1).
    ** Leave "dst" pointing to the next available place in "result".
    */
    exponent = 0;
    dst = result;
    if (intPart != 0) {
	double digit;

	/*
	** Generate digits and store in backwards order.
	*/
	for (ptr = &buffer[BufferSize]; intPart != 0; exponent++) {
            digit = modf(intPart/10, &intPart);
	    *--ptr = (int)((digit+.03)*10.0) + '0';
#ifdef debug
	    fprintf (stderr, "TLAVRS:  Generated digit %c, rem = %lf\n",
		    *ptr, intPart);
#endif
        }
	/*
	** Now store the as many digits as we can into result.
	*/
	while (ptr < &buffer[BufferSize] && dst <= &result[StringLength-1]) {
	    *dst++ = *ptr++;
	}
    } else if (arg != 0) {
	double temp;

	/*
	** Multiply the fraction to normalize it, thus ignoring
	** leading fractional zeroes, and count the number of
	** insignificant zeroes.
	*/
        while ((temp = arg*10.0) < 1) {
            arg = temp;
            exponent--;
        }
    }

    /*
    ** Save the exponent.
    */
    *decpt = exponent;

    /*
    ** Point ptr to the first truncated digit.
    */
    ptr = &result[ndigits];
    if (!expformat)
        ptr += exponent;

    /*
    ** If we are doing a fixed format conversion and the number
    ** of leading 0's in the fraction is greater than the number
    ** of displayed digits, just return a null string.
    */
    if (ptr < &result[0]) {
        result[0] = '\0';
	*decpt = -ndigits;
	*sign = 0;
	return;
    }

    /*
    ** Check if we have enough space for the conversion.
    */
    if (ptr > &result[StringLength-1]) {
	*err = 1;
	return;
    }

    /*
    ** Get as many digits as required from the fraction.
    */
    while (dst <= ptr) {
	double digit;

        arg = modf(arg * 10.0, &digit);
        *dst++ = (int)digit + '0';
#ifdef debug
	fprintf (stderr, "TLAVRS:  Generated fractional digit %c, rem = %lf\n",
		*(dst-1), arg);
#endif
    }

    /*
    ** Increment the last digit if the situation requires rounding up,
    ** and then propagate through the fraction. Rounding up is required
    ** if the truncated digits are >= .5 in the last place and it is
    ** positive, or > .5 and number is negative.
    */
    dst = ptr;
    if (*ptr > '5' || (*sign == 0 && *ptr == '5')) {
	for (;;) {
            if (--ptr >= &result[0]) {
		if (*ptr == '9') {
		    /*
		    ** Set the digit to '0' and carry on rounding.
		    */
		    *ptr = '0';
		} else {
		    /*
		    ** Increment the digit and quit rounding.
		    */
		    (*ptr)++;
		    break;
		}
            } else {
		/*
		** The number rounds to an exact power of 10.  At this point,
		** the entire stored string consists of '0's.  Set the first
		** character to a '1' and increment the exponent.
		*/
                if (expformat) {
		    if (dst == &result[0]) {
			/*
			** Whoops.  He's specified ndigits=0, presumably to
			** get the exponent.  Don't round up.
			*/
			break;
		    }
		} else {
		    /*
		    ** Since we want a fixed number of fractional digits,
		    ** we have to tack a '0' onto the end of the string.
		    */
		    *dst++ = '0';
                }
		result[0] = '1';
		(*decpt)++;
		break;
            }
        }
    }
    *dst = '\0';

#ifdef debug
    fprintf ("TLAVRS: Final value is .%se%d\n", result, *decpt);
#endif

    if (result[0] == '\0') {
	/* number = 0 */
	*sign = 0;
    }
    return;
}
