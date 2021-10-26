//
//  Event.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse
import Mapbox

enum EventStatus: String {
    case cancelled, blocked, reported, active
}

class Event: PFObject, PFSubclassing {
    
    /*
    * Used in queries, we let this flag to modify in backend to not affect associated items
    */
    @NSManaged var isEnabled: Bool
   
    /*
    * Appears if the event has been created on the organizer app, or on the backend by the admin.
    */
    @NSManaged var hasBadge: Bool
   
    /*
     * Event name
     */
    @NSManaged var name: String?
    
    /*
     * Event description
     */
    @NSManaged var desc: String?

    /*
     * Event image
     */
    @NSManaged var image: PFFileObject?
    
    /*
     * Event coordinates: PFGeoPoint, used to queries by proximity and to show in the map
     */
    @NSManaged var coordinates: PFGeoPoint?
    
    /*
     * Geocoding from the coordinates
     */
    @NSManaged var location: String?

    /*
     * User who created this event
     */
    @NSManaged var owner: User?
    
    /*
     * Category associated. Used in the filters
     */
    @NSManaged var category: String?

    /*
     * Date when the event is starting. Used in the filters
     */
    @NSManaged var startAt: Date?
    
    /*
     * Date when the event is ending. Used in the filters
     */
    @NSManaged var endAt: Date?

    /*
     * Boolean indicating if event has a webpage containing tickets and prices
     */
    @NSManaged var isBookingRequired: Bool
    
    /*
     * Price of the ticket from customer app
     */
    @NSManaged var indicativePrice: Int
    
    /*
     * Website where user can get more info of this event
     */
    @NSManaged var webLink: String?

    /*
     * Total number of tickets
     */
    @NSManaged var availableTickets: Int
    
    /*
     * Indicating the number of tickets users has bought. Updated by server side everytime an user buys a ticket
     */
    @NSManaged var ticketsSold: Int
    
    /*
     * String containing range of prices from app Organizer tickets. Updated when app Organizer adds new tickets
     */
    @NSManaged var rangePrice: String?
    
    /*
     * Status of the event. See EventStatus enum
     */
    @NSManaged var eventStatus: String?

    /*
     * A flag indicating if the event has been sent a push notification for starting in 24 hours
     */
    @NSManaged var eventStartingSent: Bool
    
    /*
     * Cached values to let the app a little lighter. See ImageHelper for actual cache images feature.
     */
    /*
    * get the creator stripe accountId to send money
    */
    @NSManaged var creatorStpAccountId: String?
    /*
     * get number the reviews an experience received
     */
    @NSManaged var reviewReceived: Int
    /*
     * get the averageStar of event
     */
    @NSManaged var averageStar: String?
    /* get the averageStar of event
        */
    @NSManaged var headerEvent: Int
    
    var lat: Double = 0
    var lng: Double = 0
    var cachedImage: UIImage?
    var hasEventBeenInterested: Bool = false
    var myTickets: [TicketBought]?
    var eventStatusEnum: EventStatus = .active
    var friends: [User] = []
    var reviews: [Review]?
    
    var distance: Double? {
        guard let location = User.current()?.location, coordinate.latitude != 0, coordinate.longitude != 0 else { return nil }
        let point = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return location.distanceInKilometers(to: point)
    }

    class func safeQuery() -> PFQuery<PFObject>? {
        let query = Event.query()
        query?.includeKey(Event.Properties.owner)
        query?.whereKey(Event.Properties.isEnabled, equalTo: true)
        query?.whereKey(Event.Properties.eventStatus, equalTo: EventStatus.active.rawValue)
        return query
    }
    
    // MARK: Functions
    class func parseClassName() -> String {
        return "Event"
    }
}

// MARK: - MGLAnnotation. Used to show pins in the map
extension Event: MGLAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinates?.latitude ?? 0,
                                      longitude: coordinates?.longitude ?? 0)
    }
}

// MARK: - Properties from parse of this event. To avoid typos
extension Event {
    struct Properties {
        static let createdAt = "createdAt"
        static let isEnabled = "isEnabled"
        static let hasBadge = "hasBadge"
        static let name = "name"
        static let desc = "desc"
        static let image = "image"
        static let coordinates = "coordinates"
        static let location = "location"
        static let owner = "owner"
        static let category = "category"
        static let startAt = "startAt"
        static let endAt = "endAt"
        static let isBookingRequired = "isBookingRequired"
        static let availableTickets = "availableTickets"
        static let indicativePrice = "indicativePrice"
        static let webLink = "webLink"
        static let ticketsSold = "ticketsSold"
        static let rangePrice = "rangePrice"
        static let eventStatus = "eventStatus"
        static let creatorStpAccountId = "creatorStpAccountId"
        static let headerEvent = "headerEvent"
    }
}
