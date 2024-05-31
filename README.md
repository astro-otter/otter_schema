---
author:
- Kate Alexander
- Noah Franz
- Suvi Gezari
- Sebastian Gomez
- Mitchell Karmen
- V. Ashley Villar
bibliography:
- references.bib
title: The OTTER Catalog
---

# Schema {#sec:schema}

This document outlines the schema that the OTTER will use for the
`json` files that contain all the relevant information for transients in
the catalog. An Entity Relationship (ER) diagram of this schema is also
available at
<https://dbdiagram.io/d/The-New-OSC-Schema-65249d45ffbf5169f05afd19>.
The GitHub organization that contains the database, schema, and frontend
is available at <https://github.com/astro-otter>.

## Definitions {#sec:definitions}

The data for each transient object will be stored in individual
`json` files with a uniform structure, where the name of each file will
be the same as the name of the transient object. Here, we describe the
schema for the database, as well as the different types of data that can
be stored in the `json` files.

-   **object**: each astronomical transient object (TDE, SN, FRB, etc.)
    is referred to as an "object\". The default will be the IAU name of
    the object, followed by the shortest name alias.

-   **[property]{style="color: cyan"}**: An overarching property of the
    object can be anything from "photometry\", a "date\", a
    "classification\", a "host\", etc. Can contain elements or
    subproperties.

-   **[subproperty]{style="color: olive"}**: any additional property
    within a property, useful when a large number of elements will share
    an additional keyword.

