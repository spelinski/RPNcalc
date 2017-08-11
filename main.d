import std.string;
import std.conv;
import std.regex;
import std.math;
import core.stdc.stdlib;

extern(C) int strcmp(const char* s1, const char* s2);

double doTheMath(double firstNum, double secondNum, string sign)
{
	if(strcmp(sign.toStringz,"-") == 0)
	{
		return firstNum - secondNum;
	}
	else if(strcmp(sign.toStringz,"+") == 0)
	{
		return firstNum + secondNum;
	}
	else if(strcmp(sign.toStringz,"*") == 0)
	{
		return firstNum * secondNum;
	}
	else
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

double doGeometry(double number, string operator)
{
	if(strcmp(operator.toLower.toStringz,"sin") == 0)
	{
		return number.sin;
	}
	else
	{
		return number.cos;
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
	double operatorCount = input.getArithmeticOperatorCount;
	assert(operatorCount == 1);
	input = "1.0 2.0 3.0 + -";
	operatorCount = input.getArithmeticOperatorCount;
	assert(operatorCount == 2);
}

double getGeometricOperatorCount(string stringForOper)
{
	auto capture = matchAll(stringForOper.toLower, r"sin|cos");
	if(!capture.empty)
	{
		return capture.count;
	}
	return 0.0;
}

unittest
{
	string input = "1.0 sin";
	double operatorCount = input.getGeometricOperatorCount;
	assert(operatorCount == 1);
	input = "1.0 sin cos";
	operatorCount = input.getGeometricOperatorCount;
	assert(operatorCount == 2);
}

double calculateValueFromString(string inputString)
{
	import std.array;
	import std.algorithm;

	string[] inputArray = inputString.split(" ");
	if(inputArray.length == 0)
	{
		throw new StringException("Empty string");
	}

	double[] outputArray;

	while(inputArray.length > 0)
	{
		string element = inputArray.front;
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
					double secondNum = outputArray.back;
					outputArray = outputArray.remove(outputArray.length-1);
					double firstNum = outputArray.back;
					outputArray = outputArray.remove(outputArray.length-1);
					double currentVal = doTheMath(firstNum, secondNum, element);
					inputArray.insertInPlace(0,to!string(currentVal));
				}
			}
			else if (getGeometricOperatorCount(element) > 0)
			{
				if(outputArray.length < 1)
				{
					throw new StringException(("To few values for " ~ element));
				}
				double onlyNum = outputArray.back;
				outputArray = outputArray.remove(outputArray.length-1);
				double currentVal = doGeometry(onlyNum, element);
				inputArray.insertInPlace(0,to!string(currentVal));
			}
			else
			{
				throw new StringException(("Invalid character " ~ element));
			}
		}
	}
	return outputArray[0];
}

unittest
{
	string input = "1.0 2.0 +";
	double result = input.calculateValueFromString;
	assert(result == 3.0);
	input = "1.0 2.0 -";
	result = input.calculateValueFromString;
	assert(result == -1.0);
	input = "1.0 2.0 *";
	result = input.calculateValueFromString;
	assert(result == 2.0);
	input = "1.0 2.0 /";
	result = input.calculateValueFromString;
	assert(result == 0.5);
	input = "1.0 2.0 + 3.0 -";
	result = input.calculateValueFromString;
	assert(result == 0.0);
	input = "1.0 2.0 - 3.0 +";
	result = input.calculateValueFromString;
	assert(result == 2.0);
	input = "1.0 2.0 * 2.0 /";
	result = input.calculateValueFromString;
	assert(result == 1.0);
	input = "1.0 2.0 / 3.0 *";
	result = input.calculateValueFromString;
	assert(result == 1.5);

	try
	{
		input = "1.0 2.0 0.0 / -";
		result = input.calculateValueFromString;
		assert(false);
	}
	catch (StringException e)
	{
		assert(e.msg == "Divide by zero attempted");
	}

	try
	{
		input = "";
		result = input.calculateValueFromString;
		assert(false);
	}
	catch (StringException e)
	{
		assert(e.msg == "Empty string");
	}

	input = "1.0";
	result = input.calculateValueFromString;
	assert(result == 1.0);

	try
	{
		input = "1.0 + 1.0";
		result = input.calculateValueFromString;
		assert(false);
	}
	catch (StringException e)
	{
		assert(e.msg == "Invalid ordering");
	}

	input = "1.0 1.0 1.0 1.0 + - *";
	result = input.calculateValueFromString;
	assert(result == -1);

	input = "1.0 1.0 + sin";
	result = input.calculateValueFromString;
	string resultString = to!string(result);
	string expectedString = to!string(sin(2.0));
	assert(resultString == expectedString);

	input = "1.0 1.0 + cos";
	result = input.calculateValueFromString;
	resultString = to!string(result);
	expectedString = to!string(cos(2.0));
	assert(resultString == expectedString);

	input = "1.0 1.0 + SIN";
	result = input.calculateValueFromString;
	resultString = to!string(result);
	expectedString = to!string(sin(2.0));
	assert(resultString == expectedString);

	input = "1.0 1.0 + COS";
	result = input.calculateValueFromString;
	resultString = to!string(result);
	expectedString = to!string(cos(2.0));
	assert(resultString == expectedString);

}

void main()
{
	import std.stdio;
	string line = "";
	writeln("enter exit to exit");
	while ((line = readln.strip) !is null)
	{
		if(line.toLower == "exit")
		{
			exit(0);
		}
		try
		{
			writeln(line.calculateValueFromString);
		}
		catch (StringException e)
		{
			writeln(e.msg);
		}
	}
}
