use clap::{Parser, Subcommand};
use surrealdb::{engine::remote::ws::Ws, opt::auth::Root, Surreal};

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    Set,
    Reset,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenv::dotenv().ok();
    let db = Surreal::new::<Ws>("127.0.0.1:8000").await?;
    db.signin(Root {
        username: &std::env::var("SURREAL_USER")?,
        password: &std::env::var("SURREAL_PASS")?,
    })
    .await?;
    db.use_ns("asymmetric").use_db("asymmetric").await?;
    let cli = Cli::parse();
    match cli.command {
        Commands::Set => println!(
            "{:#?}",
            db.query(include_str!("../queries/set.surql")).await?
        ),
        Commands::Reset => println!(
            "{:#?}",
            db.query(include_str!("../queries/reset.surql")).await?
        ),
    };
    Ok(())
}
