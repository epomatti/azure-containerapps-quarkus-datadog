package io.pomatti.documents;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("/documents")
@RequestScoped
public class DocumentResource {

  @Inject
  DocumentService service;

  @GET
  @Produces(MediaType.APPLICATION_JSON)
  @Path("{id}")
  public Response get(@PathParam("id") Long id) {
    var doc = service.findDocument(id);
    return Response
        .status(Response.Status.OK)
        .entity(doc)
        .build();
  }

  @POST
  @Produces(MediaType.APPLICATION_JSON)
  public void post() {
    service.createDocument("123");
  }
}