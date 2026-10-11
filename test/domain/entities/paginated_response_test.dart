import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';

void main() {
  group('PaginatedResponse', () {
    group('isEmpty', () {
      test('Should return true when items are empty and totalRows is zero', () {
        // Arrange
        final response = PaginatedResponse<int>(totalPages: 0, currentPage: 0, totalRows: 0, itemsList: []);

        // Act & Assert
        expect(response.isEmpty, isTrue);
      });

      test('Should return false when items are not empty', () {
        // Arrange
        final response = PaginatedResponse<int>(totalPages: 1, currentPage: 1, totalRows: 1, itemsList: [1]);

        // Act & Assert
        expect(response.isEmpty, isFalse);
      });
    });

    group('progress', () {
      test('Should return the correct pagination progress', () {
        // Arrange
        final response = PaginatedResponse<int>(totalPages: 4, currentPage: 1, itemsList: [1]);

        // Act & Assert
        expect(response.progress, 0.25);
      });

      test('Should return zero when totalPages is zero', () {
        // Arrange
        final response = PaginatedResponse<int>(totalPages: 0, currentPage: 0, itemsList: []);

        // Act & Assert
        expect(response.progress, 0.0);
      });
    });

    group('hasMore', () {
      test('Should return true when there are more pages', () {
        // Arrange
        final response = PaginatedResponse<int>(totalPages: 4, currentPage: 2, itemsList: [1]);

        // Act & Assert
        expect(response.hasMore, isTrue);
      });

      test('Should return false when current page is the last page', () {
        // Arrange
        final response = PaginatedResponse<int>(totalPages: 4, currentPage: 4, itemsList: [1]);

        // Act & Assert
        expect(response.hasMore, isFalse);
      });
    });

    group('copyWith', () {
      test('Should update the specified properties', () {
        // Arrange
        final response = PaginatedResponse<int>(totalPages: 4, currentPage: 1, pageSize: 10, totalRows: 40, itemsList: [1, 2]);

        // Act
        final result = response.copyWith(currentPage: 2, itemsList: [1, 2, 3, 4]);

        // Assert
        expect(result.currentPage, 2);
        expect(result.itemsList, [1, 2, 3, 4]);
        expect(result.totalPages, 4);
        expect(result.pageSize, 10);
        expect(result.totalRows, 40);

        // The original response should remain unchanged.
        expect(response.currentPage, 1);
        expect(response.itemsList, [1, 2]);
      });
    });

    group('addPage', () {
      test('Should merge items and update pagination metadata', () {
        // Arrange
        final response = PaginatedResponse<int>(totalPages: 4, currentPage: 1, pageSize: 10, totalRows: 40, itemsList: [1, 2, 3]);

        // Act
        final result = response.addPage(newItemsList: [4, 5, 6], newCurrentPage: 2, newTotalPages: 5);

        // Assert
        expect(result.itemsList, [1, 2, 3, 4, 5, 6]);
        expect(result.currentPage, 2);
        expect(result.totalPages, 5);
        expect(result.pageSize, 10);
        expect(result.totalRows, 40);

        // The original response should remain unchanged.
        expect(response.itemsList, [1, 2, 3]);
        expect(response.currentPage, 1);
      });

      test('Should preserve existing items when the new list is empty', () {
        // Arrange
        final response = PaginatedResponse<int>(totalPages: 4, currentPage: 1, itemsList: [1, 2, 3]);

        // Act
        final result = response.addPage(newItemsList: [], newCurrentPage: 2, newTotalPages: 4);

        // Assert
        expect(result.itemsList, [1, 2, 3]);
        expect(result.currentPage, 2);
      });
    });

    group('empty', () {
      test('Should return an empty paginated response', () {
        // Act
        final response = PaginatedResponse.empty<int>();

        // Assert
        expect(response.totalPages, 0);
        expect(response.currentPage, 0);
        expect(response.pageSize, 10);
        expect(response.totalRows, 0);
        expect(response.itemsList, isEmpty);
        expect(response.isEmpty, isTrue);
        expect(response.hasMore, isFalse);
        expect(response.progress, 0.0);
      });
    });
  });
}
