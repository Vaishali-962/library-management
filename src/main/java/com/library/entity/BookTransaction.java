package com.library.entity;

import com.library.enums.TransactionStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "book_transactions")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookTransaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

//   Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

//  TimeStamp
    @Column(nullable = false)
    private LocalDateTime issuedAt;

    @Column(nullable = false)
    private LocalDateTime dueDate;

    @Column
    private  LocalDateTime returnedAt;

//  Status
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20, columnDefinition = "VARCHAR(20)")
    private TransactionStatus status;


//    Helper Methods
    public boolean isReturned() {
        return TransactionStatus.RETURNED.equals(this.status);
    }

    public boolean isOverdue() {
        return TransactionStatus.OVERDUE.equals(this.status)
                || (TransactionStatus.ISSUED.equals(this.status)
                && LocalDateTime.now().isAfter(this.dueDate));
    }
}
