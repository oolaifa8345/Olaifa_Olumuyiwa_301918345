// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("payment_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("payment_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "payment_initiated",
                    "payment_settled"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "payment"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "payment_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("payment_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "payment_initiated",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "payment",
            "key": {
                "payment_id": 3001
            },
            "snapshot": {
                "payment_id": 3001,
                "account_id": 2001,
                "amount": 25.75,
                "status": "settled",
                "initiated_at": "2026-02-01T12:30:00Z",
                "reference": "PAY-001",
                "settled_at": "2026-02-01T12:31:00Z"
            }
        },
        "embedded": {
            "account": [
                {
                    "key": {
                        "account_id": 2001
                    },
                    "snapshot": {
                        "account_id": 2001,
                        "customer_id": 1001,
                        "account_number": "ACCT-2001",
                        "currency": "USD",
                        "balance": 1250.5,
                        "status": "active",
                        "opened_on": "2026-01-16"
                    },
                    "via": [
                        "payment.account_id → account"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "payment_settled",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "payment",
            "key": {
                "payment_id": 3001
            },
            "snapshot": {
                "payment_id": 3001,
                "account_id": 2001,
                "amount": 25.75,
                "status": "settled",
                "initiated_at": "2026-02-01T12:30:00Z",
                "reference": "PAY-001",
                "settled_at": "2026-02-01T12:31:00Z"
            }
        },
        "embedded": {
            "account": [
                {
                    "key": {
                        "account_id": 2001
                    },
                    "snapshot": {
                        "account_id": 2001,
                        "customer_id": 1001,
                        "account_number": "ACCT-2001",
                        "currency": "USD",
                        "balance": 1250.5,
                        "status": "active",
                        "opened_on": "2026-01-16"
                    },
                    "via": [
                        "payment.account_id → account"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "provider_metadata": "illustrative provider_metadata",
                "failure_detail": "illustrative failure_detail",
                "risk_signals": "illustrative risk_signals"
            }
        }
    }
]));
  await db.getCollection("payment_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("payment_events").find({"eventType":"payment_initiated"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("payment_events").find({"source.key.payment_id":3001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("payment_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("payment_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("payment_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "payment_initiated",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "payment",
        "key": {
            "payment_id": 3001
        },
        "snapshot": {
            "payment_id": 3001,
            "account_id": 2001,
            "amount": 25.75,
            "status": "settled",
            "initiated_at": "2026-02-01T12:30:00Z",
            "reference": "PAY-001",
            "settled_at": "2026-02-01T12:31:00Z"
        }
    },
    "embedded": {
        "account": [
            {
                "key": {
                    "account_id": 2001
                },
                "snapshot": {
                    "account_id": 2001,
                    "customer_id": 1001,
                    "account_number": "ACCT-2001",
                    "currency": "USD",
                    "balance": 1250.5,
                    "status": "active",
                    "opened_on": "2026-01-16"
                },
                "via": [
                    "payment.account_id → account"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("payment_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "payment_initiated",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "payment",
        "key": {
            "payment_id": 3001
        },
        "snapshot": {
            "payment_id": 3001,
            "account_id": 2001,
            "amount": 25.75,
            "status": "settled",
            "initiated_at": "2026-02-01T12:30:00Z",
            "reference": "PAY-001",
            "settled_at": "2026-02-01T12:31:00Z"
        }
    },
    "embedded": {
        "account": [
            {
                "key": {
                    "account_id": 2001
                },
                "snapshot": {
                    "account_id": 2001,
                    "customer_id": 1001,
                    "account_number": "ACCT-2001",
                    "currency": "USD",
                    "balance": 1250.5,
                    "status": "active",
                    "opened_on": "2026-01-16"
                },
                "via": [
                    "payment.account_id → account"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("payment_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