-   **[keyword]{style="color: magenta"}**: the name of an item within a
    category, property, subproperty, or element in the `json`
    dictionary. These keywords are dependent on the
    [property]{style="color: cyan"} or
    [subproperty]{style="color: olive"} that they belong to. Some
    commonly used examples are:

    1.  value (§[1.3.1](#subsec:value){reference-type="ref"
        reference="subsec:value"}): the value of the element (e.g.
        "17.2\" for a magnitude).

    2.  reference (§[1.3.2](#subsec:reference){reference-type="ref"
        reference="subsec:reference"}): the origin of the element, such
        as a paper, broker, catalog, etc.

    3.  units (§[1.3.3](#subsec:units){reference-type="ref"
        reference="subsec:units"}): units of the value written in
        astropy format (e.g. `"km / s"`)

    4.  type (§[1.3.4](#subsec:type){reference-type="ref"
        reference="subsec:type"}): string, float, bool, etc.

    5.  flag (§[1.3.5](#subsec:flag){reference-type="ref"
        reference="subsec:flag"}): integer to reference known flags.

    6.  computed (§[1.3.6](#subsec:computed){reference-type="ref"
        reference="subsec:computed"}): a Boolean that specifies whether
        the value of the element was computed by the database (True), as
        opposed to an external reference (False). If not present it is
        assumed to be False.

    7.  uui (§[1.3.7](#subsec:uui){reference-type="ref"
        reference="subsec:uui"}): universally unique identifier (UUI)
        for the element to be referenced elsewhere.

    8.  default (§[1.3.8](#subsec:default){reference-type="ref"
        reference="subsec:default"}): a Boolean used for when there are
        multiple entries of the element.

## Best practices {#sec:practices}

-   Use `snake_case` for naming variables, a naming convention where
    each word is in lower case and is separated by underscores.

-   Use prefixes when properties or elements should be categorized
    together.

-   Refrain from using plurals or capital letters when naming variables.

-   Refrain from using keywords already used in the schema as names of
    properties or elements.

-   keywords formatted as strings will have empty strings for missing
    data.

-   keywords formatted as floats will have `NaN` for missing data.

-   keywords formatted as Boolean will have `null` for missing data.

## Common Keywords {#sec:elements}

Here we provide a more detailed description and how to handle each of
the optional keywords in an element, introduced in
§[1.1](#sec:definitions){reference-type="ref"
reference="sec:definitions"}.

### [value]{style="color: magenta"} {#subsec:value}

The most critical keyword in the database, which stores the value of any
element, be that a parameter, measurement, or anything else. Can be a
string, float, integer, or Boolean.

### [reference]{style="color: magenta"} {#subsec:reference}

The reference source for the value in the element. Whenever possible,
the reference should be specified in the format for this is a
19-character ADS Bibcode (e.g. `2019ApJ...871..102N`). In the event that
a Bibcode is not available, a string or common source can also be input
here (e.g. "Smith et al.\", "SOUSA\", "WISeREP\"). If `computed = True`,
the value of this keyword can be set to the uui of the original element
used to compute the value, or multiple values (e.g. magnitude and
redshift). In the json file, these can be either a string or a list of
strings (in case there are multiple references for one value). A
complete list of acceptable references is below:

1.  An ADS bibcode

2.  A uui corresponding to another item in the `json` file.

3.  "TNS\"

4.  "Pan-STARRS\"

5.  "GaiaAlerts\"

6.  "ATLAS\"

7.  "ZTF\"

8.  "ASAS-SN\"

9.  "WISeREP\"

10. "SOUSA\"

### [units]{style="color: magenta"} {#subsec:units}

The units of the value. These should be formatted in astropy units
format. For a description of this method [see the Astropy
documentation](https://docs.astropy.org/en/stable/units/format.html#converting-from-strings).
For a full list of acceptable units [see the list from
Astropy](https://docs.astropy.org/en/stable/units/#module-astropy.units.si).
Examples might include things like `"km /s"`, `"AB"` (for AB
magnitudes), or `"erg / ( s cm2 Hz)"`.

### [type]{style="color: magenta"} {#subsec:type}

The python data type of the value, can be one of `str`, `float`, `int`,
or `bool`.

### [flag]{style="color: magenta"} {#subsec:flag}

For situations that are too nuanced or rare to store in their own
keywords, there is the option to store this information in the form of a
flag. This can be an integer value for a flag associated with the value
or element, or a comma separated list of flags. For a list of flags and
their definitions see §[1.4](#sec:flags){reference-type="ref"
reference="sec:flags"}.

### [computed]{style="color: magenta"} {#subsec:computed}

A Boolean that defines whether the value is original from a reference
(False), or if the value was computed using the database (True). The
version of the database used to compute the values with
`computed == True` is stored in the `version` element of the metadata.

### [uui]{style="color: magenta"} {#subsec:uui}

A universally unique identifier (UUI) used to cross-reference different
elements with each other. These can be created with the `uuid` Python
package and look like this: `c2ee78a2-acc0-4c01-b878-543130587e9a`.

### [default]{style="color: magenta"} {#subsec:default}

A Boolean value used in the event there are multiple competing entries
for an important property such as the name of a transient, distance, or
coordinates. There can only be one element with `default == True` for
each element in a property.

### [comment]{style="color: magenta"} {#subsec:comment}

An optional simple string with a comment pertaining to the individual
element.

## Flags {#sec:flags}

There might be some situations that are relatively common, but either
too complex to store as a keyword in an element, too long, or not
necessary. In that case, there is the option to specify a flag.
Additional flags can be added without having to re-define the entire
schema. Here we provide the full list of flags and their definition.
Multiple flags should be comma separated.

-   0 : No flags associated with the element.

-   1 : Reference for this value exists but is not a published source
    (ie. just someone submitting a value without publishing it first)

-   2 : Reference of the value is not known.

-   3 : A raccoon reduced the data, so you shouldn't trust this.

## Required Keywords {#sec:required}

This is a list of the required keywords for each type of data. Any other
keywords listed in this can be assumed to be optional.

### Objects {#subsec:object_requirements}

At a minimum, each object is required to have the
[name]{style="color: magenta"}, [coordinate]{style="color: magenta"},
and [reference_alias]{style="color: magenta"} keywords. We require a
reference for everything to ensure a high quality of data.

### Properties {#subsec:param_requirements}

The required values for all properties are:

-   [name]{style="color: cyan"}: Default name of the object. This is
    always required.

-   [coordinate]{style="color: cyan"}:
    [equitorial]{style="color: magenta"} is always required with a
    [reference]{style="color: magenta"}.
    [galactic]{style="color: magenta"} and
    [ecliptic]{style="color: magenta"} are optional but must contain a
    [reference]{style="color: magenta"}.

-   [distance]{style="color: cyan"}: Nothing required, ideally
    [redshift]{style="color: magenta"} will be provided. If one is
    provided, a [reference]{style="color: magenta"} is required!

-   [epoch]{style="color: cyan"}: Nothing required, will be derived from
    photometry if provided. If one is provided, a
    [reference]{style="color: magenta"} is required!

-   [classification]{style="color: cyan"}: Nothing required, TNS will be
    queried. If provided, a [reference]{style="color: magenta"} is
    required!

### Measurements {#subsec:measurement_requirements}

Each photometry point must have at least the following:

-   [reference]{style="color: magenta"}

-   [raw]{style="color: magenta"}

-   [filter]{style="color: magenta"}

-   [raw_units]{style="color: magenta"}

Additionally, if any corrections were applied the values *must* be
supplied as well! Similarly, if the magnitude is only an upper limit
please set `upperlimit=True`.

[FILL IN OTHER MEASUREMENTS LATER]{style="color: red"}

# Properties {#sec:parameter}

## [name]{style="color: cyan"} {#sec:name}

The name information of the object.

### [default_name]{style="color: magenta"} {#sec:default_name}

The default name of the object. If available, this will be the IAU name
without any prefixed (e.g. "2019qiz\"). If the object does not have an
IAU name, the shortest alias will be adopted as the default name.

### [alias]{style="color: olive"} {#sec:alias}

All known names and aliases of the object are stored in this list, the
default name will be selected from this list and stored in the
[name]{style="color: magenta"} keyword.

    [
        style=json,
        label=lst:example-json]
    "name": "2019qiz",
    "alias": [{
              "value": "AT2019qiz",
              "reference": "TNS"
              },
              {
              "value": "Melisandre",
              "reference": "2021ApJ...908....4V"
              },
              {
              "value": "ZTF19abzrhgq",
              "reference": "ZTF"
              }]

## [coordinate]{style="color: cyan"} {#sec:coordinate}

List that contains the coordinates of the object in the same format as
the original reference. The default will be equatorial coordinates in
degrees, this is the value that will be read by the pipeline, or
computed if not available. There is the option to have multiple element
entries, if for example there are different coordinates from different
observatories. The default coordinates used for calculations will be
identified with the keyword `default = True`. This is different (but can
be derived from) the optional coordinates values stored in for example,
individual photometry measurements.

The type of coordinate is stored in the
[coord_type]{style="color: magenta"} element and can be equatorial,
galactic, or ecliptic. Examples of how an object's coordinates and
associated keywords can be stored are shown below. The simplest
coordinate example with RA and DEC in degrees, and an associated
reference:

    [
        style=json,
        label=lst:example-json]
    {
      "ra": 32.12178,
      "dec": 45.21694,
      "epoch": "J2000",
      "frame": "ICRS",
      "coord_type": "equatorial",
      "ra_units":"deg",
      "dec_units":"deg",
      "reference": "2019ApJ...871..102N",
    }

A more complex example with equatorial coordinates in hour angle, and
computed galactic coordinates. In this case the set of coordinates with
a reference is used as opposed to the one without a reference. Then the
galactic coordinates are calculated based on the `default = True` value,
and the `uui` associated is added.

    [
        style=json,
        label=lst:example-json]
    "coordinate": [
        {
        "ra": "04:46:37.880",
        "dec": "-10:13:34.90",
        "ra_units": "hourangle",
        "dec_units": "deg",
        "coord_type": "equatorial",
        "reference": "TNS",
        "computed": false,
        "uui": "c2ee78a2-acc0-4c01-b878-543130587e9a",
        "default": true
        },
        {
        "ra": "04:46:37.77867",
        "dec": "-10:13:34.6800",
        "ra_units": "hourangle",
        "dec_units": "deg",
        "coord_type": "equatorial",
        "reference": "Fake",
        "flag": "2,3"
        },
        {
        "l": 207.876557,
        "b": -32.322864,
        "l_units": "deg",
        "b_units": "deg",
        "coord_type": "galactic",
        "computed": true,
        "reference": "c2ee78a2-acc0-4c01-b878-543130587e9a"
        }]

The keywords that can be used within a coordinate element are:

-   [ra]{style="color: magenta"}: right ascension (str, int, float)

-   [dec]{style="color: magenta"}: declination (str, int, float)

-   [l]{style="color: magenta"}: galactic longitude (str, int, float)

-   [b]{style="color: magenta"}: galactic latitude (str, int, float)

-   [lon]{style="color: magenta"}: longitude (str, int, float)

-   [lat]{style="color: magenta"}: latitude (str, int, float)

-   [\_units]{style="color: magenta"}: suffix added to any of
    [ra]{style="color: magenta"}, [dec]{style="color: magenta"},
    [l]{style="color: magenta"}, [b]{style="color: magenta"},
    [lon]{style="color: magenta"}, [lat]{style="color: magenta"} to
    specify the units of the coordinate.

-   [\_error]{style="color: magenta"}: suffix added to any of
    [ra]{style="color: magenta"}, [dec]{style="color: magenta"},
    [l]{style="color: magenta"}, [b]{style="color: magenta"},
    [lon]{style="color: magenta"}, [lat]{style="color: magenta"} to
    specify the uncertaintiy in the coordinate.

-   [epoch]{style="color: magenta"}: epoch (e.g. J2000, B1950)

-   [frame]{style="color: magenta"}: coordinate frame (e.g., ICRS, FK5)

-   [default]{style="color: magenta"}: Boolean. If multiple entries, use
    this value as the default (True)

Each element in the [coordinate]{style="color: cyan"} property can only
have one pair of coordinates in the same frame, but multiple elements
can be added.

## [distance]{style="color: cyan"} {#sec:distance}

This property stores different values realted to the distance to an
object and can be anything like a redshift, dispersion measure,
luminosity distance, etc. These can be computed or measured, some
examples listed below:

    [
        style=json,
        label=lst:example-json]
        "distance": [
            {
                "value": 1.1 ,
                "reference": "2019ApJ...871..102N" ,
                "computed": False,
                "default": True,
                "uuid": "c2ee78a2-acc0-4c01-b878-543130587e9b",
                "distance_type": "redshift"
            },
            {
                "value": 0.9 ,
                "error": 0.1
                "reference": "2019ApJ...871..102N" ,
                "computed": False,
                "distance_type": "redshift"
            },
            {
                "value": 1 ,
                "unit": " pc " ,
                "cosmology": "Planck18",
                "reference": "c2ee78a2-acc0-4c01-b878-543130587e9b",
                "computed": True
                "distance_type": "luminosity"
            },
            {
                "value": 0.1,
                "reference": "2019ApJ...871..102N",
                "computed": False,
                "distance_type": "dispersion_measure"
            }]

Where the keys can be the following.

-   [value]{style="color: magenta"}: The luminosity distance (float)

-   [unit]{style="color: magenta"}: The units on the luminosity distance
    (str, astropy units)

-   [error]{style="color: magenta"}: The error on the luminosity
    distance (float, optional)

-   [reference]{style="color: magenta"}: The reference alias (integer)

-   [cosmology]{style="color: magenta"}: Which cosmology was used to
    calculate the distance (str).

-   [computed]{style="color: magenta"}: True if the value was computed,
    False otherwise (boolean)

-   [distance_type]{style="color: magenta"}: The type of distance
    measure. Can be \"redshift\", \"luminosity\",
    \"dispersion_measure\", etc.

## [date_reference]{style="color: cyan"} {#sec:date_reference}

These are mostly computed, even if it is something very simple like
"first data point\". But if it is an explosion time determined from a
complex model in a paper, that is not computed and a reference can be
added. If a value is computed, the reference should be a uuid pointing
to another epoch that it was computed from. Example:

    [
        style=json,
        label=lst:example-json]
        "date_reference": [
        {
            "value": 56123.2 ,
            "date_format": "MJD",
            "date_type": "explosion",
            "reference":  "c2ee78a2-acc0-4c02-b878-543130587e9b",
            "computed": True
        },
        {
            "value": 56356.5,
            "date_format": "MJD"
            "reference": "c2ee78a2-acc0-4c02-b878-543130587e9b",
            "computed": True,
            "date_type": "peak"
        },
        {
            "value": "10/19/2023 14:36:43",
            "date_format": "MM/DD/YYYY HH:MM:SS",
            "reference": "2019ApJ...871..102N" ,
            "computed": False,
            "date_type": "discovery"
            "uuid": "c2ee78a2-acc0-4c02-b878-543130587e9b"
        },
        {
            "value": "123456",
            "date_format": "MJD",
            "reference": "c2ee78a2-acc0-4c02-b878-543130587e9b",
            "computed": True,
            "date_type": "discovery"
        }
        ]

Each element can have the following keys:

-   [value]{style="color: magenta"}: The date of discovery

-   [date_format]{style="color: magenta"}: The format of the date

-   [date_type]{style="color: magenta"}: The type of date this is.
    Examples are "explosion\", "peak\", "discovery\".

-   [reference]{style="color: magenta"}: The alias for the reference

-   [computed]{style="color: magenta"}: If it was computed (bool)

## [classification]{style="color: cyan"} {#sec:classification}

The elements in the classification property have no names, they are
simply entries in the classification property. In addition to the
keywords available in §[1.3](#sec:elements){reference-type="ref"
reference="sec:elements"}, classification elements can have:
[object_class]{style="color: magenta"},
[confidence]{style="color: magenta"}, and
[class_type]{style="color: magenta"} keywords. An object can have
multiple classifications.

**Class type can be a bibcode for the ad-hoc paper (e.g. TDE H+He**

-   [object_class]{style="color: magenta"}: the common object classes
    (e.g. SN, TDE, SN Ia, FRB, etc.)

-   [confidence]{style="color: magenta"}: value between 0 and 1 with the
    confidence or probability of the given object class.

-   [class_type]{style="color: magenta"}: is the classification
    photometric, spectroscopic, or machine learning predicted?

<!-- -->

    [
        style=json,
        label=lst:example-json]
    "classification": [
      {
        "object_class": "SN Ia",
        "confidence": 1.0,
        "class_type": "spectroscopic",
        "reference": "2018MNRAS.476..261B",
        "default": True
      },
      {
        "object_class": "SN",
        "confidence": 0.2,
        "class_type": "spectroscopic",
        "reference": "TNS",
        "default": False
      },
      {
        "object_class": "SN Ia",
        "confidence": 0.98,
        "class_type": "predicted",
        "reference": "2017ApJ...476...61C",
        "default": False
      }
    ]

Measurements are any values that were obtained from a real telescope, be
that photometry, spectroscopy, polarization measurements, neutrinos,
X-ray data, etc. There is no separate property for astrometry, as it is
assumed any astrometric measurement will have an associated flux, and
can added to the photometry property.

## [photometry]{style="color: cyan"} {#sec:photometry}

The photometry property will store all UV, optical, and IR photometry.
This is what will likely be the most extensive element of the catalog.
For some objects photometric measurements will have many repeated
keywords such as photometric system, telescope, or whether or not they
have some correction applied.

Groups of related photometry can be stored in individual arrays like in
the example shown below.

    [
        style=json,
        label=lst:example-json]
    "photometry": [
      {
        "telescope": "ZTF",
        "mag_system": "AB",
        "reference": "2019ApJ...871..102N",
        "flux": [5.0, 5.0, 5.0, 5.0],
        "filter": ['r', 'r', 'r', 'r']
      },
      {
        "telescope": "ASAS-SN",
        "mag_system": "Vega",
        "reference": "2018MNRAS.476..261B",
        "raw": [5.0, 5.0, 5.0],
        "raw_err": [1.0, 1.0, 1.0]
      },
      {
        "filter": "Clear",
        "raw": [1]
      }
    ]

The full list of possible keywords that can be associated with a
photometric measurement are the same for the phot_N subproperty or the
magnitude element, they are all listed in the following section
(§[\[sec:flux\]](#sec:flux){reference-type="ref" reference="sec:flux"}).

A measured magnitude is the most common element in the database, these
can have a number of associated keywords. Each magnitude element can
only have one flux-associated value (i.e. a magnitude element cannot
have an AB magnitude and a flux). In addition to the default keywords
listed for every element in §[1.3](#sec:elements){reference-type="ref"
reference="sec:elements"}, the keywords that can be associated with a
magnitude element are:

-   [raw]{style="color: magenta"} : raw flux value, can be magnitude
    (for optical, infrared, or UV), energy (for X-ray), or flux density
    (for radio). This should be the closest available value to that
    measured by the telescope, without corrections, usually as published
    in a paper.

-   [raw_err]{style="color: magenta"} : error of raw flux value.

-   [raw_units]{style="color: magenta"}: astropy units of the raw flux
    value.

-   [value]{style="color: magenta"} : flux with corrections applied, can
    be a magnitude, energy, counts or flux density. If counts provided,
    must provide [telescope_area]{style="color: magenta"}.

-   [value_err]{style="color: magenta"}: error on the corrected flux
    value.

-   [value_units]{style="color: magenta"}: units of the corrected flux
    value, can be astropy units or magnitude system.

-   [epoch_zeropoint]{style="color: magenta"} : if date is epoch, what
    is the offset.

-   [epoch_redshift]{style="color: magenta"} : if date is epoch, what is
    the redshift.

-   [filter]{style="color: magenta"} : name of telescope filter.

-   [filter_key]{style="color: magenta"} : Name of filter in the format
    described in the metadata
    (§[3.2](#sec:filter_alias){reference-type="ref"
    reference="sec:filter_alias"})

-   [obs_type]{style="color: magenta"} : The type of observation made.
    Can be ("UVOIR\", "xray\", or "radio\")

-   [telescope_area]{style="color: magenta"}: collecting area of the
    telescope. This must be provided if [flux
    \_units]{style="color: magenta"} is "counts\"

-   [date]{style="color: magenta"} : time of measurement.

-   [date_format]{style="color: magenta"} : format on the of measurement
    (e.g. MJD, JD, etc).

-   [date_err]{style="color: magenta"} : uncertainty in the date value.

-   [ignore]{style="color: magenta"} : was the data ignored.

-   [upperlimit]{style="color: magenta"} : Boolean, is the mag an upper
    limit?

-   [sigma]{style="color: magenta"} : significance of upper limit.

-   [sky]{style="color: magenta"} : sky brightness in the same units as
    mag.

-   [telescope]{style="color: magenta"} : telescope that took the data.

-   [instrument]{style="color: magenta"} : instrument on telescope that
    took the data.

-   [phot_type]{style="color: magenta"} : is the photometry PSF,
    Aperture, or synthetic.

-   [exptime]{style="color: magenta"} : Exposure time.

-   [aperture]{style="color: magenta"} : If aperture photometry,
    aperture diameter in arcseconds.

-   [observer]{style="color: magenta"} : Person or group that observed
    the data.

-   [reducer]{style="color: magenta"} : Person who reduced the data.

-   [pipeline]{style="color: magenta"} : Pipeline used to reduce the
    data.

-   [corr_k]{style="color: magenta"} : Boolean. Is the raw value
    k-corrected? Can be None which means that we are uncertain if it is
    k-corrected.

-   [corr_s]{style="color: magenta"} : Boolean. Is the raw value
    s-corrected? Can be None which means that we are uncertain if it is
    s-corrected.

-   [corr_av]{style="color: magenta"} : Boolean. Is the raw value Milky
    Way extinction corrected? Can be None which means that we are
    uncertain if it is av-corrected.

-   [corr_host]{style="color: magenta"} : Boolean. Is the raw value host
    subtracted? Can be None which means that we are uncertain if it is
    host subtracted.

-   [corr_hostav]{style="color: magenta"} : Boolean. Is the raw value
    corrected for intrinsic host extinction? Can be None which means
    that we are uncertain if it is host extinction corrected.

-   [val_k]{style="color: magenta"} : Float. Value of the k-correction
    applied to mag.

-   [val_s]{style="color: magenta"} : Float. Value of the s-corrected
    applied to mag.

-   [val_av]{style="color: magenta"} : Float. Value of the Milky Way
    extinction correction applied to mag.

-   [val_host]{style="color: magenta"} : Float. Value of the host
    contribution applied to mag.

-   [val_hostav]{style="color: magenta"} : Float. Value of the intrinsic
    host extinction applied to mag.

**Save z_phase and t0_phase for a phase time**

Clearly most magnitude measurements will not have all of these
parameters available, but the user has the option to include up to all
of these, in addition to the filter-specific keywords listed in
§[3.2](#sec:filter_alias){reference-type="ref"
reference="sec:filter_alias"}. Although it is recommended to store the
filter-specific keywords in the metadata to avoid repetition. The `mag`
and `raw` keywords do not necessarily have to contain magnitudes, they
can contain flux values. This is acceptable as long as it is specified
in the units field.

In the case of the magnitude element, the computed keyword does not
apply. In this case `raw` is always assumed to be not computed, and
`mag` is always assumed to be computed, where the computation can be as
simple as applying a total correction of 0 mags.

## [host]{style="color: cyan"} {#sec:host}

Information about the host galaxy where the object is located.

-   [host_ra]{style="color: magenta"}: The Right Ascension of the host
    galaxy

-   [host_dec]{style="color: magenta"}: the Declination of the host
    galaxy

-   [host_z]{style="color: magenta"}: Redshift of the host galaxy

-   [host_type]{style="color: magenta"}: The classification of the host
    (ex. spiral, elliptical, dwarf, AGN, etc.)

-   [host_name]{style="color: magenta"}: The name of the host galaxy

-   [reference]{style="color: magenta"}: The reference for this host
    information

# metadata {#sec:metadata}

Metadata is information that does not necessarily fit into any of the
existing categories, but is instead used to support the database
structure. Some examples of metadata are listed in this section.

## [reference_details]{style="color: cyan"} {#sec:reference_details}

We plan to store the 19 digit ADS bibcode for every reference for ease
of analysis. This will store a mapping between those bibcodes and human
readable names for easy visualization.

    [
        style=json,
        label=lst:example-json]
    "reference_alias": [
      {
        "name": "2019ApJ...871..102N",
        "human_readable_name": "somename et al. (2019)"
      },
      {
        "name": "2020ApJ...874...22N",
        "human_readable_name": "aname et al. (2020)"
      },
    ]

The two keywords used in this element are [name]{style="color: magenta"}
and [human_readable_name]{style="color: magenta"}, which store the name
of the reference and the corresponding alias integer, respectively.

## [filter_alias]{style="color: cyan"} {#sec:filter_alias}

The basic information about a filter can be stored in the metadata of
the `json` file for quick reference, without needing to add it to each
individual photometry measurement.

    [
        style=json,
        label=lst:example-json]
    "filter_alias": [
      {
        "filter_key": "PAN-STARRS_PS1.r",
        "wave_eff": 6155.47,
        "wave_min": 5391.11,
        "wave_max": 7038.08,
        "zp": 3173.02,
        "wave_units": "AA",
        "zp_units": "Jy",
        "zp_system": "Vega",
      }
    ]

Individual measurements can just reference the `filter_key` instead of
storing this repeated information in each element. The keywords
supported in the `filter_reference` element are:

-   [filter_key]{style="color: magenta"}: keyword shared between
    observations and this reference. The format is adopted from the SVO,
    but replacing the slash `/` with an underscore `_` character.

-   [wave_eff]{style="color: magenta"}: effective wavelength of filter.

-   [wave_min]{style="color: magenta"}: minimum wavelength of filter.

-   [wave_max]{style="color: magenta"}: maximum wavelength of filter.

-   [freq_eff]{style="color: magenta"}: effective frequency of the
    filters (for radio!).

-   [freq_min]{style="color: magenta"}: minimum frequency of the filters
    (for radio!).

-   [freq_max]{style="color: magenta"}: maximum frequency of the filters
    (for radio!).

-   [zp]{style="color: magenta"}: filter zeropoint.

-   [wave_units]{style="color: magenta"}: units of wavelengths.

-   [freq_units]{style="color: magenta"}: units of frequency.

-   [zp_units]{style="color: magenta"}: units of zeropoint value.

-   [zp_system]{style="color: magenta"}: system of zeropoint value (e.g.
    "Vega\").

## [schema_version]{style="color: cyan"} {#sec:otter}

Version of the schema used.

    [
        style=json,
        label=lst:example-json]
    "schema_version": {
      "value": 1.0,
      "comment": "cite us please"
    }

# Template JSON File

A sample JSON file that could be used to fill your data into is
available publicly at
<https://drive.google.com/file/d/10-llOOJGGgtCurJn8lemKdNpD07b4E4w/view?usp=sharing>

# Possibly Controversial Decisions / FAQ

1.  We use a document database to store individual object json files as
    separate documents instead of the more popular Relational Schema.
    The document schema just fits our data much easier and should not
    result in any slowdowns.

2.  We decided to use full ads bibcodes for references throughout a
    single JSON file. This is just easier for us (and hopefully for
    everyone)! Note: this is different from the original OSC which used
    aliases.

3.  We will store the original data format with a `computed = False`
    flag, always! But, we will store some other basic computations for
    quick queries with `computed = True` and the reference as the uuid.
    For example, we may get a date in MM/DD/YYYY format but convert it
    to MJD and then store both.
