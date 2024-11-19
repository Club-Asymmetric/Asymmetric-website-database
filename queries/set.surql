DEFINE TABLE photo SCHEMAFULL;
DEFINE FIELD binary ON photo TYPE bytes;
DEFINE FIELD mime ON photo TYPE string ASSERT $value INSIDE [
	'apng',
	'avif',
	'gif',
	'jpeg',
	'png',
	'svg+xml',
	'webp'
];

DEFINE TABLE event SCHEMAFULL;
DEFINE FIELD name ON event TYPE string;
DEFINE FIELD participants ON event TYPE int;
DEFINE FIELD date ON event TYPE datetime VALUE $value.group('day');
DEFINE FIELD location ON event TYPE string;
DEFINE FIELD registration_start ON event TYPE datetime VALUE $value.group('day');
DEFINE FIELD min_team_size ON event TYPE int ASSERT $value > 0;
DEFINE FIELD max_team_size ON event TYPE int ASSERT $value > 0;
DEFINE FIELD photos ON event TYPE array<record<photo>>;
DEFINE FIELD description ON event TYPE string;

DEFINE TABLE registration TYPE NORMAL SCHEMAFULL;
DEFINE FIELD name ON registration TYPE string;
DEFINE FIELD team ON registration TYPE option<string>;
DEFINE FIELD members ON registration TYPE array<string>
    ASSERT $value.len() >= $this.event.min_team_size AND $value.len() <= $this.event.max_team_size;
DEFINE FIELD year ON registration TYPE int ASSERT $value>0;
DEFINE FIELD department ON registration TYPE string;
DEFINE FIELD college ON registration TYPE string;
DEFINE FIELD email ON registration TYPE string ASSERT $value.is_email();
DEFINE FIELD number ON registration TYPE string;
DEFINE FIELD hash ON registration TYPE string;
DEFINE FIELD event ON registration TYPE record<event>;
DEFINE INDEX emails ON registration FIELDS email UNIQUE;
DEFINE INDEX numbers ON registration FIELDS number UNIQUE;

DEFINE TABLE podcast TYPE NORMAL SCHEMAFULL;
DEFINE FIELD name ON podcast TYPE string;
DEFINE FIELD publish ON podcast TYPE bool;
DEFINE FIELD guests ON podcast TYPE array<string> ASSERT $value.len() > 0;
DEFINE FIELD description ON podcast TYPE string;
DEFINE FIELD image ON podcast TYPE record<photo>;
DEFINE FIELD mime ON podcast TYPE string ASSERT $value INSIDE [
	'aac',
	'midi',
	'mpeg',
	'ogg',
	'opus',
	'wav',
	'webm'
];

DEFINE TABLE member TYPE NORMAL SCHEMAFULL;
DEFINE FIELD role ON member TYPE string;
DEFINE FIELD name ON member TYPE string;
DEFINE FIELD photos ON member TYPE array<record<photo>>;
DEFINE FIELD description ON member TYPE string;
DEFINE FIELD portfolio ON member TYPE string;