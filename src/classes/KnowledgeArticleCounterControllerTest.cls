@isTest
public class KnowledgeArticleCounterControllerTest {
	public KnowledgeArticleCounterControllerTest() {
		
	}

	static testMethod void testUpdateKnowledgeAticleViews()
	{
        	PageReference pageRef = Page.KnowledgeArticleCounter;
                Test.setCurrentPage(pageRef);
                KnowledgeArticleCounterController controller = new KnowledgeArticleCounterController();
                Alert__kav article=new Alert__kav(Title='Unit Test' , UrlName = 'Unit-Test');
                insert article;


                Test.startTest();
                	controller.KnowledgeArticleId = article.Id;
                	controller.updateKnowledgeAticleViews();
                Test.stopTest();

      
	}

	static testMethod void testperformDML()
	{
        	PageReference pageRef = Page.KnowledgeArticleCounter;
                Test.setCurrentPage(pageRef);
                KnowledgeArticleCounterController controller = new KnowledgeArticleCounterController();
                Test.startTest();
                	controller.performDML(null , '1234' , 'My Test Article' , 'My test Article');
                Test.stopTest();

                List<Knowledge_Article_View__c> articleViews = [SELECT Id FROM Knowledge_Article_View__c];
        	System.assertEquals(1 , articleViews.size() , '1 record should have been created');
	}
}