import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class MyContacts {
  String? id;
  String? displayName;
  Uint8List? photo;
  Uint8List? thumbnail;
  Name? name;
  List<Phone>? phones;
  List<Email>? emails;
  List<Address>? addresses;
  List<Organization>? organizations;
  List<Website>? websites;
  List<SocialMedia>? socialMedias;
  List<Event>? events;
  List<Note>? notes;
  List<Group>? groups;
}

class Name {
  String? first;
  String? last;
}

class Phone {
  String? number;
  PhoneLabel? label;
}

class Email {
  String? address;
  EmailLabel? label;
}

class Address {
  String? address;
  AddressLabel? label;
}

class Organization {
  String? company;
  String? title;
}

class Website {
  String? url;
  WebsiteLabel? label;
}

class SocialMedia {
  String? userName;
  SocialMediaLabel? label;
}

class Event {
  int? year;
  int? month;
  int? day;
  EventLabel? label;
}

class Note {
  String? note;
}

class Group {
  String? id;
  String? name;
}
