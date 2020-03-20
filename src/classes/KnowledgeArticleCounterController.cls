public with sharing class KnowledgeArticleCounterController {
	public Id KnowledgeArticleId{get;set;}
	public void updateKnowledgeAticleViews()
	{
		List<KnowledgeArticleVersion> theVersion = [SELECT Id  , KnowledgeArticleId  ,  ArticleNumber , Title , UrlName  FROM KnowledgeArticleVersion WHERE KnowledgeArticleId = :KnowledgeArticleId AND PublishStatus = 'Online'];
		if(theVersion.size() == 1)
		{
			performDML( theVersion[0].KnowledgeArticleId , theVersion[0].ArticleNumber , theVersion[0].Title , theVersion[0].UrlName);
		}
	}

	public void performDML(Id articleId , String articleNumber , String title , String theURL)
	{
		Knowledge_Article_View__c theArticleView = new Knowledge_Article_View__c();
		theArticleView.Article_Id__c = articleId;
		theArticleView.Article_Number__c = articleNumber;
		theArticleView.Article_Title__c = title;
		theArticleView.Article_URL__c = theURL;
		theArticleView.Article_Viewed_by__c = UserInfo.getUserId();
		insert theArticleView;
	}
		
}