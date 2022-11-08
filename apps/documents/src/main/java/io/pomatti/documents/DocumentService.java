package io.pomatti.documents;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.transaction.Transactional;

@RequestScoped
public class DocumentService {

  @Inject
  EntityManager em;

  @Transactional
  public void createDocument(String name) {
    Document doc = new Document();
    doc.setName(name);
    em.persist(doc);
  }

}