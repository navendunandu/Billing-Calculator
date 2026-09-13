// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LedgersTable extends Ledgers with TableInfo<$LedgersTable, Ledger> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, type, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledgers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ledger> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ledger map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ledger(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LedgersTable createAlias(String alias) {
    return $LedgersTable(attachedDatabase, alias);
  }
}

class Ledger extends DataClass implements Insertable<Ledger> {
  final int id;
  final String name;
  final String type;
  final DateTime createdAt;
  const Ledger({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LedgersCompanion toCompanion(bool nullToAbsent) {
    return LedgersCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      createdAt: Value(createdAt),
    );
  }

  factory Ledger.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ledger(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Ledger copyWith({int? id, String? name, String? type, DateTime? createdAt}) =>
      Ledger(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
      );
  Ledger copyWithCompanion(LedgersCompanion data) {
    return Ledger(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ledger(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ledger &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.createdAt == this.createdAt);
}

class LedgersCompanion extends UpdateCompanion<Ledger> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<DateTime> createdAt;
  const LedgersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LedgersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       type = Value(type);
  static Insertable<Ledger> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LedgersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<DateTime>? createdAt,
  }) {
    return LedgersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditLimitMeta = const VerificationMeta(
    'creditLimit',
  );
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
    'credit_limit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(500.0),
  );
  static const VerificationMeta _creditDueMeta = const VerificationMeta(
    'creditDue',
  );
  @override
  late final GeneratedColumn<double> creditDue = GeneratedColumn<double>(
    'credit_due',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ledgerIdMeta = const VerificationMeta(
    'ledgerId',
  );
  @override
  late final GeneratedColumn<int> ledgerId = GeneratedColumn<int>(
    'ledger_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledgers (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    creditLimit,
    creditDue,
    phone,
    address,
    ledgerId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
        _creditLimitMeta,
        creditLimit.isAcceptableOrUnknown(
          data['credit_limit']!,
          _creditLimitMeta,
        ),
      );
    }
    if (data.containsKey('credit_due')) {
      context.handle(
        _creditDueMeta,
        creditDue.isAcceptableOrUnknown(data['credit_due']!, _creditDueMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('ledger_id')) {
      context.handle(
        _ledgerIdMeta,
        ledgerId.isAcceptableOrUnknown(data['ledger_id']!, _ledgerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ledgerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      creditLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit_limit'],
      )!,
      creditDue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit_due'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      ledgerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ledger_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final double creditLimit;
  final double creditDue;
  final String? phone;
  final String? address;
  final int ledgerId;
  final DateTime createdAt;
  const Customer({
    required this.id,
    required this.name,
    required this.creditLimit,
    required this.creditDue,
    this.phone,
    this.address,
    required this.ledgerId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['credit_limit'] = Variable<double>(creditLimit);
    map['credit_due'] = Variable<double>(creditDue);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['ledger_id'] = Variable<int>(ledgerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      creditLimit: Value(creditLimit),
      creditDue: Value(creditDue),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      ledgerId: Value(ledgerId),
      createdAt: Value(createdAt),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      creditLimit: serializer.fromJson<double>(json['creditLimit']),
      creditDue: serializer.fromJson<double>(json['creditDue']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      ledgerId: serializer.fromJson<int>(json['ledgerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'creditLimit': serializer.toJson<double>(creditLimit),
      'creditDue': serializer.toJson<double>(creditDue),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'ledgerId': serializer.toJson<int>(ledgerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Customer copyWith({
    int? id,
    String? name,
    double? creditLimit,
    double? creditDue,
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    int? ledgerId,
    DateTime? createdAt,
  }) => Customer(
    id: id ?? this.id,
    name: name ?? this.name,
    creditLimit: creditLimit ?? this.creditLimit,
    creditDue: creditDue ?? this.creditDue,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    ledgerId: ledgerId ?? this.ledgerId,
    createdAt: createdAt ?? this.createdAt,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      creditLimit: data.creditLimit.present
          ? data.creditLimit.value
          : this.creditLimit,
      creditDue: data.creditDue.present ? data.creditDue.value : this.creditDue,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      ledgerId: data.ledgerId.present ? data.ledgerId.value : this.ledgerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('creditDue: $creditDue, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('ledgerId: $ledgerId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    creditLimit,
    creditDue,
    phone,
    address,
    ledgerId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.creditLimit == this.creditLimit &&
          other.creditDue == this.creditDue &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.ledgerId == this.ledgerId &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> creditLimit;
  final Value<double> creditDue;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<int> ledgerId;
  final Value<DateTime> createdAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.creditDue = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.ledgerId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.creditLimit = const Value.absent(),
    this.creditDue = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    required int ledgerId,
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       ledgerId = Value(ledgerId);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? creditLimit,
    Expression<double>? creditDue,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<int>? ledgerId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (creditDue != null) 'credit_due': creditDue,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (ledgerId != null) 'ledger_id': ledgerId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? creditLimit,
    Value<double>? creditDue,
    Value<String?>? phone,
    Value<String?>? address,
    Value<int>? ledgerId,
    Value<DateTime>? createdAt,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      creditLimit: creditLimit ?? this.creditLimit,
      creditDue: creditDue ?? this.creditDue,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      ledgerId: ledgerId ?? this.ledgerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (creditDue.present) {
      map['credit_due'] = Variable<double>(creditDue.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (ledgerId.present) {
      map['ledger_id'] = Variable<int>(ledgerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('creditDue: $creditDue, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('ledgerId: $ledgerId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _invoiceNoMeta = const VerificationMeta(
    'invoiceNo',
  );
  @override
  late final GeneratedColumn<String> invoiceNo = GeneratedColumn<String>(
    'invoice_no',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _subtotalAmountMeta = const VerificationMeta(
    'subtotalAmount',
  );
  @override
  late final GeneratedColumn<double> subtotalAmount = GeneratedColumn<double>(
    'subtotal_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
    'discount_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _taxableAmountMeta = const VerificationMeta(
    'taxableAmount',
  );
  @override
  late final GeneratedColumn<double> taxableAmount = GeneratedColumn<double>(
    'taxable_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalTaxAmountMeta = const VerificationMeta(
    'totalTaxAmount',
  );
  @override
  late final GeneratedColumn<double> totalTaxAmount = GeneratedColumn<double>(
    'total_tax_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _cgstAmountMeta = const VerificationMeta(
    'cgstAmount',
  );
  @override
  late final GeneratedColumn<double> cgstAmount = GeneratedColumn<double>(
    'cgst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _sgstAmountMeta = const VerificationMeta(
    'sgstAmount',
  );
  @override
  late final GeneratedColumn<double> sgstAmount = GeneratedColumn<double>(
    'sgst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMode, int> paymentMode =
      GeneratedColumn<int>(
        'payment_mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<PaymentMode>($InvoicesTable.$converterpaymentMode);
  @override
  late final GeneratedColumnWithTypeConverter<PaymentStatus, int>
  paymentStatus = GeneratedColumn<int>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<PaymentStatus>($InvoicesTable.$converterpaymentStatus);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    invoiceNo,
    subtotalAmount,
    discountAmount,
    totalAmount,
    taxableAmount,
    totalTaxAmount,
    cgstAmount,
    sgstAmount,
    paidAmount,
    paymentMode,
    paymentStatus,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('invoice_no')) {
      context.handle(
        _invoiceNoMeta,
        invoiceNo.isAcceptableOrUnknown(data['invoice_no']!, _invoiceNoMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceNoMeta);
    }
    if (data.containsKey('subtotal_amount')) {
      context.handle(
        _subtotalAmountMeta,
        subtotalAmount.isAcceptableOrUnknown(
          data['subtotal_amount']!,
          _subtotalAmountMeta,
        ),
      );
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('taxable_amount')) {
      context.handle(
        _taxableAmountMeta,
        taxableAmount.isAcceptableOrUnknown(
          data['taxable_amount']!,
          _taxableAmountMeta,
        ),
      );
    }
    if (data.containsKey('total_tax_amount')) {
      context.handle(
        _totalTaxAmountMeta,
        totalTaxAmount.isAcceptableOrUnknown(
          data['total_tax_amount']!,
          _totalTaxAmountMeta,
        ),
      );
    }
    if (data.containsKey('cgst_amount')) {
      context.handle(
        _cgstAmountMeta,
        cgstAmount.isAcceptableOrUnknown(data['cgst_amount']!, _cgstAmountMeta),
      );
    }
    if (data.containsKey('sgst_amount')) {
      context.handle(
        _sgstAmountMeta,
        sgstAmount.isAcceptableOrUnknown(data['sgst_amount']!, _sgstAmountMeta),
      );
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      ),
      invoiceNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_no'],
      )!,
      subtotalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal_amount'],
      )!,
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_amount'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      taxableAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}taxable_amount'],
      )!,
      totalTaxAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_tax_amount'],
      )!,
      cgstAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cgst_amount'],
      )!,
      sgstAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sgst_amount'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paid_amount'],
      )!,
      paymentMode: $InvoicesTable.$converterpaymentMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}payment_mode'],
        )!,
      ),
      paymentStatus: $InvoicesTable.$converterpaymentStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}payment_status'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentMode, int, int> $converterpaymentMode =
      const EnumIndexConverter<PaymentMode>(PaymentMode.values);
  static JsonTypeConverter2<PaymentStatus, int, int> $converterpaymentStatus =
      const EnumIndexConverter<PaymentStatus>(PaymentStatus.values);
}

class Invoice extends DataClass implements Insertable<Invoice> {
  /// Primary key - auto increment
  final int id;

  /// Optional customer reference for credit invoices
  final int? customerId;

  /// Unique invoice number (e.g., INV-20260125-001)
  final String invoiceNo;

  /// Total amount before discount
  final double subtotalAmount;

  /// Discount amount
  final double discountAmount;

  /// Total amount after discount
  final double totalAmount;

  /// Total taxable amount (pre-tax base)
  final double taxableAmount;

  /// Total tax amount (CGST + SGST)
  final double totalTaxAmount;

  /// Total CGST amount
  final double cgstAmount;

  /// Total SGST amount
  final double sgstAmount;

  /// Amount already paid against the invoice
  final double paidAmount;

  /// Payment mode (cash, upi, credit)
  final PaymentMode paymentMode;

  /// Payment status (pending, partial, fulfilled)
  final PaymentStatus paymentStatus;

  /// Optional notes
  final String? notes;

  /// Created timestamp
  final DateTime createdAt;

  /// Updated timestamp
  final DateTime updatedAt;
  const Invoice({
    required this.id,
    this.customerId,
    required this.invoiceNo,
    required this.subtotalAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.taxableAmount,
    required this.totalTaxAmount,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.paidAmount,
    required this.paymentMode,
    required this.paymentStatus,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    map['invoice_no'] = Variable<String>(invoiceNo);
    map['subtotal_amount'] = Variable<double>(subtotalAmount);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['total_amount'] = Variable<double>(totalAmount);
    map['taxable_amount'] = Variable<double>(taxableAmount);
    map['total_tax_amount'] = Variable<double>(totalTaxAmount);
    map['cgst_amount'] = Variable<double>(cgstAmount);
    map['sgst_amount'] = Variable<double>(sgstAmount);
    map['paid_amount'] = Variable<double>(paidAmount);
    {
      map['payment_mode'] = Variable<int>(
        $InvoicesTable.$converterpaymentMode.toSql(paymentMode),
      );
    }
    {
      map['payment_status'] = Variable<int>(
        $InvoicesTable.$converterpaymentStatus.toSql(paymentStatus),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      invoiceNo: Value(invoiceNo),
      subtotalAmount: Value(subtotalAmount),
      discountAmount: Value(discountAmount),
      totalAmount: Value(totalAmount),
      taxableAmount: Value(taxableAmount),
      totalTaxAmount: Value(totalTaxAmount),
      cgstAmount: Value(cgstAmount),
      sgstAmount: Value(sgstAmount),
      paidAmount: Value(paidAmount),
      paymentMode: Value(paymentMode),
      paymentStatus: Value(paymentStatus),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Invoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<int>(json['id']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      invoiceNo: serializer.fromJson<String>(json['invoiceNo']),
      subtotalAmount: serializer.fromJson<double>(json['subtotalAmount']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      taxableAmount: serializer.fromJson<double>(json['taxableAmount']),
      totalTaxAmount: serializer.fromJson<double>(json['totalTaxAmount']),
      cgstAmount: serializer.fromJson<double>(json['cgstAmount']),
      sgstAmount: serializer.fromJson<double>(json['sgstAmount']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      paymentMode: $InvoicesTable.$converterpaymentMode.fromJson(
        serializer.fromJson<int>(json['paymentMode']),
      ),
      paymentStatus: $InvoicesTable.$converterpaymentStatus.fromJson(
        serializer.fromJson<int>(json['paymentStatus']),
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerId': serializer.toJson<int?>(customerId),
      'invoiceNo': serializer.toJson<String>(invoiceNo),
      'subtotalAmount': serializer.toJson<double>(subtotalAmount),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'taxableAmount': serializer.toJson<double>(taxableAmount),
      'totalTaxAmount': serializer.toJson<double>(totalTaxAmount),
      'cgstAmount': serializer.toJson<double>(cgstAmount),
      'sgstAmount': serializer.toJson<double>(sgstAmount),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'paymentMode': serializer.toJson<int>(
        $InvoicesTable.$converterpaymentMode.toJson(paymentMode),
      ),
      'paymentStatus': serializer.toJson<int>(
        $InvoicesTable.$converterpaymentStatus.toJson(paymentStatus),
      ),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Invoice copyWith({
    int? id,
    Value<int?> customerId = const Value.absent(),
    String? invoiceNo,
    double? subtotalAmount,
    double? discountAmount,
    double? totalAmount,
    double? taxableAmount,
    double? totalTaxAmount,
    double? cgstAmount,
    double? sgstAmount,
    double? paidAmount,
    PaymentMode? paymentMode,
    PaymentStatus? paymentStatus,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Invoice(
    id: id ?? this.id,
    customerId: customerId.present ? customerId.value : this.customerId,
    invoiceNo: invoiceNo ?? this.invoiceNo,
    subtotalAmount: subtotalAmount ?? this.subtotalAmount,
    discountAmount: discountAmount ?? this.discountAmount,
    totalAmount: totalAmount ?? this.totalAmount,
    taxableAmount: taxableAmount ?? this.taxableAmount,
    totalTaxAmount: totalTaxAmount ?? this.totalTaxAmount,
    cgstAmount: cgstAmount ?? this.cgstAmount,
    sgstAmount: sgstAmount ?? this.sgstAmount,
    paidAmount: paidAmount ?? this.paidAmount,
    paymentMode: paymentMode ?? this.paymentMode,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      invoiceNo: data.invoiceNo.present ? data.invoiceNo.value : this.invoiceNo,
      subtotalAmount: data.subtotalAmount.present
          ? data.subtotalAmount.value
          : this.subtotalAmount,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      taxableAmount: data.taxableAmount.present
          ? data.taxableAmount.value
          : this.taxableAmount,
      totalTaxAmount: data.totalTaxAmount.present
          ? data.totalTaxAmount.value
          : this.totalTaxAmount,
      cgstAmount: data.cgstAmount.present
          ? data.cgstAmount.value
          : this.cgstAmount,
      sgstAmount: data.sgstAmount.present
          ? data.sgstAmount.value
          : this.sgstAmount,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('invoiceNo: $invoiceNo, ')
          ..write('subtotalAmount: $subtotalAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('totalTaxAmount: $totalTaxAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    invoiceNo,
    subtotalAmount,
    discountAmount,
    totalAmount,
    taxableAmount,
    totalTaxAmount,
    cgstAmount,
    sgstAmount,
    paidAmount,
    paymentMode,
    paymentStatus,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.invoiceNo == this.invoiceNo &&
          other.subtotalAmount == this.subtotalAmount &&
          other.discountAmount == this.discountAmount &&
          other.totalAmount == this.totalAmount &&
          other.taxableAmount == this.taxableAmount &&
          other.totalTaxAmount == this.totalTaxAmount &&
          other.cgstAmount == this.cgstAmount &&
          other.sgstAmount == this.sgstAmount &&
          other.paidAmount == this.paidAmount &&
          other.paymentMode == this.paymentMode &&
          other.paymentStatus == this.paymentStatus &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<int> id;
  final Value<int?> customerId;
  final Value<String> invoiceNo;
  final Value<double> subtotalAmount;
  final Value<double> discountAmount;
  final Value<double> totalAmount;
  final Value<double> taxableAmount;
  final Value<double> totalTaxAmount;
  final Value<double> cgstAmount;
  final Value<double> sgstAmount;
  final Value<double> paidAmount;
  final Value<PaymentMode> paymentMode;
  final Value<PaymentStatus> paymentStatus;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.invoiceNo = const Value.absent(),
    this.subtotalAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.taxableAmount = const Value.absent(),
    this.totalTaxAmount = const Value.absent(),
    this.cgstAmount = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    required String invoiceNo,
    this.subtotalAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.taxableAmount = const Value.absent(),
    this.totalTaxAmount = const Value.absent(),
    this.cgstAmount = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    required PaymentMode paymentMode,
    required PaymentStatus paymentStatus,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : invoiceNo = Value(invoiceNo),
       paymentMode = Value(paymentMode),
       paymentStatus = Value(paymentStatus);
  static Insertable<Invoice> custom({
    Expression<int>? id,
    Expression<int>? customerId,
    Expression<String>? invoiceNo,
    Expression<double>? subtotalAmount,
    Expression<double>? discountAmount,
    Expression<double>? totalAmount,
    Expression<double>? taxableAmount,
    Expression<double>? totalTaxAmount,
    Expression<double>? cgstAmount,
    Expression<double>? sgstAmount,
    Expression<double>? paidAmount,
    Expression<int>? paymentMode,
    Expression<int>? paymentStatus,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (invoiceNo != null) 'invoice_no': invoiceNo,
      if (subtotalAmount != null) 'subtotal_amount': subtotalAmount,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (taxableAmount != null) 'taxable_amount': taxableAmount,
      if (totalTaxAmount != null) 'total_tax_amount': totalTaxAmount,
      if (cgstAmount != null) 'cgst_amount': cgstAmount,
      if (sgstAmount != null) 'sgst_amount': sgstAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InvoicesCompanion copyWith({
    Value<int>? id,
    Value<int?>? customerId,
    Value<String>? invoiceNo,
    Value<double>? subtotalAmount,
    Value<double>? discountAmount,
    Value<double>? totalAmount,
    Value<double>? taxableAmount,
    Value<double>? totalTaxAmount,
    Value<double>? cgstAmount,
    Value<double>? sgstAmount,
    Value<double>? paidAmount,
    Value<PaymentMode>? paymentMode,
    Value<PaymentStatus>? paymentStatus,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      subtotalAmount: subtotalAmount ?? this.subtotalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      totalTaxAmount: totalTaxAmount ?? this.totalTaxAmount,
      cgstAmount: cgstAmount ?? this.cgstAmount,
      sgstAmount: sgstAmount ?? this.sgstAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      paymentMode: paymentMode ?? this.paymentMode,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (invoiceNo.present) {
      map['invoice_no'] = Variable<String>(invoiceNo.value);
    }
    if (subtotalAmount.present) {
      map['subtotal_amount'] = Variable<double>(subtotalAmount.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (taxableAmount.present) {
      map['taxable_amount'] = Variable<double>(taxableAmount.value);
    }
    if (totalTaxAmount.present) {
      map['total_tax_amount'] = Variable<double>(totalTaxAmount.value);
    }
    if (cgstAmount.present) {
      map['cgst_amount'] = Variable<double>(cgstAmount.value);
    }
    if (sgstAmount.present) {
      map['sgst_amount'] = Variable<double>(sgstAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<int>(
        $InvoicesTable.$converterpaymentMode.toSql(paymentMode.value),
      );
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<int>(
        $InvoicesTable.$converterpaymentStatus.toSql(paymentStatus.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('invoiceNo: $invoiceNo, ')
          ..write('subtotalAmount: $subtotalAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('totalTaxAmount: $totalTaxAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InvoiceItemsTable extends InvoiceItems
    with TableInfo<$InvoiceItemsTable, InvoiceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
    'discount_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _taxableAmountMeta = const VerificationMeta(
    'taxableAmount',
  );
  @override
  late final GeneratedColumn<double> taxableAmount = GeneratedColumn<double>(
    'taxable_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _taxAmountMeta = const VerificationMeta(
    'taxAmount',
  );
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
    'tax_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _cgstAmountMeta = const VerificationMeta(
    'cgstAmount',
  );
  @override
  late final GeneratedColumn<double> cgstAmount = GeneratedColumn<double>(
    'cgst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _sgstAmountMeta = const VerificationMeta(
    'sgstAmount',
  );
  @override
  late final GeneratedColumn<double> sgstAmount = GeneratedColumn<double>(
    'sgst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isTaxInclusiveMeta = const VerificationMeta(
    'isTaxInclusive',
  );
  @override
  late final GeneratedColumn<bool> isTaxInclusive = GeneratedColumn<bool>(
    'is_tax_inclusive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_tax_inclusive" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _serialNoMeta = const VerificationMeta(
    'serialNo',
  );
  @override
  late final GeneratedColumn<int> serialNo = GeneratedColumn<int>(
    'serial_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceId,
    itemName,
    quantity,
    rate,
    total,
    discountAmount,
    hsnCode,
    taxRate,
    taxableAmount,
    taxAmount,
    cgstAmount,
    sgstAmount,
    isTaxInclusive,
    serialNo,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('taxable_amount')) {
      context.handle(
        _taxableAmountMeta,
        taxableAmount.isAcceptableOrUnknown(
          data['taxable_amount']!,
          _taxableAmountMeta,
        ),
      );
    }
    if (data.containsKey('tax_amount')) {
      context.handle(
        _taxAmountMeta,
        taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta),
      );
    }
    if (data.containsKey('cgst_amount')) {
      context.handle(
        _cgstAmountMeta,
        cgstAmount.isAcceptableOrUnknown(data['cgst_amount']!, _cgstAmountMeta),
      );
    }
    if (data.containsKey('sgst_amount')) {
      context.handle(
        _sgstAmountMeta,
        sgstAmount.isAcceptableOrUnknown(data['sgst_amount']!, _sgstAmountMeta),
      );
    }
    if (data.containsKey('is_tax_inclusive')) {
      context.handle(
        _isTaxInclusiveMeta,
        isTaxInclusive.isAcceptableOrUnknown(
          data['is_tax_inclusive']!,
          _isTaxInclusiveMeta,
        ),
      );
    }
    if (data.containsKey('serial_no')) {
      context.handle(
        _serialNoMeta,
        serialNo.isAcceptableOrUnknown(data['serial_no']!, _serialNoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_amount'],
      )!,
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      ),
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      taxableAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}taxable_amount'],
      )!,
      taxAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_amount'],
      )!,
      cgstAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cgst_amount'],
      )!,
      sgstAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sgst_amount'],
      )!,
      isTaxInclusive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_tax_inclusive'],
      )!,
      serialNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serial_no'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InvoiceItemsTable createAlias(String alias) {
    return $InvoiceItemsTable(attachedDatabase, alias);
  }
}

class InvoiceItem extends DataClass implements Insertable<InvoiceItem> {
  /// Primary key - auto increment
  final int id;

  /// Foreign key to invoice
  final int invoiceId;

  /// Item name (default: "Item 1", "Item 2", etc.)
  final String itemName;

  /// Quantity (can be decimal, e.g., 1.5)
  final double quantity;

  /// Rate per unit (can be decimal, e.g., 12.50)
  final double rate;

  /// Total = quantity * rate
  final double total;

  /// Item-level discount (optional)
  final double discountAmount;

  /// HSN / SAC Code
  final String? hsnCode;

  /// GST Tax Rate percentage (0, 5, 12, 18, 28)
  final double taxRate;

  /// Taxable value (base amount)
  final double taxableAmount;

  /// Total tax amount
  final double taxAmount;

  /// CGST amount
  final double cgstAmount;

  /// SGST amount
  final double sgstAmount;

  /// Whether the item rate is tax-inclusive (MRP)
  final bool isTaxInclusive;

  /// Serial number for ordering within invoice
  final int serialNo;

  /// Created timestamp
  final DateTime createdAt;
  const InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.itemName,
    required this.quantity,
    required this.rate,
    required this.total,
    required this.discountAmount,
    this.hsnCode,
    required this.taxRate,
    required this.taxableAmount,
    required this.taxAmount,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.isTaxInclusive,
    required this.serialNo,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['item_name'] = Variable<String>(itemName);
    map['quantity'] = Variable<double>(quantity);
    map['rate'] = Variable<double>(rate);
    map['total'] = Variable<double>(total);
    map['discount_amount'] = Variable<double>(discountAmount);
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    map['tax_rate'] = Variable<double>(taxRate);
    map['taxable_amount'] = Variable<double>(taxableAmount);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['cgst_amount'] = Variable<double>(cgstAmount);
    map['sgst_amount'] = Variable<double>(sgstAmount);
    map['is_tax_inclusive'] = Variable<bool>(isTaxInclusive);
    map['serial_no'] = Variable<int>(serialNo);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceItemsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      itemName: Value(itemName),
      quantity: Value(quantity),
      rate: Value(rate),
      total: Value(total),
      discountAmount: Value(discountAmount),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      taxRate: Value(taxRate),
      taxableAmount: Value(taxableAmount),
      taxAmount: Value(taxAmount),
      cgstAmount: Value(cgstAmount),
      sgstAmount: Value(sgstAmount),
      isTaxInclusive: Value(isTaxInclusive),
      serialNo: Value(serialNo),
      createdAt: Value(createdAt),
    );
  }

  factory InvoiceItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceItem(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      rate: serializer.fromJson<double>(json['rate']),
      total: serializer.fromJson<double>(json['total']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      taxableAmount: serializer.fromJson<double>(json['taxableAmount']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      cgstAmount: serializer.fromJson<double>(json['cgstAmount']),
      sgstAmount: serializer.fromJson<double>(json['sgstAmount']),
      isTaxInclusive: serializer.fromJson<bool>(json['isTaxInclusive']),
      serialNo: serializer.fromJson<int>(json['serialNo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'itemName': serializer.toJson<String>(itemName),
      'quantity': serializer.toJson<double>(quantity),
      'rate': serializer.toJson<double>(rate),
      'total': serializer.toJson<double>(total),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'taxRate': serializer.toJson<double>(taxRate),
      'taxableAmount': serializer.toJson<double>(taxableAmount),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'cgstAmount': serializer.toJson<double>(cgstAmount),
      'sgstAmount': serializer.toJson<double>(sgstAmount),
      'isTaxInclusive': serializer.toJson<bool>(isTaxInclusive),
      'serialNo': serializer.toJson<int>(serialNo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InvoiceItem copyWith({
    int? id,
    int? invoiceId,
    String? itemName,
    double? quantity,
    double? rate,
    double? total,
    double? discountAmount,
    Value<String?> hsnCode = const Value.absent(),
    double? taxRate,
    double? taxableAmount,
    double? taxAmount,
    double? cgstAmount,
    double? sgstAmount,
    bool? isTaxInclusive,
    int? serialNo,
    DateTime? createdAt,
  }) => InvoiceItem(
    id: id ?? this.id,
    invoiceId: invoiceId ?? this.invoiceId,
    itemName: itemName ?? this.itemName,
    quantity: quantity ?? this.quantity,
    rate: rate ?? this.rate,
    total: total ?? this.total,
    discountAmount: discountAmount ?? this.discountAmount,
    hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
    taxRate: taxRate ?? this.taxRate,
    taxableAmount: taxableAmount ?? this.taxableAmount,
    taxAmount: taxAmount ?? this.taxAmount,
    cgstAmount: cgstAmount ?? this.cgstAmount,
    sgstAmount: sgstAmount ?? this.sgstAmount,
    isTaxInclusive: isTaxInclusive ?? this.isTaxInclusive,
    serialNo: serialNo ?? this.serialNo,
    createdAt: createdAt ?? this.createdAt,
  );
  InvoiceItem copyWithCompanion(InvoiceItemsCompanion data) {
    return InvoiceItem(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      rate: data.rate.present ? data.rate.value : this.rate,
      total: data.total.present ? data.total.value : this.total,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      taxableAmount: data.taxableAmount.present
          ? data.taxableAmount.value
          : this.taxableAmount,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      cgstAmount: data.cgstAmount.present
          ? data.cgstAmount.value
          : this.cgstAmount,
      sgstAmount: data.sgstAmount.present
          ? data.sgstAmount.value
          : this.sgstAmount,
      isTaxInclusive: data.isTaxInclusive.present
          ? data.isTaxInclusive.value
          : this.isTaxInclusive,
      serialNo: data.serialNo.present ? data.serialNo.value : this.serialNo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItem(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('rate: $rate, ')
          ..write('total: $total, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('taxRate: $taxRate, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('isTaxInclusive: $isTaxInclusive, ')
          ..write('serialNo: $serialNo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceId,
    itemName,
    quantity,
    rate,
    total,
    discountAmount,
    hsnCode,
    taxRate,
    taxableAmount,
    taxAmount,
    cgstAmount,
    sgstAmount,
    isTaxInclusive,
    serialNo,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceItem &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.itemName == this.itemName &&
          other.quantity == this.quantity &&
          other.rate == this.rate &&
          other.total == this.total &&
          other.discountAmount == this.discountAmount &&
          other.hsnCode == this.hsnCode &&
          other.taxRate == this.taxRate &&
          other.taxableAmount == this.taxableAmount &&
          other.taxAmount == this.taxAmount &&
          other.cgstAmount == this.cgstAmount &&
          other.sgstAmount == this.sgstAmount &&
          other.isTaxInclusive == this.isTaxInclusive &&
          other.serialNo == this.serialNo &&
          other.createdAt == this.createdAt);
}

class InvoiceItemsCompanion extends UpdateCompanion<InvoiceItem> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<String> itemName;
  final Value<double> quantity;
  final Value<double> rate;
  final Value<double> total;
  final Value<double> discountAmount;
  final Value<String?> hsnCode;
  final Value<double> taxRate;
  final Value<double> taxableAmount;
  final Value<double> taxAmount;
  final Value<double> cgstAmount;
  final Value<double> sgstAmount;
  final Value<bool> isTaxInclusive;
  final Value<int> serialNo;
  final Value<DateTime> createdAt;
  const InvoiceItemsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rate = const Value.absent(),
    this.total = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.taxableAmount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.cgstAmount = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.isTaxInclusive = const Value.absent(),
    this.serialNo = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InvoiceItemsCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required String itemName,
    required double quantity,
    required double rate,
    required double total,
    this.discountAmount = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.taxableAmount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.cgstAmount = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.isTaxInclusive = const Value.absent(),
    this.serialNo = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : invoiceId = Value(invoiceId),
       itemName = Value(itemName),
       quantity = Value(quantity),
       rate = Value(rate),
       total = Value(total);
  static Insertable<InvoiceItem> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<String>? itemName,
    Expression<double>? quantity,
    Expression<double>? rate,
    Expression<double>? total,
    Expression<double>? discountAmount,
    Expression<String>? hsnCode,
    Expression<double>? taxRate,
    Expression<double>? taxableAmount,
    Expression<double>? taxAmount,
    Expression<double>? cgstAmount,
    Expression<double>? sgstAmount,
    Expression<bool>? isTaxInclusive,
    Expression<int>? serialNo,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (itemName != null) 'item_name': itemName,
      if (quantity != null) 'quantity': quantity,
      if (rate != null) 'rate': rate,
      if (total != null) 'total': total,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (taxRate != null) 'tax_rate': taxRate,
      if (taxableAmount != null) 'taxable_amount': taxableAmount,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (cgstAmount != null) 'cgst_amount': cgstAmount,
      if (sgstAmount != null) 'sgst_amount': sgstAmount,
      if (isTaxInclusive != null) 'is_tax_inclusive': isTaxInclusive,
      if (serialNo != null) 'serial_no': serialNo,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InvoiceItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? invoiceId,
    Value<String>? itemName,
    Value<double>? quantity,
    Value<double>? rate,
    Value<double>? total,
    Value<double>? discountAmount,
    Value<String?>? hsnCode,
    Value<double>? taxRate,
    Value<double>? taxableAmount,
    Value<double>? taxAmount,
    Value<double>? cgstAmount,
    Value<double>? sgstAmount,
    Value<bool>? isTaxInclusive,
    Value<int>? serialNo,
    Value<DateTime>? createdAt,
  }) {
    return InvoiceItemsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      total: total ?? this.total,
      discountAmount: discountAmount ?? this.discountAmount,
      hsnCode: hsnCode ?? this.hsnCode,
      taxRate: taxRate ?? this.taxRate,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      cgstAmount: cgstAmount ?? this.cgstAmount,
      sgstAmount: sgstAmount ?? this.sgstAmount,
      isTaxInclusive: isTaxInclusive ?? this.isTaxInclusive,
      serialNo: serialNo ?? this.serialNo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (taxableAmount.present) {
      map['taxable_amount'] = Variable<double>(taxableAmount.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (cgstAmount.present) {
      map['cgst_amount'] = Variable<double>(cgstAmount.value);
    }
    if (sgstAmount.present) {
      map['sgst_amount'] = Variable<double>(sgstAmount.value);
    }
    if (isTaxInclusive.present) {
      map['is_tax_inclusive'] = Variable<bool>(isTaxInclusive.value);
    }
    if (serialNo.present) {
      map['serial_no'] = Variable<int>(serialNo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('rate: $rate, ')
          ..write('total: $total, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('taxRate: $taxRate, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('isTaxInclusive: $isTaxInclusive, ')
          ..write('serialNo: $serialNo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $InventoryItemsTable extends InventoryItems
    with TableInfo<$InventoryItemsTable, InventoryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uomMeta = const VerificationMeta('uom');
  @override
  late final GeneratedColumn<String> uom = GeneratedColumn<String>(
    'uom',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pcs'),
  );
  static const VerificationMeta _unitValueMeta = const VerificationMeta(
    'unitValue',
  );
  @override
  late final GeneratedColumn<double> unitValue = GeneratedColumn<double>(
    'unit_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InventoryItemStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(InventoryItemStatus.available.index),
      ).withConverter<InventoryItemStatus>(
        $InventoryItemsTable.$converterstatus,
      );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isTaxInclusiveMeta = const VerificationMeta(
    'isTaxInclusive',
  );
  @override
  late final GeneratedColumn<bool> isTaxInclusive = GeneratedColumn<bool>(
    'is_tax_inclusive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_tax_inclusive" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    barcode,
    name,
    category,
    brand,
    price,
    uom,
    unitValue,
    imagePath,
    status,
    hsnCode,
    taxRate,
    isTaxInclusive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('uom')) {
      context.handle(
        _uomMeta,
        uom.isAcceptableOrUnknown(data['uom']!, _uomMeta),
      );
    }
    if (data.containsKey('unit_value')) {
      context.handle(
        _unitValueMeta,
        unitValue.isAcceptableOrUnknown(data['unit_value']!, _unitValueMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('is_tax_inclusive')) {
      context.handle(
        _isTaxInclusiveMeta,
        isTaxInclusive.isAcceptableOrUnknown(
          data['is_tax_inclusive']!,
          _isTaxInclusiveMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      uom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uom'],
      )!,
      unitValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_value'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      status: $InventoryItemsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      ),
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      isTaxInclusive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_tax_inclusive'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InventoryItemsTable createAlias(String alias) {
    return $InventoryItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InventoryItemStatus, int, int> $converterstatus =
      const EnumIndexConverter<InventoryItemStatus>(InventoryItemStatus.values);
}

class InventoryItem extends DataClass implements Insertable<InventoryItem> {
  /// Primary key - auto increment
  final int id;

  /// Unique internal item code (SKU)
  final String code;

  /// Optional scannable barcode value
  final String? barcode;

  /// Display name
  final String name;

  /// Category label
  final String category;

  /// Brand label
  final String brand;

  /// Unit price
  final double price;

  /// Unit of measurement (pcs, kg, l, etc.)
  final String uom;

  /// Quantity represented by one price unit (e.g. 1 kg, 500 g)
  final double unitValue;

  /// Optional local image path
  final String? imagePath;

  /// Availability status
  final InventoryItemStatus status;

  /// Optional HSN / SAC code reference
  final String? hsnCode;

  /// Tax / GST percentage (e.g. 0.0, 5.0, 12.0, 18.0, 28.0)
  final double taxRate;

  /// Whether selling price is tax-inclusive (MRP) or tax-exclusive (base rate)
  final bool isTaxInclusive;

  /// Created timestamp
  final DateTime createdAt;
  const InventoryItem({
    required this.id,
    required this.code,
    this.barcode,
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
    required this.uom,
    required this.unitValue,
    this.imagePath,
    required this.status,
    this.hsnCode,
    required this.taxRate,
    required this.isTaxInclusive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['brand'] = Variable<String>(brand);
    map['price'] = Variable<double>(price);
    map['uom'] = Variable<String>(uom);
    map['unit_value'] = Variable<double>(unitValue);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    {
      map['status'] = Variable<int>(
        $InventoryItemsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    map['tax_rate'] = Variable<double>(taxRate);
    map['is_tax_inclusive'] = Variable<bool>(isTaxInclusive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InventoryItemsCompanion toCompanion(bool nullToAbsent) {
    return InventoryItemsCompanion(
      id: Value(id),
      code: Value(code),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      name: Value(name),
      category: Value(category),
      brand: Value(brand),
      price: Value(price),
      uom: Value(uom),
      unitValue: Value(unitValue),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      status: Value(status),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      taxRate: Value(taxRate),
      isTaxInclusive: Value(isTaxInclusive),
      createdAt: Value(createdAt),
    );
  }

  factory InventoryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryItem(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      brand: serializer.fromJson<String>(json['brand']),
      price: serializer.fromJson<double>(json['price']),
      uom: serializer.fromJson<String>(json['uom']),
      unitValue: serializer.fromJson<double>(json['unitValue']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      status: $InventoryItemsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      isTaxInclusive: serializer.fromJson<bool>(json['isTaxInclusive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'barcode': serializer.toJson<String?>(barcode),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'brand': serializer.toJson<String>(brand),
      'price': serializer.toJson<double>(price),
      'uom': serializer.toJson<String>(uom),
      'unitValue': serializer.toJson<double>(unitValue),
      'imagePath': serializer.toJson<String?>(imagePath),
      'status': serializer.toJson<int>(
        $InventoryItemsTable.$converterstatus.toJson(status),
      ),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'taxRate': serializer.toJson<double>(taxRate),
      'isTaxInclusive': serializer.toJson<bool>(isTaxInclusive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InventoryItem copyWith({
    int? id,
    String? code,
    Value<String?> barcode = const Value.absent(),
    String? name,
    String? category,
    String? brand,
    double? price,
    String? uom,
    double? unitValue,
    Value<String?> imagePath = const Value.absent(),
    InventoryItemStatus? status,
    Value<String?> hsnCode = const Value.absent(),
    double? taxRate,
    bool? isTaxInclusive,
    DateTime? createdAt,
  }) => InventoryItem(
    id: id ?? this.id,
    code: code ?? this.code,
    barcode: barcode.present ? barcode.value : this.barcode,
    name: name ?? this.name,
    category: category ?? this.category,
    brand: brand ?? this.brand,
    price: price ?? this.price,
    uom: uom ?? this.uom,
    unitValue: unitValue ?? this.unitValue,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    status: status ?? this.status,
    hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
    taxRate: taxRate ?? this.taxRate,
    isTaxInclusive: isTaxInclusive ?? this.isTaxInclusive,
    createdAt: createdAt ?? this.createdAt,
  );
  InventoryItem copyWithCompanion(InventoryItemsCompanion data) {
    return InventoryItem(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      brand: data.brand.present ? data.brand.value : this.brand,
      price: data.price.present ? data.price.value : this.price,
      uom: data.uom.present ? data.uom.value : this.uom,
      unitValue: data.unitValue.present ? data.unitValue.value : this.unitValue,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      status: data.status.present ? data.status.value : this.status,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      isTaxInclusive: data.isTaxInclusive.present
          ? data.isTaxInclusive.value
          : this.isTaxInclusive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItem(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('brand: $brand, ')
          ..write('price: $price, ')
          ..write('uom: $uom, ')
          ..write('unitValue: $unitValue, ')
          ..write('imagePath: $imagePath, ')
          ..write('status: $status, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('taxRate: $taxRate, ')
          ..write('isTaxInclusive: $isTaxInclusive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    barcode,
    name,
    category,
    brand,
    price,
    uom,
    unitValue,
    imagePath,
    status,
    hsnCode,
    taxRate,
    isTaxInclusive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryItem &&
          other.id == this.id &&
          other.code == this.code &&
          other.barcode == this.barcode &&
          other.name == this.name &&
          other.category == this.category &&
          other.brand == this.brand &&
          other.price == this.price &&
          other.uom == this.uom &&
          other.unitValue == this.unitValue &&
          other.imagePath == this.imagePath &&
          other.status == this.status &&
          other.hsnCode == this.hsnCode &&
          other.taxRate == this.taxRate &&
          other.isTaxInclusive == this.isTaxInclusive &&
          other.createdAt == this.createdAt);
}

class InventoryItemsCompanion extends UpdateCompanion<InventoryItem> {
  final Value<int> id;
  final Value<String> code;
  final Value<String?> barcode;
  final Value<String> name;
  final Value<String> category;
  final Value<String> brand;
  final Value<double> price;
  final Value<String> uom;
  final Value<double> unitValue;
  final Value<String?> imagePath;
  final Value<InventoryItemStatus> status;
  final Value<String?> hsnCode;
  final Value<double> taxRate;
  final Value<bool> isTaxInclusive;
  final Value<DateTime> createdAt;
  const InventoryItemsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.barcode = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.brand = const Value.absent(),
    this.price = const Value.absent(),
    this.uom = const Value.absent(),
    this.unitValue = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.status = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.isTaxInclusive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InventoryItemsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    this.barcode = const Value.absent(),
    required String name,
    required String category,
    required String brand,
    required double price,
    this.uom = const Value.absent(),
    this.unitValue = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.status = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.isTaxInclusive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : code = Value(code),
       name = Value(name),
       category = Value(category),
       brand = Value(brand),
       price = Value(price);
  static Insertable<InventoryItem> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? barcode,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? brand,
    Expression<double>? price,
    Expression<String>? uom,
    Expression<double>? unitValue,
    Expression<String>? imagePath,
    Expression<int>? status,
    Expression<String>? hsnCode,
    Expression<double>? taxRate,
    Expression<bool>? isTaxInclusive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (barcode != null) 'barcode': barcode,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (brand != null) 'brand': brand,
      if (price != null) 'price': price,
      if (uom != null) 'uom': uom,
      if (unitValue != null) 'unit_value': unitValue,
      if (imagePath != null) 'image_path': imagePath,
      if (status != null) 'status': status,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (taxRate != null) 'tax_rate': taxRate,
      if (isTaxInclusive != null) 'is_tax_inclusive': isTaxInclusive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InventoryItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String?>? barcode,
    Value<String>? name,
    Value<String>? category,
    Value<String>? brand,
    Value<double>? price,
    Value<String>? uom,
    Value<double>? unitValue,
    Value<String?>? imagePath,
    Value<InventoryItemStatus>? status,
    Value<String?>? hsnCode,
    Value<double>? taxRate,
    Value<bool>? isTaxInclusive,
    Value<DateTime>? createdAt,
  }) {
    return InventoryItemsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      uom: uom ?? this.uom,
      unitValue: unitValue ?? this.unitValue,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      hsnCode: hsnCode ?? this.hsnCode,
      taxRate: taxRate ?? this.taxRate,
      isTaxInclusive: isTaxInclusive ?? this.isTaxInclusive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (uom.present) {
      map['uom'] = Variable<String>(uom.value);
    }
    if (unitValue.present) {
      map['unit_value'] = Variable<double>(unitValue.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $InventoryItemsTable.$converterstatus.toSql(status.value),
      );
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (isTaxInclusive.present) {
      map['is_tax_inclusive'] = Variable<bool>(isTaxInclusive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItemsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('brand: $brand, ')
          ..write('price: $price, ')
          ..write('uom: $uom, ')
          ..write('unitValue: $unitValue, ')
          ..write('imagePath: $imagePath, ')
          ..write('status: $status, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('taxRate: $taxRate, ')
          ..write('isTaxInclusive: $isTaxInclusive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DocumentSeriesNumbersTable extends DocumentSeriesNumbers
    with TableInfo<$DocumentSeriesNumbersTable, DocumentSeriesNumber> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentSeriesNumbersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
    'module',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _startingNumberMeta = const VerificationMeta(
    'startingNumber',
  );
  @override
  late final GeneratedColumn<int> startingNumber = GeneratedColumn<int>(
    'starting_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1001),
  );
  static const VerificationMeta _currentNumberMeta = const VerificationMeta(
    'currentNumber',
  );
  @override
  late final GeneratedColumn<int> currentNumber = GeneratedColumn<int>(
    'current_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1001),
  );
  static const VerificationMeta _prefixMeta = const VerificationMeta('prefix');
  @override
  late final GeneratedColumn<String> prefix = GeneratedColumn<String>(
    'prefix',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suffixMeta = const VerificationMeta('suffix');
  @override
  late final GeneratedColumn<String> suffix = GeneratedColumn<String>(
    'suffix',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{prefix}-{current_number}'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    module,
    startingNumber,
    currentNumber,
    prefix,
    suffix,
    pattern,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_series_numbers';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentSeriesNumber> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('module')) {
      context.handle(
        _moduleMeta,
        module.isAcceptableOrUnknown(data['module']!, _moduleMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('starting_number')) {
      context.handle(
        _startingNumberMeta,
        startingNumber.isAcceptableOrUnknown(
          data['starting_number']!,
          _startingNumberMeta,
        ),
      );
    }
    if (data.containsKey('current_number')) {
      context.handle(
        _currentNumberMeta,
        currentNumber.isAcceptableOrUnknown(
          data['current_number']!,
          _currentNumberMeta,
        ),
      );
    }
    if (data.containsKey('prefix')) {
      context.handle(
        _prefixMeta,
        prefix.isAcceptableOrUnknown(data['prefix']!, _prefixMeta),
      );
    }
    if (data.containsKey('suffix')) {
      context.handle(
        _suffixMeta,
        suffix.isAcceptableOrUnknown(data['suffix']!, _suffixMeta),
      );
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentSeriesNumber map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentSeriesNumber(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      module: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module'],
      )!,
      startingNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}starting_number'],
      )!,
      currentNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_number'],
      )!,
      prefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prefix'],
      ),
      suffix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suffix'],
      ),
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DocumentSeriesNumbersTable createAlias(String alias) {
    return $DocumentSeriesNumbersTable(attachedDatabase, alias);
  }
}

class DocumentSeriesNumber extends DataClass
    implements Insertable<DocumentSeriesNumber> {
  final int id;

  /// Module key, e.g. 'item', 'invoice'
  final String module;

  /// First number of the series
  final int startingNumber;

  /// Current number to be used for formatting
  final int currentNumber;

  /// Optional prefix in the formatted code
  final String? prefix;

  /// Optional suffix in the formatted code
  final String? suffix;

  /// Supported tokens: {prefix}, {current_number}, {suffix}
  final String pattern;

  /// 1: Active, 0: Inactive
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DocumentSeriesNumber({
    required this.id,
    required this.module,
    required this.startingNumber,
    required this.currentNumber,
    this.prefix,
    this.suffix,
    required this.pattern,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['module'] = Variable<String>(module);
    map['starting_number'] = Variable<int>(startingNumber);
    map['current_number'] = Variable<int>(currentNumber);
    if (!nullToAbsent || prefix != null) {
      map['prefix'] = Variable<String>(prefix);
    }
    if (!nullToAbsent || suffix != null) {
      map['suffix'] = Variable<String>(suffix);
    }
    map['pattern'] = Variable<String>(pattern);
    map['status'] = Variable<int>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DocumentSeriesNumbersCompanion toCompanion(bool nullToAbsent) {
    return DocumentSeriesNumbersCompanion(
      id: Value(id),
      module: Value(module),
      startingNumber: Value(startingNumber),
      currentNumber: Value(currentNumber),
      prefix: prefix == null && nullToAbsent
          ? const Value.absent()
          : Value(prefix),
      suffix: suffix == null && nullToAbsent
          ? const Value.absent()
          : Value(suffix),
      pattern: Value(pattern),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DocumentSeriesNumber.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentSeriesNumber(
      id: serializer.fromJson<int>(json['id']),
      module: serializer.fromJson<String>(json['module']),
      startingNumber: serializer.fromJson<int>(json['startingNumber']),
      currentNumber: serializer.fromJson<int>(json['currentNumber']),
      prefix: serializer.fromJson<String?>(json['prefix']),
      suffix: serializer.fromJson<String?>(json['suffix']),
      pattern: serializer.fromJson<String>(json['pattern']),
      status: serializer.fromJson<int>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'module': serializer.toJson<String>(module),
      'startingNumber': serializer.toJson<int>(startingNumber),
      'currentNumber': serializer.toJson<int>(currentNumber),
      'prefix': serializer.toJson<String?>(prefix),
      'suffix': serializer.toJson<String?>(suffix),
      'pattern': serializer.toJson<String>(pattern),
      'status': serializer.toJson<int>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DocumentSeriesNumber copyWith({
    int? id,
    String? module,
    int? startingNumber,
    int? currentNumber,
    Value<String?> prefix = const Value.absent(),
    Value<String?> suffix = const Value.absent(),
    String? pattern,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DocumentSeriesNumber(
    id: id ?? this.id,
    module: module ?? this.module,
    startingNumber: startingNumber ?? this.startingNumber,
    currentNumber: currentNumber ?? this.currentNumber,
    prefix: prefix.present ? prefix.value : this.prefix,
    suffix: suffix.present ? suffix.value : this.suffix,
    pattern: pattern ?? this.pattern,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DocumentSeriesNumber copyWithCompanion(DocumentSeriesNumbersCompanion data) {
    return DocumentSeriesNumber(
      id: data.id.present ? data.id.value : this.id,
      module: data.module.present ? data.module.value : this.module,
      startingNumber: data.startingNumber.present
          ? data.startingNumber.value
          : this.startingNumber,
      currentNumber: data.currentNumber.present
          ? data.currentNumber.value
          : this.currentNumber,
      prefix: data.prefix.present ? data.prefix.value : this.prefix,
      suffix: data.suffix.present ? data.suffix.value : this.suffix,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentSeriesNumber(')
          ..write('id: $id, ')
          ..write('module: $module, ')
          ..write('startingNumber: $startingNumber, ')
          ..write('currentNumber: $currentNumber, ')
          ..write('prefix: $prefix, ')
          ..write('suffix: $suffix, ')
          ..write('pattern: $pattern, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    module,
    startingNumber,
    currentNumber,
    prefix,
    suffix,
    pattern,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentSeriesNumber &&
          other.id == this.id &&
          other.module == this.module &&
          other.startingNumber == this.startingNumber &&
          other.currentNumber == this.currentNumber &&
          other.prefix == this.prefix &&
          other.suffix == this.suffix &&
          other.pattern == this.pattern &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DocumentSeriesNumbersCompanion
    extends UpdateCompanion<DocumentSeriesNumber> {
  final Value<int> id;
  final Value<String> module;
  final Value<int> startingNumber;
  final Value<int> currentNumber;
  final Value<String?> prefix;
  final Value<String?> suffix;
  final Value<String> pattern;
  final Value<int> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DocumentSeriesNumbersCompanion({
    this.id = const Value.absent(),
    this.module = const Value.absent(),
    this.startingNumber = const Value.absent(),
    this.currentNumber = const Value.absent(),
    this.prefix = const Value.absent(),
    this.suffix = const Value.absent(),
    this.pattern = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DocumentSeriesNumbersCompanion.insert({
    this.id = const Value.absent(),
    required String module,
    this.startingNumber = const Value.absent(),
    this.currentNumber = const Value.absent(),
    this.prefix = const Value.absent(),
    this.suffix = const Value.absent(),
    this.pattern = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : module = Value(module);
  static Insertable<DocumentSeriesNumber> custom({
    Expression<int>? id,
    Expression<String>? module,
    Expression<int>? startingNumber,
    Expression<int>? currentNumber,
    Expression<String>? prefix,
    Expression<String>? suffix,
    Expression<String>? pattern,
    Expression<int>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (module != null) 'module': module,
      if (startingNumber != null) 'starting_number': startingNumber,
      if (currentNumber != null) 'current_number': currentNumber,
      if (prefix != null) 'prefix': prefix,
      if (suffix != null) 'suffix': suffix,
      if (pattern != null) 'pattern': pattern,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DocumentSeriesNumbersCompanion copyWith({
    Value<int>? id,
    Value<String>? module,
    Value<int>? startingNumber,
    Value<int>? currentNumber,
    Value<String?>? prefix,
    Value<String?>? suffix,
    Value<String>? pattern,
    Value<int>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DocumentSeriesNumbersCompanion(
      id: id ?? this.id,
      module: module ?? this.module,
      startingNumber: startingNumber ?? this.startingNumber,
      currentNumber: currentNumber ?? this.currentNumber,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      pattern: pattern ?? this.pattern,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (startingNumber.present) {
      map['starting_number'] = Variable<int>(startingNumber.value);
    }
    if (currentNumber.present) {
      map['current_number'] = Variable<int>(currentNumber.value);
    }
    if (prefix.present) {
      map['prefix'] = Variable<String>(prefix.value);
    }
    if (suffix.present) {
      map['suffix'] = Variable<String>(suffix.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentSeriesNumbersCompanion(')
          ..write('id: $id, ')
          ..write('module: $module, ')
          ..write('startingNumber: $startingNumber, ')
          ..write('currentNumber: $currentNumber, ')
          ..write('prefix: $prefix, ')
          ..write('suffix: $suffix, ')
          ..write('pattern: $pattern, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $VouchersTable extends Vouchers with TableInfo<$VouchersTable, Voucher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VouchersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<int> referenceId = GeneratedColumn<int>(
    'reference_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, type, referenceId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vouchers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Voucher> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Voucher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Voucher(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reference_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VouchersTable createAlias(String alias) {
    return $VouchersTable(attachedDatabase, alias);
  }
}

class Voucher extends DataClass implements Insertable<Voucher> {
  final int id;
  final String type;
  final int? referenceId;
  final DateTime createdAt;
  const Voucher({
    required this.id,
    required this.type,
    this.referenceId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<int>(referenceId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VouchersCompanion toCompanion(bool nullToAbsent) {
    return VouchersCompanion(
      id: Value(id),
      type: Value(type),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      createdAt: Value(createdAt),
    );
  }

  factory Voucher.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Voucher(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      referenceId: serializer.fromJson<int?>(json['referenceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'referenceId': serializer.toJson<int?>(referenceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Voucher copyWith({
    int? id,
    String? type,
    Value<int?> referenceId = const Value.absent(),
    DateTime? createdAt,
  }) => Voucher(
    id: id ?? this.id,
    type: type ?? this.type,
    referenceId: referenceId.present ? referenceId.value : this.referenceId,
    createdAt: createdAt ?? this.createdAt,
  );
  Voucher copyWithCompanion(VouchersCompanion data) {
    return Voucher(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Voucher(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('referenceId: $referenceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, referenceId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Voucher &&
          other.id == this.id &&
          other.type == this.type &&
          other.referenceId == this.referenceId &&
          other.createdAt == this.createdAt);
}

class VouchersCompanion extends UpdateCompanion<Voucher> {
  final Value<int> id;
  final Value<String> type;
  final Value<int?> referenceId;
  final Value<DateTime> createdAt;
  const VouchersCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VouchersCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    this.referenceId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : type = Value(type);
  static Insertable<Voucher> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? referenceId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (referenceId != null) 'reference_id': referenceId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VouchersCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<int?>? referenceId,
    Value<DateTime>? createdAt,
  }) {
    return VouchersCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<int>(referenceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VouchersCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('referenceId: $referenceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LedgerEntriesTable extends LedgerEntries
    with TableInfo<$LedgerEntriesTable, LedgerEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _voucherIdMeta = const VerificationMeta(
    'voucherId',
  );
  @override
  late final GeneratedColumn<int> voucherId = GeneratedColumn<int>(
    'voucher_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vouchers (id)',
    ),
  );
  static const VerificationMeta _ledgerIdMeta = const VerificationMeta(
    'ledgerId',
  );
  @override
  late final GeneratedColumn<int> ledgerId = GeneratedColumn<int>(
    'ledger_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledgers (id)',
    ),
  );
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<double> debit = GeneratedColumn<double>(
    'debit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _creditMeta = const VerificationMeta('credit');
  @override
  late final GeneratedColumn<double> credit = GeneratedColumn<double>(
    'credit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    voucherId,
    ledgerId,
    debit,
    credit,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LedgerEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('voucher_id')) {
      context.handle(
        _voucherIdMeta,
        voucherId.isAcceptableOrUnknown(data['voucher_id']!, _voucherIdMeta),
      );
    } else if (isInserting) {
      context.missing(_voucherIdMeta);
    }
    if (data.containsKey('ledger_id')) {
      context.handle(
        _ledgerIdMeta,
        ledgerId.isAcceptableOrUnknown(data['ledger_id']!, _ledgerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ledgerIdMeta);
    }
    if (data.containsKey('debit')) {
      context.handle(
        _debitMeta,
        debit.isAcceptableOrUnknown(data['debit']!, _debitMeta),
      );
    }
    if (data.containsKey('credit')) {
      context.handle(
        _creditMeta,
        credit.isAcceptableOrUnknown(data['credit']!, _creditMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      voucherId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}voucher_id'],
      )!,
      ledgerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ledger_id'],
      )!,
      debit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}debit'],
      )!,
      credit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LedgerEntriesTable createAlias(String alias) {
    return $LedgerEntriesTable(attachedDatabase, alias);
  }
}

class LedgerEntry extends DataClass implements Insertable<LedgerEntry> {
  final int id;
  final int voucherId;
  final int ledgerId;
  final double debit;
  final double credit;
  final DateTime createdAt;
  const LedgerEntry({
    required this.id,
    required this.voucherId,
    required this.ledgerId,
    required this.debit,
    required this.credit,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['voucher_id'] = Variable<int>(voucherId);
    map['ledger_id'] = Variable<int>(ledgerId);
    map['debit'] = Variable<double>(debit);
    map['credit'] = Variable<double>(credit);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LedgerEntriesCompanion toCompanion(bool nullToAbsent) {
    return LedgerEntriesCompanion(
      id: Value(id),
      voucherId: Value(voucherId),
      ledgerId: Value(ledgerId),
      debit: Value(debit),
      credit: Value(credit),
      createdAt: Value(createdAt),
    );
  }

  factory LedgerEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerEntry(
      id: serializer.fromJson<int>(json['id']),
      voucherId: serializer.fromJson<int>(json['voucherId']),
      ledgerId: serializer.fromJson<int>(json['ledgerId']),
      debit: serializer.fromJson<double>(json['debit']),
      credit: serializer.fromJson<double>(json['credit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'voucherId': serializer.toJson<int>(voucherId),
      'ledgerId': serializer.toJson<int>(ledgerId),
      'debit': serializer.toJson<double>(debit),
      'credit': serializer.toJson<double>(credit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LedgerEntry copyWith({
    int? id,
    int? voucherId,
    int? ledgerId,
    double? debit,
    double? credit,
    DateTime? createdAt,
  }) => LedgerEntry(
    id: id ?? this.id,
    voucherId: voucherId ?? this.voucherId,
    ledgerId: ledgerId ?? this.ledgerId,
    debit: debit ?? this.debit,
    credit: credit ?? this.credit,
    createdAt: createdAt ?? this.createdAt,
  );
  LedgerEntry copyWithCompanion(LedgerEntriesCompanion data) {
    return LedgerEntry(
      id: data.id.present ? data.id.value : this.id,
      voucherId: data.voucherId.present ? data.voucherId.value : this.voucherId,
      ledgerId: data.ledgerId.present ? data.ledgerId.value : this.ledgerId,
      debit: data.debit.present ? data.debit.value : this.debit,
      credit: data.credit.present ? data.credit.value : this.credit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEntry(')
          ..write('id: $id, ')
          ..write('voucherId: $voucherId, ')
          ..write('ledgerId: $ledgerId, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, voucherId, ledgerId, debit, credit, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerEntry &&
          other.id == this.id &&
          other.voucherId == this.voucherId &&
          other.ledgerId == this.ledgerId &&
          other.debit == this.debit &&
          other.credit == this.credit &&
          other.createdAt == this.createdAt);
}

class LedgerEntriesCompanion extends UpdateCompanion<LedgerEntry> {
  final Value<int> id;
  final Value<int> voucherId;
  final Value<int> ledgerId;
  final Value<double> debit;
  final Value<double> credit;
  final Value<DateTime> createdAt;
  const LedgerEntriesCompanion({
    this.id = const Value.absent(),
    this.voucherId = const Value.absent(),
    this.ledgerId = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LedgerEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int voucherId,
    required int ledgerId,
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : voucherId = Value(voucherId),
       ledgerId = Value(ledgerId);
  static Insertable<LedgerEntry> custom({
    Expression<int>? id,
    Expression<int>? voucherId,
    Expression<int>? ledgerId,
    Expression<double>? debit,
    Expression<double>? credit,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (voucherId != null) 'voucher_id': voucherId,
      if (ledgerId != null) 'ledger_id': ledgerId,
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LedgerEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? voucherId,
    Value<int>? ledgerId,
    Value<double>? debit,
    Value<double>? credit,
    Value<DateTime>? createdAt,
  }) {
    return LedgerEntriesCompanion(
      id: id ?? this.id,
      voucherId: voucherId ?? this.voucherId,
      ledgerId: ledgerId ?? this.ledgerId,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (voucherId.present) {
      map['voucher_id'] = Variable<int>(voucherId.value);
    }
    if (ledgerId.present) {
      map['ledger_id'] = Variable<int>(ledgerId.value);
    }
    if (debit.present) {
      map['debit'] = Variable<double>(debit.value);
    }
    if (credit.present) {
      map['credit'] = Variable<double>(credit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEntriesCompanion(')
          ..write('id: $id, ')
          ..write('voucherId: $voucherId, ')
          ..write('ledgerId: $ledgerId, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HsnEntriesTable extends HsnEntries
    with TableInfo<$HsnEntriesTable, HsnEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HsnEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstRateMeta = const VerificationMeta(
    'gstRate',
  );
  @override
  late final GeneratedColumn<double> gstRate = GeneratedColumn<double>(
    'gst_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cgstRateMeta = const VerificationMeta(
    'cgstRate',
  );
  @override
  late final GeneratedColumn<double> cgstRate = GeneratedColumn<double>(
    'cgst_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sgstRateMeta = const VerificationMeta(
    'sgstRate',
  );
  @override
  late final GeneratedColumn<double> sgstRate = GeneratedColumn<double>(
    'sgst_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _igstRateMeta = const VerificationMeta(
    'igstRate',
  );
  @override
  late final GeneratedColumn<double> igstRate = GeneratedColumn<double>(
    'igst_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hsnCode,
    description,
    gstRate,
    cgstRate,
    sgstRate,
    igstRate,
    isDefault,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hsn_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<HsnEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_hsnCodeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('gst_rate')) {
      context.handle(
        _gstRateMeta,
        gstRate.isAcceptableOrUnknown(data['gst_rate']!, _gstRateMeta),
      );
    } else if (isInserting) {
      context.missing(_gstRateMeta);
    }
    if (data.containsKey('cgst_rate')) {
      context.handle(
        _cgstRateMeta,
        cgstRate.isAcceptableOrUnknown(data['cgst_rate']!, _cgstRateMeta),
      );
    } else if (isInserting) {
      context.missing(_cgstRateMeta);
    }
    if (data.containsKey('sgst_rate')) {
      context.handle(
        _sgstRateMeta,
        sgstRate.isAcceptableOrUnknown(data['sgst_rate']!, _sgstRateMeta),
      );
    } else if (isInserting) {
      context.missing(_sgstRateMeta);
    }
    if (data.containsKey('igst_rate')) {
      context.handle(
        _igstRateMeta,
        igstRate.isAcceptableOrUnknown(data['igst_rate']!, _igstRateMeta),
      );
    } else if (isInserting) {
      context.missing(_igstRateMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HsnEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HsnEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      gstRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gst_rate'],
      )!,
      cgstRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cgst_rate'],
      )!,
      sgstRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sgst_rate'],
      )!,
      igstRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}igst_rate'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HsnEntriesTable createAlias(String alias) {
    return $HsnEntriesTable(attachedDatabase, alias);
  }
}

class HsnEntry extends DataClass implements Insertable<HsnEntry> {
  /// Primary key - auto increment
  final int id;

  /// HSN / SAC code (e.g. "1001", "0808", "9983")
  final String hsnCode;

  /// Descriptive commodity or service name
  final String description;

  /// Total GST Rate percentage (e.g. 0.0, 5.0, 12.0, 18.0, 28.0)
  final double gstRate;

  /// Central GST Rate percentage (typically gstRate / 2)
  final double cgstRate;

  /// State GST Rate percentage (typically gstRate / 2)
  final double sgstRate;

  /// Integrated GST Rate percentage (typically gstRate)
  final double igstRate;

  /// Whether this is a system default entry
  final bool isDefault;

  /// Created timestamp
  final DateTime createdAt;

  /// Updated timestamp
  final DateTime updatedAt;
  const HsnEntry({
    required this.id,
    required this.hsnCode,
    required this.description,
    required this.gstRate,
    required this.cgstRate,
    required this.sgstRate,
    required this.igstRate,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hsn_code'] = Variable<String>(hsnCode);
    map['description'] = Variable<String>(description);
    map['gst_rate'] = Variable<double>(gstRate);
    map['cgst_rate'] = Variable<double>(cgstRate);
    map['sgst_rate'] = Variable<double>(sgstRate);
    map['igst_rate'] = Variable<double>(igstRate);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HsnEntriesCompanion toCompanion(bool nullToAbsent) {
    return HsnEntriesCompanion(
      id: Value(id),
      hsnCode: Value(hsnCode),
      description: Value(description),
      gstRate: Value(gstRate),
      cgstRate: Value(cgstRate),
      sgstRate: Value(sgstRate),
      igstRate: Value(igstRate),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HsnEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HsnEntry(
      id: serializer.fromJson<int>(json['id']),
      hsnCode: serializer.fromJson<String>(json['hsnCode']),
      description: serializer.fromJson<String>(json['description']),
      gstRate: serializer.fromJson<double>(json['gstRate']),
      cgstRate: serializer.fromJson<double>(json['cgstRate']),
      sgstRate: serializer.fromJson<double>(json['sgstRate']),
      igstRate: serializer.fromJson<double>(json['igstRate']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hsnCode': serializer.toJson<String>(hsnCode),
      'description': serializer.toJson<String>(description),
      'gstRate': serializer.toJson<double>(gstRate),
      'cgstRate': serializer.toJson<double>(cgstRate),
      'sgstRate': serializer.toJson<double>(sgstRate),
      'igstRate': serializer.toJson<double>(igstRate),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HsnEntry copyWith({
    int? id,
    String? hsnCode,
    String? description,
    double? gstRate,
    double? cgstRate,
    double? sgstRate,
    double? igstRate,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HsnEntry(
    id: id ?? this.id,
    hsnCode: hsnCode ?? this.hsnCode,
    description: description ?? this.description,
    gstRate: gstRate ?? this.gstRate,
    cgstRate: cgstRate ?? this.cgstRate,
    sgstRate: sgstRate ?? this.sgstRate,
    igstRate: igstRate ?? this.igstRate,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HsnEntry copyWithCompanion(HsnEntriesCompanion data) {
    return HsnEntry(
      id: data.id.present ? data.id.value : this.id,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      description: data.description.present
          ? data.description.value
          : this.description,
      gstRate: data.gstRate.present ? data.gstRate.value : this.gstRate,
      cgstRate: data.cgstRate.present ? data.cgstRate.value : this.cgstRate,
      sgstRate: data.sgstRate.present ? data.sgstRate.value : this.sgstRate,
      igstRate: data.igstRate.present ? data.igstRate.value : this.igstRate,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HsnEntry(')
          ..write('id: $id, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('description: $description, ')
          ..write('gstRate: $gstRate, ')
          ..write('cgstRate: $cgstRate, ')
          ..write('sgstRate: $sgstRate, ')
          ..write('igstRate: $igstRate, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hsnCode,
    description,
    gstRate,
    cgstRate,
    sgstRate,
    igstRate,
    isDefault,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HsnEntry &&
          other.id == this.id &&
          other.hsnCode == this.hsnCode &&
          other.description == this.description &&
          other.gstRate == this.gstRate &&
          other.cgstRate == this.cgstRate &&
          other.sgstRate == this.sgstRate &&
          other.igstRate == this.igstRate &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HsnEntriesCompanion extends UpdateCompanion<HsnEntry> {
  final Value<int> id;
  final Value<String> hsnCode;
  final Value<String> description;
  final Value<double> gstRate;
  final Value<double> cgstRate;
  final Value<double> sgstRate;
  final Value<double> igstRate;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const HsnEntriesCompanion({
    this.id = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.description = const Value.absent(),
    this.gstRate = const Value.absent(),
    this.cgstRate = const Value.absent(),
    this.sgstRate = const Value.absent(),
    this.igstRate = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  HsnEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String hsnCode,
    required String description,
    required double gstRate,
    required double cgstRate,
    required double sgstRate,
    required double igstRate,
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : hsnCode = Value(hsnCode),
       description = Value(description),
       gstRate = Value(gstRate),
       cgstRate = Value(cgstRate),
       sgstRate = Value(sgstRate),
       igstRate = Value(igstRate);
  static Insertable<HsnEntry> custom({
    Expression<int>? id,
    Expression<String>? hsnCode,
    Expression<String>? description,
    Expression<double>? gstRate,
    Expression<double>? cgstRate,
    Expression<double>? sgstRate,
    Expression<double>? igstRate,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (description != null) 'description': description,
      if (gstRate != null) 'gst_rate': gstRate,
      if (cgstRate != null) 'cgst_rate': cgstRate,
      if (sgstRate != null) 'sgst_rate': sgstRate,
      if (igstRate != null) 'igst_rate': igstRate,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  HsnEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? hsnCode,
    Value<String>? description,
    Value<double>? gstRate,
    Value<double>? cgstRate,
    Value<double>? sgstRate,
    Value<double>? igstRate,
    Value<bool>? isDefault,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return HsnEntriesCompanion(
      id: id ?? this.id,
      hsnCode: hsnCode ?? this.hsnCode,
      description: description ?? this.description,
      gstRate: gstRate ?? this.gstRate,
      cgstRate: cgstRate ?? this.cgstRate,
      sgstRate: sgstRate ?? this.sgstRate,
      igstRate: igstRate ?? this.igstRate,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (gstRate.present) {
      map['gst_rate'] = Variable<double>(gstRate.value);
    }
    if (cgstRate.present) {
      map['cgst_rate'] = Variable<double>(cgstRate.value);
    }
    if (sgstRate.present) {
      map['sgst_rate'] = Variable<double>(sgstRate.value);
    }
    if (igstRate.present) {
      map['igst_rate'] = Variable<double>(igstRate.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HsnEntriesCompanion(')
          ..write('id: $id, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('description: $description, ')
          ..write('gstRate: $gstRate, ')
          ..write('cgstRate: $cgstRate, ')
          ..write('sgstRate: $sgstRate, ')
          ..write('igstRate: $igstRate, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LedgersTable ledgers = $LedgersTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceItemsTable invoiceItems = $InvoiceItemsTable(this);
  late final $InventoryItemsTable inventoryItems = $InventoryItemsTable(this);
  late final $DocumentSeriesNumbersTable documentSeriesNumbers =
      $DocumentSeriesNumbersTable(this);
  late final $VouchersTable vouchers = $VouchersTable(this);
  late final $LedgerEntriesTable ledgerEntries = $LedgerEntriesTable(this);
  late final $HsnEntriesTable hsnEntries = $HsnEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    ledgers,
    customers,
    invoices,
    invoiceItems,
    inventoryItems,
    documentSeriesNumbers,
    vouchers,
    ledgerEntries,
    hsnEntries,
  ];
}

typedef $$LedgersTableCreateCompanionBuilder =
    LedgersCompanion Function({
      Value<int> id,
      required String name,
      required String type,
      Value<DateTime> createdAt,
    });
typedef $$LedgersTableUpdateCompanionBuilder =
    LedgersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<DateTime> createdAt,
    });

final class $$LedgersTableReferences
    extends BaseReferences<_$AppDatabase, $LedgersTable, Ledger> {
  $$LedgersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CustomersTable, List<Customer>>
  _customersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customers,
    aliasName: 'ledgers__id__customers__ledger_id',
  );

  $$CustomersTableProcessedTableManager get customersRefs {
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.ledgerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_customersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LedgerEntriesTable, List<LedgerEntry>>
  _ledgerEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ledgerEntries,
    aliasName: 'ledgers__id__ledger_entries__ledger_id',
  );

  $$LedgerEntriesTableProcessedTableManager get ledgerEntriesRefs {
    final manager = $$LedgerEntriesTableTableManager(
      $_db,
      $_db.ledgerEntries,
    ).filter((f) => f.ledgerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ledgerEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LedgersTableFilterComposer
    extends Composer<_$AppDatabase, $LedgersTable> {
  $$LedgersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> customersRefs(
    Expression<bool> Function($$CustomersTableFilterComposer f) f,
  ) {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.ledgerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ledgerEntriesRefs(
    Expression<bool> Function($$LedgerEntriesTableFilterComposer f) f,
  ) {
    final $$LedgerEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerEntries,
      getReferencedColumn: (t) => t.ledgerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerEntriesTableFilterComposer(
            $db: $db,
            $table: $db.ledgerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LedgersTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgersTable> {
  $$LedgersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LedgersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgersTable> {
  $$LedgersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> customersRefs<T extends Object>(
    Expression<T> Function($$CustomersTableAnnotationComposer a) f,
  ) {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.ledgerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ledgerEntriesRefs<T extends Object>(
    Expression<T> Function($$LedgerEntriesTableAnnotationComposer a) f,
  ) {
    final $$LedgerEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerEntries,
      getReferencedColumn: (t) => t.ledgerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LedgersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LedgersTable,
          Ledger,
          $$LedgersTableFilterComposer,
          $$LedgersTableOrderingComposer,
          $$LedgersTableAnnotationComposer,
          $$LedgersTableCreateCompanionBuilder,
          $$LedgersTableUpdateCompanionBuilder,
          (Ledger, $$LedgersTableReferences),
          Ledger,
          PrefetchHooks Function({bool customersRefs, bool ledgerEntriesRefs})
        > {
  $$LedgersTableTableManager(_$AppDatabase db, $LedgersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LedgersCompanion(
                id: id,
                name: name,
                type: type,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String type,
                Value<DateTime> createdAt = const Value.absent(),
              }) => LedgersCompanion.insert(
                id: id,
                name: name,
                type: type,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LedgersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({customersRefs = false, ledgerEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (customersRefs) db.customers,
                    if (ledgerEntriesRefs) db.ledgerEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (customersRefs)
                        await $_getPrefetchedData<
                          Ledger,
                          $LedgersTable,
                          Customer
                        >(
                          currentTable: table,
                          referencedTable: $$LedgersTableReferences
                              ._customersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgersTableReferences(
                                db,
                                table,
                                p0,
                              ).customersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ledgerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ledgerEntriesRefs)
                        await $_getPrefetchedData<
                          Ledger,
                          $LedgersTable,
                          LedgerEntry
                        >(
                          currentTable: table,
                          referencedTable: $$LedgersTableReferences
                              ._ledgerEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgersTableReferences(
                                db,
                                table,
                                p0,
                              ).ledgerEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ledgerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LedgersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LedgersTable,
      Ledger,
      $$LedgersTableFilterComposer,
      $$LedgersTableOrderingComposer,
      $$LedgersTableAnnotationComposer,
      $$LedgersTableCreateCompanionBuilder,
      $$LedgersTableUpdateCompanionBuilder,
      (Ledger, $$LedgersTableReferences),
      Ledger,
      PrefetchHooks Function({bool customersRefs, bool ledgerEntriesRefs})
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      required String name,
      Value<double> creditLimit,
      Value<double> creditDue,
      Value<String?> phone,
      Value<String?> address,
      required int ledgerId,
      Value<DateTime> createdAt,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> creditLimit,
      Value<double> creditDue,
      Value<String?> phone,
      Value<String?> address,
      Value<int> ledgerId,
      Value<DateTime> createdAt,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LedgersTable _ledgerIdTable(_$AppDatabase db) =>
      db.ledgers.createAlias('customers__ledger_id__ledgers__id');

  $$LedgersTableProcessedTableManager get ledgerId {
    final $_column = $_itemColumn<int>('ledger_id')!;

    final manager = $$LedgersTableTableManager(
      $_db,
      $_db.ledgers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ledgerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: 'customers__id__invoices__customer_id',
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get creditDue => $composableBuilder(
    column: $table.creditDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LedgersTableFilterComposer get ledgerId {
    final $$LedgersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerId,
      referencedTable: $db.ledgers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgersTableFilterComposer(
            $db: $db,
            $table: $db.ledgers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get creditDue => $composableBuilder(
    column: $table.creditDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LedgersTableOrderingComposer get ledgerId {
    final $$LedgersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerId,
      referencedTable: $db.ledgers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgersTableOrderingComposer(
            $db: $db,
            $table: $db.ledgers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get creditDue =>
      $composableBuilder(column: $table.creditDue, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$LedgersTableAnnotationComposer get ledgerId {
    final $$LedgersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerId,
      referencedTable: $db.ledgers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgersTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({bool ledgerId, bool invoicesRefs})
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> creditLimit = const Value.absent(),
                Value<double> creditDue = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<int> ledgerId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                creditLimit: creditLimit,
                creditDue: creditDue,
                phone: phone,
                address: address,
                ledgerId: ledgerId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<double> creditLimit = const Value.absent(),
                Value<double> creditDue = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                required int ledgerId,
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                creditLimit: creditLimit,
                creditDue: creditDue,
                phone: phone,
                address: address,
                ledgerId: ledgerId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ledgerId = false, invoicesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (invoicesRefs) db.invoices],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ledgerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ledgerId,
                                referencedTable: $$CustomersTableReferences
                                    ._ledgerIdTable(db),
                                referencedColumn: $$CustomersTableReferences
                                    ._ledgerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (invoicesRefs)
                    await $_getPrefetchedData<
                      Customer,
                      $CustomersTable,
                      Invoice
                    >(
                      currentTable: table,
                      referencedTable: $$CustomersTableReferences
                          ._invoicesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomersTableReferences(
                            db,
                            table,
                            p0,
                          ).invoicesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.customerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({bool ledgerId, bool invoicesRefs})
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      Value<int?> customerId,
      required String invoiceNo,
      Value<double> subtotalAmount,
      Value<double> discountAmount,
      Value<double> totalAmount,
      Value<double> taxableAmount,
      Value<double> totalTaxAmount,
      Value<double> cgstAmount,
      Value<double> sgstAmount,
      Value<double> paidAmount,
      required PaymentMode paymentMode,
      required PaymentStatus paymentStatus,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      Value<int?> customerId,
      Value<String> invoiceNo,
      Value<double> subtotalAmount,
      Value<double> discountAmount,
      Value<double> totalAmount,
      Value<double> taxableAmount,
      Value<double> totalTaxAmount,
      Value<double> cgstAmount,
      Value<double> sgstAmount,
      Value<double> paidAmount,
      Value<PaymentMode> paymentMode,
      Value<PaymentStatus> paymentStatus,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, Invoice> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('invoices__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoiceItemsTable, List<InvoiceItem>>
  _invoiceItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceItems,
    aliasName: 'invoices__id__invoice_items__invoice_id',
  );

  $$InvoiceItemsTableProcessedTableManager get invoiceItemsRefs {
    final manager = $$InvoiceItemsTableTableManager(
      $_db,
      $_db.invoiceItems,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNo => $composableBuilder(
    column: $table.invoiceNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotalAmount => $composableBuilder(
    column: $table.subtotalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalTaxAmount => $composableBuilder(
    column: $table.totalTaxAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMode, PaymentMode, int>
  get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentStatus, PaymentStatus, int>
  get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoiceItemsRefs(
    Expression<bool> Function($$InvoiceItemsTableFilterComposer f) f,
  ) {
    final $$InvoiceItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableFilterComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNo => $composableBuilder(
    column: $table.invoiceNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotalAmount => $composableBuilder(
    column: $table.subtotalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalTaxAmount => $composableBuilder(
    column: $table.totalTaxAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNo =>
      $composableBuilder(column: $table.invoiceNo, builder: (column) => column);

  GeneratedColumn<double> get subtotalAmount => $composableBuilder(
    column: $table.subtotalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalTaxAmount => $composableBuilder(
    column: $table.totalTaxAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PaymentMode, int> get paymentMode =>
      $composableBuilder(
        column: $table.paymentMode,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<PaymentStatus, int> get paymentStatus =>
      $composableBuilder(
        column: $table.paymentStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoiceItemsRefs<T extends Object>(
    Expression<T> Function($$InvoiceItemsTableAnnotationComposer a) f,
  ) {
    final $$InvoiceItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, $$InvoicesTableReferences),
          Invoice,
          PrefetchHooks Function({bool customerId, bool invoiceItemsRefs})
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<String> invoiceNo = const Value.absent(),
                Value<double> subtotalAmount = const Value.absent(),
                Value<double> discountAmount = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> taxableAmount = const Value.absent(),
                Value<double> totalTaxAmount = const Value.absent(),
                Value<double> cgstAmount = const Value.absent(),
                Value<double> sgstAmount = const Value.absent(),
                Value<double> paidAmount = const Value.absent(),
                Value<PaymentMode> paymentMode = const Value.absent(),
                Value<PaymentStatus> paymentStatus = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                customerId: customerId,
                invoiceNo: invoiceNo,
                subtotalAmount: subtotalAmount,
                discountAmount: discountAmount,
                totalAmount: totalAmount,
                taxableAmount: taxableAmount,
                totalTaxAmount: totalTaxAmount,
                cgstAmount: cgstAmount,
                sgstAmount: sgstAmount,
                paidAmount: paidAmount,
                paymentMode: paymentMode,
                paymentStatus: paymentStatus,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                required String invoiceNo,
                Value<double> subtotalAmount = const Value.absent(),
                Value<double> discountAmount = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> taxableAmount = const Value.absent(),
                Value<double> totalTaxAmount = const Value.absent(),
                Value<double> cgstAmount = const Value.absent(),
                Value<double> sgstAmount = const Value.absent(),
                Value<double> paidAmount = const Value.absent(),
                required PaymentMode paymentMode,
                required PaymentStatus paymentStatus,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                customerId: customerId,
                invoiceNo: invoiceNo,
                subtotalAmount: subtotalAmount,
                discountAmount: discountAmount,
                totalAmount: totalAmount,
                taxableAmount: taxableAmount,
                totalTaxAmount: totalTaxAmount,
                cgstAmount: cgstAmount,
                sgstAmount: sgstAmount,
                paidAmount: paidAmount,
                paymentMode: paymentMode,
                paymentStatus: paymentStatus,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({customerId = false, invoiceItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceItemsRefs) db.invoiceItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceItemsRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          InvoiceItem
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._invoiceItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, $$InvoicesTableReferences),
      Invoice,
      PrefetchHooks Function({bool customerId, bool invoiceItemsRefs})
    >;
typedef $$InvoiceItemsTableCreateCompanionBuilder =
    InvoiceItemsCompanion Function({
      Value<int> id,
      required int invoiceId,
      required String itemName,
      required double quantity,
      required double rate,
      required double total,
      Value<double> discountAmount,
      Value<String?> hsnCode,
      Value<double> taxRate,
      Value<double> taxableAmount,
      Value<double> taxAmount,
      Value<double> cgstAmount,
      Value<double> sgstAmount,
      Value<bool> isTaxInclusive,
      Value<int> serialNo,
      Value<DateTime> createdAt,
    });
typedef $$InvoiceItemsTableUpdateCompanionBuilder =
    InvoiceItemsCompanion Function({
      Value<int> id,
      Value<int> invoiceId,
      Value<String> itemName,
      Value<double> quantity,
      Value<double> rate,
      Value<double> total,
      Value<double> discountAmount,
      Value<String?> hsnCode,
      Value<double> taxRate,
      Value<double> taxableAmount,
      Value<double> taxAmount,
      Value<double> cgstAmount,
      Value<double> sgstAmount,
      Value<bool> isTaxInclusive,
      Value<int> serialNo,
      Value<DateTime> createdAt,
    });

final class $$InvoiceItemsTableReferences
    extends BaseReferences<_$AppDatabase, $InvoiceItemsTable, InvoiceItem> {
  $$InvoiceItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('invoice_items__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoiceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTaxInclusive => $composableBuilder(
    column: $table.isTaxInclusive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serialNo => $composableBuilder(
    column: $table.serialNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTaxInclusive => $composableBuilder(
    column: $table.isTaxInclusive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serialNo => $composableBuilder(
    column: $table.serialNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isTaxInclusive => $composableBuilder(
    column: $table.isTaxInclusive,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serialNo =>
      $composableBuilder(column: $table.serialNo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceItemsTable,
          InvoiceItem,
          $$InvoiceItemsTableFilterComposer,
          $$InvoiceItemsTableOrderingComposer,
          $$InvoiceItemsTableAnnotationComposer,
          $$InvoiceItemsTableCreateCompanionBuilder,
          $$InvoiceItemsTableUpdateCompanionBuilder,
          (InvoiceItem, $$InvoiceItemsTableReferences),
          InvoiceItem,
          PrefetchHooks Function({bool invoiceId})
        > {
  $$InvoiceItemsTableTableManager(_$AppDatabase db, $InvoiceItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> invoiceId = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<double> discountAmount = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<double> taxableAmount = const Value.absent(),
                Value<double> taxAmount = const Value.absent(),
                Value<double> cgstAmount = const Value.absent(),
                Value<double> sgstAmount = const Value.absent(),
                Value<bool> isTaxInclusive = const Value.absent(),
                Value<int> serialNo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InvoiceItemsCompanion(
                id: id,
                invoiceId: invoiceId,
                itemName: itemName,
                quantity: quantity,
                rate: rate,
                total: total,
                discountAmount: discountAmount,
                hsnCode: hsnCode,
                taxRate: taxRate,
                taxableAmount: taxableAmount,
                taxAmount: taxAmount,
                cgstAmount: cgstAmount,
                sgstAmount: sgstAmount,
                isTaxInclusive: isTaxInclusive,
                serialNo: serialNo,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int invoiceId,
                required String itemName,
                required double quantity,
                required double rate,
                required double total,
                Value<double> discountAmount = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<double> taxableAmount = const Value.absent(),
                Value<double> taxAmount = const Value.absent(),
                Value<double> cgstAmount = const Value.absent(),
                Value<double> sgstAmount = const Value.absent(),
                Value<bool> isTaxInclusive = const Value.absent(),
                Value<int> serialNo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InvoiceItemsCompanion.insert(
                id: id,
                invoiceId: invoiceId,
                itemName: itemName,
                quantity: quantity,
                rate: rate,
                total: total,
                discountAmount: discountAmount,
                hsnCode: hsnCode,
                taxRate: taxRate,
                taxableAmount: taxableAmount,
                taxAmount: taxAmount,
                cgstAmount: cgstAmount,
                sgstAmount: sgstAmount,
                isTaxInclusive: isTaxInclusive,
                serialNo: serialNo,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoiceItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable: $$InvoiceItemsTableReferences
                                    ._invoiceIdTable(db),
                                referencedColumn: $$InvoiceItemsTableReferences
                                    ._invoiceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InvoiceItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceItemsTable,
      InvoiceItem,
      $$InvoiceItemsTableFilterComposer,
      $$InvoiceItemsTableOrderingComposer,
      $$InvoiceItemsTableAnnotationComposer,
      $$InvoiceItemsTableCreateCompanionBuilder,
      $$InvoiceItemsTableUpdateCompanionBuilder,
      (InvoiceItem, $$InvoiceItemsTableReferences),
      InvoiceItem,
      PrefetchHooks Function({bool invoiceId})
    >;
typedef $$InventoryItemsTableCreateCompanionBuilder =
    InventoryItemsCompanion Function({
      Value<int> id,
      required String code,
      Value<String?> barcode,
      required String name,
      required String category,
      required String brand,
      required double price,
      Value<String> uom,
      Value<double> unitValue,
      Value<String?> imagePath,
      Value<InventoryItemStatus> status,
      Value<String?> hsnCode,
      Value<double> taxRate,
      Value<bool> isTaxInclusive,
      Value<DateTime> createdAt,
    });
typedef $$InventoryItemsTableUpdateCompanionBuilder =
    InventoryItemsCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String?> barcode,
      Value<String> name,
      Value<String> category,
      Value<String> brand,
      Value<double> price,
      Value<String> uom,
      Value<double> unitValue,
      Value<String?> imagePath,
      Value<InventoryItemStatus> status,
      Value<String?> hsnCode,
      Value<double> taxRate,
      Value<bool> isTaxInclusive,
      Value<DateTime> createdAt,
    });

class $$InventoryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitValue => $composableBuilder(
    column: $table.unitValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InventoryItemStatus, InventoryItemStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTaxInclusive => $composableBuilder(
    column: $table.isTaxInclusive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitValue => $composableBuilder(
    column: $table.unitValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTaxInclusive => $composableBuilder(
    column: $table.isTaxInclusive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get uom =>
      $composableBuilder(column: $table.uom, builder: (column) => column);

  GeneratedColumn<double> get unitValue =>
      $composableBuilder(column: $table.unitValue, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InventoryItemStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<bool> get isTaxInclusive => $composableBuilder(
    column: $table.isTaxInclusive,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InventoryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryItemsTable,
          InventoryItem,
          $$InventoryItemsTableFilterComposer,
          $$InventoryItemsTableOrderingComposer,
          $$InventoryItemsTableAnnotationComposer,
          $$InventoryItemsTableCreateCompanionBuilder,
          $$InventoryItemsTableUpdateCompanionBuilder,
          (
            InventoryItem,
            BaseReferences<_$AppDatabase, $InventoryItemsTable, InventoryItem>,
          ),
          InventoryItem,
          PrefetchHooks Function()
        > {
  $$InventoryItemsTableTableManager(
    _$AppDatabase db,
    $InventoryItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> uom = const Value.absent(),
                Value<double> unitValue = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<InventoryItemStatus> status = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<bool> isTaxInclusive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InventoryItemsCompanion(
                id: id,
                code: code,
                barcode: barcode,
                name: name,
                category: category,
                brand: brand,
                price: price,
                uom: uom,
                unitValue: unitValue,
                imagePath: imagePath,
                status: status,
                hsnCode: hsnCode,
                taxRate: taxRate,
                isTaxInclusive: isTaxInclusive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                Value<String?> barcode = const Value.absent(),
                required String name,
                required String category,
                required String brand,
                required double price,
                Value<String> uom = const Value.absent(),
                Value<double> unitValue = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<InventoryItemStatus> status = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<bool> isTaxInclusive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InventoryItemsCompanion.insert(
                id: id,
                code: code,
                barcode: barcode,
                name: name,
                category: category,
                brand: brand,
                price: price,
                uom: uom,
                unitValue: unitValue,
                imagePath: imagePath,
                status: status,
                hsnCode: hsnCode,
                taxRate: taxRate,
                isTaxInclusive: isTaxInclusive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryItemsTable,
      InventoryItem,
      $$InventoryItemsTableFilterComposer,
      $$InventoryItemsTableOrderingComposer,
      $$InventoryItemsTableAnnotationComposer,
      $$InventoryItemsTableCreateCompanionBuilder,
      $$InventoryItemsTableUpdateCompanionBuilder,
      (
        InventoryItem,
        BaseReferences<_$AppDatabase, $InventoryItemsTable, InventoryItem>,
      ),
      InventoryItem,
      PrefetchHooks Function()
    >;
typedef $$DocumentSeriesNumbersTableCreateCompanionBuilder =
    DocumentSeriesNumbersCompanion Function({
      Value<int> id,
      required String module,
      Value<int> startingNumber,
      Value<int> currentNumber,
      Value<String?> prefix,
      Value<String?> suffix,
      Value<String> pattern,
      Value<int> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$DocumentSeriesNumbersTableUpdateCompanionBuilder =
    DocumentSeriesNumbersCompanion Function({
      Value<int> id,
      Value<String> module,
      Value<int> startingNumber,
      Value<int> currentNumber,
      Value<String?> prefix,
      Value<String?> suffix,
      Value<String> pattern,
      Value<int> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$DocumentSeriesNumbersTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentSeriesNumbersTable> {
  $$DocumentSeriesNumbersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startingNumber => $composableBuilder(
    column: $table.startingNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentNumber => $composableBuilder(
    column: $table.currentNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prefix => $composableBuilder(
    column: $table.prefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suffix => $composableBuilder(
    column: $table.suffix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentSeriesNumbersTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentSeriesNumbersTable> {
  $$DocumentSeriesNumbersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startingNumber => $composableBuilder(
    column: $table.startingNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentNumber => $composableBuilder(
    column: $table.currentNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prefix => $composableBuilder(
    column: $table.prefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suffix => $composableBuilder(
    column: $table.suffix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentSeriesNumbersTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentSeriesNumbersTable> {
  $$DocumentSeriesNumbersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get module =>
      $composableBuilder(column: $table.module, builder: (column) => column);

  GeneratedColumn<int> get startingNumber => $composableBuilder(
    column: $table.startingNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentNumber => $composableBuilder(
    column: $table.currentNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prefix =>
      $composableBuilder(column: $table.prefix, builder: (column) => column);

  GeneratedColumn<String> get suffix =>
      $composableBuilder(column: $table.suffix, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DocumentSeriesNumbersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentSeriesNumbersTable,
          DocumentSeriesNumber,
          $$DocumentSeriesNumbersTableFilterComposer,
          $$DocumentSeriesNumbersTableOrderingComposer,
          $$DocumentSeriesNumbersTableAnnotationComposer,
          $$DocumentSeriesNumbersTableCreateCompanionBuilder,
          $$DocumentSeriesNumbersTableUpdateCompanionBuilder,
          (
            DocumentSeriesNumber,
            BaseReferences<
              _$AppDatabase,
              $DocumentSeriesNumbersTable,
              DocumentSeriesNumber
            >,
          ),
          DocumentSeriesNumber,
          PrefetchHooks Function()
        > {
  $$DocumentSeriesNumbersTableTableManager(
    _$AppDatabase db,
    $DocumentSeriesNumbersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentSeriesNumbersTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DocumentSeriesNumbersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DocumentSeriesNumbersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> module = const Value.absent(),
                Value<int> startingNumber = const Value.absent(),
                Value<int> currentNumber = const Value.absent(),
                Value<String?> prefix = const Value.absent(),
                Value<String?> suffix = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DocumentSeriesNumbersCompanion(
                id: id,
                module: module,
                startingNumber: startingNumber,
                currentNumber: currentNumber,
                prefix: prefix,
                suffix: suffix,
                pattern: pattern,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String module,
                Value<int> startingNumber = const Value.absent(),
                Value<int> currentNumber = const Value.absent(),
                Value<String?> prefix = const Value.absent(),
                Value<String?> suffix = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DocumentSeriesNumbersCompanion.insert(
                id: id,
                module: module,
                startingNumber: startingNumber,
                currentNumber: currentNumber,
                prefix: prefix,
                suffix: suffix,
                pattern: pattern,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentSeriesNumbersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentSeriesNumbersTable,
      DocumentSeriesNumber,
      $$DocumentSeriesNumbersTableFilterComposer,
      $$DocumentSeriesNumbersTableOrderingComposer,
      $$DocumentSeriesNumbersTableAnnotationComposer,
      $$DocumentSeriesNumbersTableCreateCompanionBuilder,
      $$DocumentSeriesNumbersTableUpdateCompanionBuilder,
      (
        DocumentSeriesNumber,
        BaseReferences<
          _$AppDatabase,
          $DocumentSeriesNumbersTable,
          DocumentSeriesNumber
        >,
      ),
      DocumentSeriesNumber,
      PrefetchHooks Function()
    >;
typedef $$VouchersTableCreateCompanionBuilder =
    VouchersCompanion Function({
      Value<int> id,
      required String type,
      Value<int?> referenceId,
      Value<DateTime> createdAt,
    });
typedef $$VouchersTableUpdateCompanionBuilder =
    VouchersCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<int?> referenceId,
      Value<DateTime> createdAt,
    });

final class $$VouchersTableReferences
    extends BaseReferences<_$AppDatabase, $VouchersTable, Voucher> {
  $$VouchersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LedgerEntriesTable, List<LedgerEntry>>
  _ledgerEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ledgerEntries,
    aliasName: 'vouchers__id__ledger_entries__voucher_id',
  );

  $$LedgerEntriesTableProcessedTableManager get ledgerEntriesRefs {
    final manager = $$LedgerEntriesTableTableManager(
      $_db,
      $_db.ledgerEntries,
    ).filter((f) => f.voucherId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ledgerEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VouchersTableFilterComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ledgerEntriesRefs(
    Expression<bool> Function($$LedgerEntriesTableFilterComposer f) f,
  ) {
    final $$LedgerEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerEntries,
      getReferencedColumn: (t) => t.voucherId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerEntriesTableFilterComposer(
            $db: $db,
            $table: $db.ledgerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VouchersTableOrderingComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VouchersTableAnnotationComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> ledgerEntriesRefs<T extends Object>(
    Expression<T> Function($$LedgerEntriesTableAnnotationComposer a) f,
  ) {
    final $$LedgerEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerEntries,
      getReferencedColumn: (t) => t.voucherId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VouchersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VouchersTable,
          Voucher,
          $$VouchersTableFilterComposer,
          $$VouchersTableOrderingComposer,
          $$VouchersTableAnnotationComposer,
          $$VouchersTableCreateCompanionBuilder,
          $$VouchersTableUpdateCompanionBuilder,
          (Voucher, $$VouchersTableReferences),
          Voucher,
          PrefetchHooks Function({bool ledgerEntriesRefs})
        > {
  $$VouchersTableTableManager(_$AppDatabase db, $VouchersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VouchersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VouchersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VouchersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> referenceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VouchersCompanion(
                id: id,
                type: type,
                referenceId: referenceId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                Value<int?> referenceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VouchersCompanion.insert(
                id: id,
                type: type,
                referenceId: referenceId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VouchersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ledgerEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ledgerEntriesRefs) db.ledgerEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ledgerEntriesRefs)
                    await $_getPrefetchedData<
                      Voucher,
                      $VouchersTable,
                      LedgerEntry
                    >(
                      currentTable: table,
                      referencedTable: $$VouchersTableReferences
                          ._ledgerEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$VouchersTableReferences(
                        db,
                        table,
                        p0,
                      ).ledgerEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.voucherId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$VouchersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VouchersTable,
      Voucher,
      $$VouchersTableFilterComposer,
      $$VouchersTableOrderingComposer,
      $$VouchersTableAnnotationComposer,
      $$VouchersTableCreateCompanionBuilder,
      $$VouchersTableUpdateCompanionBuilder,
      (Voucher, $$VouchersTableReferences),
      Voucher,
      PrefetchHooks Function({bool ledgerEntriesRefs})
    >;
typedef $$LedgerEntriesTableCreateCompanionBuilder =
    LedgerEntriesCompanion Function({
      Value<int> id,
      required int voucherId,
      required int ledgerId,
      Value<double> debit,
      Value<double> credit,
      Value<DateTime> createdAt,
    });
typedef $$LedgerEntriesTableUpdateCompanionBuilder =
    LedgerEntriesCompanion Function({
      Value<int> id,
      Value<int> voucherId,
      Value<int> ledgerId,
      Value<double> debit,
      Value<double> credit,
      Value<DateTime> createdAt,
    });

final class $$LedgerEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $LedgerEntriesTable, LedgerEntry> {
  $$LedgerEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VouchersTable _voucherIdTable(_$AppDatabase db) =>
      db.vouchers.createAlias('ledger_entries__voucher_id__vouchers__id');

  $$VouchersTableProcessedTableManager get voucherId {
    final $_column = $_itemColumn<int>('voucher_id')!;

    final manager = $$VouchersTableTableManager(
      $_db,
      $_db.vouchers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_voucherIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LedgersTable _ledgerIdTable(_$AppDatabase db) =>
      db.ledgers.createAlias('ledger_entries__ledger_id__ledgers__id');

  $$LedgersTableProcessedTableManager get ledgerId {
    final $_column = $_itemColumn<int>('ledger_id')!;

    final manager = $$LedgersTableTableManager(
      $_db,
      $_db.ledgers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ledgerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LedgerEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VouchersTableFilterComposer get voucherId {
    final $$VouchersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voucherId,
      referencedTable: $db.vouchers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VouchersTableFilterComposer(
            $db: $db,
            $table: $db.vouchers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgersTableFilterComposer get ledgerId {
    final $$LedgersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerId,
      referencedTable: $db.ledgers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgersTableFilterComposer(
            $db: $db,
            $table: $db.ledgers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VouchersTableOrderingComposer get voucherId {
    final $$VouchersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voucherId,
      referencedTable: $db.vouchers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VouchersTableOrderingComposer(
            $db: $db,
            $table: $db.vouchers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgersTableOrderingComposer get ledgerId {
    final $$LedgersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerId,
      referencedTable: $db.ledgers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgersTableOrderingComposer(
            $db: $db,
            $table: $db.ledgers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<double> get credit =>
      $composableBuilder(column: $table.credit, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VouchersTableAnnotationComposer get voucherId {
    final $$VouchersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voucherId,
      referencedTable: $db.vouchers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VouchersTableAnnotationComposer(
            $db: $db,
            $table: $db.vouchers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgersTableAnnotationComposer get ledgerId {
    final $$LedgersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerId,
      referencedTable: $db.ledgers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgersTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LedgerEntriesTable,
          LedgerEntry,
          $$LedgerEntriesTableFilterComposer,
          $$LedgerEntriesTableOrderingComposer,
          $$LedgerEntriesTableAnnotationComposer,
          $$LedgerEntriesTableCreateCompanionBuilder,
          $$LedgerEntriesTableUpdateCompanionBuilder,
          (LedgerEntry, $$LedgerEntriesTableReferences),
          LedgerEntry,
          PrefetchHooks Function({bool voucherId, bool ledgerId})
        > {
  $$LedgerEntriesTableTableManager(_$AppDatabase db, $LedgerEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> voucherId = const Value.absent(),
                Value<int> ledgerId = const Value.absent(),
                Value<double> debit = const Value.absent(),
                Value<double> credit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LedgerEntriesCompanion(
                id: id,
                voucherId: voucherId,
                ledgerId: ledgerId,
                debit: debit,
                credit: credit,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int voucherId,
                required int ledgerId,
                Value<double> debit = const Value.absent(),
                Value<double> credit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LedgerEntriesCompanion.insert(
                id: id,
                voucherId: voucherId,
                ledgerId: ledgerId,
                debit: debit,
                credit: credit,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LedgerEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({voucherId = false, ledgerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (voucherId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.voucherId,
                                referencedTable: $$LedgerEntriesTableReferences
                                    ._voucherIdTable(db),
                                referencedColumn: $$LedgerEntriesTableReferences
                                    ._voucherIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (ledgerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ledgerId,
                                referencedTable: $$LedgerEntriesTableReferences
                                    ._ledgerIdTable(db),
                                referencedColumn: $$LedgerEntriesTableReferences
                                    ._ledgerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LedgerEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LedgerEntriesTable,
      LedgerEntry,
      $$LedgerEntriesTableFilterComposer,
      $$LedgerEntriesTableOrderingComposer,
      $$LedgerEntriesTableAnnotationComposer,
      $$LedgerEntriesTableCreateCompanionBuilder,
      $$LedgerEntriesTableUpdateCompanionBuilder,
      (LedgerEntry, $$LedgerEntriesTableReferences),
      LedgerEntry,
      PrefetchHooks Function({bool voucherId, bool ledgerId})
    >;
typedef $$HsnEntriesTableCreateCompanionBuilder =
    HsnEntriesCompanion Function({
      Value<int> id,
      required String hsnCode,
      required String description,
      required double gstRate,
      required double cgstRate,
      required double sgstRate,
      required double igstRate,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$HsnEntriesTableUpdateCompanionBuilder =
    HsnEntriesCompanion Function({
      Value<int> id,
      Value<String> hsnCode,
      Value<String> description,
      Value<double> gstRate,
      Value<double> cgstRate,
      Value<double> sgstRate,
      Value<double> igstRate,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$HsnEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HsnEntriesTable> {
  $$HsnEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gstRate => $composableBuilder(
    column: $table.gstRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cgstRate => $composableBuilder(
    column: $table.cgstRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sgstRate => $composableBuilder(
    column: $table.sgstRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get igstRate => $composableBuilder(
    column: $table.igstRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HsnEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HsnEntriesTable> {
  $$HsnEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gstRate => $composableBuilder(
    column: $table.gstRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cgstRate => $composableBuilder(
    column: $table.cgstRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sgstRate => $composableBuilder(
    column: $table.sgstRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get igstRate => $composableBuilder(
    column: $table.igstRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HsnEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HsnEntriesTable> {
  $$HsnEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get gstRate =>
      $composableBuilder(column: $table.gstRate, builder: (column) => column);

  GeneratedColumn<double> get cgstRate =>
      $composableBuilder(column: $table.cgstRate, builder: (column) => column);

  GeneratedColumn<double> get sgstRate =>
      $composableBuilder(column: $table.sgstRate, builder: (column) => column);

  GeneratedColumn<double> get igstRate =>
      $composableBuilder(column: $table.igstRate, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HsnEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HsnEntriesTable,
          HsnEntry,
          $$HsnEntriesTableFilterComposer,
          $$HsnEntriesTableOrderingComposer,
          $$HsnEntriesTableAnnotationComposer,
          $$HsnEntriesTableCreateCompanionBuilder,
          $$HsnEntriesTableUpdateCompanionBuilder,
          (HsnEntry, BaseReferences<_$AppDatabase, $HsnEntriesTable, HsnEntry>),
          HsnEntry,
          PrefetchHooks Function()
        > {
  $$HsnEntriesTableTableManager(_$AppDatabase db, $HsnEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HsnEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HsnEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HsnEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> hsnCode = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> gstRate = const Value.absent(),
                Value<double> cgstRate = const Value.absent(),
                Value<double> sgstRate = const Value.absent(),
                Value<double> igstRate = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => HsnEntriesCompanion(
                id: id,
                hsnCode: hsnCode,
                description: description,
                gstRate: gstRate,
                cgstRate: cgstRate,
                sgstRate: sgstRate,
                igstRate: igstRate,
                isDefault: isDefault,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String hsnCode,
                required String description,
                required double gstRate,
                required double cgstRate,
                required double sgstRate,
                required double igstRate,
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => HsnEntriesCompanion.insert(
                id: id,
                hsnCode: hsnCode,
                description: description,
                gstRate: gstRate,
                cgstRate: cgstRate,
                sgstRate: sgstRate,
                igstRate: igstRate,
                isDefault: isDefault,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HsnEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HsnEntriesTable,
      HsnEntry,
      $$HsnEntriesTableFilterComposer,
      $$HsnEntriesTableOrderingComposer,
      $$HsnEntriesTableAnnotationComposer,
      $$HsnEntriesTableCreateCompanionBuilder,
      $$HsnEntriesTableUpdateCompanionBuilder,
      (HsnEntry, BaseReferences<_$AppDatabase, $HsnEntriesTable, HsnEntry>),
      HsnEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LedgersTableTableManager get ledgers =>
      $$LedgersTableTableManager(_db, _db.ledgers);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceItemsTableTableManager get invoiceItems =>
      $$InvoiceItemsTableTableManager(_db, _db.invoiceItems);
  $$InventoryItemsTableTableManager get inventoryItems =>
      $$InventoryItemsTableTableManager(_db, _db.inventoryItems);
  $$DocumentSeriesNumbersTableTableManager get documentSeriesNumbers =>
      $$DocumentSeriesNumbersTableTableManager(_db, _db.documentSeriesNumbers);
  $$VouchersTableTableManager get vouchers =>
      $$VouchersTableTableManager(_db, _db.vouchers);
  $$LedgerEntriesTableTableManager get ledgerEntries =>
      $$LedgerEntriesTableTableManager(_db, _db.ledgerEntries);
  $$HsnEntriesTableTableManager get hsnEntries =>
      $$HsnEntriesTableTableManager(_db, _db.hsnEntries);
}
