public class Stack 
{
      public Integer top{get;set;}
      public String[] storage{get;set;}
 
      public Stack(Integer capacity) {
            if (capacity <= 0)
                  throw new StackException('Stack\'s capacity must be positive');
            storage = new String[capacity];
            top = -1;
      }
 
      public void push(String value) {
            if (top == storage.size())
                  throw new StackException('Stack\'s underlying storage is overflow');
            top++;
            storage[top] = value;
      }
 
       
      public String pop() {
            if (top == -1)
                  throw new StackException('Stack is empty');
           return storage[top--];
      }

      public String peek() {
            if (top == -1)
                  throw new StackException('Stack is empty');
	       return storage[top];
	             
      }
 
 
      public boolean isEmpty() {
            return (top == -1);
      }
 
      public class StackException extends Exception {}
      
}