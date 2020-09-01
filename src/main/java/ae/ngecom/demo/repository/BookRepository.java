package ae.ngecom.demo.repository;

import org.springframework.data.repository.CrudRepository;

import ae.ngecom.demo.dto.Book;

public interface BookRepository extends CrudRepository<Book, Long> {
}
