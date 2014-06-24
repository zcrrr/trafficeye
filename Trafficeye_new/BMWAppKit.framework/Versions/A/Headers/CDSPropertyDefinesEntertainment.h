/*  
 *  CDSPropertyDefinesEntertainment.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @constant CDSEntertainmentMultimedia
 @abstract Returns informaiton about the current multimedia file being played on the entertainment server of the head unit.
 @discussion (entertainment.multimedia) Stored in a response key "multimedia" as a dictionary with keys "title", "artist", "album", "genre", "year", "tracktime" and "bitrate". title, artist and album all are strings, where genre is a number based on ID3-spec, year is a number, tracktime is a number represented in ms, and bitrate is a number representing kbps. genre, year, tracktime, and bitrate are not supported in current vehicles.
 */
extern NSString * const CDSEntertainmentMultimedia;
