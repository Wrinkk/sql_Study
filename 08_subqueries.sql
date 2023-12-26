 -- 유재식씨의 부서와 같은 부서에서 일하는 직원
 SELECT * FROM employee;
--  서브쿼리
 SELECT dept_code FROM employee WHERE emp_name = '유재식'; -- D6
--  메인쿼리
 SELECT * FROM employee WHERE dept_code = 'D6'; -- 유재식씨와 같은 부서에서 일하는 직원(본인 포함)
 
--  서브 쿼리를 포함한 메인쿼리
SELECT
		  *
	FROM employee
  WHERE dept_code = (SELECT dept_code
  							  FROM employee
							 WHERE emp_name = '유재식');	
							 
-- 이와 같은 방법으로 유재식씨 사원번호를 추출해서 해당 사원을 제거해 보자.
SELECT
		  *
	FROM employee
  WHERE dept_code = (SELECT dept_code
                       FROM employee
                      WHERE emp_name = '유재식') -- 인라인 뷰
   AND emp_id <> (SELECT emp_id
                    FROM employee
                   WHERE emp_name = '유재식');
-- 메뉴 조회시 메뉴의 카테고리에 있는 메뉴들의 평균 가격보다 높은 메뉴만 조회
-- 상관 서브쿼리 , 단일행서브쿼리
SELECT
		  a.menu_code
		, a.menu_name
		, a.menu_price
		, a. category_code
		, a.orderable_status
  FROM tbl_menu a
 WHERE a.menu_price > (SELECT AVG(b.menu_price) -- 단일행 일때
                         FROM tbl_menu b
                        WHERE b.category_code = a.category_code);
                        
-- 메뉴 카테고리의 평균과 같은 가격의 메뉴를 조회(상관 서브쿼리 안쓰고 다중행 서브쿼리)
SELECT
		 *
  FROM tbl_menu a
 WHERE a.menu_price IN (SELECT AVG(b.menu_price) -- group by로 묶어서 카테고리를 나눔 다중행 
                         FROM tbl_menu b
                        WHERE b.category_code = a.category_code
                        GROUP BY b.category_code);
--  ----------------------------------------------------
SELECT
		  category_code
		, category_name
  FROM tbl_category a
 WHERE EXISTS (SELECT 1
                 FROM tbl_menu b
                WHERE b.category_code = a.category_code)
 ORDER BY 1;

-- ----------------------------------------------------------------
-- 4번 카테고리를 메인쿼릴에서 where 조건 판별 중 동작하는 서브쿼리
SELECT 1
  FROM tbl_menu b
 WHERE b.category_code = 4;
--  -----------------------------------------------------------------
-- join을 활용한 메뉴가 있는 카테고리 조회도 해보자.
SELECT
		  a.category_code
		, a.category_name
  FROM  tbl_category a
  JOIN tbl_menu b ON (a.category_code = b.category_code)
 GROUP BY a.category_code, a.category_name
 ORDER BY 1;