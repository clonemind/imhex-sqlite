#pragma endian big

#include <std/sys.pat>

enum TEXT_ENCODING : u32 {
	UTF8 = 1,
	UTF16LE = 2,
	UTF16BE = 3
};

enum PAGE_TYPE : u8 {
	interior_index_page = 2,
	interior_table_page = 5,
	leaf_index_page = 10,
	leaf_table_page = 13,
};

struct DB_HEADER {
    char magic[16]; // 0-15
    std::assert(magic == "SQLite format 3", "Header mismatch");
    u16 page_size; // 16-17
    u8 write_version; // 18
    u8 read_version; // 19
    u8 unused_page_space; // 20
    u8 max_index_embed; // 21
    std::assert(max_index_embed == 64, "Max index embed");
    u8 min_index_embed; // 22
    std::assert(min_index_embed == 32, "Min index embed");
    u8 min_table_embed; // 23
	std::assert(min_table_embed == 32, "Min table embed");
    u32 change_count; // 24-27
    u32 database_size; // 28-31
    u32 freelist_trunk_page; // 32-35
    u32 db_free_pages; // 36-39
    u32 schema_cookie; // 40-43
    u32 schema_file_format; // 44-47
    std::assert(schema_file_format >= 1 && schema_file_format <= 4, "Schema file format not supported");
    u32 page_cache_size; // 48-51
    u32 top_root_page; // 52-55
    TEXT_ENCODING text_encoding; // 56-59
    u32 user_version; // 60-63
    u32 inc_vacuum; // 64-67
    u32 application_id; // 68-71
    u8 reserved[20]; // 72-91
    u32 version_valid_for; // 92-95
    u32 sqlite_version_number; // 96-99
};

struct DB_FREELIST_TRUNK_HEADER {
	u32 next_trunk_pointer;
	u32 num_leaf_pointer;
	u32 pointer[num_leaf_pointer];
};

struct DB_PAGE_HEADER {
	PAGE_TYPE page_type;
};

fn loop_pages(u32 pages, u32 page_size) {
	for (u32 i = 0, i<= pages, i = i +1){
		DB_PAGE_HEADER db_page_header1 @ i*page_size;
	}
};

DB_HEADER db_header @ 0x0;
//loop_pages(db_header.database_size, db_header.page_size);
//DB_PAGE_HEADER db_page_header @ 2*db_header.page_size;
DB_FREELIST_TRUNK_HEADER db_freelist_trunk_header @ (db_header.freelist_trunk_page - 1) * db_header.page_size;