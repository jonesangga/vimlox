vim9script

# Temporary. Delete later.

# 8.1 Statements.
# --------------------------------------------------------------------

Vimlox
print "one";
print true;
print 2 + 1;

# 8.2 Global variables.
# --------------------------------------------------------------------

# 8.3 Environments.
# --------------------------------------------------------------------

# Allow redefining variable.
Vimlox
var a = "before";
print a; // "before".
var a = "after";
print a; // "after".

# This should error.
Vimlox
print a;
var a = "too late!";

Vimlox
var a;
print a; // "nil".

Vimlox
var a = 1;
var b = 2;
print a + b;

# To test Parser._Synchronize()
Vimlox
var a = 1;
print a + "real" "so real" + 2 * nil;
print a;
