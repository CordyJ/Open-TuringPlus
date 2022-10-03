#include <UNIX64/cinterface>
static struct {
    TLint4	dummy;
    char	dummy2[7];
} TLFTAB =
    { 1,
    {'h', 'i', 'h', 'o', '.', 't', '\0'
    }};

static void hi () {
    TLSTKCHKSLF(100004);
    TLSETF();
    TLSETL(100004);
    TLRESCHEDROUT();
    for(;;) {
	TLSETL(100004);
	TLRESCHEDLOOP();
	TL_TLI_TLISSO ();
	TL_TLI_TLIPS ((TLint4) 0, "hi", (TLint2) -1);
	TL_TLI_TLIPK ((TLint2) -1);
    };
    TLRESTORELF();
}

static void ho () {
    TLSTKCHKSLF(100010);
    TLSETF();
    TLSETL(100010);
    TLRESCHEDROUT();
    for(;;) {
	TLSETL(100010);
	TLRESCHEDLOOP();
	TL_TLI_TLISSO ();
	TL_TLI_TLIPS ((TLint4) 0, "ho", (TLint2) -1);
	TL_TLI_TLIPK ((TLint2) -1);
    };
    TLRESTORELF();
}

static void he () {
    TLSTKCHKSLF(100016);
    TLSETF();
    TLSETL(100016);
    TLRESCHEDROUT();
    for(;;) {
	TLSETL(100016);
	TLRESCHEDLOOP();
	TL_TLI_TLISSO ();
	TL_TLI_TLIPS ((TLint4) 0, "he", (TLint2) -1);
	TL_TLI_TLIPK ((TLint2) -1);
    };
    TLRESTORELF();
}
void TProg () {
    TLSETF();
    TLSETL(100020);
    TL_TLK_TLKPFORK((TLint4) 0, "hi", hi, (TLaddressint *) 0, (TLint4) 10000, (TLboolean *) 0);
    TLINCL();
    TL_TLK_TLKPFORK((TLint4) 0, "ho", ho, (TLaddressint *) 0, (TLint4) 10000, (TLboolean *) 0);
    TLINCL();
    TL_TLK_TLKPFORK((TLint4) 0, "he", he, (TLaddressint *) 0, (TLint4) 10000, (TLboolean *) 0);
}
