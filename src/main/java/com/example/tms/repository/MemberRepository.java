package com.example.tms.repository;


import com.example.tms.entity.Member;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface MemberRepository extends MongoRepository<Member, Long> {
    List<Member> findByState(String str);
    Member findById(String str);
    Boolean existsById(String str);
}
