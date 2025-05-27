
import CloudKit
import Foundation

class CloudKitManager {
    static let shared = CloudKitManager()
    private let publicDatabase = CKContainer.default().publicCloudDatabase

    private init() {}

    /// Saves a record to CloudKit with a specified type and field values.
    func saveRecord(recordType: String, fields: [String: CKRecordValue]) async throws -> CKRecord {
        let record = CKRecord(recordType: recordType)
        fields.forEach { key, value in
            record[key] = value
        }

        do {
            let savedRecord = try await publicDatabase.save(record)
            print("✅ Record saved successfully: \(savedRecord.recordID.recordName)")
            return savedRecord
        } catch {
            print("❌ Error saving record: \(error.localizedDescription)")
            throw error
        }
    }
}
