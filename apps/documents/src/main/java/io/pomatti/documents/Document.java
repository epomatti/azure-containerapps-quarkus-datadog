package io.pomatti.documents;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;

@Entity
public class Document {

  private Long id;
  private String name;

  @Id
  @SequenceGenerator(name = "docSeq", sequenceName = "documents_id_seq", allocationSize = 1, initialValue = 1)
  @GeneratedValue(generator = "docSeq")
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

}
