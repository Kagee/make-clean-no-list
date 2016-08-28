create table potential_domains (
    id             serial      primary key,
    first_inserted timestamp   not null default now(),
    last_checked   timestamp   default null,
    name           text        not null unique, -- sol.no, www.xn--troms-zua.no
    source         text        not null
);

CREATE INDEX potential_domains_last_checked ON potential_domains (last_checked);

create table found (
    id          serial      primary key,
    domain_id   int         not null references potential_domains(id),
    found       timestamp   not null default now(),
    querytype   text        not null, -- NS, A, WWWA
    record      text        not null -- sol.no, www.xn--troms-zua.no
);

create table servfails (
    id          serial      primary key,
    domain_id   int         not null references domains(id),
    timestamp   timestamp   not null default now()
);

create table dns_timeouts (
    id          serial      primary key,
    domain_id   int         not null references domains(id),
    timestamp   timestamp   not null default now()
);
