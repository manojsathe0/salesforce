@isTest
public class ExpressionEvaluatorTest 
{
	
	static testMethod void testComputePostfixExpressionFirst()
	{
		String theExpression = 'tt&';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(theResult , 'Result should have been true'); 
		Test.stopTest();
	}
	static testMethod void testComputePostfixExpressionSecond()
	{
		String theExpression = 'tf&';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(!theResult , 'Result should have been false'); 
		Test.stopTest();
	}

	static testMethod void testComputePostfixExpressionThird()
	{
		String theExpression = 'tf|';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(theResult , 'Result should have been true'); 
		Test.stopTest();
	}

	static testMethod void testComputePostfixExpressionFourth()
	{
		String theExpression = 't';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(theResult , 'Result should have been true'); 
		Test.stopTest();
	}

	static testMethod void testComputePostfixExpressionFifth()
	{
		String theExpression = 'tt&ff&&';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(!theResult , 'Result should have been false'); 
		Test.stopTest();
	}

	static testMethod void testComputePostfixExpressionSixth()
	{
		String theExpression = 'tt&ff&|';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(theResult , 'Result should have been true'); 
		Test.stopTest();
	}

	static testMethod void testComputePostfixExpressionSeventh()
	{
		String theExpression = 'tf|tf|&';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(theResult , 'Result should have been true'); 
		Test.stopTest();
	}
	static testMethod void testComputePostfixExpressionEigth()
	{
		String theExpression = 'tf&tt&|ff&|';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(theResult , 'Result should have been true'); 
		Test.stopTest();
	}
	static testMethod void testComputePostfixExpressionNineth()
	{
		String theExpression = 'tf&tt&|ff&&';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(!theResult , 'Result should have been false'); 
		Test.stopTest();
	}
	static testMethod void testComputePostfixExpressionTenth()
	{
		String theExpression = 'tf&tt&ff&|&';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(!theResult , 'Result should have been false'); 
		Test.stopTest();
	}

	static testMethod void testComputePostfixExpressionEleventh()
	{
		String theExpression = 'tft|&';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(theResult , 'Result should have been true'); 
		Test.stopTest();
	}
	static testMethod void testComputePostfixExpressionTwelveth()
	{
		String theExpression = 'tftf||&';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(theResult , 'Result should have been true'); 
		Test.stopTest();
	}
	static testMethod void testComputePostfixExpressionThirteenth()
	{
		String theExpression = 'fftf||&';
		Test.startTest();
			Boolean theResult = ExpressionEvaluator.computePostfix(theExpression);
			System.assert(!theResult , 'Result should have been false'); 
		Test.stopTest();
	}


}