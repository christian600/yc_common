/**
 * @brief 文件相关操作函数集合
*/
#pragma once

int common_test();

/**
 * @brief 确保目录存在
 * @param {const char*} 目录路径：传入时需保证为有\0结尾的绝对路径
 * @return {bool} 
*/
bool yc_makesure_dir_exit(const char* target_dir);