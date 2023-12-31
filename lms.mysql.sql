# --------------------------------------------------------
# $Id: lms.mysql,v 1.186 2011/03/25 08:14:40 chilek Exp $
# --------------------------------------------------------

# -- Drop tables first, MySQL doesn't support CASCADE

drop database if exists LMS2;
create database LMS2 default character set utf8;

USE LMS2;

DROP VIEW IF EXISTS nas;
DROP VIEW IF EXISTS vnodes_mac;
DROP VIEW IF EXISTS vnodes;
DROP VIEW IF EXISTS vmacs;
DROP VIEW IF EXISTS customersview;

DROP TABLE IF EXISTS ewx_stm_nodes;
DROP TABLE IF EXISTS ewx_stm_channels;
DROP TABLE IF EXISTS ewx_pt_config;
DROP TABLE IF EXISTS ewx_channels;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS numberplans;
DROP TABLE IF EXISTS nodeassignments;
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS taxes;
DROP TABLE IF EXISTS cash;
DROP TABLE IF EXISTS dbinfo;
DROP TABLE IF EXISTS numberplanassignments;
DROP TABLE IF EXISTS invoicecontents;
DROP TABLE IF EXISTS debitnotecontents;
DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS documentcontents;
DROP TABLE IF EXISTS receiptcontents;
DROP TABLE IF EXISTS netdevices;
DROP TABLE IF EXISTS netlinks;
DROP TABLE IF EXISTS networks;
DROP TABLE IF EXISTS macs;
DROP TABLE IF EXISTS nodes;
DROP TABLE IF EXISTS nodegroups;
DROP TABLE IF EXISTS nodegroupassignments;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS rtattachments;
DROP TABLE IF EXISTS rtmessages;
DROP TABLE IF EXISTS rtnotes;
DROP TABLE IF EXISTS rtqueues;
DROP TABLE IF EXISTS rttickets;
DROP TABLE IF EXISTS rtrights;
DROP TABLE IF EXISTS stats;
DROP TABLE IF EXISTS tariffs;
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS promotionschemas;
DROP TABLE IF EXISTS promotionassignments;
DROP TABLE IF EXISTS liabilities;
DROP TABLE IF EXISTS customergroups;
DROP TABLE IF EXISTS customerassignments;
DROP TABLE IF EXISTS records;
DROP TABLE IF EXISTS passwd;
DROP TABLE IF EXISTS domains;
DROP TABLE IF EXISTS aliases;
DROP TABLE IF EXISTS aliasassignments;
DROP TABLE IF EXISTS uiconfig;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS eventassignments;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS cashsources;
DROP TABLE IF EXISTS sourcefiles;
DROP TABLE IF EXISTS cashimport;
DROP TABLE IF EXISTS hosts;
DROP TABLE IF EXISTS daemoninstances;
DROP TABLE IF EXISTS daemonconfig;
DROP TABLE IF EXISTS docrights;
DROP TABLE IF EXISTS cashrights;
DROP TABLE IF EXISTS cashregs;
DROP TABLE IF EXISTS cashreglog;
DROP TABLE IF EXISTS imessengers;
DROP TABLE IF EXISTS customercontacts;
DROP TABLE IF EXISTS states;
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS zipcodes;
DROP TABLE IF EXISTS divisions;
DROP TABLE IF EXISTS excludedgroups;
DROP TABLE IF EXISTS voipaccounts;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS messageitems;
DROP TABLE IF EXISTS nastypes;
DROP TABLE IF EXISTS up_rights;
DROP TABLE IF EXISTS up_rights_assignments;
DROP TABLE IF EXISTS up_customers;
DROP TABLE IF EXISTS up_help;
DROP TABLE IF EXISTS up_info_changes;
DROP TABLE IF EXISTS supermasters;

# --------------------------------------------------------
#
# Structure of table  users
#

