#!/bin/bash

filename="update.md"
# 生成3个表格：补丁更新表、功能体验表、发布记录。
# 补丁更新：按产品、包名分组，按时间升序展示版本号，链接到对应更新文档。如有发布到7.2.x，则加对应标签。
# 功能体验：按功能分表展示（复用标签字段，不展示），无标签内容属于共享更新。其他同补丁更新。
# 发布记录：汇总功能和补丁，按时间排序。合并重复版本的全部标签（不显示功能体验分组标签）。

# shellcheck disable=SC1111

cat <<EOF | gawk -f scripts/tagged-table.awk scripts/release-7.2.*.tsv - > "$filename"
# 单产品更新
<!-- WARNING: DO NOT EDIT. this file was generated by script at $(LC_ALL=C date +%F-%X%z). -->

单产品更新为蓝鲸快速发布软件更新的机制。主要有如下用途：
* 发行版补丁：蓝鲸发行版中各产品版本的新补丁，不会引入新功能，可安稳升级。
* 新功能体验：跨版本升级体验最新功能。维护期短，期满需要继续跨版本升级。

## 重要时间节点
* 2024-10-18 7.2.0 公开下载，部署文档陆续上线。
* 2024-10-23 7.2.0 正式公告发布。
* 2024-11-08 7.2.1 发布。
* 2024-12-05 7.2.2 发布。
* 2025-10-31 标准维护期结束，不提供普通问题修复补丁，仅提供安全补丁。
* 2026-10-31 扩展维护期结束，不再提供安全补丁。
* 2027-10-31 停止提供技术支持（包括企点客服系统、论坛官方解答等）。
* 2028-10-31 资源归档，不再提供公开访问（包括官方文档、安装包等）。

## 发行版补丁
随蓝鲸 7.2 发布的版本，视作长期支持版。提供为期 2 年的维护服务（1 年标准维护 + 1 年扩展维护）。

>**提示**
>
>* 点击包版本号查阅具体的升级文档。
>* Helm chart 的包版本号可能和软件版本号不同，其他类型制品的包版本号即软件版本号。
>* 已经发布的版本后续会收录到发行版中，会在标签列中显示蓝鲸版本号。
>* 标签列显示“安全更新”，说明此补丁修复安全问题，需要尽快安排更新。
>* 标签列显示“重要补丁”，说明此补丁修复了一些重要问题，强烈建议更新。

$(gawk -f scripts/patches.awk scripts/patches.tsv)

## 新功能体验
应用户需求，我们会推出一些尝鲜新功能。这些新版本不属于长期维护版本，维护期一般为 3~4 个月，此后遇到的问题都需要持续升级到最新版本解决。

>**提示**
>
>* 以“功能”维度分表格展示初始版本及其可用更新。新版本如果适用于多个功能，则会多次出现。
>* 体验新功能时，如果一个包有多个版本，建议先参考初始版本的文档部署，然后升级到新版本。

$(gawk -f scripts/features.awk scripts/features.tsv)

## 发布记录
按发布时间编制的表格，方便回顾。

$(gawk -f scripts/journal.awk scripts/patches.tsv scripts/features.tsv)
EOF

ls -lh "$filename"
