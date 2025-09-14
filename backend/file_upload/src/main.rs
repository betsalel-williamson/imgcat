use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello world v1!")
}

#[post("/echo")]
async fn echo(req_body: String) -> impl Responder {
    HttpResponse::Ok().body(req_body)
}

#[get("/healthcheck")]
async fn health_check() -> impl Responder {
    HttpResponse::Ok()
}

async fn manual_hello() -> impl Responder {
    HttpResponse::Ok().body("Hey there!")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
        .service(hello)
        .service(echo)
        .service(health_check)
        .route("/hey", web::get().to(manual_hello))
    })
    .bind(("0.0.0.0", 9001))?
    .run()
    .await
}