CREATE TABLE users (
  id int(11)            NOT NULL auto_increment,
  login varchar(32)     NOT NULL DEFAULT '',
  name varchar(64)      NOT NULL DEFAULT '',
  email varchar(255)    NOT NULL DEFAULT '',
  phone varchar(32)     DEFAULT NULL,
  position varchar(255) NOT NULL DEFAULT '',
  rights varchar(64)    NOT NULL DEFAULT '',
  hosts varchar(255)    NOT NULL DEFAULT '',
  passwd varchar(255)   NOT NULL DEFAULT '',
  ntype smallint        DEFAULT NULL,
  lastlogindate int(11) NOT NULL DEFAULT '0',
  lastloginip varchar(16) NOT NULL DEFAULT '',
  failedlogindate int(11) NOT NULL DEFAULT '0',
  failedloginip varchar(16) NOT NULL DEFAULT '',
  deleted tinyint(1)    NOT NULL DEFAULT '0',
  PRIMARY KEY  (id),
  UNIQUE KEY login (login)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table customers (customers)
#
CREATE TABLE customers (
  id int(11) 		NOT NULL auto_increment,
  lastname varchar(128) NOT NULL DEFAULT '',
  name varchar(128) 	NOT NULL DEFAULT '',
  status smallint 	NOT NULL DEFAULT '0',
  type smallint		NOT NULL DEFAULT '0',
  email varchar(255) 	NOT NULL DEFAULT '',
  address varchar(255) 	NOT NULL DEFAULT '',
  zip varchar(10) 	NOT NULL DEFAULT '',
  city varchar(32) 	NOT NULL DEFAULT '',
  countryid int(11)	DEFAULT NULL,
  post_name varchar(255) DEFAULT NULL,
  post_address varchar(255) DEFAULT NULL,
  post_zip varchar(10) 	    DEFAULT NULL,
  post_city varchar(32) 	DEFAULT NULL,
  post_countryid int(11)	DEFAULT NULL,
  ten varchar(16) 	NOT NULL DEFAULT '',
  ssn varchar(11) 	NOT NULL DEFAULT '',
  regon varchar(255) 	NOT NULL DEFAULT '',
  rbe varchar(255) 	NOT NULL DEFAULT '',
  icn varchar(255) 	NOT NULL DEFAULT '',
  info text 		NOT NULL,
  notes text    NOT NULL,
  creationdate int(11) 	NOT NULL DEFAULT '0',
  moddate int(11) 	NOT NULL DEFAULT '0',
  creatorid int(11) 	NOT NULL DEFAULT '0',
  modid int(11) 	NOT NULL DEFAULT '0',
  deleted tinyint(1) 	NOT NULL DEFAULT '0',
  message text 		NOT NULL,
  pin int(6) 		NOT NULL DEFAULT '0',
  cutoffstop int(11) 	NOT NULL DEFAULT '0',
  consentdate int(11)   NOT NULL DEFAULT '0',
  einvoice tinyint(1)   DEFAULT NULL,
  invoicenotice tinyint(1)   DEFAULT NULL,
  mailingnotice tinyint(1)   DEFAULT NULL,
  divisionid int(11)   	NOT NULL DEFAULT '0',
  paytime tinyint	NOT NULL DEFAULT '-1',
  paytype smallint  DEFAULT NULL,
  PRIMARY KEY  (id),
  INDEX zip (zip),
  INDEX name (lastname, name)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table numberplans
#
CREATE TABLE numberplans (
	id int(11) NOT NULL auto_increment,
	template varchar(255) NOT NULL DEFAULT '',
	period smallint NOT NULL DEFAULT '0',
	doctype int(11) NOT NULL DEFAULT '0',
	isdefault tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (id)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  assignments
#
CREATE TABLE assignments (
  id int(11) NOT NULL auto_increment,
  tariffid int(11) NOT NULL DEFAULT '0',
  liabilityid int(11) NOT NULL DEFAULT '0',
  customerid int(11) NOT NULL
    REFERENCES customers (id) ON DELETE CASCADE ON UPDATE CASCADE,
  period smallint NOT NULL DEFAULT '0',
  at int(11) NOT NULL DEFAULT '0',
  datefrom int(11) NOT NULL DEFAULT '0',
  dateto int(11) NOT NULL DEFAULT '0',
  invoice tinyint(1) NOT NULL DEFAULT '0',
  suspended tinyint(1) NOT NULL DEFAULT '0',
  settlement tinyint(1) NOT NULL DEFAULT '0',
  discount decimal(4,2) NOT NULL DEFAULT '0',
  paytype smallint DEFAULT NULL,
  numberplanid int(11) DEFAULT NULL
    REFERENCES numberplans (id) ON DELETE SET NULL ON UPDATE CASCADE,
  PRIMARY KEY (id),
  INDEX tariffid (tariffid),
  INDEX customerid (customerid),
  INDEX numberplanid (numberplanid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table taxes
#
CREATE TABLE taxes (
    id int(11) NOT NULL auto_increment,
    value decimal(4,2) NOT NULL DEFAULT '0',
    taxed tinyint NOT NULL DEFAULT '0',
    label varchar(16) NOT NULL DEFAULT '',
    validfrom int(11) NOT NULL DEFAULT '0',
    validto int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (id)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  cash
#
CREATE TABLE cash (
  id int(11) NOT NULL auto_increment,
  time int(11) NOT NULL DEFAULT '0',
  type smallint NOT NULL DEFAULT '0',
  userid int(11) NOT NULL DEFAULT '0',
  value decimal(9,2) NOT NULL DEFAULT '0.00',
  taxid int(11) NOT NULL DEFAULT '0',
  customerid int(11) NOT NULL DEFAULT '0',
  comment text NOT NULL,
  docid int(11) NOT NULL DEFAULT '0',
  itemid smallint NOT NULL DEFAULT '0',
  importid int(11) DEFAULT NULL,
  sourceid int(11) DEFAULT NULL,
  PRIMARY KEY  (id),
  INDEX customerid (customerid),
  INDEX docid (docid),
  INDEX time (time),
  INDEX importid (importid),
  INDEX sourceid (sourceid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  dbinfo
#
CREATE TABLE dbinfo (
  keytype varchar(255) NOT NULL DEFAULT '',
  keyvalue varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY  (keytype)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table numberplanassignments
#
CREATE TABLE numberplanassignments (
	id int(11) NOT NULL auto_increment,
	planid int(11) NOT NULL DEFAULT '0',
	divisionid int(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (id),
	UNIQUE KEY planid (planid, divisionid),
	INDEX divisionid (divisionid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  invoicecontents
#
CREATE TABLE invoicecontents (
  docid int(11) NOT NULL DEFAULT '0',
  itemid smallint NOT NULL DEFAULT '0',
  value decimal(9,2) NOT NULL DEFAULT '0.00',
  discount decimal(4,2) NOT NULL DEFAULT '0.00',
  taxid int(11) NOT NULL DEFAULT '0',
  prodid varchar(255) NOT NULL DEFAULT '',
  content varchar(16) NOT NULL DEFAULT '',
  count decimal(9,2) NOT NULL DEFAULT '0.00',
  description text NOT NULL,
  tariffid int(11) NOT NULL DEFAULT '0',
  INDEX docid (docid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table debitnotecontents
#
CREATE TABLE debitnotecontents (
	id int(11) NOT NULL auto_increment,
	docid int(11) NOT NULL DEFAULT '0',
	itemid smallint NOT NULL DEFAULT '0',
        value decimal(9,2) NOT NULL DEFAULT '0.00',
	description text NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY docid (docid, itemid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table documents
#
CREATE TABLE documents (
	id int(11) NOT NULL auto_increment,
	type tinyint NOT NULL DEFAULT '0',
	number int(11) NOT NULL DEFAULT '0',
	numberplanid int(11) NOT NULL DEFAULT '0',
	extnumber varchar(255) NOT NULL DEFAULT '',
	cdate int(11) NOT NULL DEFAULT '0',
	sdate int(11) NOT NULL DEFAULT '0',
	customerid int(11) NOT NULL DEFAULT '0',
	userid int(11) NOT NULL DEFAULT '0',
	divisionid int(11) NOT NULL DEFAULT '0',
	name varchar(255) NOT NULL DEFAULT '',
	address varchar(255) NOT NULL DEFAULT '',
	zip varchar(10) NOT NULL DEFAULT '',
	city varchar(32) NOT NULL DEFAULT '',
	countryid int(11) NOT NULL DEFAULT '0',
	ten varchar(16) NOT NULL DEFAULT '',
	ssn varchar(11) NOT NULL DEFAULT '',
	paytime tinyint NOT NULL DEFAULT '0',
	paytype smallint DEFAULT NULL,
	closed tinyint(1) NOT NULL DEFAULT '0',
	reference int(11) NOT NULL DEFAULT '0',
	reason varchar(255) NOT NULL DEFAULT '',
	PRIMARY KEY (id),
	INDEX cdate (cdate),
	INDEX numberplanid (numberplanid),
	INDEX customerid (customerid),
	INDEX closed (closed)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table documentcontents
#
CREATE TABLE documentcontents (
  docid int(11) DEFAULT '0' NOT NULL,
	title text NOT NULL,
  fromdate int(11) DEFAULT '0' NOT NULL,
	todate int(11) DEFAULT '0' NOT NULL,
  filename varchar(255) DEFAULT '' NOT NULL,
	contenttype varchar(255) DEFAULT '' NOT NULL,
  md5sum varchar(32) DEFAULT '' NOT NULL,
	description text NOT NULL,
  INDEX md5sum (md5sum),
	INDEX fromdate (fromdate),
	INDEX todate (todate),
	UNIQUE KEY docid (docid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table receiptcontents
#
CREATE TABLE receiptcontents (
	docid int(11) 		NOT NULL DEFAULT '0',
	itemid 			TINYINT NOT NULL DEFAULT '0',
	value decimal(9,2) 	NOT NULL DEFAULT '0',
	description text 	NOT NULL,
	regid int(11)		NOT NULL DEFAULT '0',
	INDEX docid (docid),
	INDEX regid (regid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of tables ewx_* (EtherWerX(R))
#
CREATE TABLE ewx_stm_nodes (
	id int(11)              NOT NULL auto_increment,
	nodeid int(11)          DEFAULT '0' NOT NULL,
	mac varchar(20)         DEFAULT '' NOT NULL,
	ipaddr int(16) unsigned DEFAULT '0' NOT NULL,
	channelid int(11)       DEFAULT '0' NOT NULL,
	uprate int(11)          DEFAULT '0' NOT NULL,
	upceil int(11)          DEFAULT '0' NOT NULL,
	downrate int(11)        DEFAULT '0' NOT NULL,
	downceil int(11)        DEFAULT '0' NOT NULL,
	halfduplex tinyint(1)   DEFAULT '0' NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY nodeid (nodeid)
    ) ENGINE=InnoDB;

CREATE TABLE ewx_stm_channels (
	id int(11)              NOT NULL auto_increment,
	cid int(11)             DEFAULT '0' NOT NULL,
	upceil int(11)          DEFAULT '0' NOT NULL,
	downceil int(11)        DEFAULT '0' NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY cid (cid)
) ENGINE=InnoDB;

CREATE TABLE ewx_pt_config (
        id int(11)              NOT NULL auto_increment,
	nodeid int(11)          DEFAULT '0' NOT NULL,
	name varchar(32)        DEFAULT '' NOT NULL,
	mac varchar(20)         DEFAULT '' NOT NULL,
	ipaddr int(16) unsigned DEFAULT '0' NOT NULL,
	passwd varchar(32)      DEFAULT '' NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY nodeid (nodeid)
) ENGINE=InnoDB;

CREATE TABLE ewx_channels (
	id int(11)              NOT NULL auto_increment,
	name varchar(32)        DEFAULT '' NOT NULL,
	upceil int(11)          DEFAULT '0' NOT NULL,
	downceil int(11)        DEFAULT '0' NOT NULL,
	upceil_n int(11)        DEFAULT NULL,
	downceil_n int(11)      DEFAULT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY name (name)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  netdevices
#
CREATE TABLE netdevices (
  id 		int(11) 	NOT NULL auto_increment,
  name 		varchar(32) 	NOT NULL DEFAULT '',
  location 	varchar(255) 	NOT NULL DEFAULT '',
  description 	text 		NOT NULL,
  producer 	varchar(64) 	NOT NULL DEFAULT '',
  model 	varchar(32) 	NOT NULL DEFAULT '',
  serialnumber 	varchar(32) 	NOT NULL DEFAULT '',
  ports 	int(11) 	NOT NULL DEFAULT '0',
  purchasetime 	int(11) 	NOT NULL DEFAULT '0',
  guaranteeperiod tinyint unsigned DEFAULT '0',
  shortname 	varchar(32) 	NOT NULL DEFAULT '',
  nastype 	int(11) 	NOT NULL DEFAULT '0',
  clients 	int(11) 	NOT NULL DEFAULT '0',
  secret 	varchar(60) 	NOT NULL DEFAULT '',
  community 	varchar(50) 	NOT NULL DEFAULT '',
  channelid 	int(11) 	DEFAULT NULL
        REFERENCES ewx_channels (id) ON DELETE SET NULL ON UPDATE CASCADE,
  PRIMARY KEY (id),
  INDEX channelid (channelid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  netlinks
#
CREATE TABLE netlinks (
  id int(11) NOT NULL auto_increment,
  src int(11) NOT NULL DEFAULT '0',
  dst int(11) NOT NULL DEFAULT '0',
  type tinyint(1) NOT NULL DEFAULT '0',
  srcport smallint NOT NULL DEFAULT '0',
  dstport smallint NOT NULL DEFAULT '0',
  PRIMARY KEY  (id),
  UNIQUE KEY src (src,dst)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  networks
#
CREATE TABLE networks (
  id int(11) NOT NULL auto_increment,
  name varchar(128) NOT NULL DEFAULT '',
  address int(16) unsigned NOT NULL DEFAULT '0',
  mask varchar(16) NOT NULL DEFAULT '',
  gateway varchar(16) NOT NULL DEFAULT '',
  interface varchar(16) NOT NULL DEFAULT '',
  dns varchar(16) NOT NULL DEFAULT '',
  dns2 varchar(16) NOT NULL DEFAULT '',
  domain varchar(64) NOT NULL DEFAULT '',
  wins varchar(16) NOT NULL DEFAULT '',
  dhcpstart varchar(16) NOT NULL DEFAULT '',
  dhcpend varchar(16) NOT NULL DEFAULT '',
  disabled tinyint(1) NOT NULL DEFAULT '0',
  notes text NOT NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY name (name),
  UNIQUE KEY address (address)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  nodes
#
CREATE TABLE nodes (
  id int(11) NOT NULL auto_increment,
  name varchar(32) NOT NULL DEFAULT '',
  ipaddr int(16) unsigned NOT NULL DEFAULT '0',
  ipaddr_pub int(16) unsigned NOT NULL DEFAULT '0',
  passwd varchar(32) NOT NULL DEFAULT '',
  ownerid int(11) NOT NULL DEFAULT '0',
  creationdate int(11) NOT NULL DEFAULT '0',
  moddate int(11) NOT NULL DEFAULT '0',
  creatorid int(11) NOT NULL DEFAULT '0',
  modid int(11) NOT NULL DEFAULT '0',
  netdev int(11) NOT NULL DEFAULT '0',
  linktype tinyint(1) NOT NULL DEFAULT '0',
  port smallint NOT NULL DEFAULT '0',
  access tinyint(1) NOT NULL DEFAULT '1',
  warning tinyint(1) NOT NULL DEFAULT '0',
  chkmac tinyint(1) NOT NULL DEFAULT '1',
  halfduplex tinyint(1) NOT NULL DEFAULT '0',
  lastonline int(11) NOT NULL DEFAULT '0',
  info text NOT NULL,
  location_address varchar(255) DEFAULT NULL,
  location_zip varchar(10) 	    DEFAULT NULL,
  location_city varchar(32) 	DEFAULT NULL,
  nas tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name),
  UNIQUE KEY ipaddr (ipaddr),
  INDEX netdev (netdev),
  INDEX ownerid (ownerid),
  INDEX ipaddr_pub (ipaddr_pub)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table macs
#
CREATE TABLE macs (
  id int(11)        NOT NULL auto_increment,
  mac varchar(17)   NOT NULL DEFAULT '',
  nodeid int(11)    NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (nodeid) REFERENCES nodes (id) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE KEY mac (mac, nodeid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table nodegroups
#
CREATE TABLE nodegroups (
        id              int(11)         NOT NULL auto_increment,
	name            varchar(255)    NOT NULL DEFAULT '',
	prio		int(11)		NOT NULL DEFAULT '0',
	description     text            NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY name (name)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table nodegroupassignments
#
CREATE TABLE nodegroupassignments (
        id              int(11)         NOT NULL auto_increment,
        nodegroupid     int(11)         NOT NULL DEFAULT 0,
	nodeid          int(11)         NOT NULL DEFAULT 0,
	PRIMARY KEY (id),
	UNIQUE KEY nodeid (nodeid, nodegroupid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table nodeassignments
#
CREATE TABLE nodeassignments (
    id int(11) NOT NULL auto_increment,
    nodeid int(11) NOT NULL,
    assignmentid int(11) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (nodeid) REFERENCES nodes (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (assignmentid) REFERENCES assignments (id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY nodeid (nodeid, assignmentid),
    INDEX assignmentid (assignmentid)
) ENGINE=InnoDB;


# --------------------------------------------------------
#
# Structure of table  payments
#
CREATE TABLE payments (
  id int(11) NOT NULL auto_increment,
  name varchar(255) NOT NULL DEFAULT '',
  value decimal(9,2) NOT NULL DEFAULT '0.00',
  creditor varchar(255) NOT NULL DEFAULT '',
  period smallint NOT NULL DEFAULT '0',
  at smallint NOT NULL DEFAULT '0',
  description text NOT NULL,
  PRIMARY KEY  (id)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  rtattachments
#
CREATE TABLE rtattachments (
  messageid int(11)     NOT NULL
    ,
  filename varchar(255) NOT NULL DEFAULT '',
  contenttype varchar(255) NOT NULL DEFAULT '',
  INDEX messageid (messageid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  rtmessages
#
CREATE TABLE rtmessages (
  id int(11) NOT NULL auto_increment,
  ticketid int(11) NOT NULL,
  userid int(11) NOT NULL DEFAULT '0',
  customerid int(11) NOT NULL DEFAULT '0',
  mailfrom varchar(255) NOT NULL DEFAULT '',
  subject varchar(255) NOT NULL DEFAULT '',
  messageid varchar(255) NOT NULL DEFAULT '',
  inreplyto int(11) NOT NULL DEFAULT '0',
  replyto text NOT NULL,
  headers text NOT NULL,
  body mediumtext NOT NULL,
  createtime int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY  (id),
  INDEX ticketid (ticketid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  rtnotes
#
CREATE TABLE rtnotes (
	id int(11) 	     NOT NULL auto_increment,
	ticketid int(11)     NOT NULL,
    userid int(11)       NOT NULL,
	body text            NOT NULL,
	createtime int(11)   NOT NULL DEFAULT '0',
	PRIMARY KEY (id),
	INDEX ticketid (ticketid),
	INDEX userid (userid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  rtqueues
#
CREATE TABLE rtqueues (
  id int(11) NOT NULL auto_increment,
  name varchar(255) NOT NULL DEFAULT '',
  email varchar(255) NOT NULL DEFAULT '',
  description text NOT NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  rttickets
#
CREATE TABLE rttickets (
  id int(11) NOT NULL auto_increment,
  queueid int(11) NOT NULL
    REFERENCES rtqueues (id) ON DELETE CASCADE ON UPDATE CASCADE,
  requestor varchar(255) NOT NULL DEFAULT '',
  subject varchar(255) NOT NULL DEFAULT '',
  state tinyint(4) NOT NULL DEFAULT '0',
  cause tinyint(4) NOT NULL DEFAULT '0',
  owner int(11) NOT NULL DEFAULT '0',
  customerid int(11) NOT NULL DEFAULT '0',
  creatorid int(11) NOT NULL DEFAULT '0',
  createtime int(11) NOT NULL DEFAULT '0',
  resolvetime int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY  (id),
  INDEX queueid (queueid),
  INDEX customerid (customerid),
  INDEX creatorid (creatorid),
  INDEX createtime (createtime)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table  rtrights
#
CREATE TABLE rtrights (
    id INT(11) NOT NULL auto_increment, 
    userid INT(11) NOT NULL
        REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    queueid INT(11) NOT NULL
        REFERENCES rtqueues (id) ON DELETE CASCADE ON UPDATE CASCADE,
    rights INT(11) DEFAULT 0 NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY (userid, queueid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table stats
#
CREATE TABLE stats (
  nodeid int(11) NOT NULL DEFAULT '0',
  dt int(11) NOT NULL DEFAULT '0',
  upload BIGINT DEFAULT '0',
  download BIGINT DEFAULT '0',
  UNIQUE KEY nodeid (nodeid,dt),
  INDEX dt (dt)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table tariffs
#
CREATE TABLE tariffs (
  id int(11) 		NOT NULL auto_increment,
  name varchar(255) 	NOT NULL DEFAULT '',
  type tinyint 		NOT NULL DEFAULT '1',
  value decimal(9,2) 	NOT NULL DEFAULT '0.00',
  taxid int(11) 	NOT NULL DEFAULT '0',
  period smallint   DEFAULT NULL,
  prodid varchar(255) 	NOT NULL DEFAULT '',
  uprate int(11) 	NOT NULL DEFAULT '0',
  upceil int(11) 	NOT NULL DEFAULT '0',
  downrate int(11) 	NOT NULL DEFAULT '0',
  downceil int(11) 	NOT NULL DEFAULT '0',
  climit int(11) 	NOT NULL DEFAULT '0',
  plimit int(11) 	NOT NULL DEFAULT '0',
  dlimit int(11) 	NOT NULL DEFAULT '0',
  uprate_n int(11)        	DEFAULT NULL,
  upceil_n int(11)        	DEFAULT NULL,
  downrate_n int(11)      	DEFAULT NULL,
  downceil_n int(11)     	DEFAULT NULL,
  climit_n int(11)      	DEFAULT NULL,
  plimit_n int(11)        	DEFAULT NULL,
  domain_limit int(11)  	DEFAULT NULL,
  alias_limit int(11)		DEFAULT NULL,
  sh_limit int(11)      	DEFAULT NULL,
  www_limit int(11)     	DEFAULT NULL,
  mail_limit int(11)    	DEFAULT NULL,
  ftp_limit int(11)     	DEFAULT NULL,
  sql_limit int(11)     	DEFAULT NULL,
  quota_sh_limit int(11)  	DEFAULT NULL,
  quota_www_limit int(11) 	DEFAULT NULL,
  quota_mail_limit int(11) 	DEFAULT NULL,
  quota_ftp_limit int(11) 	DEFAULT NULL,
  quota_sql_limit int(11) 	DEFAULT NULL,
  description text 	NOT NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY name (name, value, period),
  INDEX type (type)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table promotions
#
CREATE TABLE promotions (
    id int(11)          NOT NULL auto_increment,
    name varchar(255)   NOT NULL,
    description text    DEFAULT NULL,
    disabled tinyint(1) DEFAULT '0' NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY name (name)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table promotionschemas
#
CREATE TABLE promotionschemas (
    id int(11)          NOT NULL auto_increment,
    name varchar(255)   NOT NULL,
    description text    DEFAULT NULL,
    data text           DEFAULT NULL,
    promotionid int(11) DEFAULT NULL
        REFERENCES promotions (id) ON DELETE CASCADE ON UPDATE CASCADE,
    disabled tinyint(1) DEFAULT '0' NOT NULL,
    continuation tinyint(1) DEFAULT NULL,
    ctariffid int(11) DEFAULT NULL
        REFERENCES tariffs (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id),
    UNIQUE KEY promotionid (promotionid, name),
    INDEX ctariffid (ctariffid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table promotionassignments
#
CREATE TABLE promotionassignments (
    id int(11)          NOT NULL auto_increment,
    promotionschemaid int(11) DEFAULT NULL
        REFERENCES promotionschemas (id) ON DELETE CASCADE ON UPDATE CASCADE,
    tariffid int(11)    DEFAULT NULL
        REFERENCES tariffs (id) ON DELETE CASCADE ON UPDATE CASCADE,
    data text           DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY promotionschemaid (promotionschemaid, tariffid),
    INDEX tariffid (tariffid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table liabilities
#
CREATE TABLE liabilities (
    id int(11)              NOT NULL auto_increment,
    value decimal(9,2)      NOT NULL DEFAULT '0',
    name text               NOT NULL,
    taxid int(11)           NOT NULL DEFAULT '0',
    prodid varchar(255)     NOT NULL DEFAULT '',
    PRIMARY KEY (id)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table customergroups
#
CREATE TABLE customergroups (
  id int(11) NOT NULL auto_increment, 
  name varchar(255) NOT NULL DEFAULT '', 
  description text NOT NULL, 
  PRIMARY KEY (id), 
  UNIQUE KEY name (name)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table customerassignments
#
CREATE TABLE customerassignments (
  id int(11) NOT NULL auto_increment, 
  customergroupid int(11) NOT NULL
    REFERENCES customergroups (id) ON DELETE CASCADE ON UPDATE CASCADE,
  customerid int(11) NOT NULL
    REFERENCES customers (id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (id),
  UNIQUE KEY customerassignment (customergroupid, customerid),
  INDEX customerid (customerid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table passwd
#
CREATE TABLE passwd (
    id int(11) NOT NULL auto_increment,
    ownerid int(11) NOT NULL DEFAULT 0,
    login varchar(200) NOT NULL DEFAULT '',
    password varchar(200) NOT NULL DEFAULT '',
    lastlogin int(11) NOT NULL DEFAULT 0,
    uid int(11)	NOT NULL DEFAULT 0,
    home varchar(255) NOT NULL DEFAULT '',
    type smallint NOT NULL DEFAULT 0,
    expdate int(11) NOT NULL DEFAULT 0,
    domainid int(11) NOT NULL DEFAULT 0,
    quota_sh int(11) NOT NULL DEFAULT 0,
    quota_mail int(11) NOT NULL DEFAULT 0,
    quota_www int(11) NOT NULL DEFAULT 0,
    quota_ftp int(11) NOT NULL DEFAULT 0,
    quota_sql int(11) NOT NULL DEFAULT 0,
    realname varchar(255) NOT NULL DEFAULT '',
    createtime int(11) NOT NULL DEFAULT 0,
    mail_forward varchar(255) NOT NULL DEFAULT '',
    mail_bcc varchar(255) NOT NULL DEFAULT '',
    description text NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY (login, domainid),
    INDEX ownerid (ownerid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table domains
#
CREATE TABLE domains (
    id int(11) NOT NULL auto_increment,
    ownerid int(11) NOT NULL DEFAULT 0,
    name varchar(255) NOT NULL DEFAULT '',
    description text NOT NULL,
    master VARCHAR(128) DEFAULT NULL,
    last_check INT(11) DEFAULT NULL,
    type VARCHAR(6) NOT NULL,
    notified_serial INT(11) DEFAULT NULL,
    account VARCHAR(40) DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY (name),
    INDEX ownerid (ownerid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table aliases
#
CREATE TABLE aliases (
    id int(11) NOT NULL auto_increment,
    login varchar(255) NOT NULL DEFAULT '',
    domainid int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (id),
    UNIQUE KEY (login, domainid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table aliasassignments
#
CREATE TABLE aliasassignments (
    id              int(11)         NOT NULL auto_increment,
    aliasid         int(11)         DEFAULT '0' NOT NULL,
    accountid       int(11)         DEFAULT '0' NOT NULL,
    mail_forward    varchar(255)    DEFAULT '' NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY aliasid (aliasid, accountid, mail_forward)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table uiconfig
#
CREATE TABLE uiconfig (
    id int(11) NOT NULL auto_increment,
    section varchar(64) NOT NULL DEFAULT '',
    var varchar(64) NOT NULL DEFAULT '',
    value text NOT NULL,
    description text NOT NULL,
    disabled tinyint(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (id),
    UNIQUE KEY var (section, var)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table events
#
CREATE TABLE events (
    id int(11) NOT NULL auto_increment,
    title varchar(255) NOT NULL DEFAULT '',
    description text NOT NULL,
    note text NOT NULL,
    date int(11) NOT NULL DEFAULT '0',
    begintime smallint(4) NOT NULL DEFAULT '0',
    endtime smallint(4) NOT NULL DEFAULT '0',
    userid int(11) NOT NULL DEFAULT '0',
    customerid int(11) NOT NULL DEFAULT '0',
    private tinyint(1) NOT NULL DEFAULT '0',
    closed tinyint(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (id),
    INDEX date (date)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table eventassignments
#
CREATE TABLE eventassignments (
    eventid int(11) NOT NULL DEFAULT '0',
    userid int(11) NOT NULL DEFAULT '0',
    UNIQUE (eventid, userid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table sessions
#
CREATE TABLE sessions (
    id varchar(50) NOT NULL DEFAULT '', 
    ctime int(11) NOT NULL DEFAULT 0, 
    mtime int(11) NOT NULL DEFAULT 0, 
    atime int(11) NOT NULL DEFAULT 0, 
    vdata text NOT NULL, 
    content text NOT NULL, 
    PRIMARY KEY (id)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table cashsources
#
CREATE TABLE cashsources (
    id      int(11)         NOT NULL auto_increment,
    name	varchar(32)     DEFAULT '' NOT NULL,
    description text		DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY name (name)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table sourcefiles
#
CREATE TABLE sourcefiles (
    id      int(11)         NOT NULL auto_increment,
    userid integer     DEFAULT NULL
        REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
    name	varchar(255)    NOT NULL,
    idate	int(11)	        NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY idate (idate, name),
    INDEX userid (userid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table cashimport
#
CREATE TABLE cashimport (
    id int(11) NOT NULL auto_increment,
    date int(11) NOT NULL DEFAULT '0',
    value decimal(9,2) NOT NULL DEFAULT '0.00',
    customer varchar(150) NOT NULL DEFAULT '',
    description varchar(150) NOT NULL DEFAULT '',
    customerid int(11) DEFAULT NULL
        REFERENCES customers (id) ON DELETE SET NULL ON UPDATE CASCADE,
    hash varchar(50) NOT NULL DEFAULT '',
    closed tinyint(1) NOT NULL DEFAULT '0',
    sourceid int(11) DEFAULT NULL
        REFERENCES cashsources (id) ON DELETE SET NULL ON UPDATE CASCADE,
    sourcefileid int(11) DEFAULT NULL
        REFERENCES sourcefiles (id) ON DELETE SET NULL ON UPDATE CASCADE,
    PRIMARY KEY (id),
    INDEX hash (hash),
    INDEX customerid (customerid),
    INDEX sourceid (sourceid),
    INDEX sourcefileid (sourcefileid)
) ENGINE=InnoDB;


# --------------------------------------------------------
#
# Structure of table hosts
#
CREATE TABLE hosts (
    id int(11) NOT NULL auto_increment,
    name varchar(255) DEFAULT '' NOT NULL,
    description text NOT NULL,
    lastreload int(11) DEFAULT '0' NOT NULL,
    reload tinyint(1) DEFAULT '0' NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY name (name)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table daemoninstances (lmsd configuration)
#
CREATE TABLE daemoninstances (
    id int(11) 			NOT NULL auto_increment,
    name varchar(255) 		DEFAULT '' NOT NULL,
    hostid int(11) 		DEFAULT '0' NOT NULL,
    module varchar(255) 	DEFAULT '' NOT NULL,
    crontab varchar(255) 	DEFAULT '' NOT NULL,
    priority int(11) 		DEFAULT '0' NOT NULL,
    description text 		NOT NULL,
    disabled tinyint(1) 	DEFAULT '0' NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table daemonconfig (lmsd configuration)
#
CREATE TABLE daemonconfig (
    id int(11) 		NOT NULL auto_increment,
    instanceid int(11) 	DEFAULT '0' NOT NULL,
    var varchar(64) 	DEFAULT '' NOT NULL,
    value text 	 NOT NULL,
    description text 	NOT NULL,
    disabled tinyint(1) DEFAULT '0' NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY instanceid (instanceid, var)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table docrights
#
CREATE TABLE docrights (
    id          int(11)         NOT NULL auto_increment,
    userid      int(11)         DEFAULT '0' NOT NULL,
    doctype     int(11)         DEFAULT '0' NOT NULL,
    rights      int(11)         DEFAULT '0' NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY userid (userid, doctype)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table cashrights
#
CREATE TABLE cashrights (
    id int(11)      NOT NULL auto_increment,
    userid int(11)  DEFAULT '0' NOT NULL,
    regid int(11)   DEFAULT '0' NOT NULL,
    rights int(11)  DEFAULT '0' NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY userid (userid, regid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table cashregs
#
CREATE TABLE cashregs (
    id int(11)              NOT NULL auto_increment,
    name varchar(255)       DEFAULT '' NOT NULL,
    description text        NOT NULL,
    in_numberplanid int(11) DEFAULT '0' NOT NULL,
    out_numberplanid int(11) DEFAULT '0' NOT NULL,
    disabled tinyint(1)     DEFAULT '0' NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY name (name)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table cashreglog
#
CREATE TABLE cashreglog (
    id int(11) 			NOT NULL auto_increment,
    regid int(11)          	DEFAULT '0' NOT NULL,
    userid int(11)		DEFAULT '0' NOT NULL,
    time int(11)		DEFAULT '0' NOT NULL,
    value decimal(9,2)      	DEFAULT '0' NOT NULL,
    snapshot decimal(9,2)      	DEFAULT '0' NOT NULL,
    description text		NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY regid (regid, time)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table imessengers
#
CREATE TABLE imessengers (
	id int(11) 		NOT NULL auto_increment,
    customerid int(11) 	NOT NULL
        REFERENCES customers (id) ON DELETE CASCADE ON UPDATE CASCADE,
	uid varchar(32) 	NOT NULL DEFAULT '',
	type tinyint(1) 	NOT NULL DEFAULT '0',
	PRIMARY KEY (id),
	INDEX customerid (customerid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table customercontacts
#
CREATE TABLE customercontacts (
	id 		int(11) 	NOT NULL auto_increment,
    customerid 	int(11) 	NOT NULL
        REFERENCES customers (id) ON DELETE CASCADE ON UPDATE CASCADE,
	name 		varchar(255) 	NOT NULL DEFAULT '',
	phone 		varchar(255) 	NOT NULL DEFAULT '',
	type        smallint        DEFAULT NULL,
	PRIMARY KEY (id),
	INDEX customerid (customerid),
	INDEX phone (phone)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table states
#
CREATE TABLE states (
    	id 		int(11) 	NOT NULL auto_increment,
	name 		varchar(255) 	NOT NULL DEFAULT '',
	description 	text 		NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY name (name)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table countries
#
CREATE TABLE countries (
    	id 		int(11) 	NOT NULL auto_increment,
	name 		varchar(255) 	NOT NULL DEFAULT '',
	PRIMARY KEY (id),
	UNIQUE KEY name (name)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table zipcodes
#
CREATE TABLE zipcodes (
    	id 		int(11) 	NOT NULL auto_increment,
	zip 		varchar(10) 	NOT NULL DEFAULT '',
	stateid 	int(11) 	NOT NULL DEFAULT '0',
	PRIMARY KEY (id),
	UNIQUE KEY zip (zip),
	INDEX stateid (stateid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table divisions
#
CREATE TABLE divisions (
    	id 		int(11) 	NOT NULL auto_increment,
	shortname       varchar(255) 	NOT NULL DEFAULT '',
        name        	text    	NOT NULL,
	address         varchar(255) 	NOT NULL DEFAULT '',
	city            varchar(255) 	NOT NULL DEFAULT '',
	zip             varchar(255) 	NOT NULL DEFAULT '',
	countryid	int(11)		NOT NULL DEFAULT '0',
	ten		varchar(16)	NOT NULL DEFAULT '',
	regon		varchar(255)	NOT NULL DEFAULT '',
	account         varchar(48) 	NOT NULL DEFAULT '',
	inv_header      text    	NOT NULL,
	inv_footer      text    	NOT NULL,
	inv_author      text    	NOT NULL,
	inv_cplace      text    	NOT NULL,
	inv_paytime 	tinyint         DEFAULT NULL,
	inv_paytype 	smallint    DEFAULT NULL,
	description     text    	NOT NULL,
	status 		tinyint(1) 	NOT NULL DEFAULT 0,
	PRIMARY KEY (id),
	UNIQUE KEY shortname (shortname)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table excludedgroups
#
CREATE TABLE excludedgroups (
	id 		int(11) 	NOT NULL auto_increment,
    customergroupid int(11) 	NOT NULL
        REFERENCES customergroups (id) ON DELETE CASCADE ON UPDATE CASCADE,
	userid 		int(11) 	NOT NULL DEFAULT 0,
	PRIMARY KEY (id),
	UNIQUE KEY userid (userid, customergroupid),
	KEY customergroupid (customergroupid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table voipaccounts
#
CREATE TABLE voipaccounts (
	id 		int(11) 	NOT NULL auto_increment,
	ownerid 	int(11) 	NOT NULL DEFAULT 0,
	login		varchar(255)	NOT NULL DEFAULT '',
	passwd		varchar(255)	NOT NULL DEFAULT '',
	phone		varchar(255)	NOT NULL DEFAULT '',
	creationdate	int(11)		NOT NULL DEFAULT 0,
	moddate		int(11)		NOT NULL DEFAULT 0,
	creatorid	int(11)		NOT NULL DEFAULT 0,
	modid		int(11)		NOT NULL DEFAULT 0,
	PRIMARY KEY (id)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table messages
#
CREATE TABLE messages (
        id 	int(11) 	NOT NULL auto_increment,
        subject varchar(255)	DEFAULT '' NOT NULL,
	body 	text		 NOT NULL,
	cdate 	int(11)		DEFAULT '0' NOT NULL,
	type 	smallint	DEFAULT '0' NOT NULL,
	userid 	int(11)		DEFAULT '0' NOT NULL,
	sender 	varchar(255) 	DEFAULT NULL,
        PRIMARY KEY (id),
	INDEX cdate (cdate, type),
	INDEX userid (userid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table messageitems
#
CREATE TABLE messageitems (
        id 		int(11) 	NOT NULL auto_increment,
	messageid 	int(11)		DEFAULT '0' NOT NULL,
	customerid 	int(11) 	DEFAULT '0' NOT NULL,
	destination 	varchar(255) 	DEFAULT '' NOT NULL,
	lastdate 	int(11)		DEFAULT '0' NOT NULL,
	status 		smallint	DEFAULT '0' NOT NULL,
	error 		text		DEFAULT NULL, 
        PRIMARY KEY (id),
	INDEX messageid (messageid),
	INDEX customerid (customerid)
) ENGINE=InnoDB; 

# --------------------------------------------------------
#
# Structure of table nastypes
#
CREATE TABLE nastypes (
    	id 	int(11) 	NOT NULL auto_increment,
	name 	varchar(255) 	NOT NULL DEFAULT '',
	PRIMARY KEY (id),
	UNIQUE KEY name (name)
) ENGINE=InnoDB;

CREATE VIEW nas AS
    SELECT n.id, inet_ntoa(n.ipaddr) AS nasname, d.shortname, d.nastype AS type,
	d.clients AS ports, d.secret, d.community, d.description 
        FROM nodes n 
        JOIN netdevices d ON (n.netdev = d.id) 
        WHERE n.nas = 1;

CREATE VIEW vnodes_mac AS
	SELECT nodeid, GROUP_CONCAT(mac SEPARATOR ',') AS mac
	FROM macs GROUP BY nodeid;

CREATE VIEW vnodes AS
	SELECT n.*, m.mac
	FROM nodes n
    LEFT JOIN vnodes_mac m ON (n.id = m.nodeid);

CREATE VIEW vmacs AS
SELECT n.*, m.mac, m.id AS macid
    FROM nodes n
    JOIN macs m ON (n.id = m.nodeid);

DROP FUNCTION IF EXISTS lms_current_user;
CREATE FUNCTION lms_current_user() RETURNS int(11) NO SQL
RETURN @lms_current_user;

CREATE VIEW customersview AS
	SELECT c.* FROM customers c
	WHERE NOT EXISTS (
	    	SELECT 1 FROM customerassignments a
		JOIN excludedgroups e ON (a.customergroupid = e.customergroupid)
		WHERE e.userid = lms_current_user() AND a.customerid = c.id);

DROP FUNCTION IF EXISTS mask2prefix;
CREATE FUNCTION mask2prefix(mask bigint) RETURNS smallint DETERMINISTIC
RETURN bit_count(mask);

DROP FUNCTION IF EXISTS broadcast;
CREATE FUNCTION broadcast(address bigint, mask bigint) RETURNS bigint DETERMINISTIC
RETURN address + (pow(2, (32-mask2prefix(mask)))-1);

DROP FUNCTION IF EXISTS int2txt;
CREATE FUNCTION int2txt(num bigint) RETURNS char(20) DETERMINISTIC
RETURN CAST(num AS char(20));

# --------------------------------------------------------
#
# Structure of table up_rights (Userpanel)
#
CREATE TABLE up_rights (
    	id int(11) NOT NULL auto_increment,
	module varchar(255) NOT NULL DEFAULT '',
	name varchar(255) NOT NULL DEFAULT '',
	description varchar(255) DEFAULT '',
	setdefault tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (id)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table up_rights_assignments (Userpanel)
#
CREATE TABLE up_rights_assignments (
	id int(11) NOT NULL auto_increment,
	customerid int(11) NOT NULL DEFAULT '0',
	rightid int(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (id),
	UNIQUE KEY up_right_assignment (customerid, rightid)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table up_customers (Userpanel)
#
CREATE TABLE up_customers (
        id int(11) NOT NULL auto_increment,
	customerid int(11) NOT NULL DEFAULT '0',
	lastlogindate int(11) NOT NULL DEFAULT '0',
	lastloginip varchar(16) NOT NULL DEFAULT '',
	failedlogindate int(11) NOT NULL DEFAULT '0',
	failedloginip varchar(16) NOT NULL DEFAULT '',
	enabled int(10) NOT NULL DEFAULT '0',
	PRIMARY KEY (id)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table up_help (Userpanel)
#
CREATE TABLE up_help (
        id int(11) NOT NULL auto_increment,
	reference int(11) NOT NULL DEFAULT '0',
	title varchar(128) NOT NULL DEFAULT '',
	body text NOT NULL,
	PRIMARY KEY id (id)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table up_info_changes (Userpanel)
#
CREATE TABLE up_info_changes (
        id int(11) NOT NULL auto_increment,
	customerid int(11) NOT NULL,
	fieldname varchar(255) NOT NULL DEFAULT '',
	fieldvalue varchar(255) NOT NULL DEFAULT '',
	PRIMARY KEY (id)
) ENGINE=InnoDB;

INSERT INTO uiconfig (section, var, value, description)
	VALUES ('userpanel', 'data_consent_text', '', '');
INSERT INTO uiconfig (section, var, value, description, disabled) 
	VALUES ('userpanel', 'disable_transferform', '0', '', 0);
INSERT INTO uiconfig (section, var, value, description, disabled)
	VALUES ('userpanel', 'disable_invoices', '0', '', 0);
INSERT INTO uiconfig (section, var, value, description, disabled)
	VALUES ('userpanel', 'invoice_duplicate', '0', '', 0);
INSERT INTO uiconfig (section, var, value, description)
	VALUES ('userpanel', 'show_tariffname', '1', '');
INSERT INTO uiconfig (section, var, value, description)
	VALUES ('userpanel', 'show_speeds', '1', '');
INSERT INTO uiconfig (section, var, value, description, disabled)
	VALUES ('userpanel', 'default_queue', '1', '', 0);
INSERT INTO uiconfig (section, var, value, description, disabled)
	VALUES ('userpanel', 'default_userid', '0', '', 0);
INSERT INTO uiconfig (section, var, value, description, disabled)
	VALUES ('userpanel', 'debug_email', '', '', 0);
INSERT INTO uiconfig (section, var, value, description, disabled)
	VALUES ('userpanel', 'lms_url', '', '', 0);
INSERT INTO uiconfig (section, var, value, description, disabled)
	VALUES ('userpanel', 'hide_nodesbox', '0', '', 0);
INSERT INTO uiconfig (section, var, value, description, disabled)
	VALUES ('userpanel', 'logout_url', '', '', 0);
INSERT INTO uiconfig (section, var, value, description, disabled)
	VALUES ('userpanel', 'owner_stats', '0', '', 0);
INSERT INTO up_rights(module, name, description)
	VALUES ('info', 'edit_addr_ack', 'Customer can change address information with admin acknowlegment');
INSERT INTO up_rights(module, name, description)
        VALUES ('info', 'edit_addr', 'Customer can change address information');
INSERT INTO up_rights(module, name, description, setdefault)
        VALUES ('info', 'edit_contact_ack', 'Customer can change contact information with admin acknowlegment', 0);
INSERT INTO up_rights(module, name, description)
        VALUES ('info', 'edit_contact', 'Customer can change contact information');

INSERT INTO countries (name) VALUES ('Lithuania');
INSERT INTO countries (name) VALUES ('Poland');
INSERT INTO countries (name) VALUES ('Romania');
INSERT INTO countries (name) VALUES ('Slovakia');
INSERT INTO countries (name) VALUES ('USA');

INSERT INTO nastypes (name) VALUES ('mikrotik_snmp');
INSERT INTO nastypes (name) VALUES ('cisco');
INSERT INTO nastypes (name) VALUES ('computone');
INSERT INTO nastypes (name) VALUES ('livingston');
INSERT INTO nastypes (name) VALUES ('max40xx');
INSERT INTO nastypes (name) VALUES ('multitech');
INSERT INTO nastypes (name) VALUES ('netserver');
INSERT INTO nastypes (name) VALUES ('pathras');
INSERT INTO nastypes (name) VALUES ('patton');
INSERT INTO nastypes (name) VALUES ('portslave');
INSERT INTO nastypes (name) VALUES ('tc');
INSERT INTO nastypes (name) VALUES ('usrhiper');
INSERT INTO nastypes (name) VALUES ('other');

# --------------------------------------------------------
#
# Structure of table records
#
CREATE TABLE records (
  id              INT(11) auto_increment,
  domain_id       INT(11) DEFAULT NULL,
  name            VARCHAR(255) DEFAULT NULL,
  type            VARCHAR(6) DEFAULT NULL,
  content         VARCHAR(255) DEFAULT NULL,
  ttl             INT(11) DEFAULT NULL,
  prio            INT(11) DEFAULT NULL,
  change_date     INT(11) DEFAULT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (domain_id) REFERENCES domains (id) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX domain_id (domain_id),
  INDEX name_type (name, type, domain_id)
) ENGINE=InnoDB;

# --------------------------------------------------------
#
# Structure of table supermasters
#
CREATE TABLE supermasters (
  id            INT(11) auto_increment,
  ip            VARCHAR(25) NOT NULL,
  nameserver    VARCHAR(255) NOT NULL,
  account       VARCHAR(40) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;


# --------------------------------------------------------
INSERT INTO dbinfo (keytype, keyvalue) VALUES ('dbversion', '2011031000');
