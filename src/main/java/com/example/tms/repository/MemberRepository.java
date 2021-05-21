package com.example.tms.repository;

import com.example.tms.entity.Member;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface MemberRepository extends MongoRepository<Member, Long> {
    Member findById(String str);
    Boolean existsById(String str);
    Member deleteById(String str);
}
