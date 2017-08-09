import std.array;
import std.algorithm;
import std.stdio;
import std.exception;
import std.string;
import std.conv;
import std.regex;
import std.math;

static double doTheMath(double firstNum, double secondNum, string sign)
{
	if(sign == "-")
	{
		return firstNum - secondNum;
	}
	else if(sign == "+")
	{
		return firstNum + secondNum;
	}
	else if(sign == "*")
	{
		return firstNum * secondNum;
	}
	else if(sign == "/")
	{
		if(secondNum == 0.0)
		{
			throw new StringException("Divide by zero attempted");
		}
		else
		{
			return firstNum / secondNum;
		}
	}
	return 0;
}

unittest
{
	assert(doTheMath(1.0,2.0,"+") == 3.0);
	assert(doTheMath(1.0,2.0,"-") == -1);
	assert(doTheMath(1.0,2.0,"*") == 2);
	assert(doTheMath(1.0,2.0,"/") == 0.5);
	try
	{
		doTheMath(1.0,0.0,"/");
		assert(false);
	}
	catch (StringException e)
	{
		assert(e.msg == "Divide by zero attempted");
	}
}

double getArithmeticOperatorCount(string stringForOper)
{
	auto capture = matchAll(stringForOper, r"\+|\-|\*|\/");
	if(!capture.empty)
	{
		return capture.count;
	}
	return 0.0;
}

unittest
{
	string input = "1.0 2.0 +";
	double operatorCount = input.getArithmeticOperatorCount();
	assert(operatorCount == 1);
	input = "1.0 2.0 3.0 + -";
	operatorCount = input.getArithmeticOperatorCount();
	assert(operatorCount == 2);
}

static double doTheStuff(string inputString)
{
	string[] inputArray = inputString.split(" ");
	if(inputArray.length == 0)
	{
		throw new StringException("Empty string");
	}

	/*double operatorCount = inputString.getArithmeticOperatorCount();
	if((operatorCount < ((inputArray.length/2))))
	{
		throw new StringException("No ending operator");
	}*/

	double[] outputArray;

	while(inputArray.length > 0)
	{
		string element = inputArray.front();
		inputArray = inputArray.remove(0);
		try
		{
			double currentNum = to!double(element);
			outputArray ~= currentNum;
		}
		catch (ConvException e)
		{
			if(getArithmeticOperatorCount(element) > 0)
			{
				if(outputArray.length < 2)
				{
					throw new StringException("Invalid ordering");
				}
				else
				{
					double secondNum = outputArray.back();
					outputArray = outputArray.remove(outputArray.length-1);
					double firstNum = outputArray.back();
					outputArray = outputArray.remove(outputArray.length-1);
					double currentVal = doTheMath(firstNum, secondNum, element);
					inputArray.insertInPlace(0,to!string(currentVal));
				}
			}
			else if (getGeometricOperatorCount(element) > 0)
			{
				if(outputArray.length < 1)
				{
					throw new StringException("To few values for " + element);
				}
			}
		}
	}
	return outputArray[0];
}

unittest
{
	string input = "1.0 2.0 +";
	double result = input.doTheStuff();
	assert(result == 3.0);
	input = "1.0 2.0 -";
	result = input.doTheStuff();
	assert(result == -1.0);
	input = "1.0 2.0 *";
	result = input.doTheStuff();
	assert(result == 2.0);
	input = "1.0 2.0 /";
	result = input.doTheStuff();
	assert(result == 0.5);
	input = "1.0 2.0 + 3.0 -";
	result = input.doTheStuff();
	assert(result == 0.0);
	input = "1.0 2.0 - 3.0 +";
	result = input.doTheStuff();
	assert(result == 2.0);
	input = "1.0 2.0 * 2.0 /";
	result = input.doTheStuff();
	assert(result == 1.0);
	input = "1.0 2.0 / 3.0 *";
	result = input.doTheStuff();
	assert(result == 1.5);

	try
	{
		input = "1.0 2.0 0.0 / -";
		result = input.doTheStuff();
		assert(false);
	}
	catch (StringException e)
	{
		assert(e.msg == "Divide by zero attempted");
	}

	try
	{
		input = "";
		result = input.doTheStuff();
		assert(false);
	}
	catch (StringException e)
	{
		assert(e.msg == "Empty string");
	}

	input = "1.0";
	result = input.doTheStuff();
	assert(result == 1.0);

	try
	{
		input = "1.0 + 1.0";
		result = input.doTheStuff();
		assert(false);
	}
	catch (StringException e)
	{
		assert(e.msg == "Invalid ordering");
	}

	input = "1.0 1.0 1.0 1.0 + - *";
	result = input.doTheStuff();
	assert(result == -1);

	input = "1.0 1.0 + sin";
	result = input.doTheStuff();
	assert(result == sin(2.0));

}

void main() {
	return;
}
