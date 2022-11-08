package io.pomatti.documents;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/documents")
@RequestScoped
public class DocumentResource {

  @Inject
  DocumentService service;

  @GET
  @Produces(MediaType.APPLICATION_JSON)
  public String get() {
    return "Hello from RESTEasy Reactive";
  }

  @POST
  @Produces(MediaType.APPLICATION_JSON)
  public void post() {
    service.createDocument("123");
  }
}