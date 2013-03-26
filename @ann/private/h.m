## -*- texinfo -*-
## @deftypefn {Function File} z = h(x)
## 
## h
## 
## @end deftypefn

function z = h(x,eta)
	z = 1./(1+e.^(-eta * x));
endfunction