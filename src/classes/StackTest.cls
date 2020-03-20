@isTest
public class StackTest
{
	final static Integer SIZE = 5;

	static testMethod void testPushIntoStack()
	{
		Stack theStack ;
		Test.startTest();
			theStack = new Stack(SIZE);
			theStack.push('a');
			theStack.push('b');
			theStack.push('c');
		Test.stopTest();
		
		System.assertEquals(2 , theStack.top , 'Value of top should have been 2');
	}

	static testMethod void testPopFromStack()
	{
		Stack theStack ;
		theStack = new Stack(SIZE);
		theStack.push('a');
		theStack.push('b');
		theStack.push('c');
		String poppedElement;
		Test.startTest();
			poppedElement = theStack.pop();
		Test.stopTest();

		System.assertEquals('c' , poppedElement , 'c should have been popped out of stack');
		System.assertEquals(1 , theStack.top , 'Value of top should have been 1');
	}

	static testMethod void testPeekOnStack()
	{
		Stack theStack ;
		theStack = new Stack(SIZE);
		theStack.push('a');
		theStack.push('b');
		theStack.push('c');
		String topElement;
		Test.startTest();
			topElement = theStack.peek();
		Test.stopTest();

		System.assertEquals('c' , topElement , 'Peeked element should have been c');
		System.assertEquals(2 , theStack.top , 'Value of top should have been 2');
	}
}