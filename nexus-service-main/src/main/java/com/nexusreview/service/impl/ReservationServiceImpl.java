package com.nexusreview.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.nexusreview.entity.Reservation;
import com.nexusreview.mapper.ReservationMapper;
import com.nexusreview.service.IReservationService;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author ShenCodr
 * @since 2025-10-07
 */
@Service
public class ReservationServiceImpl extends ServiceImpl<ReservationMapper, Reservation> implements IReservationService {
}
