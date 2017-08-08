import std.array;
import std.algorithm.iteration;
import std.stdio;

class polishCalculator
{
	
	static double addAllNumbers(immutable double[] numbers)
	{
		return numbers.sum();
	}

	unittest
	{
	}
	
	static double arithmetic(immutable double[] numbers, immutable string sign)
	{
		if(sign == "-")
		{
			return numbers.fold!((a,b)=>a-b);
		}
		else if(sign == "+")
		{
			return numbers.sum();
		}
		else if(sign == "*")
		{
			return numbers.fold!((a,b)=>a*b);
		}
		else if(sign == "/")
		{
			return numbers.fold!((a,b)=>a/b);
		}
		return 0;
	}
	
	unittest
	{
		immutable double[] addArray = array([1.0,2.0]);
		immutable double[] secondAddArray = array([1.0,2.0,0.0,-6.0]);
		assert(arithmetic(addArray, "+") == 3.0);
		assert(arithmetic(secondAddArray, "+") == -3.0);
		
		immutable double[] subArray = array([1.0,2.0]);
		immutable double[] secondSubArray = array([1.0,2.0,0.0,-6.0]);
		assert(arithmetic(subArray, "-") == -1);
		assert(arithmetic(secondSubArray, "-") == 5);
		
		immutable double[] mulArray = array([1.0,2.0]);
		immutable double[] secondMulArray = array([1.0,2.0,0.0,-6.0]);
		assert(arithmetic(mulArray, "*") == 2);
		assert(arithmetic(secondMulArray, "*") == 0);
		
		immutable double[] divArray = array([1.0,2.0]);
		//immutable double[] secondDivArray = array([1.0,2.0,0.0,-6.0]);
		assert(arithmetic(divArray, "/") == 0.5);
		//assert(arithmetic(secondDivArray, "/") == "error");
	}
}

void main() {
	return;
}
