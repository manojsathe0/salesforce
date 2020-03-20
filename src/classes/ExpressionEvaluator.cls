public with sharing class ExpressionEvaluator 
{
	final static String T = 't';
	final static String F = 'f';
	public ExpressionEvaluator()
	{

	}
	//Computes the postfix expresssion Eg. 12&34&|
	public static Boolean computePostfix(String postfix) 
	{
		if(postfix == T)
		{
			return true;
		}
		else if(postfix == F)
		{
			return false;
		}
		Stack theStack = new Stack(postfix.length());
		//break the expression into tokens
		String[] tokens = postfix.split('');
		for (String token : tokens) 
		{
			if (token.equals('&') || token.equals('|')) 
			{
				applyOperator(token, theStack);
			}  
			else 
			{ // an operand
				theStack.push(token);
			}
		}
		String result = theStack.pop();
		Boolean finalResult;
		if(result == T)
			finalResult = true;
		else
			finalResult = false;
		return finalResult;
	}


	public static void applyOperator(String operator, Stack s) 
	{
		String op1 = s.pop();
		Boolean operator1;
		if(op1 == T)
			operator1 = true;
		else
			operator1 = false;

		Boolean operator2;

		String op2 = s.pop();
		if(op2 == T)
			operator2 = true;
		else
			operator2 = false;

		Boolean  result;
		if (operator.equals('&')) 
		{
			result = operator2 && operator1;
		} 
		else if (operator.equals('|')) 
		{
			result = operator2 || operator1;
		} 
		String finalResult;
		if(result == true)
			finalResult = T;
		else
			finalResult = F;
		s.push(finalResult);
	}
}