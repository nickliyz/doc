# RustDDS Example

项目地址: https://github.com/jhelovuo/RustDDS/
参考资料: https://github.com/jhelovuo/RustDDS/blob/master/examples/hello_world_publisher/main.rs

# 参考代码
`Cargo.toml`:
```
[package]
name = "rdds-test"
version = "0.1.0"
edition = "2021"

[dependencies]
ctrlc = "3.4.5"
futures = "0.3.30"
rustdds = "0.11.0"
serde = "1.0.210"
smol = "2.0.2"
```

`main.rs`:
```
use std::{thread, time::Duration};

use rustdds::{policy::Reliability, DataWriterStatus, DomainParticipantBuilder, Publisher, QosPolicyBuilder, StatusEvented, TopicKind};
use serde::{Deserialize, Serialize};
use futures::{select, FutureExt, StreamExt};
use smol::Timer;

#[derive(Debug, Clone, Serialize, Deserialize)]
struct HelloWorld {
    pub index: i32,
    pub message: String,
}

fn main() {
    let (stop_sender, stop_receiver) = smol::channel::bounded(1);
    ctrlc::set_handler(move || {
        stop_sender.try_send(()).unwrap();
    }).expect("Error setting Ctrl-C to quit.");
    println!("Press Ctrl-C to quit.");

    let domain_participant = DomainParticipantBuilder::new(0)
        .build()
        .unwrap_or_else(|e| {
            panic!("Error creating DomainParticipant: {:?}", e);
        });

    let qos = QosPolicyBuilder::new()
        .reliability(Reliability::BestEffort)
        .build();
    
    let topic = domain_participant
        .create_topic(
            "HelloWorldTopicliyang".to_string(), 
            "HelloWorld".to_string(), 
            &qos, 
            TopicKind::NoKey).unwrap();

    let publisher = domain_participant.create_publisher(&qos).unwrap();
    let writer = publisher
            .create_datawriter_no_key_cdr::<HelloWorld>(&topic, None).unwrap();
    
    let mut hello_message = HelloWorld {
        index: 0,
        message: "Hello, World!".to_string(),
    };

    smol::block_on(async {
        let mut event_stream = writer.as_async_status_stream();
        let (trigger_sender, trigger_receiver) = smol::channel::bounded(1);

        println!("Ready to say hello!");

        loop {
            futures::select! {
                _ = trigger_receiver.recv().fuse() => {
                    println!("Sending hello");
                    loop {
                        writer.async_write(hello_message.clone(), None).await.unwrap();
                        hello_message.index += 1;
                        // sleep 100ms
                        thread::sleep(Duration::from_millis(100));
                        if hello_message.index > 100 {
                            break;
                        }
                    }
                    break;
                },
                e = event_stream.select_next_some().fuse() => {
                    match e {
                        DataWriterStatus::PublicationMatched{..} => {
                          println!("Matched with hello subscriber");
                          Timer::after(Duration::from_secs(1)).await;
                          trigger_sender.send(()).await.unwrap();
                        }
                        _ =>
                          println!("DataWriter event: {e:?}"),
                      }
                },
            }
        }

        println!("Bye, World!");
    });
}
```
